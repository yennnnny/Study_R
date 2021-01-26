####################################
# chap12_Classification
####################################

install.packages('rpart') # rpart() : 분류모델 생성 
install.packages("rpart.plot") # prp(), rpart.plot() : rpart 시각화
install.packages('rattle') # fancyRpartPlot() : node 번호 시각화 

library(rpart) 
library(rpart.plot) 
library(rattle) 

####################################
# 암 진단 분류 분석 : 이항분류
####################################
# "wdbc_data.csv" : 유방암 진단결과 데이터 셋 분류

# 1. 데이터셋 가져오기 
wdbc <- read.csv('C:/')
str(wdbc)  # 569

# 2. 데이터 탐색 및 전처리 
wdbc_df <- wdbc[-1] # id 칼럼 제외
head(wdbc_df)
wdbc_df$diagnosis # 진단결과 : B -> '양성', M -> '악성'
table(wdbc_df$diagnosis)
#  B   M 
# 357 212 

# 목표변수(y변수)를 factor형 변환 : 0, 1 dummy 변수  
wdbc_df$diagnosis <- factor(wdbc$diagnosis, levels = c("B", "M")) # 0, 1
wdbc_df$diagnosis[1:10] # Levels: B M -> 0(NO), 1(YES)


# 3. 훈련데이터와 검정데이터 생성 : 7 : 3 비율 
set.seed(415)  # -> 동일한 난수 생성(seed)
idx = sample(nrow(wdbc_df), 0.7*nrow(wdbc_df))
wdbc_train = wdbc_df[idx, ] # 훈련 데이터 
wdbc_test = wdbc_df[-idx, ] # 검정 데이터 
dim(wdbc_test) # 171  31


# 4. rpart 분류모델 생성 
model_wdbc <- rpart(diagnosis ~ ., data = wdbc_train)
model_wdbc # - 가장 중요한 x변수? 

# 1) root 398개 중 에서 149개를 제외한 나머지는 B로 분류 됬다(0.62562814 0.37437186)  
#   2) perimeter_worst< 105.95 243  13 B (0.94650206 0.05349794)  
#   노드번호) root 노드 분류 조건 = YES
#       4) points_worst< 0.1589 235   6 B (0.97446809 0.02553191) * <- 단노드
#       5) points_worst>=0.1589 8   1 M (0.12500000 0.87500000) * <- 단노드
#   3) perimeter_worst>=105.95 155  19 M (0.12258065 0.87741935)  
#   노드번호) root 노드 분류 조건 = NO
#       6) points_mean< 0.04952 23   8 B (0.65217391 0.34782609)  
#           12) points_se>=0.0101255 11   0 B (1.00000000 0.00000000) * <- 단노드
#           13) points_se< 0.0101255 12   4 M (0.33333333 0.66666667) * <- 단노드
#       7) points_mean>=0.04952 132   4 M (0.03030303 0.96969697) * <- 단노드


# tree 시각화 
rpart.plot(model_wdbc)
# 분류 label ->  분류 비율 : Yes(1)기준 -> 전체 비율 : 분류조건 True


# 5. 분류 모델 평가
pred <- predict(model_wdbc, wdbc_test, type = 'class' )
pred  # 예측치    

length(pred) # 171
y_true <- wdbc_test$diagnosis # 관측치 
length(y_true)#  171


# 교차분할표(confusion matrix)
table(y_true, pred)
#           pred
# y_true    B   M
#   B     100   8 (100/108)
#   M       3  60 (60/63)
 
acc <- (100+60)/nrow(wdbc_test)
acc  # 0.94

####################################
### Titanic
####################################
setwd("C:/")
titanic <- read.csv("Titanic3.csv")

str(titanic)
# titanic3.csv 변수 설명
#'data.frame': 1309 obs. of 14 variables:
#1.pclass : 1, 2, 3등석 정보를 각각 1, 2, 3으로 저장
#2.survived : 생존 여부. survived(생존=1), dead(사망=0)
#3.name : 이름(제외)
#4.sex : 성별. female(여성), male(남성)
#5.age : 나이
#6.sibsp : 함께 탑승한 형제 또는 배우자의 수
#7.parch : 함께 탑승한 부모 또는 자녀의 수
#8.ticket : 티켓 번호(제외)
#9.fare : 티켓 요금
#10.cabin : 선실 번호(제외)
#11.embarked : 탑승한 곳. C(Cherbourg), Q(Queenstown), S(Southampton)
#12.boat     : (제외)Factor w/ 28 levels "","1","10","11",..: 13 4 1 1 1 14 3 1 28 1 ...
#13.body     : (제외)int  NA NA NA 135 NA NA NA NA NA 22 ...
#14.home.dest: (제외)

# y 요인형 변환 : dummy변수(0, 1)
titanic$survived <- factor(titanic$survived, levels = c(0,1))
table(titanic$survived)
#  0   1 
# 809 500 

df <- titanic[-c(3,8, 10:14)]  # 7컬럼 제외

# 7:3 비율로 데이터 셋 분할
idx <- sample(nrow(df), nrow(df)*0.7)

trainset <- df[idx,]  # 70%
testset <- df[-idx,]  # 30%

# 분류 모델
model <- rpart(survived ~ ., data = trainset)

# 분류 트리 시각화
rpart.plot(model)



# 모델 평가
pred <- predict(model, testset)  # 비율예측, type = "class"
dim(pred)  # 393  2[0     1]
range(pred)  # 0.066667   0.9333333

# 연속형 -> 범주형
y_pred <- ifelse(pred[,2] > 0.5, 'Yes', 'No')
table(y_pred)
#     y_pred
# No Rain Yes Rain 
#   84       26 

y_true <- testset$survived  # 관측치(정답)

table(y_true, y_pred)
#              y_pred
#  y_true No Rain  Yes Rain
#   No       80        6
#   Yes       4       20

acc <- (221 + 103) / nrow(testset)
acc  # 0.8244275


################################
# iris 데이터셋 : 다항분류 
################################
# 단계1. 실습데이터 생성 
data(iris)
set.seed(415)
idx = sample(nrow(iris), 0.7*nrow(iris))
train = iris[idx, ]
test = iris[-idx, ]
dim(train) # 105 5
dim(test) # 45  5

# y 변수 : 꽃의 종
table(train$Species)
# setosa versicolor  virginica 
#  37         33         35 

# 단계2. 분류모델 생성 
# rpart(y변수 ~ x변수, data)
model = rpart(Species~., data=train) # iris의 꽃의 종류(Species) 분류 
model

# 분류모델 시각화 - rpart.plot 패키지 제공 
prp(model) # 간단한 시각화   
rpart.plot(model) # rpart 모델 tree 출력
fancyRpartPlot(model) # node 번호 출력(rattle 패키지 제공)


# 단계3. 분류모델 평가  
pred <- predict(model, test) # 비율 예측 
pred <- predict(model, test, type="class") # 분류 예측 

# 1) 분류모델로 분류된 y변수 보기 
table(pred)

# 2) 분류모델 성능 평가 
table(pred, test$Species)
acc <- (13+16+12) / nrow(test)
acc  # 0.911111

############################
## 가지치기(cp : cut prune)
############################
# Tree 가지치기 : 과적합 문제 해결
# cp 범위 : 0~1(default = 0.01)
# 0 으로 갈수록 Tree 깊어짐(과적합 증가, 오분류 감소)

# 현재 모델 cp값 확인
names(model)
model$control
# cp -> [1] 0.01

model$cptable
#     CP nsplit  rel error     xerror(오분류율)   xstd
# 1   0.5147059  0 1.00000000   1.11764706         0.06737554
# 2   0.4558824  1 0.48529412   0.57352941         0.07281162 -> cp(오분류율이 조금 증가하지만, 과적합 정도를 낮출 수 있음)
# 3   0.0100000  2 0.02941176   0.02941176         0.02059824 -> 현재 cp


# cp = 0.4558824 수정 -> model 수정
?rpart
model2 <- rpart(Species~., data = train, control = rpart.control(cp=0.4558824))

# 가지치기 : level 2 제거 
model2
prp(model2)
rpart.plot(model2)



########################
## 교차검정
########################

# k겹 교차검정을 위한 샘플링
install.packages("cvTools")
library(cvTools)  # cvFolds() 함수수
cross <- cvFolds(nrow(iris), K = 3, R =1)  # 3 겹 : 3등분
cross  # Fold(Dataset 구분)  Index(행번호)

str(cross)
# $ subsets : [n, R] -> 2차원(행번호)
# $ which : dataset 구분

# dataset -> d1, d2, d3 
d1 <- cross$subsets[cross$which == 1, 1]
d2 <- cross$subsets[cross$which == 2, 1]
d3 <- cross$subsets[cross$which == 3, 1]
d1; d2; d3

# k겹 교차검정
# d1(test), d2 + d3(train) -> acc1
# d2(test), d1 + d3(train) -> acc2
# d3(test), d1 + d2(train) -> acc3

K = 1:3  # 3겹  
ACC <- numeric()  # vector 변수

for(i in K){
  idx <- cross$subsets[cross$which == i, 1]  # d1>d2>d3
  test <- iris[idx, ]  # d1(test)
  train <- iris[-idx, ]  # d2 + d3(train)
  model <- rpart(Species~., data = train)
  
  # 예측치
  y_pred <- predict(model, test, type = 'class')
  
  # 모델 평가 : 교차분할표
  t <- table(test$Species, y_pred)
  ACC[i] <- (t[1,1] + t[2,2] + t[3,3]) / sum(t)
}


ACC  # 0.92 0.98 0.96
mean(ACC)  # 0.9533333


############################
## Entropy : 불확실성 척도
############################
# -Tree model에서 중요 변수(x) 선정 시 사용

# x : 앞면, y : 뒷면 - 불확실성이 높은 경우
x = 0.5; y =0.5  # 확률변수

e1 = -x * log2(x) + -y*log2(y)
cat('e1 = ', e1) # e1 = 1

# entropy = -sum(x * log2(x) + y*log2(y))

# x : 앞면, y : 뒷면 - 불확실성이 낮은 경우
x = 0.9; y = 0.1  # 확률변수수

e2 = -x * log2(x) + -y*log2(y)
cat('e2 = ', e2) # e2 = 0.4689956

# x -> 예측치 vs 정답 : 오차가 작은 x 변수 선정



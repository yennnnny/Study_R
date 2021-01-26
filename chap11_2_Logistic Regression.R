###############################################
# 11_2. 로지스틱 회귀분석(Logistic Regression) 
###############################################
# 목적 : 일반 회귀분석과 동일하게 종속변수와 독립변수 간의 관계를 나타내어 
# 향후 예측 모델을 생성하는데 있다.

# 차이점 : 종속변수가 범주형 데이터를 대상으로 하며 입력 데이터가 주어졌을 때
# 해당 데이터의결과가 특정 분류로 나눠지기 때문에 분류분석 방법으로 분류된다.
# 유형 : 이항형(종속변수가 2개 범주-Yes/No), 다항형(종속변수가 3개 이상 범주-iris 꽃 종류)
# 다항형 로지스틱 회귀분석 : nnet, rpart 패키지 이용 
# a : 0.6,  b:0.3,  c:0.1 -> a 분류 

# 분야 : 의료, 통신, 기타 데이터마이닝

# 선형회귀분석 vs 로지스틱 회귀분석 
# 1. 로지스틱 회귀분석 결과는 0과 1로 나타난다.(이항형)
# 2. 정규분포 대신에 이항분포를 따른다.
# 3. 로직스틱 모형 적용 : 변수[-무한대, +무한대] -> 변수[0,1]사이에 있도록 하는 모형 
#    -> 로짓변환 : 출력범위를 [0,1]로 조정
# 4. 종속변수가 2개 이상인 경우 더미변수(dummy variable)로 변환하여 0과 1를 갖도록한다.
#    예) 혈액형 AB인 경우 -> [1,0,0,0] AB(1) -> A,B,O(0)

# 로짓 변환 : 오즈비에 log 함수 적용(자연로그)

## 1. 오즈비(Odds ratio) : 실패(0)에 대한 성공(1) 비율
# ex)  10대 1의 배당률(성공 비율 1/10)
# p : 성공확률
# 1-p : 실패 확률(q) -> 성공확률에 대한 여사건

p = 0.5  # -> 성공
q = 1-p  # 0.5  -> 실패

odds_ratio = p/(1-p)  # 1 : 실패에 대한 성공 확률 

p = 0.6
odds_ratio = p/(1-p)  # 1.5 

p = 0.4
odds_ratio = p/(1-p)  # 0.6667
# [정리] 성공확률(p) 큰 경우 오즈비 증가

## 2. 로짓변환 : 오즈비에 log 함수 적용
p = 0.5  # 성공
odds_ratio = p / (1 - p) # 1
logi1 = log(odds_ratio)  # 0

p = 1  # 성공
odds_ratio = p / (1 - p) # 1
logi2 = log(odds_ratio)  # -Inf

p = 0  # 성공
odds_ratio = p / (1 - p) # 0
logi3 = log(odds_ratio)  # -Inf
# [정리]
#   - 성공확률(p) 0.5 이상이면 Inf
#   - 성공확률(p) 0.5 이하면 - Inf
# p = 0.5 -> 0
# p = 1 -> Inf
# p = 0 -> - Inf


## 3. sigmoid function : Inf(0) ~ Inf(1)
# logit =   0  -> 0.5
# logit =  Inf -> 1
# logit = -Inf -> 0


# 단계1. 데이터 가져오기
weather = read.csv("C:/", stringsAsFactors = F) 
# stringsAsFactors : 문자열로 된것 변환하지 말고 가지고 와
dim(weather)  # 366  15
head(weather)
str(weather)

# chr 칼럼, Date, RainToday 칼럼 제거 
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df)

# RainTomorrow 칼럼 -> 로지스틱 회귀분석 결과(0,1)에 맞게 더미변수 생성      
weather_df$RainTomorrow[weather_df$RainTomorrow=='Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow=='No'] <- 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow)
head(weather_df)

#  단계2.  데이터 샘플링
idx <- sample(1:nrow(weather_df), nrow(weather_df)*0.7)
train <- weather_df[idx, ]  # 훈련셋
test <- weather_df[-idx, ]  # 검정셋
dim(train)  # 256   11
dim(test)   # 110   11

#  단계3.  로지스틱  회귀모델 생성 : 학습데이터 
weater_model <- glm(RainTomorrow ~ ., data = train, family = 'binomial')
weater_model 
summary(weater_model) 


# 단계4. 로지스틱  회귀모델 예측치 생성 : 검정데이터 
# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측 
pred <- predict(weater_model, newdata=test, type="response")  
pred 
range(pred, na.rm = T)
summary(pred)
str(pred)

# NA 위치 파악
table(ifelse(is.na(pred), "TRUE", "FLASE"))
# FLASE 
# 120 

p <- ifelse(is.na(pred), "True", "False")
which(p == "True")
# 222 301 -> names 
# 62  88 -> index 
p[62]
p[88]

# cut off = 0.5
y_pred <- ifelse(pred > 0.5, 1, 0)
y_pred  # y 예측치

y_true <- test$RainTomorrow  # y 관측치()

# 단계5. 모델 평가
# 교차분할표 (confusion matrix)
tab <- table(y_true, y_pred)
#         y_pred
# y_true   0  1
#   0     82  4  -> NO(84/86)
#   1     11 11  -> Yes(11/20)

11/20  # 0.55
86/88  # 0.977272


# 1) 분류정확도(accuracy)
acc <- (tab[1,1] + tab[2,2]) / sum(tab)  # accuracy =  0.8981481
cat("accuracy = ", acc)  # accuracy =  0.8611111

# 2) 정확률(precision) : 알고리즘이 Yes로 판단한 것 중에 실제로 Yes인 비율
precision <- tab[2,2] / sum(tab[,2])
cat("precision = ", precision)  # precision =  0.7333333


# 3) 재현율(민감도) : 실제값이 Yes 인것 중에서 알고리즘이 Yes로 판단한 비율
recall <- sum(tab[2, 2] / sum(tab[2,]))
cat("recall = ", recall)  # precision =  0.5

# 4) F1 score : y 불균형, 정확률과 재현율을 동시에 고려하는 측정치 
f1_score <- 2*((precision*recall)/(precision+recall))
cat("f1_score = ", f1_score)  # f1_score =  0.5945946


## 정분류율 = (TP + TN) / 전체 관측치 -> 알고리즘의 성능 
## 오분류율 = (TN + FP) / 전체 관측치 -> 알고리즘의 오차 비율
## 정확률 = TP / (TP + FP) 
## 재현율 = TP / (TP + FN)
## F 측정치 = 2*(정확률 X 재현율) / (정확률 + 재현율)



### ROC Curve를 이용한 모형평가(분류정확도)  ####
# Receiver Operating Characteristic

install.packages("ROCR")
library(ROCR)

# ROCR 패키지 제공 함수 : prediction() -> performance
pred <- pred[-c(62,88)] na.omit(pred)
real_value <- test$RainTomorrow

pr <- prediction(pred, test$RainTomorrow)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)


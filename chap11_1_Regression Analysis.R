######################################################
# 회귀분석(Regression Analysis)
######################################################
# - 특정 변수(독립변수:설명변수)가 다른 변수(종속변수:반응변수)에 어떠한 영향을 미치는가 분석

###################################
## 1. 단순회귀분석 
###################################
# - 독립변수와 종속변수가 1개인 경우

# 단순선형회귀 모델 생성  
# 형식) lm(formula= y ~ x 변수, data) 

setwd("C:/")
product <- read.csv("product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)

str(product) # 'data.frame':  264 obs. of  3 variables:
y = product$"제품_만족도" # 종속변수 -> "한글칼럼명"
x = product$"제품_적절성" # 독립변수
df <- data.frame(x, y)
head(df)
dim(df) # 264   2

# 회귀모델 생성 
result.lm <- lm(formula=y ~ x, data=df)
result.lm # 회귀계수(Coefficients:)
# (Intercept)      x  
# 0.7789(절편=b)   0.7393(기울기=a) 

# 회귀방정식 : f(x) = ax + b
a = 0.7393 # 기울기 
b = 0.7789 # 절편 
x <- 4
Y <- 3 # 관측치 
y <- a*x + b # 예측치 
Y; y # 3 3.7361

# 오차(잔차:error)
err <- Y - y
err # -0.7361
err^2 # 0.5418432
# 부호+, 패널티 효과 

names(result.lm) # 12개 칼럼 제공 
# 계수 : "coefficients", 잔차 : "residuals", 예측치 : "fitted.values"
result.lm$coefficients
result.lm$residuals
result.lm$fitted.values

# 회귀모델 예측 
predict(result.lm, data.frame(x=5) ) 


# (2) 선형회귀 분석 결과 보기
summary(result.lm)


# (3) 단순선형회귀 시각화
# x,y 산점도 그리기 
plot(formula=y ~ x, data=df)
# 회귀분석
result.lm <- lm(formula=y ~ x, data=df)
# 회귀선 
abline(result.lm, col='red')


# <선형회귀 분석절차> 
# 1. F검정 통계량 : 모델의 통계적 유의성 검정(p < 0.05)
# 2. 모델의 설명력(예측력) : R^2(0 ~ 1)
# 3. X변수의 통계적 유의성 검정(p < 0.05)

# 예측치 
y_pred <- result.lm$fitted.values
y_pred

###################################
## 2. 다중회귀분석
###################################
# - 여러 개의 독립변수 -> 종속변수에 미치는 영향 분석
# 가설 : 음료수 제품의 적절성(x1)과 친밀도(x2)는 제품 만족도(y)에 정의 영향을 미친다.

product <- read.csv("product.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)


# 1) 적절성 + 친밀도 -> 만족도  
y = product$'제품_만족도' # 종속변수
x1 = product$'제품_친밀도' # 독립변수1
x2 = product$'제품_적절성' # 독립변수2

df <- data.frame(x1, x2, y)

# lm(y ~ x1 + x2, ... +xn)
#result.lm <- lm(formula=y ~ x1 + x2, data=df)
result.lm <- lm(formula=y ~ ., data=df) # . : 전체 독립변수 

# 계수 확인 
result.lm
# (Intercept)     x1           x2  
# 0.66731      0.09593      0.68522 

# f(x) = a1*x1 + a2*x2 + b
f_x = 0.09593 * df$x1 + 0.68522 * df$x2 + 0.66731
f_x

# 다중회귀분석 
summary(result.lm)
# 1. 모델의 통계적 유의성 검정 
# 2. 모델 설명력 
# 3. x변수의 통계적 유의성 검정



# 2) 102개 직업군 평판 dataset 이용 
install.packages("car") # 다중공선성 문제 확인  
library(car)

Prestige # car 제공 dataset

# 102개 직업군의 평판 : 교육수준,수입,여성비율,평판(프레스티지),센서스(인구수=직원수)
str(Prestige)
# 'data.frame':	102 obs. of  6 variables:
#$ education: 교육수준 - num  13.1 12.3 12.8 11.4 14.6 ...
#$ income   : 수입 - int  12351 25879 9271 8865 8403 11030 8258 14163 11377 11023 ...
#$ women    : 여성비율 - num  11.16 4.02 15.7 9.11 11.68 ...
#$ prestige : 평판 - num  68.8 69.1 63.4 56.8 73.5 77.6 72.6 78.1 73.1 68.8 ...
#$ census   : int  1113 1130 1171 1175 2111 2113 2133 2141 2143 2153 ...
#$ type     : Factor w/ 3 levels "bc","prof","wc": 2 2 2 2 2 2 2 2 2 2 ...
head(Prestige)

job <- row.names(Prestige) # 행 이름 
job

newdata <- Prestige[,c(1:4)]
dim(newdata) # 102   4

pairs(newdata)
# 수입 vs 교육수준 : 낮은 비례 
# 수입 vs 여성비율 : 낮은 반비례
# 수입 vs 평판 : 비례 

cor(newdata)
# income    0.57758023  1.0000000 -0.44105927  0.7149057

model <- lm(income ~ education + women + prestige, data = newdata)
#model <- lm(income ~ ., data = newdata)

model

summary(model)
# 1. 통계적 유의성 검정 : p-value: < 2.2e-16
# 2. 설명력 : 0.6323
# 3. x변수 유의성 검정 
#education    177.199    187.632   0.944    0.347    영향력 없음 
#women        -50.896      8.556  -5.948 4.19e-08 *** 부(-)의 영향력 있음 
#prestige     141.435     29.910   4.729 7.58e-06 *** 정(+)의 영향력 있음

names(model)

# 오차 = 관측치 - 예측치 
res <- model$residuals
mean(res) # 1.704083e-14 = 0.0000000000000000017


######################################
# 3. 변수 선택 방법
######################################
# 최적의 모델을 위한 x변수 선택

newdata2 <- Prestige[,c(1:5)]
dim(newdata2)  # 102  5

model2 <- lm(income ~ ., data = newdata2)
summary(model2)
# 설명력 : R-squared:  0.6289

library(MASS)
step <- stepAIC(model2, direction = 'both')
?stepAIC
#   - 단계적선택법(both) : 최적의 유의한 변수만 선택
#   - 후진선택법(backward) : p값을 기준으로 1개씩 제거하는 방법
#   - 전진적선택법(forward) : p값이 낮은 유의한 변수를 한개씩 추가하는 방법
#   - 절대적 결과는 아님, 참고용

# 수정된 model
model3 <- lm(income ~ women + prestige, data = newdata2)
summary(model3)
## 설명력 : R-squared:  0.6327 



##############################################
# 4. 다중공선성(Multicolinearity) & 기계학습
##############################################
# - 독립변수 간의 강한 상관관계로 인해서 회귀분석의 결과를 신뢰할 수 없는 현상
# - 생년월일과 나이를 독립변수로 갖는 경우
# - 해결방안 : 강한 상관관계를 갖는 독립변수 제거

# (1) 다중공선성 문제 확인
library(car)
names(iris)
fit <- lm(formula=Sepal.Length ~ Sepal.Width+Petal.Length+Petal.Width, data=iris)
vif(fit)  # x 변수 중 다중공선성 문제가 있는지 확인
#  Sepal.Width Petal.Length  Petal.Width 
#   1.270815    15.097572     14.234335

sqrt(vif(fit)) > 2 # root(VIF)가 2 이상인 것은 다중공선성 문제 의심 
#  Sepal.Width Petal.Length  Petal.Width 
#     FALSE         TRUE         TRUE 

# (2) iris 변수 간의 상관계수 구하기
cor(iris[,-5]) # 변수간의 상관계수 보기(Species 제외) 
#x변수 들끼 계수값이 높을 수도 있다. -> 해당 변수 제거(모형 수정) <- Petal.Width
# Petal.Width - Petal.Length의 상관계수 : 0.9628654 
#     -> 상관관계가 높음, 두 변수중 하나만 사용하는 것이 좋음

# (3) 학습데이터와 검정데이터 분류
x <- sample(nrow(iris), 0.7*nrow(iris)) # 전체중 70%만 추출
length(x)  # 105

train <- iris[x, ] # 학습데이터 추출
test <- iris[-x, ] # 검정데이터 추출
dim(train)  # 105   5
dim(test)   #  45   5

# (4) model 생성 : 학습용 데이터 - Petal.Width 변수를 제거한 후 회귀분석 
model <- lm(formula=Sepal.Length ~ Sepal.Width + Petal.Length, data=train)
model
#  (Intercept)   Sepal.Width  Petal.Length  
#    2.3144        0.5831        0.4724 

summary(model)

#  R-squared:  0.8487 -> 85% 정도의 설명력을 가짐
#               Estimate  Std. Error t value Pr(>|t|)    
# (Intercept)   2.31443    0.28530   8.112   1.17e-12 ***  -> 영량력이 큼
# Sepal.Width   0.58305    0.08188   7.121   1.55e-10 ***  -> 영량력이 큼
# Petal.Length  0.47238    0.01955  24.157   < 2e-16 ***  -> 영량력이 큼

# (5) model의 예측치 & 모델 평가
# 형식) predict(object, testset)
pred <- predict(model , test)  # -> y값 예측
pred  # y의 예측치

length(pre)
real_value = test$Sepal.Length  # y의 실체값

## 방법1 : 상관계수
cor(real_value, pred)  # 0.8946382

## 방법2 : MSE(Mean Square Error) -> 평균제곱오차
err <- real_value - pred

err_sq = err^2  # 부호 +, 패널티 적용(오차가 크면 더 크게, 작으면 더 작게 만들어줌)

err_sq <- err^2
mse <- mean(err_sq)
cat('MSE = ', mse)  # MSE = 0.1312743

## 방법3 : RMSE(Root Mean Square Error)
rmse <- sqrt(mse)
cat('RMSE = ', mse)  # RMSE = 0.3623179

## 방법4 : real value vs pred value
plot(real_value, col = 'blue', type = 'o', pch = 18)
point(pred, col = 'red', type = 'o', pch = 19)

# 범례추가
legend("topleft", legend = c("real", "pred"), 
       col = c("blue", "red"), pch(18, 19))

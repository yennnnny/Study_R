# chap09_Ttest_Anova

##########################
### 표본의 확률 분포###
##########################
# 모집단 으로 부터 추출된 표본의 통계량에 대한 분포
# 예) z, t, f 분포

# 1. z분포(표준 정규분호)
#   - 모집단의 모분산(표쥰편차)이 알려진 분포
#   - 용도 : 정규분포 -> 표준화(평균 = 0, 표준편차 = 1 )
#   - z = (x -mu)/sigma


# 2. t분포
#   - 모집단의 모분산(표준편차)이 알려지지 않은 분포
#   - 표본을 이용하여 모수(모평균) 추정
#   - z분포 유사 : 표본수가 많을 수록 정규분포를 따른다.
#   - 용도 : 모집단의 모평균 추정(집단간 평균 차이검정)

# 3. f분포
#   - 모집단의 모분산(표준편차)이 알려지지 않은 분포
#   - 용도 :  정규분포 가정하에 두 집단 분산 차이 검정


# t 분포 : 표본 수 = 10, α = 0.05 일때
x <- runif(n = 10, min = 5, max = 10)  # 확률 변수 x
x

# mu = 6.7
t.test(x, mu = 6.7)  # 확률 변수 x에 대한 모평균 6.7추정
# t = 1.606, df = 9, p-value = 0.1427

# t 검정통계량 = (표본 평균 - 모평균) / (표본 표준편차/표본 수 제곱근)
mu <- mean(x)  # 표본 평균
u <- 6.7
sd(x)
n <- sqrt(10)
t <- (mu - u) / (sd(x) / n)
t # 1.605956



###########################
# 1. 단일집단 평균차이 검정
###########################
# - 신규 집단의 평균이 기존 집단의 평균 값과 차이가 있는지를 검증

# 1. 실습파일 가져오기
data <- read.csv("one_sample.csv", header=TRUE)
str(data) # 150
head(data)
x <- data$time
head(x)

# 2. 기술통계량 평균 계산
summary(x) # NA-41개
mean(x) # NA
mean(x, na.rm=T) # NA 제외 평균(방법1)

x1 <- na.omit(x) # NA 제외 평균(방법2)
mean(x1)  # 5.556881(A) > 5.2(국내)

# 3. 정규분포 검정
# 정규분포(바른 분포) : 평균에 대한 검정 
# 정규분포 검정 귀무가설 : 정규분포와 차이가 없다.

shapiro.test(x1) # 정규분포 검정 함수(p-value = 0.7242) 

# 4. 가설검정 - 모수/비모수
# 정규분포(모수검정) -> t.test()
# 비정규분포(비모수검정) -> wilcox.test()


# 1) 양측검정 - 정제 데이터와 5.2시간 비교
t.test(x1, mu=5.2) 
t.test(x1, mu=5.2, alter="two.side", conf.level=0.95)  # two.side : 양측 검정정
# p-value = 0.0001417 < 0.05 : 귀무가설 기각(국내 != A)

# 2) 방향성이 있는 대립가설 검정 (A > 국내) : P < α
t.test(x1, mu=5.2, alter="greater", conf.level=0.95) 
# p-value = 7.083e-05

# 3) 방향성이 있는 대립가설 검정 (A < 국내) : 기각
t.test(x1, mu=5.2, alter="less", conf.level=0.95) 
# p-value = 0.9999



############################
#  2-1. 두집단 평균차이 검정
############################

# 1. 실습파일 가져오기
data <- read.csv("two_sample.csv")
data 
head(data) #4개 변수 확인
summary(data) # score - NA's : 73개

# 2. 두 집단 subset 작성(데이터 정제,전처리)
#result <- subset(data, !is.na(score), c(method, score))
dataset <- data[c('method', 'score')]
table(dataset$method)
#  1   2 
# 150 150 

# 3. 데이터 분리
# 1) 교육방법 별로 분리
method1 <- subset(dataset, method==1)  # 집단1
method2 <- subset(dataset, method==2)  # 집단2
dim(method1) # 150   2
dim(method2) # 150   2

# 2) 교육방법에서 점수 추출
method1_score <- method1$score
method2_score <- method2$score

# 3) 기술통계량 
length(method1_score); # 150
length(method2_score); # 150

# 4. 분포모양 검정 : 두 집단의 분포모양  일치 여부 검정
#   기본 가설 : 분포에 차이가 없다.
var.test(method1_score, method2_score)   # p-value = 0.3002
# 동질성 분포 : t.test()
# 비동질성 분포 : wilcox.test()

# 5. 가설검정 - 두집단 평균 차이검정
t.test(method1_score, method2_score)
t.test(method1_score, method2_score, alter="two.sided", conf.int=TRUE, conf.level=0.95)
# p-value = 0.0411 - 두 집단간 평균에 차이가 있다.

# # 방향성이 있는 대립가설 검정 (A > B)  : p-value = 0.9764
t.test(method1_score, method2_score, alter="greater", conf.int=TRUE, conf.level=0.95)
# # 방향성이 있는 대립가설 검정 (A < B)  : p-value = 0.02055 < 0.05
t.test(method1_score, method2_score, alter="less", conf.int=TRUE, conf.level=0.95)


###############################
# 2-2. 대응 두 집단 평균차이 검정
###############################
# 조건 : A집단  독립적 B집단 -> 비교대상 독립성 유지
# 대응 : 표본이 짝을 이룬다. -> 한 사람에게 2가지 질문
# 사례) 다이어트식품 효능 테스트 : 복용전 몸무게 -> 복용후 몸무게 

# 1. 실습파일 가져오기
getwd()
setwd("c:/")
data <- read.csv("paired_sample.csv", header=TRUE)

# 2. 두 집단 subset 작성

# 1) 데이터 정제
#result <- subset(data, !is.na(after), c(before,after))
dataset <- data[ c('before',  'after')]
dataset

# 2) 적용전과 적용후 분리
before <- dataset$before# 교수법 적용전 점수
after <- dataset$after # 교수법 적용후 점수
before; after

# 3) 기술통계량 
length(before) # 100
length(after) # 100
mean(before) # 5.145
mean(after, na.rm = T) # 6.220833 -> 1.052  정도 증가


# 3. 분포모양 검정 
var.test(before, after, paired=TRUE) 
# 동질성 분포 : t.test()
# 비동질성 분포 : wilcox.test()

# 4. 가설검정
t.test(before, after, paired=TRUE) # p-value < 2.2e-16 

# 방향성이 있는 대립가설 검정 
t.test(before, after, paired=TRUE,alter="greater",conf.int=TRUE, conf.level=0.95) 
#p-value = 1 -> x을 기준으로 비교 : x가 y보다 크지 않다.

#  방향성이 있는 대립가설 검정
t.test(before, after, paired=TRUE,alter="less",conf.int=TRUE, conf.level=0.95) 
# p-value < 2.2e-16 -> x을 기준으로 비교 : x가 y보다 적다.



############################################
#  3. 분산분석 : 두 집단 이상 분산 차이 검정 
############################################
# 집단별 분산의 비율 차이 검정
# 정규분포 가정하에 두 집단 분산 차이 검정
 
## 일원배치 분산분석 : y ~ x
#   x : 독립 변수(집단)
#   y : 종속 변수(숫자)

# 1. 파일 가져오기
data <- read.csv("three_sample.csv")

# 2. 데이터 정제/전처리 - NA, outline 제거
data <- subset(data, !is.na(score), c(method, score)) 
data # method, score

# (1) 차트이용 - ontlier 보기(데이터 분포 현황 분석)
plot(data$score) # 차트로 outlier 확인 : 50이상과 음수값
barplot(data$score) # 바 차트
mean(data$score) # 14.45

# (2) outlier 제거 - 평균(14) 이상 제거
length(data$score)#91
data2 <- subset(data, score <= 14) # 14이상 제거
length(data2$score) #88(3개 제거)

# (3) 정제된 데이터 보기 
x <- data2$score
boxplot(x)
plot(x)

# 3. 집단별 subset 작성
# method: 1:방법1, 2:방법2, 3:방법3
data2$method2[data2$method==1] <- "방법1" 
data2$method2[data2$method==2] <- "방법2"
data2$method2[data2$method==3] <- "방법3"

table(data2$method2) # 교육방법 별 빈도수 

# 4. 동질성 검정 - 정규성 검정
# bartlett.test(종속변수 ~ 독립변수) # 독립변수(세 집단)
bartlett.test(score ~ method2, data=data2)

# 귀무가설 : 집단 간 분포의 모양이 동질적이다.
# 해설 : 유의수준 0.05보다 크기 때문에 귀무가설을 기각할 수 없다. 

# 동질한 경우 : aov() - Analysis of Variance(분산분석)
# 동질하지 않은 경우 - kruskal.test()

# 5. 분산검정(집단이 2개 이상인 경우 분산분석이라고 함)
# aov(종속변수 ~ 독립변수, data=data set)

# 귀무가설 : 집단 간 평균에 차이가 없다.
result <- aov(score ~ method2, data=data2)

# aov()의 결과값은 summary()함수를 사용해야 p-value 확인 
summary(result) 

# 6. 분산분석의 사후검정
TukeyHSD(result)
#               diff        lwr        upr     p adj
# 방법2-방법1  2.612903  1.9424342  3.2833723 0.0000000 : 차이 있음
# 방법3-방법1  1.422903  0.7705979  2.0752085 0.0000040 : 차이 있음
# 방법3-방법2 -1.190000 -1.8656509 -0.5143491 0.0001911 : 차이 있음
# diff : 집단간 차이 통계
# lwr ~ upr : 95% 신뢰수준(신뢰구간)
# p adj : 유의확률 < 유의수준(0.05) : 차이있음

plot(TukeyHSD(result))
# lwr ~ upr : 0을 포함하지 않은 경우 : 차이 있음

# [quakes 실습]
data("quakes")
data

# 1. 변수 선택
str(data)
# mgr : y -> 지진 강도(숫자)
# dept : x -> 수심깊이(집단)

# 2. 연속형 -> 범주형(집단변수)
range(quakes$depth) # 40 680
680-40
div <-round(640 / 3)  # 213.3333 -> 213

40 + div # 253
680 - div # 467

## 253 이하
quakes$depth2[quakes$depth <= (40+div)] <- "low"
## 254 ~ 467
quakes$depth2[quakes$depth >= (40+div) & quakes$depth <= (680- div)] <- "mid"
## 468 이상
quakes$depth2[quakes$depth >= (680- div)] <- "high"
quakes

head(quakes)
tail(quakes)
table(quakes$depth2)
# high  low  mid 
# 367  508  125 

# 3. 동질성검정
bartlett.test(mag ~ depth2, data=quakes)
# p-value = 0.1596 -> 모수검정 가능


# 4. 분산분석  
model <- aov(mag ~ depth2, data=quakes)
summary(model)
# Df Sum Sq Mean Sq F value  Pr(>F)    
# depth2        2   9.61   4.806   31.43 5.8e-14 ***
# Residuals   997 152.45   0.153    
# F : 31.43 -> P : 5.78e-14
## 적어도 한 집단 이상에서 차이를 보인다,

# 5. 사후 검정
TukeyHSD(model)
##             diff        lwr         upr     p adj
# low-high  0.17139394  0.1085143  0.23427361 0.0000000  : 차이 있음
# mid-high -0.07557929 -0.1706323  0.01947368 0.1490807  : 차이 없음
# mid-low  -0.24697323 -0.3386135 -0.15533300 0.0000000  : 차이 있음

plot(TukeyHSD(model))


## 이원배치 분산분석 : y ~ x1 + x2
#   - 쇼핑몰 고객의 연령대(20, 30, 40대)별, 시간대(오전/오후)별 구매현황 분석
#   - 독립변수(범주형) : 연령대, 시간대
#   - 종속변수(연속형) : 구매비용

# 1. dataset 생성
age <- round(runif(100, min = 20, max = 49))  # 20~49세
time <- round(runif(100, min = 0, max = 1)) # 0~1


buy <- round(runif(100, min = 1, max =10))

data <-  data.frame(age, time, buy)
head(data)

# 연령대 리코드
data$age2[data$age <= 29] <- 20
data$age2[data$age > 29 & data$age <= 39] <- 30
data$age2[data$age > 39] <- 40
table(data$age2)

# 2. 동질성 검정
bartlett.test(buy ~ data$age2, data = data)  # p-value = 0.3768
bartlett.test(buy ~ data$time, data = data)  # p-value = 0.2578

# 3. 분산분석 : (y ~ x1 + x2)
result <- aov(buy ~ data$age2 + data$time)
summary(result)

#             Df Sum Sq Mean Sq F value Pr(>F)
# data$age2    1    0.8   0.817   0.122  0.728 -> 연령대별 차이 없음
# data$time    1    1.2   1.217   0.182  0.671 -> 시간 별 차이 없음
# Residuals   97  649.2   6.693 

### 사후 검정 제공 안함

# 집단별 서브셋
g1 <- subset(data, age2 == 20)
g2 <- subset(data, age2 == 30)
g3 <- subset(data, age2 == 40)

mean(g1$buy)  # 5.366667
mean(g2$buy)  # 5.275
mean(g3$buy)  # 5.133333

install.packages("dplyr")
library(dplyr)

# %>% : 파이프 연산자 - DF 조작에 관한 함수 나열
data %>% head()  # DF %>% func1() %>% func()

# SQL문
# SELECT avg(buy) FROM data GROUP BY age2;

data %>% group_by(age2) %>% summarise(mean(buy))
#      age2    `mean(buy)`
#  1    20        5.6 
#  2    30        5.13
#  3    40        5.71

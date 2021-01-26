# chap04_2_Function 

# 함수 : 사용자 정의 함수, 내장함수(in R)

########################
## 1. 사용자정의함수
########################
#   - 수학에서 함수  :f(x) = x^2 + 3 에서 x=2일떄 f(x) = 7

# [형식]
# 함수명 <- function([x]) { x : 인수(매개변수), 실행문}

#   (1)인수가 없는 함수
f1 <- function(){
  cat("인수가 없는 함수")
}

f1()  # 함수 호출

#   (2)인수가 있는 함수
f2 <- function(name){
  cat(name, "씨 안녕하세요")
}

f2("홍길동")  # 함수 호출

#    (3)반환값이 있는 함수
f3 <- function(x,y){
  result = x + y  # 계산
  return(result)  # 반환값
}

result = f3(10, 20)
cat("result = ", result)

# <문제1> f(x) = x^2 + x + 3
f4 <- function(x){
  return(x^2 + x + 3)
}
f4(2)


# <문제2> 구구단 출력
# 9 -> 9*1=9 ~ 9*9=81
gugu <- function(x){
  for(i in 1:9){
    result = x * i 
    cat(x," x ", i, " = ", result, '\n')
  }
}

gugu(3)

# 분산, 표주편차를 구하는 함수(var_sd) 정의
x <- c(7, 5, 12, 9, 15, 6)

var(x) # 14.8 - 표본분산 
sd(x) # 3.847077 - 표본표준편차 
sqrt(var(x)) # 분산 양의 제곱근 = 표준편차 

#  표본분산 : var = sum((x-산술평균)^2)/(n-1)
#  표본 표준편차 : sd = sqrt(var)

# 산술평균 함수 정의
avg <- function(x){
  a <- sum(x)/length(x)  # 평균
  return(a)
}

cat("avg = ", avg(x))  

# 산포도 함수 정의
var_sd <- function(x){
  # 표본 분산
  v <- sum((x-avg(x))^2)/(length(x)-1)
  # 표본 표준편차
  s <- sqrt(v)
  cat("표본 분산 = ", v, "\n")
  cat("표본 표준편차 = ", round(s,2))
}

var_sd(x)


##########################
## 2. 주요 R 내장함수 
##########################

# 1) 기술통계 
vec <- round(runif(10, min=1, max=10))  
vec
min(vec) # 벡터 대상 최소값
max(vec) # 벡터 대상 최대값
range(vec) # 벡터 대상 범위 값
mean(vec) # 벡터 대상 평균값
median(vec) # 벡터 대상 사분위수
sum(vec) # 벡터 대상 합계
sort(vec) # 오름차순 
sort(vec, decreasing = T) # 내림차순
order(vec) # 벡터의 정렬된 값의 인덱스를 보여줌
rank(vec) # 벡터의 각 원소의 순위를 알려줌
summary(vec) # 데이터에 대한 기본적인 통계 정보 요약
table(vec) # 데이터 빈도수
sd(vec) # 표준편차

# 2) 반올림 관련 함수 
x <- c(1.5, 2.5, -1.3, 2.5)
ceiling(x) # 큰 정수 
floor(x) # 작은 정수 
round(x) # 반올림

# 3) log 함수 
log(8) # 자연로그 : e 밑수 : 2.079442
log2(8) # 2 밑수 : 3
log10(10) # 상용로그 : 1


# 4) 행렬관련 함수
x <- matrix(1:9, nrow = 3, ncol = 3, byrow = T) # 3x3 정방행렬 
y <- matrix(1:3, nrow = 3) # 3x1 행렬  
dim(x) # 3 3
dim(y)  # 3 1
# 수행조건 : x(열) = y(행) 일치

ncol(x) # 3 : 열 수 반환 
nrow(x) # 3 : 행 수 반환 
t(x) # x의 전치행렬 반환


# 5) 선형대수학  
diag(x) # 대각행렬 

matmul <- x %*% y # (2) 행렬곱 : x, y의 행과 열의 곱의 합
matmul
dim(matmul)  #3(x), 1(y)
# 1차 방정시 : y = x1*a1 +x2*a2 +x3*a3
# 행렬곱 : y = x %% a

x2 <- matrix(1:4, nrow = 2)
x2  # 정방행렬
det(x2) # (3)행렬식 : 좌대각합 - 우대각합 = -2


# 6) 난수 생성 & 확률분포 
# 확률분포
# - 연속확률분포 : 값이 셀 수 없는 확률분포(연속형/실수형) 
# - 이산확률분포 : 값이 셀 수 있는 확률분포(이산형/정수형)

# (1) 표준정규분포 생성 : 연속확률분포
n = 1000
r <- rnorm(n, mean = 0, sd = 1)  # N(0, 1^2) 평균 = 0, 표준편차 = 1
r

mean(r)
sd(r)
hist(r)  # 대칭분포

# (2) 균등분포 생성 : 연속확률분포
r2 <- runif(n, min =0 , max =1) 
r2
hist(r2)  # 균등 분포

# (3) 이항분포 생성 : 이산확률분포
# 형식) rbinom(n,size, prob)
# B(n,p) : n(시행횟수), p(성공확률)
# n = 1 : 베루누이 시행

# ex)동전 앞면(1)이 나오는 확률 실험

# seed : 동일한 난수 생성
set.seed(123)  # 123 = 시드값

#  B(1, 0.5) : 시행횟수 = 1, 성공확률 = 0.5
rbinom(n=10, size=1, prob=0.5)  # n : 반복, size : 시행횟수, prob : 확률
# 1 1 1 0 0 0 1 0 0 1 -> 10번 반복

#  B(20, 0.5) : 시행횟수 = 20, 성공확률 = 0.5
rbinom(n=5, size=20, prob=0.5)  
# 12  8  9 11 10

rbinom(n=5, size=1000,  prob=0.5)  
# 503 485 512 505 491


# (4) sample(n, size)
num <- 1:100
sample(length(num), 20)

sample(c(10:20, 30:50, 100:200), 20)


# (ex) 훈련셋과 검증셋 샘플링 
iris
str(iris)

# 'data.frame' : 150 obs. of 5 variacles:
dim(iris)  # 150 5

idx <- sample(x=nrow(iris), size = nrow(iris)*0.7)
length(idx)  # 105
idx   # 행번호

training <- iris[idx, ]   # 훈련셋
head(training)
dim(training)


150-105  # 45
test <- iris[-idx, ]  # 검정셋
dim(test)
head(test)


getwd()
bmi <- read.csv('bmi.csv')
bmi
idx <- sample(x=nrow(bmi), size = nrow(bmi)*0.75)
training <- bmi[idx, ]
testing <- bmi[-idx, ]

head(training)
head(testing)


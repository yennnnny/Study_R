# chap02_DataStructure

######################
##5가지 자료구조 유형
######################

# 1. vector 자료구조
#   - 동일한 자료형을 갖는 1차원 자료구조
#   - 생성 함수 : c(), seq(), rep()

# 1) c(x1, x2, ...)
var1 <- c(1:10)
var11 <- c(1:10, 20, 30, 50, -5:4)
var1; var11
var1; length(var1)

var2 <- c("hong", "lee", "kang")
var2
mode(var2)

# 2) seq(from, to, by)  -> by : 간격
num <- seq(1,9, by = 2)  # 증가
num <- seq(9,1, by = -2)  # 감소

# 3) rep(x, times, each)
x <- 1:3
rep(x, times = 2)  # 1 2 3 1 2 3
rep(x, each = 2)  # 1 1 2 2 3 3

# 4) index : 자료 저장 위치 -> 1부터

# 형식
## 1) 변수[n]
a <- 1:50
a[5]  # 5번째 원소
a[50]
a[-c(24:26)]  # 특정 원소 제외 : -

## 2) 변수[함수]
length(a)  # 50
a[seq(from = 1, to = length(a),by =2)]

## 3) 변수[조건식]
a[a >= 10 & a <= 30]  # & : AND
a[a >= 10 | a <= 30]  # | : OR
a[!(a >= 10)]  # ! : NOT



# 2. Matrix 자료구조
#   - 동일한 자료형을 갖는 2차원(행X열) 배열구조
#   - 생성 함수 : matrix(), rbind(), cbind()
#   - 처리 함수 : apply()

# 1) matrix()
m1 <- matrix(data = 1:5, nrow = 1, ncol = 5)
m1

m2 <- matrix(data = 1:9, nrow = 3, byrow = TRUE)
m2

dim(m2)  # 3 3 - 차원정보(shape)
mode(m2)  # "numeric"
class(m2)  # "matrix" "array" - 자료구조

# 2) rbind() : vector 행단위 묶음
v1 <- 1:5
v2 <- c(10, 20, 30, 40, 50)
m3 <- rbind(v1, v2)
m3

# 3) cbind() : vector 열단위 묶음
m4 <- cbind(v1, v2)
m4

# 4) apply() : 행렬구조 자료처리 함수
#   - apply(data, 행/열, 함수)

apply(m4, 1, sum)  # 행 단위
apply(m4, 2, mean)  # 열 단위 평균

# 5) 색인(index)()
m2  # 3X3
m2[1,]  # 1행 전체 참조
m2[,1]  # 1열 전체 참조
m2[1,1]  # 1개의 원소


# 3. Array 자료구조
#   - 동일한 자료형을 갖는 3채원 배열구조
#   - 생성함수 : array()

# array()
arr <- array(data=1:12, dim=c(2,2,3))  # dimnames = NULL
arr
dim(arr)  # 2, 2, 3 (행, 열, 면)

arr[,,1]  # 1면
arr[1,,1]  # 1면의 1행 전체


# 4. DataFrame 자료구조
#   - 열 단위 별로 상이한 자료형을 갖는 2차원 배열 구조
#   - 생성함수 : data.frame()
#   - 처리함수 : apply()

# 1) vector 준비 
empno <- 1:3
ename <- c('홍길동', '이순신', '유관순')
gender <- c("남자", "남자", "여자")
pay <- c(350, 450, 550)

# 2) DataFrmae, 생성
emp <- data.frame(NO=empno, NAME = ename, GENDER=gender, PAY = pay)
emp

str(emp)
# 'data.frame':	3 obs. of  4 variables:
# $ NO    : int  1 2 3                      -> 이산형(셀수 있는 수 )
# $ NAME  : chr  "홍길동" "이순신" "유관순" -> 문자형
# $ GENDER: chr  "남자" "남자" "여자"       -> 범주형(집단)
# $ PAY   : num  350 450 550                -> 연속형(셀수 없는 수)


# 3) file open DataFrmae, 생성
setwd("C:/")
getwd()  # "C:/ITWILL/2_Rwork"

emp <- read.csv("emp.csv")
str(emp)
# 'data.frame':	5 obs. of  3 variables:
emp 

# matrix -> data.frame
df <- as.data.frame(m4)

apply(df, 1, sum)
apply(df, 2, mean)

# 4) 컬럼 참조
emp[1, ]  # 색인 참조

# 컬럼 단위 참조 : DF$컬럼
pay <- emp$pay
pay  # 150 450 500 350 400
mean(pay)  # 370
sd(pay)  # 135.0926

names <- emp$name
help("barplot")
barplot(pay, names.arg = names)  # X축 눈금 = 사원명


# 5. List 자료구조
#   - 서로 다른 자료형/자료구조를 갖는 자료구조
#   - 키와 값 한쌍의 원소(key1 = value, key2 = value,...)
#   - 키를 통해 값을 참조
#   - 생성함수: list(key=value)
#   - 처리함수 : unlist(), lapply(), sapply()

#   1) key=value
lst <- list(first = 1:5, sencond =6:10, three=c("a", "b","c"))
lst
##$first
##[1] 1 2 3 4 5

##$sencond
##[1]  6  7  8  9 10

# key -> value 참조
lst$first    # [1] 1 2 3 4 5  -> 전체 참조
lst$first[2:4]  #  -> 부분참조
lst$secend # 6  7  8  9 10
lst$secend[-3] # 6  7  9 10

# $three 
# [1] "a" "b" "c"

#   2) key 생략 : 기본키 제공([[n]])
lst2 <- list('lee', 45, '이순신')  # [key=]value
lst2
## [[1]]  -> 기본키 key
## [1] "lee"

## [[2]]  -> 기본키 key
## [1] 45

## [[3]]  -> 기본키 key
## [1] "이순신"

# key -> value 참조
lst2[[1]]  # "lee"
lst2[[3]]  # "이순신"


# 3) 처리함수 : unlist(), lapply(), sapply()
x <- list(1:5)  # key 생략
x


# list -> vector
vec <- unlist(x)
vec  # [1] 1 2 3 4 5

# lapply(list, func), sapply(list, funsc) : 외부함수 적용
lst3 <- list(x = 1:5, y = 6:10)
lst3

lapply(lst3, sum)  # list 형식 반환
sapply(lst3, sum)  # vector 형식 반환


#  6. 문자열 처리와 정규표현식
install.packages('stringt')
library(stringr)
library(help = 'stringr')

#   1) 패턴과 일치하는 문자열 추출
string <- 'hong35lee45kang55유관순25이사도시45'   # 처리하고자 하는 문자열

# 정규표현식 메타문자 :  [x] : x 1개, {n} : n개 연속
str_extract(string, pattern = '[a-z]{4}')  # 최초로 발견된 패턴 "hong" --> 벡터로 반환
str_extract_all(string, '[a-z]{4}')  # 리스트로 반환
#[[1]]  -> 기본키
#[1] "hong" "kang"

str_extract_all(string, '[가-힣]{3}')  # "유관순" "이사도"
str_extract_all(string, '[가-힣]{3,4}')  # "유관순" "이사도시"


str_extract_all(string, '[0-9]{2}')  # 나이추출

# and(다른 문자 타입 이어서 출력) : 그냥 붙어서, or : | 
names <- str_extract_all(string, '[a-z]{3,}|[가-힣]{3,}')
names
# list -> vector
vnames <- unlist(names)
vnames

#   2) 패턴과 일치하는 문자열 치환(replace)
string2 <- 'age홍길동!@#$kang123유관순'

# 불용어 제거
str_replace_all(string2, pattern = '[!@#$]|[0-9]', replacement = '')  # "age홍길동kang유관순"


#   3) 문자열 분리(split) : 기준 문자열
string3 <-'홍길동, 이순신, 유관순'
names <- str_split(string3, pattern = ', ')
names
length(names)  # 1

vnames <- unlist(names)
length(vnames)  # 3


#   4) 문자열 결합 : 단어 -> 문장
sent <- str_c( vnames, collapse = ', ')  # concat(결합)
sent

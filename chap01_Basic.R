# chap01_Basic


# 1. 패키지와 세션 보기
dim(available.packages())  #  차원정보 : 16871(행:사용가능한 패키지 수) 17(열)

# session : R시작~종료
sessionInfo()  # 세션 보기
# R 버전, 다국어(locale),
# base packages(7개-> 메모리에 올리지 않아도 자동으로 메모리에 올라가서 바로 사용할 수 있는 패키지)


# 2. 패키지 사용법
#  패키지 = fuction + dataset

#   1)패키지 설치 : 기본 30개 이미 설치됨
install.packages('stringr') # download + install

#   2)패키지 설치 경로
.libPaths()

#   3)패키지 사용 : in memory(사용하고자 하는 패키지를 메모리에 로딩)
library(stringr)  # memory loading

str <- '홍길동34이순신45유관순25'  # "", '' 모두 사용 가능
str
str_extract_all(str, '[0-9]{2}')  # "34" "45" "25"
str_extract_all(str, '[가-힣]{3}')  # "홍길동" "이순신" "유관순"

#   4)패키지 삭제
remove.packages('stringr')  # or 폴더에서 물리적으로 삭제 가능

###########################
## 패키지 삭제 시 주의사항
###########################
# 1. 기존 패키지 삭제 후 재설치
#   1) remove.packages('패키지명')
#   2) 재부팅
#   3) install.packages('패키지명')

# 2. 최초 패키지 삭제 후 재설치
#   1) Rstudio 관리자 권한으로 실행
#   2) install.packages('패키지명')


# 3. 변수와 자료형

#   1) (참조)변수 : 객채(object)가 저장된 주소를 저장
#   2) 변수 작성 규칙
#       - 시작은 영문, 숫자 혼용, 특수문자(_, .)
#       - 한글 비권장
#       - 예약어, 함수명 사용불가가
#       - 대소문자 구분


score2020.kor = 95
score2020.eng = 90

tot = score2020.kor + score2020.eng
tot  # 185
print(tot)

num = 100  # int
NUM = 125.45
num; NUM

num = 100.25  # float

# vector 변수
name <- "홍길동"  # 1개 워소
age <- 35
name; age

names <- c("홍길동", "이순신", "유관순")  #여러개 원소를 갖틑 변수
ages <- c(35, 45, 25)

names  # [1] "홍길동", "이순신", "유관순"
names[3]
ages[2]

#   3) 자료형(data type)
int <- 100  #숫자형
string <- "우리나라 대한민국"  # 문자형
boolean <- TRUE  # or FALSE  - 논리형
int; string; boolean


# 자료형 반환 함수
mode(int)  # "numeric"  -> 계산, 차트
mode(string)  # "charater"  -> 계산(X), 차트(X)
mode(boolean)  # "logical"  -> 조건식

# is.xxx(X)  -> T/F
is.numeric(int)  #TURE
is.character(string)  #TURE
is.logical(int) #FALSE

score <- c(85, 75, 65, NA, 90)
score  # 85 75 65 NA(결측치) 90

is.na(score)  # 결측치 유무 반환
# FALSE FALSE FALSE  TRUE FALSE

#   4) 자료형 변환 : as.xxx(X)
#     (1) 문자형--> 숫자형

X <- c(10, 20, 30, '40')
X  # "10" "20" "30" "40"
mode(X)  #"character"
sum(X)  # error -- > 문자 연산 불가능

num<- as.numeric(X)  # 형 변환환
mode(num)  # "numeric"
sum(num)  # 100
barplot(num)

#     (2) 문자형--> 날짜형
Sys.Date()  # "2021-01-13"
Sys.time()  # "2021-01-13 11:13:14 KST"

today <- "2021-01-13"
mode(today)  # "character"

ctoday <- as.Date(today) # 형 변환
mode(ctoday)  # "numeric"
class(ctoday)  # "Date"

## mode VS class
# mode :  자료형만 반환
# class : 자료구조(어떤 구조에 의해 자료가 만들어 졌는지)



# 4. 기본 함수 사용 및 작업공간

#   1) 기본함수 도움말  : 7개 패키지에서 제공하는 함수
help(sum)  # sum(..., na.rm = FALSE)
?sum

sum(score)  # na.rm = FLASE
sum(score, na.rm = TRUE)  # 315

args(sum)  # function(..., na.rm = FALSE) 

example(sum)

# google : stringr in R


#   2) 기본 데이터셋
data("Nile")  # memory loading
Nile
length(Nile)  # 100
mode(Nile)  # "numeric"
mean(Nile)  # 919.35
plot(Nile)  # 시계열 시각화



#   3) 작업 공간
getwd()  # 현재 작업 위치 반환환

setwd("C:/")  # 작업 위치 변경경
getwd()

emp <- read.csv("emp.csv")
emp



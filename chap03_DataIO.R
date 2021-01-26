# chap03_DataIO

# 데이터(파일) 입출력

# 1. 데이터 불러오기

##  1) 키보드 입력
score <- scan()  # 숫자 입력 -> 소량의 데이터를 입력할때 유용
score
mean(score)  # 80


##  2) 파일 자료 불러오기
# csv : 콤마, txt : 공백 or 특수문자, xlsx : excel
getwd() 
setwd("C:/")  # . : 현재경로를 기준으로 // 상대경로

# (1) read.table() : 컬럼 구분자(공백, 특수문자) 
st <- read.table('student.txt')
st  # V1 V2 V3 V4 : 기본 컬럼명 제공

## 컬럼명이 있는 경우
st1 <- read.table('student1.txt', header = TRUE)
st1

## 특수문자 구분자
st2 <- read.table('student2.txt', sep = ';',header = TRUE)
st2


# (2) read.csv() : header = TRUE, sep=','  -> 기본값
bmi <- read.csv(file = 'bmi.csv', header = TRUE, sep = ',')
bmi <- read.csv(file = 'bmi.csv')
bmi
str(bmi)  # 'data.frame':	20000 obs. of  3 variables:

# 탐색기 이용 : 파일 선택
emp <- read.csv(file = file.choose())
emp


# (3) read.xlsx()
#   [방법1]
install.packages('xlsx')  # rJava 패키지도 함께 설치(의존성을 갖음)
read.xlsx()

library(rJava)  # R에서 java를 사용할 수 있게 해주는 패키지
# java 가상머신 경로 설정
Sys.setenv(JAVA_HOME = 'C:\\Program Files\\Java\\jdk1.8.0_151')
library(xlsx)  # excel file 읽어오기

ex <- read.xlsx(file.choose(), sheetIndex = 1, encoding = 'UTF-8')
ex

#   [방법2]
install.packages('readxl')
library(readxl)

setwd('C:/')
stex <- read_excel("studentexcel.xlsx")
stex

calss(stex)
# tbl_df ->  data.frame 형변환
stex_df <- as.data.frame(stex)
stex_df


# (4) 인터넷 파일 불러오기기
# 데이터 셋 제공 사이트 
# http://www.public.iastate.edu/~hofmann/data_in_r_sortable.html - Datasets in R packages
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# https://r-dir.com/reference/datasets.html - Dataset site
# http://www.rdatamining.com/resources/data

titanic <- read.csv("https://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
titanic
str(titanic)
# data.frame':	1316 obs. of  5 variables:

head(titanic)  # 6개 관측치
tail(titanic)

# 범주형 빈도수 : 생존유무
table(titanic$survived)
# no yes
# 817 499

# 성별 빈도수
table(titanic$sex)
# man women 
#869   447 

# 교차분할표
table(titanic$survived, titanic$sex)  # (행, 열)
#      man women
# no  694   123
# yes 175   324

man_rate = 694 / (694+175)  # 0.7986191
women_rate = 123 / (123+324)  # 0.2751678
man_rate; women_rate




# 2. 데이터 저장하기

# 1) 화면 출력
# cat('문자열, 변수)
cat('남자 사망 비율 : ', round(man_rate, 2)*100,'%')


# print(변수, 수식)
print(man_rate*100)



# 2) 파일 저장
# read.table() <-> write.table()
# read.csv() <-> write.csv()
# read_excel() <-> write_excel()

getwd()
setwd("C:/")

#   (1) write.table : 컬럼 구분자(공백)
write.table(st1, file = 'st_table1.txt', row.names = FALSE, quote = FALSE)


#   (2) write.csv : 컬럼 구분자(,)
data("iris")
str(iris)
# data.frame':	150 obs. of  5 variables
head(iris)

write.csv(iris, file = 'iris_df.csv', row.names = FALSE, quote = FALSE)


#   (3) write_xlsx()
install.packages('writexl')
library(writexl)

write_xlsx(stex_df, path = 'stex_df.xlsx')


# chap06_EDA_Preprocessing

# subset 만들기(data, 조건식)
x <- 1:5
y <- 6:10
z <- letters[1:5]  # a~z

df <- data.frame(x, y, z)
df

# 1) 조건식으로 만들기
df2 <- subset(df, x>3)
df2


# 2) 컬럼으로 만들기
df3 <- subset(df, select = c(x, y))
df3 

# 3) %in% 연산자로 만드기
df4 <- subset(df, z %in% c("a", "c", "e"))


#####################################
## Chapter06. 탐색적데이터분석과 전처리 
#####################################

# 1. 탐색적 데이터 조회 

# 실습 데이터 읽어오기

setwd("C:/")

dataset <- read.csv("dataset.csv", header=TRUE) # 헤더가 있는 경우
# dataset.csv - 칼럼과 척도 관계 

# 1) 데이터 조회
#    - 탐색적 데이터 분석을 위한 데이터 조회 

# (1) 데이터 셋 구조
names(dataset) # 변수명(컬럼)
attributes(dataset) # names(), class, row.names
str(dataset) # 데이터 구조보기
dim(dataset) # 차원보기 : 300 7
nrow(dataset) # 관측치 수 : 300
length(dataset) # 칼럼수 : 7 

# (2) 데이터 셋 조회
# 전체 데이터 보기
dataset # print(dataset) 
View(dataset) # 뷰어창 출력

# 칼럼명 포함 간단 보기 
head(dataset) 
tail(dataset) 

# (3) 칼럼 조회 
# 형식) dataframe$칼럼명   
dataset$age 
dataset$resident
length(dataset$age) # data 수-300개 

# 형식) dataframe["칼럼명"] - $기호 대신 [""]기호 사용
dataset["gender"] 
dataset["price"]

# 형식) dataframe[색인] : 색인(index)으로 원소 위치 지정 
dataset[2] # 두번째 컬럼
dataset[6] # 여섯번째 컬럼
dataset[3,] # 3번째 관찰치(행) 전체
dataset[,3] # 3번째 변수(열) 전체

# dataset에서 2개 이상 칼럼 조회
dataset[c("job","price")]
dataset[c(2,6)] 

dataset[c(1,2,3)] 
dataset[c(1:3)] 
dataset[c(2,4:6,3,1)] 


# 2. 결측치(NA) 처리
summary(dataset$price) 
sum(dataset$price) # NA 출력
sum(dataset$price, na.rm = TRUE)  # sum

# 결측데이터 제거  
price2 <- na.omit(dataset$price) 
sum(price2) # 2362.9
length(price2) # 270 -> 30개 제거

dim(dataset)  # 300     7

# subset 생성
dataset2 <- na.omit(dataset)
dim(dataset2)  # 209    7

# 결측데이터 처리(0 or 상수 대체)
x <- dataset$price # price vector 생성 
x[1:30] # 5.1 4.2 4.7 3.5 5.0
dataset$price2 = ifelse( !is.na(x), x, 0) # 0으로 대체
dataset$price2[1:30]

# 결측데이터 처리(평균 or 중위수 대체)
x <- dataset$price # price vector 생성 
x[1:30] # 5.1 4.2 4.7 3.5 5.0
dataset$price3 = ifelse(!is.na(x), x, round(mean(x, na.rm=TRUE), 2) ) # 평균으로 대체
dataset$price3[1:30]



# 3. 극단치 발견과 정제

# 1) 범주형 변수 극단치 처리
gender <- dataset$gender
gender

# outlier 확인
hist(gender) # 히스토그램
table(gender) # 빈도수
pie(table(gender)) # 파이 차트
# 0   1   2   5
# 2  173 124  1

# gender 변수 정제(1,2)
dataset <- subset(dataset, gender==1 | gender==2)
dataset # gender변수 데이터 정제
length(dataset$gender) # 297개 - 3개 정제됨
pie(table(dataset$gender))


# 2) 비율척도 극단치 처리

# (1) 정상 범위 기반 이상치 처리
dataset$price # 세부데이터 보기(2~8반원)
length(dataset$price) #300개(NA포함)
plot(dataset$price) # 산점도 
summary(dataset$price) # 범위확인

# price변수 정제
dataset2 <- subset(dataset, price >= 2 & price <= 8)
length(dataset2$price) 
boxplot(dataset2$age)

# (2) 사분범위(IQR) 기반 
plot(dataset$price)

boxplot(dataset$price)

# 이상치 발경 : 상자그래프 & 통계량
boxplot(dataset$price)$stats  # 정상범위 통계 : 2.1~7.9

# 이상치 정제 
dataset2 <- subset(dataset, price >= 2.1 & price <= 7.9)
dim(dataset2)  # 248  8
boxplot(dataset2$price)


# 4. 코딩변경 
# - 데이터의 가독성, 척도 변경, 최초 코딩 내용 변경을 목적으로 수행

# 1) 가독성을 위한 코딩변경 
# 형식) dataframe$새칼럼명[부울린언식] <- 변경값   
dataset2$resident2[dataset2$resident == 1] <-'1.서울특별시'
dataset2$resident2[dataset2$resident == 2] <-'2.인천광역시'
dataset2$resident2[dataset2$resident == 3] <-'3.대전광역시'
dataset2$resident2[dataset2$resident == 4] <-'4.대구광역시'
dataset2$resident2[dataset2$resident == 5] <-'5.시구군'
dataset2[c("resident","resident2")] # 2개만 지정

dataset2$job2[dataset2$job == 1] <- '공무원'
dataset2$job2[dataset2$job == 2] <- '회사원'
dataset2$job2[dataset2$job == 3] <- '개인사업'

# 2) 연속형 -> 범주형
dataset2$age2[dataset2$age <= 30] <-"청년층"
dataset2$age2[dataset2$age > 30 & dataset2$age <=55] <-"중년층"
dataset2$age2[dataset2$age > 55] <-"장년층"
head(dataset2)

# 3) 역코딩 : 긍정순서(5~1)
# 5점 척도 
# 1.매우만족,  ...  5. 매우불만족 -> 6-1, 6-5 -> 5, 1

dataset2$survey
survey <- dataset2$survey
csurvey <- 6-survey # 역코딩
csurvey
survey  # 역코딩 결과와 비교
dataset2$survey <- csurvey # survery 수정
head(dataset2) # survey 결과 확인


# 5. 탐색적 분석을 위한 시각화 

# 데이터셋 불러오기
new_data <- read.csv("new_data.csv", header=TRUE)
new_data 
dim(new_data) #  231  15
str(new_data)

# 1) 명목척도(범주/서열) vs 명목척도(범주/서열) 
# - 거주지역과 성별 칼럼 시각화 
table(new_data$resident)
table(new_data$gender)

#교차 분할표
resident_gender <- table(new_data$resident2, new_data$gender2)
resident_gender
gender_resident <- table(new_data$gender2, new_data$resident2)
gender_resident

# 성별에 따른 거주지역 분포 현황 
barplot(resident_gender, beside=T, horiz=T,
        col = rainbow(5),
        legend = row.names(resident_gender),
        main = '성별에 따른 거주지역 분포 현황') 
# row.names(resident_gender) # 행 이름 

# 거주지역에 따른 성별 분포 현황 
barplot(gender_resident, beside=T, 
        col=rep(c(2, 4),5), horiz=T,
        legend=c("남자","여자"),
        main = '거주지역별 성별 분포 현황')  


# 2) 비율척도(연속) vs 명목척도(범주/서열)
# - 나이와 직업유형에 따른 시각화 
install.packages("lattice")  # chap08
library(lattice)

# 직업유형에 따른 나이 분포 현황   
# func(y~x)
densityplot( ~ age, data=new_data, groups = job2,
             plot.points=T, auto.key = T)
# plot.points=T : 밀도, auto.key = T : 범례 

# 3) 비율(연속) vs 명목(범주/서열) vs 명목(범주/서열)
# - 구매비용(연속):x칼럼 , 성별(명목):조건, 직급(서열):그룹   

# (1) 성별에 따른 직급별 구매비용 분석  
densityplot(~ price | factor(gender2), data=new_data, 
            groups = position2, plot.points=T, auto.key = T) 

# | factor(명목 척도) : 격자 만듬
# 조건(격자) : 성별, 그룹 : 직급 

# (2) 직급에 따른 성별 구매비용 분석  
densityplot(~ price | factor(position2), data=new_data, 
            groups = gender2, plot.points=T, auto.key = T) 
# 조건 : 직급(격자), 그룹 : 성별 


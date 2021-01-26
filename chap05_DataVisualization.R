# chap05_DataVisualization

# 이산형 변수와 연속형 변수 시각화

# 1. 이산형 변수 시각화
#   - 이산형 변수 : 정수 단위로 나누어지는 변수(자녀수, 판매수)

# 차트 데이터 생성
chart_data <- c(305,450, 320, 460, 330, 480, 380, 520) 
names(chart_data) <- c("2016 1분기","2017 1분기","2016 2분기","2017 2분기","2016 3분기","2017 3분기","2016 4분기","2017 4분기")
str(chart_data)
chart_data

# 1) 막대 그래프 시각화

#   (1) 세로막대 그래프
help("barplot")
barplot(chart_data, ylim = c(0, 600),
        col = rainbow(8), 
        xlab = "년도별 분기 현황",
        main = "2016 년도 2017년도 분기별 매출현황황")

#   (2) 가로막대 그래프
barplot(chart_data, xlim = c(0, 600),
        horiz = TRUE,  # 그래프를 가로로 그림
        col = rainbow(8), xlab = "매출액(단위 : 만원)",
        ylab = "년도별 분기 현황",
        main = "2016 년도 2017년도 분기별 매출현황황")

# 1행 2열 차트 보기
par(mfrow =  c(1, 2))
VADeaths
row_names <- row.names(VADeaths)

# 개별 막대 차트트
barplot(VADeaths, beside = TRUE, col = rainbow(5),  # beside = T : 개별형
        main = "버지니아주 하위계층 사망비율")

legend(x = 20, y = 71,  # x : 우측 하단, y : 좌측상단
       legend = row_names,cex = 0.8, fill = rainbow(5) )


# 누적 막대 차트트
barplot(VADeaths, beside = F, col = rainbow(5),  # beside = F : 누적형
        main = '버지니아주 하위계층 사망비율')

legend(x = 4, y = 200,  # x : 우측 하단, y : 좌측상단
       legend = row_names,cex = 0.8, fill = rainbow(5) )



# 2) 점 그래프
chart_data
dotchart(chart_data, color=c("green","red"), lcolor="black",
         pch=1:2, labels=names(chart_data), xlab="매출액",
         main="분기별 판매현황 점 차트 시각화", cex=1.2)


# 3) 파이 그래프 : 비율(점유율) 시각화에 유용
pie(chart_data, labels = names(chart_data), border = 'blue',
    col = rainbow(8), cex = 1.2)
title("2014~2015년도 분기별 매출 현황황")  # 직전에 그린 차트의 제목 추가

#  파이 그래프 주의사항 : 중복 응답 반영 불가(비율만 제공)
genre <- c(45, 25, 15, 30)  # 100명을 설문조사
names(genre) <- c("액션", "스릴러", "공포", "드라마마")
genre
sum(genre)  # 115(15명 중복)

rate =  round(45 / sum(genre)*100, 2)  # 39.13
lables = paste(names(genre), '\n',rate)  # 문자열 결함

pie(genre, lable = lables, col = rainbow(4))  # 비율 적용
barplot(genre, ylim = c(0,50), col=rainbow(4))  # 실제값 적용

# 실제값 적용
bp <- barplot(genre, ylim = c(0, 50), col = rainbow(4))
text(x = bp, y = genre + 2, labels = genre, col="black")  # text 반영영



# 2. 연속형 변수 시각화
#   - 연속형 변수 : 주어진 범위 안의 모든 연속되 값을 갖는 변수(실수형)

# 1) Box plot
#   - 요약 통계 정보를 시각화 하는 도구
VADeaths
summary(VADeaths)  # 요약통계

boxplot(VADeaths, range = 0)  # 상자 그래프


# 2) histogram
#   - 계급과 빈도수에 따른 
data(iris)
names(iris)
str(iris)
head(iris)
# 'data.frame':	150 obs. of  5 variables:
# $ Sepal.Length(꽃받침 길이): num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...연속형
# $ Sepal.Width(꽃받침 넓이) : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...연속형
# $ Petal.Length(꽃잎 길이) : num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...연속형
# $ Petal.Width(꽃잎 넓이) : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...연속형
# $ Species(종)     : Factor w/ 3 levels "setosa","versicolor"

table(iris$Species)
# setosa versicolor virginica 
#   50      50          50 

summary(iris$Sepal.Length)  # 꽃받침 길이
summary(iris$Sepal.Width)  # 꽃의 넓이

#    (1) 일반 히스토 그램
hist(iris$Sepal.Width, 
     col="plum",  # 색상
     main="iris 꽃받침 넓이 histogram",  # main 제목(차트 제목)
     xlab="iris$Sepal.Width",  # x축 이름
     xlim=c(2.0, 4.5))  # x축 범위

#    (2) 계급수 조정
hist(iris$Sepal.Width, xlab="iris$Sepal.Width",
     col="plum", breaks = 30,  # 막대 개수 지정
     main="iris 꽃받침 넓이 histogram", xlim=c(2.0, 4.5))

#    (3) 확률 밀도 함수(PDF) : 확률 변수 x의 크기를 나타낸 값(추정)
#       step1 : 밀도 단위 변경
hist(iris$Sepal.Width, xlab="iris$Sepal.Width",
     col="plum", freq = FALSE,
     main="iris 꽃받침 넓이 histogram", xlim=c(2.0, 4.5))

#       step2 : 밀도 단위 변경
lines(density(iris$Sepal.Width), col="red")


#    (4) 정규분포 곡선 : dnorm(정규분포 추정 --> 곡선추가 )
x <- seq(2.0, 4.5, 0.1)  # 2.0~4.5까지 0.1 간격으로 
curve(dnorm(x, mean=mean(iris$Sepal.Width), sd=sd(iris$Sepal.Width)),
      col="blue", add = T)

# 정규분포 예
r <- rnorm(10000)  # mean = 0, sd =1
hist(r, freq = FALSE)
lines(density(r), col = "red")  # 확률 밀도 함수  -> 곡선

range(r)  # -4.017952  3.680873
x <- seq(-4.017952, 3.680873, 0.1 )
curve(dnorm(x, mean=mean(r), sd=sd(r)), 
      col="blue", add = T)  # 정규 분포 추정 -> 곡선


# 3) Scatter plot: (x, y)
price<- runif(10, min=1, max=100) # 1~100사이 10개 난수 발생
price #price <-c(1:10)
plot(price)  # x= index

# 2행 2열 차트
par(mfrow=c(2,2)) 
plot(price, type="l") # 유형 : 실선
plot(price, type="o") # 유형 : 원형과 실선(원형 통과)
plot(price, type="h") # 직선
plot(price, type="s") # 꺾은선(계단형)


# pch : 연결점 문자타입-> plotting characher-번호(1~30)
plot(price, type="o", pch=5) # 빈 사각형
plot(price, type="o", pch=15)# 채워진 마름모
plot(price, type="o", pch=20, col="blue") #color 지정
plot(price, type="o", pch=20, col="orange", cex=1.5) #character expension(확대)
plot(price, type="o", pch=20, col="plum", cex=2.0, lwd=3) #lwd : line width


# 만능차트 : 사용가능한 plot list
methods(plot)

# (예시) 시계열 데이터  -> 추세선 그래프
WWWusage
plot(WWWusage)

# plot 2개 겹치기
plot(iris$Sepal.Length, type="o", ann=FALSE, col="blue")  # ann=FALSE : 축 이름 제외 
par(new = T)   # 그래프 겹치기
plot(iris$Sepal.Length,type = "o", col="red",
     ann = FALSE, axes = FALSE)  # 축 눈금 제외

title("iris의 꽃받침 길이와 꽃잎의 길이 비교")
legend(x = 0, y = 7, legend = c("꽃받침 길이", "꽃잎의 길이"),
       lty = 1, col = c("blue", "red"))

# plot 2개 겹치기 
plot(iris$Sepal.Length, type="o", ann=FALSE, col="blue")


# ann=FALSE : 축 이름 제외 
par(new = T) # 그래프 겹치기 
plot(iris$Petal.Length, type="o", axes = FALSE,
     ann=FALSE, col="red")
# axes = FALSE : 축 눈금 제외 
title("iris의 꽃받침 길이와 꽃잎의 길이 비교")
# 범례추가 
legend(x=0, y=7, legend = c("꽃받침 길이", "꽃잎의 길이"),
       lty=1, col=c("blue", "red"))

# 4) Scatter Matrix: (x, y) : 변수 비교
pairs(iris[, 1:4])  # 변수 4개 이용


# 5) 차트 파일 저장
setwd("C:/") # 폴더 지정

jpeg("iris.jpg", width=720, height=480) # 픽셀 지정 가능
plot(iris$Sepal.Length, iris$Petal.Length, col=iris$Species)
title(main="iris 데이터 테이블 산포도 차트")
dev.off() # 장치 종료
...

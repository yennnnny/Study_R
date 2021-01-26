# Correlation

##################################################
# chap10. 상관관계 분석(Correlation Analysis)
##################################################
# - 변수 간 관련성 분석 방법
# - 상관분석/회귀분석 변수 : 등간척도 or 비율척도

product <- read.csv("C:/.csv", header=TRUE)
head(product) # 친밀도 적절성 만족도(등간척도 - 5점 척도)

# 기술통계량
summary(product) # 요약통계량

sd(product$제품_친밀도); sd(product$제품_적절성); sd(product$제품_만족도)
# 변수 간의 상관관계 분석 
# 형식) cor(x,y, method) # x변수, y변수, method(pearson): 방법

# 1) 상관계수(coefficient of correlation) : 두 변량 X,Y 사이의 상관관계 정도를 나타내는 수치(계수)
cor(product$제품_친밀도, product$제품_적절성) # 0.4992086 -> 다소 높은 양의 상관관계

cor(product$제품_친밀도, product$제품_만족도) # 0.467145 -> 다소 높은 양의 상관관계

cor(product$제품_적절성, product$제품_만족도) # 0.7668527 -> 높은 양의 상관관계

# 전체 변수 간 상관계수 보기
cor(product, method="pearson") # 피어슨 상관계수 - default
## 상관걔쑤 정방 행렬
#              제품_친밀도 제품_적절성 제품_만족도
# 제품_친밀도   1.0000000   0.4992086   0.4671450
# 제품_적절성   0.4992086   1.0000000   0.7668527
# 제품_만족도   0.4671450   0.7668527   1.0000000


# 방향성 있는 색생으로 표현 - 동일 색상으로 그룹화 표시 및 색의 농도 
install.packages("corrgram") # -> 상관계수 시각화   
library(corrgram)
corrgram(product, font.labels = 20) # 색상 적용 - 동일 색상으로 그룹화 표시
corrgram(product, upper.panel=panel.conf) # 수치(상관계수) 추가(위쪽)
corrgram(product, lower.panel=panel.conf) # 수치(상관계수) 추가(아래쪽)

# 차트에 곡선과 별표 추가
install.packages("PerformanceAnalytics") 
library(PerformanceAnalytics) 

# 상관성,p값(*),정규분포 시각화 - 모수 검정 조건 
chart.Correlation(product, histogram=TRUE, pch="+") 

# spearman : 서열척도 대상 상관계수


# 2. 공분산 : 두 변인 x, y 의 관걔를 나타내는 양(크기)
cor(product)
cov(product)

cov2cor(cov(product))

# 상관계수 VS 공분산
## 상관계수 : 두 변인 x, y의 관계를 나타내는 크기, 방향(양/음) 제공
## 공분산 : 두 변인 x, y의 관계를 나타내는 크기만 제공


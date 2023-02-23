library(nnet)
library(randomForest)
library(caret)
library(kernlab)

setwd("C:/Users/Soyoung Cho/Desktop/datamining")
train <- read.csv("train_result.csv")
test <- read.csv("test_result.csv")

### 다중 로지스틱 회귀분석
### 미세먼지 예측
str(train)
str(test)
train_pm10 <- train[,-c(1,2,52,50,49)]
test_pm10 <- test[,-c(1,2,3,53,51,50)]
colnames(train_pm10)
str(train_pm10)
str(test_pm10)
as.factor(test_pm10$pm_10)
library(randomForest)
library(caret)

library(randomForest) # 랜덤 포레스트 모델
library(caret) # 특징 선택
library(e1071) # 모델 튜닝
install.packages("ROCR")
library(ROCR) # 모델 평가

tr <- trainControl(method = "repeatedcv", number = 5 )
modFit.rf <- caret::train(pm_10 ~., data = train_pm10, method = "rf", prox = TRUE, trControl = tr)
modFit.rf

pred.rf <- predict(modFit.rf, newdata = test_pm10)
actual.rf <- as.factor(test_pm10$pm_10)
confusionMatrix(actual.rf, pred.rf)

setwd("C:/Users/stand/code/2020/Datamining_Analysis/data")
library(nnet)
library(randomForest)
library(caret)
train <- read.csv("train_result.csv")
test <- read.csv("test_reresult.csv")
str(train)
# factor형 변환
train$pm10_Q <- as.factor(train$pm10_Q)
train$pm25_Q <- as.factor(train$pm25_Q)
train$pm_10 <- as.factor(train$pm_10)
train$pm_25 <- as.factor(train$pm_25)
test$pm10_Q <- as.factor(test$pm10_Q)
test$pm25_Q <- as.factor(test$pm25_Q)
test$pm_10 <- as.factor(test$pm_10)
test$pm_25 <- as.factor(test$pm_25)

# EDA
# 미세먼지 plot
barplot(table(train$미세먼지.....))
barplot(table(train$초미세먼지.....))
barplot(table(test$미세먼지.....))
barplot(table(test$초미세먼지.....))
# 4분위수 기준 범주형 플랏
plot(train$pm10_Q)
plot(train$pm25_Q)
plot(test$pm10_Q)
plot(test$pm25_Q)
# 미세먼지 농도 기준 범주형 플랏
plot(train$pm_10)
plot(train$pm_25)
plot(test$pm_10)
plot(test$pm_25)

################################################################################
################################################################################
var.test(train$미세먼지....., test$미세먼지.....)
var.test(train$초미세먼지....., test$초미세먼지.....)

t.test(train$미세먼지....., test$미세먼지.....,  
       paired =FALSE, var.equal = TRUE, conf.level = 0.95)
t.test(train$초미세먼지....., test$초미세먼지.....,  
       paired =FALSE, var.equal = TRUE, conf.level = 0.95)




################################################################################
################################################################################
################################regression######################################
regression_tr_pm10 <- train[, !names(train) %in% c("pm10_Q", "초미세먼지.....", "pm25_Q",
                                             "pm_10", "pm_25")]
regression_te_pm10 <- test[, !names(test) %in% c("X", "pm10_Q", "초미세먼지.....", "pm25_Q",
                                          "pm_10", "pm_25")]
regression_tr_pm25 <- train[, !names(train) %in% c("미세먼지.....", "pm25_Q", "pm10_Q",
                                             "pm_10", "pm_25")]
regression_te_pm25 <- test[, !names(test) %in% c("X", "미세먼지.....", "pm25_Q", "pm10_Q",
                                          "pm_10", "pm_25")]
str(regression_te_pm10)
# 미세먼지 예측
regression_pm10_model <- lm(미세먼지.....~., regression_tr_pm10)
summary(regression_pm10_model)
# 미세먼지 모델에 변수 선택법 Stepwise 수행
model1 = step(regression_pm10_model, direction="both")
summary(model1)

# 초미세먼지 예측
regression_pm25_model <- lm(초미세먼지.....~., regression_tr_pm25)
summary(regression_pm25_model)
# 초미세먼지 모델에 변수 선택법 Stepwise 수행
mode2 = step(regression_pm25_model, direction="both")
summary(mode2)

################################################################################
################################################################################
############################다항 로지스틱 회귀##################################
# 1. 4분위수 예측 모델링
str(train)
str(test)
train_pm10_Q <- train[, !names(train) %in% c("미세먼지.....", "초미세먼지.....", "pm25_Q",
                                             "pm_10", "pm_25")]
test_pm10_Q <- test[, !names(test) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm25_Q",
                                            "pm_10", "pm_25")]
train_pm25_Q <- train[, !names(train) %in% c("미세먼지.....", "초미세먼지.....", "pm10_Q",
                                             "pm_10", "pm_25")]
test_pm25_Q <- test[, !names(test) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm10_Q",
                                          "pm_10", "pm_25")]
### 1.1 4분위수 미세먼지 예측 모델링
train_pm10_Q_model <- multinom(pm10_Q ~ ., data=train_pm10_Q)
summary(train_pm10_Q_model)
predictionsTree <- predict(train_pm10_Q_model, test_pm10_Q, na.action = na.pass)
confusionMatrix( table(predictionsTree, test_pm10_Q$pm10_Q) )

### 1.2 4분위수 초미세먼지 예측 모델링
train_pm25_Q_model <- multinom(pm25_Q ~ ., data=test_pm25_Q)
summary(train_pm25_Q_model)
predictionsTree_1 <- predict(train_pm25_Q_model, test_pm10_Q, na.action = na.pass)
confusionMatrix( table(predictionsTree_1, test_pm25_Q$pm25_Q) )


# 2. 농도 기준 미세먼지 예측 모델링
train_pm10 <- train[, !names(train) %in% c("미세먼지.....", "초미세먼지.....", "pm25_Q",
                                             "pm_25", "pm10_Q")]
test_pm10 <- test[, !names(test) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm25_Q",
                                          "pm_25", "pm10_Q")]
train_pm25 <- train[, !names(train) %in% c("미세먼지.....", "초미세먼지.....", "pm25_Q",
                                           "pm_10", "pm10_Q")]
test_pm25 <- test[, !names(test) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm25_Q",
                                        "pm_10", "pm10_Q")]
### 2.1농도 기준 미세먼지 예측 모델링
train_pm10_model <- multinom(pm_10 ~ ., data=train_pm10)
summary(train_pm10_model)
predictionsTree1 <- predict(train_pm10_model, test_pm10, na.action = na.pass)
confusionMatrix( table(predictionsTree1, test_pm10$pm_10) )
### 2.2 농도 기준 초미세먼지 예측 모델링 -> 33% 예측 정확도
train_pm25_model <- multinom(pm_25 ~ ., data=train_pm25)
summary(train_pm25_model)
predictionsTree2 <- predict(train_pm25_model, test_pm25, na.action = na.pass)
confusionMatrix( table(predictionsTree2, test_pm25$pm_25) )

################################################################################
################################################################################
#############################랜덤 포레스트######################################
# 1. 미세먼지 랜덤 포레스트
pm10_rf = randomForest(pm_10 ~ ., data = train_pm10, mtry = 10, ntree = 200, importance = T)
pm10_pred = predict(pm10_rf, test_pm10, type = "class")
confusionMatrix(pm10_pred, test_pm10$pm_10)
importance(pm10_rf)
varImpPlot(pm10_rf, main="varImpPlot of Random Forest")

# 2. 초미세먼지 랜덤 포레스트
pm25_rf = randomForest(pm_25 ~ ., data = train_pm25, mtry = 10, ntree = 200, importance = T)
pm25_pred = predict(pm25_rf, test_pm25, type = "class")
confusionMatrix(pm25_pred, test_pm25$pm_25)
importance(pm25_rf)
varImpPlot(pm25_rf, main="varImpPlot of Random Forest")

str(train_pm25)



















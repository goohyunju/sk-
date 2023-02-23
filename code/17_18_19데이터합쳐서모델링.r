setwd("C:/Users/stand/code/2020/Datamining_Analysis/data")
library(nnet)
library(randomForest)
library(caret)
library(kernlab)


train <- read.csv("train_real_result.csv")
test <- read.csv("test_real_result.csv")
colSums(is.na(train))
colSums(is.na(test))

train <- train[, !names(train) %in% c("X.1", "X", "일시","tianjin_o3", "qingdao_co",
                                      "권역명", "지점명", "요일")]
test <- test[, !names(test) %in% c("X.1", "X", "일시","tianjin_o3", "qingdao_co",
                                   "권역명", "지점명", "요일")]

str(train)
test_na <- na.omit(test)
colSums(is.na(test_na))
str(test)
# 미세먼지 사분위수 범주형 변환
train_4q <- within(train, 
                   {
                      pm10_Q = character(0)
                      pm10_Q[미세먼지..... < quantile(미세먼지....., 0.25)] = "1Q"
                      pm10_Q[미세먼지..... >= quantile(미세먼지....., 0.25) & 미세먼지..... < quantile(미세먼지....., 0.50)] = "2Q"
                      pm10_Q[미세먼지..... >=quantile(미세먼지....., 0.50) & 미세먼지..... < quantile(미세먼지....., 0.75)] = "3Q"
                      pm10_Q[미세먼지..... >= quantile(미세먼지....., 0.75)] = "4Q"
                      pm10_Q = factor(pm10_Q, level = c("1Q", "2Q", "3Q", "4Q"))})

test_4q <- within(test_na, 
                  {
                     pm10_Q = character(0)
                     pm10_Q[미세먼지..... < quantile(미세먼지....., 0.25)] = "1Q"
                     pm10_Q[미세먼지..... >= quantile(미세먼지....., 0.25) & 미세먼지..... < quantile(미세먼지....., 0.50)] = "2Q"
                     pm10_Q[미세먼지..... >=quantile(미세먼지....., 0.50) & 미세먼지..... < quantile(미세먼지....., 0.75)] = "3Q"
                     pm10_Q[미세먼지..... >= quantile(미세먼지....., 0.75)] = "4Q"
                     pm10_Q = factor(pm10_Q, level = c("1Q", "2Q", "3Q", "4Q"))})

# 초미세먼지 사분위수 범주형 변환
train_4q <- within(train_4q, 
                   {
                      pm25_Q = character(0)
                      pm25_Q[초미세먼지..... < quantile(초미세먼지....., 0.25)] = "1Q"
                      pm25_Q[초미세먼지..... >= quantile(초미세먼지....., 0.25) & 초미세먼지..... < quantile(초미세먼지....., 0.50)] = "2Q"
                      pm25_Q[초미세먼지..... >=quantile(초미세먼지....., 0.50) & 초미세먼지..... < quantile(초미세먼지....., 0.75)] = "3Q"
                      pm25_Q[초미세먼지..... >= quantile(초미세먼지....., 0.75)] = "4Q"
                      pm25_Q = factor(pm25_Q, level = c("1Q", "2Q", "3Q", "4Q"))})

test_4q <- within(test_4q,
                  {
                     pm25_Q = character(0)
                     pm25_Q[초미세먼지..... < quantile(초미세먼지....., 0.25)] = "1Q"
                     pm25_Q[초미세먼지..... >= quantile(초미세먼지....., 0.25) & 초미세먼지..... < quantile(초미세먼지....., 0.50)] = "2Q"
                     pm25_Q[초미세먼지..... >=quantile(초미세먼지....., 0.50) & 초미세먼지..... < quantile(초미세먼지....., 0.75)] = "3Q"
                     pm25_Q[초미세먼지..... >= quantile(초미세먼지....., 0.75)] = "4Q"
                     pm25_Q = factor(pm25_Q, level = c("1Q", "2Q", "3Q", "4Q"))})

train_df <- transform(train_4q,
                      pm_10 = ifelse(미세먼지..... < 31, "좋음",
                                         ifelse(미세먼지.....>= 31 & 미세먼지..... < 81, "보통",
                                                    ifelse(미세먼지.....>= 81 & 미세먼지..... < 151, "나쁨", "매우나쁨"
                                                    ))))
train_df <- transform(train_df,
                      pm_25 = ifelse(초미세먼지..... < 16, "좋음",
                                          ifelse(초미세먼지..... >= 16 & 초미세먼지..... < 36, "보통",
                                                      ifelse(초미세먼지..... >= 36 & 초미세먼지..... < 76, "나쁨", "매우나쁨"
                                                      ))))

test_df <- transform(test_4q,
                     pm_10 = ifelse(미세먼지..... < 31, "좋음",
                                        ifelse(미세먼지.....>= 31 & 미세먼지..... < 81, "보통",
                                                   ifelse(미세먼지.....>= 81 & 미세먼지..... < 151, "나쁨", "매우나쁨"
                                                   ))))
test_df <- transform(test_df,
                     pm_25 = ifelse(초미세먼지..... < 16, "좋음",
                                         ifelse(초미세먼지..... >= 16 & 초미세먼지..... < 36, "보통",
                                                     ifelse(초미세먼지..... >= 36 & 초미세먼지..... < 76, "나쁨", "매우나쁨"
                                                     ))))
str(test_df)
str(train_df)
train_df$pm_10 <- as.factor(train_df$pm_10)
train_df$pm_25 <- as.factor(train_df$pm_25)
test_df$pm_10 <- as.factor(test_df$pm_10)
test_df$pm_25 <- as.factor(test_df$pm_25)


################################################################################
################################################################################
################################regression######################################
regression_tr_pm10 <- train_df[, !names(train_df) %in% c("pm10_Q", "초미세먼지.....", "pm25_Q",
                                                   "pm_10", "pm_25")]
regression_te_pm10 <- test_df[, !names(test_df) %in% c("X", "pm10_Q", "초미세먼지.....", "pm25_Q",
                                                 "pm_10", "pm_25")]
regression_tr_pm25 <- train_df[, !names(train_df) %in% c("미세먼지.....", "pm25_Q", "pm10_Q",
                                                   "pm_10", "pm_25")]
regression_te_pm25 <- test_df[, !names(test_df) %in% c("X", "미세먼지.....", "pm25_Q", "pm10_Q",
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
train_pm10_Q <- train_df[, !names(train_df) %in% c("미세먼지.....", "초미세먼지.....", "pm25_Q",
                                             "pm_10", "pm_25")]
test_pm10_Q <- test_df[, !names(test_df) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm25_Q",
                                          "pm_10", "pm_25")]
train_pm25_Q <- train_df[, !names(train_df) %in% c("미세먼지.....", "초미세먼지.....", "pm10_Q",
                                             "pm_10", "pm_25")]
test_pm25_Q <- test_df[, !names(test_df) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm10_Q",
                                          "pm_10", "pm_25")]
### 1.1 4분위수 미세먼지 예측 모델링
train_pm10_Q_model <- multinom(pm10_Q ~ ., data=train_pm10_Q)
summary(train_pm10_Q_model)
predictionsTree <- predict(train_pm10_Q_model, test_pm10_Q, na.action = na.pass)
confusionMatrix( table(predictionsTree, test_pm10_Q$pm10_Q) )

# 2. 농도 기준 미세먼지 예측 모델링 
train_pm10 <- train_df[, !names(train_df) %in% c("미세먼지.....", "초미세먼지.....", "pm25_Q",
                                           "pm_25", "pm10_Q")]
test_pm10 <- test_df[, !names(test_df) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm25_Q",
                                        "pm_25", "pm10_Q")]
train_pm25 <- train_df[, !names(train_df) %in% c("미세먼지.....", "초미세먼지.....", "pm25_Q",
                                           "pm_10", "pm10_Q")]
test_pm25 <- test_df[, !names(test_df) %in% c("X", "미세먼지.....", "초미세먼지.....", "pm25_Q",
                                        "pm_10", "pm10_Q")]
### 2.1농도 기준 미세먼지 예측 모델
train_pm10_model <- multinom(pm_10 ~ ., data=train_pm10)
summary(train_pm10_model)
predictionsTree1 <- predict(train_pm10_model, test_pm10, na.action = na.pass)
confusionMatrix( table(predictionsTree1, test_pm10$pm_10) )
### 2.2 농도 기준 초미세먼지 예측 모델링
train_pm25_model <- multinom(pm_25 ~ ., data=train_pm25)
summary(train_pm25_model)
predictionsTree2 <- predict(train_pm25_model, test_pm25, na.action = na.pass)
confusionMatrix( table(predictionsTree2, test_pm25$pm_25) )

################################################################################
################################################################################
#############################랜덤 포레스트######################################
# 1. 미세먼지 랜덤 포레스트
pm10_rf = randomForest(pm_10 ~ ., data = train_pm10, mtry = 10, ntree = 100, importance = T)
pm10_pred = predict(pm10_rf, test_pm10, type = "class")
confusionMatrix(pm10_pred, test_pm10$pm_10)
importance(pm10_rf)
varImpPlot(pm10_rf, main="varImpPlot of Random Forest")

options(repr.plot.width=5, repr.plot.height=4)
plot(pm10_rf)


# 2. 초미세먼지 랜덤 포레스트
pm25_rf = randomForest(pm_25 ~ ., data = train_pm25, mtry = 10, ntree = 200, importance = T)
pm25_pred = predict(pm25_rf, test_pm25, type = "class")
confusionMatrix(pm25_pred, test_pm25$pm_25)
importance(pm25_rf)
varImpPlot(pm25_rf, main="varImpPlot of Random Forest")





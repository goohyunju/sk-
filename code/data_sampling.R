setwd("C:/Users/Soyoung Cho/Desktop/datamining")
train <- read.csv("train_result.csv")
test <- read.csv("test_result.csv")

train <- train[, !names(train) %in% c("미세먼지.....", "초미세먼지.....",
                                      "pm10_Q", "pm25_Q")]
test  <- test[, !names(test) %in% c("X", "미세먼지.....", "초미세먼지.....",
                                    "pm10_Q", "pm25_Q")]
colnames(train)

str(train$pm_10)
str(train$pm_25)

str(test$pm_10)
str(test$pm_25)

train$pm_10 <- as.factor(train$pm_10)
train$pm_25 <- as.factor(train$pm_25)

test$pm_10 <- as.factor(test$pm_10)
test$pm_25 <- as.factor(test$pm_25)

plot(train$pm_10)
plot(test$pm_10)

plot(train$pm_25)
plot(test$pm_25)

table(train$pm_10)
table(test$pm_25)
table(train$pm_10)
table(test$pm_25)
#--------------------------------
# Unbalanced 데이터셋인 것 확인
# -------------------------------

library(DMwR)
install.packages("MASS")
library(MASS)

sample.train <- SMOTE(pm_10 ~ ., train, perc.over=1000, k=5, perc.under=200)
genData = AdasynClassif(pm_10 ~ . , train)

table(train$pm_10)
table(sample.train$pm_10)









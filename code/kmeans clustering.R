setwd("C:/Users/Soyoung Cho/Desktop/datamining")
train <- read.csv("train_result.csv")
test <- read.csv("test_result.csv")

library(caret)
set.seed(1712)

train <- train[, !names(train) %in% c("pm_10", "pm_25",
                                      "pm10_Q", "pm25_Q")]
test  <- test[, !names(test) %in% c("X", "pm_10", "pm_25",
                                    "pm10_Q", "pm25_Q")]
                                    
set.seed(1004) # for reprodicibility


str(train)
inTrain <- createDataPartition(y = train$미세먼지....., p = 0.7, list = F)
training <- train[inTrain,]
testing <- train[-inTrain,]

training.data <- scale(training[-5])
summary(training.data)

train.kmeans <- kmeans(training.data[,-5], centers = 3, iter.max = 10000)
train.kmeans$centers

training$cluster <- as.factor(train.kmeans$cluster)
qplot(미세먼지....., 초미세먼지....., colour = cluster, data = training)

dev.off()

setwd("C:/Users/Soyoung Cho/Desktop/datamining")
train <- read.csv("train_result.csv")
test <- read.csv("test_result.csv")

test  <- test[, !names(test) %in% c("X",
                                    "pm10_Q", "pm25_Q")]

test_origin <- read.csv("test_result.csv")
test_origin  <- test[, !names(test) %in% c("X", "pm_10", "pm_25",
                                    "pm10_Q", "pm25_Q")]

library(ggfortify)
pca_res <- prcomp(test_origin, scale. = TRUE)

autoplot(pca_res)

autoplot(pca_res, data = test, colour = 'pm_10')
autoplot(pca_res, data = test, colour = 'pm_25')
colnames(train)
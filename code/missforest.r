setwd("C:/Users/stand/code/2020/Datamining_Analysis/data")

# 데이터 불러오기
train <- read.csv("train_최종.csv")
test <- read.csv("test_최종.csv")

library(tidyverse)  
library(janitor)
library(farff)      
library(missForest) 
library(caret)      
library(lime)       
library(skimr)

missing_plot <- VIM::aggr(train, col=c('lightgreen','red'),
                          numbers=FALSE, sortVars=TRUE,
                          labels=names(data), cex.axis=.7,
                          combined = FALSE,
                          gap=3, ylab=c("Missing data","Pattern"))

str(train)
# missing data가 0.5 이상인 qingdao_co, tianjin_o3 열 삭제
train_miss <- train[,-c(1, 2,3,4,5, 55, 51, 36)]
str(train_miss)


missing_plot <- VIM::aggr(train_miss, col=c('lightgreen','red'),
                          numbers=FALSE, sortVars=TRUE,
                          labels=names(data), cex.axis=.7,
                          combined = FALSE,
                          gap=3, ylab=c("Missing data","Pattern"))

colSums(is.na(train))
data_imp_df <- missForest(train_miss)
colSums(is.na(train_miss))

colSums(is.na(data_imp_df))
data_imp_df
head(data_imp_df)
data_imp_df$OOBerrord
data <- data_imp_df$ximp
head(data)
write.csv(data, "C:/Users/stand/code/2020/Datamining_Analysis/data/train_mf.csv")

#############################################################################################333
setwd("C:/Users/stand/code/2020/Datamining_Analysis/data")

train <- read.csv("train.csv")
test <- read.csv("test.csv")
colSums(is.na(train))
colSums(is.na(test))

train <- train[, !names(train) %in% c("X.1", "X", "일시", "tianjin_o3", "qingdao_co",
                                                   "권역명", "지점명", "요일")]
test <- test[, !names(test) %in% c("X.1", "X", "일시", "tianjin_o3", "qingdao_co",
                                      "권역명", "지점명", "요일")]

total_data <- rbind(train, test)
set.seed(1004) # for reprodicibility
train_idx <- sample(1:nrow(total_data), size=0.7*nrow(total_data), replace=F) # train-set 0.7, test-set 0.3
test_idx <- (-train_idx)

train <- total_data[train_idx,]
test <- total_data[test_idx,]

library(missForest)
data_imp_df <- missForest(train)
data_imp_df$OOBerror
result <- data_imp_df$ximp

plot(colSums(is.na(train)))
missing_plot <- VIM::aggr(train, col=c('lightgreen','red'),
                          numbers=FALSE, sortVars=TRUE,
                          labels=names(data), cex.axis=.7,
                          combined = FALSE,
                          gap=3, ylab=c("Missing data","Pattern"))
colSums(is.na(result))
write.csv("train_real_result.csv")

write.csv(result, "C:/Users/stand/code/2020/Datamining_Analysis/data/train_real_result.csv")
write.csv(test, "C:/Users/stand/code/2020/Datamining_Analysis/data/test_real_result.csv")

##################################################################################################3

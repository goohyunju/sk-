# 1. 데이터셋 로드
setwd("C:/Users/Soyoung Cho/Desktop/datamining")
data_1718 <- read.csv('train_missing_final.csv', stringsAsFactors = T)
data_19 <- read.csv('test_missing_final.csv', stringsAsFactors = T)
#data_1718 <- read.csv('1718결측치존재.csv', stringsAsFactors = T) # 18250행
#data_19 <- read.csv('19결측치존재.csv', stringsAsFactors = T) # 9125 행)

data_1718 <- data_1718[,-c(1,2)]
data_19 <- data_19[,-c(1,2)]

data_1718 <- subset(data_1718, select=-c(tianjin_o3, qingdao_co))
data_19 <- subset(data_19, select=-c(tianjin_o3, qingdao_co))

na_1718 <- colSums(is.na(data_1718))
barplot(na_1718, main="Missing Values Count per Feature (1718)",
        ylim = c(0, 4000), las=2, horiz = F) #TRUE)

na_19 <- colSums(is.na(data_19))
barplot(na_19, main="Missing Values Count per Feature (19)",
        ylim = c(0, 4000), las=2, horiz = F) #TRUE)

# 결측치 시각화
library(VIM)
nan_plot <- aggr(data_1718, col=c('navyblue','yellow'),
                 numbers=TRUE, sortVars=TRUE,
                 labels=names(data_1718), cex.axis=.7,
                 gap=3, ylab=c("Missing data in 1718","Pattern"))

nan_plot <- aggr(data_19, col=c('navyblue','yellow'),
                 numbers=TRUE, sortVars=TRUE,
                 labels=names(data_1718), cex.axis=.7,
                 gap=3, ylab=c("Missing data in 19","Pattern"))

colSums(is.na(data_1718))
colSums(is.na(data_19))

# 날짜 Date 형으로 변환
data_1718$일시 <- as.Date(data_1718$일시)
data_1718$일시 <- as.Date(data_1718$일시)

# 결측치 존재하는 행 삭제
origin_1718 <- na.omit(data_1718) # 19925 -> 11935 행
origin_19 <- na.omit(data_19) # 8896 -> 6065 행

colSums(is.na(origin_1718)) 


# 원본 데이터 백업
sample_1718 <- origin_1718
colSums(is.na(sample_1718))

str(sample_1718)

# 결측치 생성 함수
generate_NA <- function(dataset, feature, n) {
  dataset[sample(1:nrow(dataset), n), feature] <- NA
  print(feature)
  return(dataset)
}

# 결측치 생성할 변수들
imput_features <- colnames(sample_1718[, !names(sample_1718) %in% c("요일","일시", "권역명", "지점명")])

# 각 변수별 결측치 생성
for (feature in imput_features){
  sample_1718 <- generate_NA(sample_1718, feature, 100)
}
colSums(is.na(sample_1718))

################################################################################

#install.packages("dplyr")
library(dplyr)

# imputation 평가하는 함수 -> 각 피처별 전체 MSE 다 더해서 평균 내기
imp_eval <- function(origin_data, sample_data, imput_data, imput_features){
  score <- 0
  for (feature in imput_features){
    origin_temp <- origin_data[, feature]
    sample_temp <- sample_data[, feature]
    
    actuals <- origin_temp[is.na(sample_temp)]
    predicteds <- imput_data[is.na(sample_temp), feature]
    score <- score + regr.eval(actuals, predicteds)
  }
  result <- score/length(imput_features)
  return(result)
}



# 1. knn 대체하기 (연속형 데이터만 가능)
library(DMwR)
knn_imput_data <- knnImputation(sample_1718[, !names(sample_1718) %in% c("일시", "지점명", "권역명", "요일")]) #일부 변수 제외하고 knn으로 NA 대체

# 결측치 대체한 데이터에 NA 있는지 확인하기
anyNA(knn_imput_data)

# KNN imputation 평가
knn_result <- imp_eval(origin_1718, sample_1718, knn_imput_data, imput_features)
knn_result
#mae         mse        rmse        mape 
#13.34216   11614.38015    18.25408         NaN 
#11.38802   9100.43139     16.10001        NaN 

# 2. MICE로 대체하기
library(mice)

mice_tempData <- mice(sample_1718[, !names(sample_1718) %in% c("일시", "지점명", "권역명", "요일")],m=5,maxit=50, seed=500)
mice_tempData$meth

summary(mice_tempData)
mice_imput_data <- complete(mice_tempData,1)

# mice 평가
mice_result <- imp_eval(origin_1718, sample_1718, mice_imput_data, imput_features)
mice_result
#       mae         mse        rmse        mape 
# 23.75726 15733.12418    32.40217         NaN

final_data <- complete(mice_tempData,5)
mice_result <- imp_eval(origin_1718, sample_1718, final_data, imput_features)
mice_result
#mae         mse        rmse        mape 
# 25.86221 20973.77135    35.21210
#        mae         mse        rmse        mape 
# 25.04610 19557.96620    34.27561         NaN 

# 3. Miss Forest
#install.packages("missForest")
library(missForest)
missforest_imput_data <- missForest(sample_1718[, !names(sample_1718) %in% c("일시", "지점명","권역명", "요일")])
missforest_imput_data <-missforest_imput_data$ximp
mf_result <- imp_eval(origin_1718, sample_1718, missforest_imput_data, imput_features)
mf_result
#  mae        mse       rmse       mape 
#10.41907 7478.07233   14.24261        Inf 
#   8.988071 5868.038186   12.939247         Inf 




# Random Forest

set.seed(42)
index <- createDataPartition(data_imp_df2$미세먼지....., p = 0.9, list = FALSE)
train_data <- data_imp_df2[index, ]
test_data  <- data_imp_df2[-index, ]

model_rf <- caret::train(미세먼지..... ~ .,
                        data = train_data,
                        method = "rf", # random forest
                        trControl = trainControl(method = "repeatedcv", 
                                              number = 10, 
                                              repeats = 5, 
                                              verboseIter = FALSE))





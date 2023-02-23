setwd("C:/Users/stand/code/2020/Datamining_Analysis/data")
#install.packages('lubridate')
library('lubridate')
library('dplyr')
# 데이터 불러오기
air_train <- read.csv("air_train (1).csv")
air_test <- read.csv("air_test (1).csv")
weather_17 <- read.csv("data/날씨/2017_weather.csv")
weather_18 <- read.csv("data/날씨/2018.csv")
weather_19 <- read.csv("data/날씨/2019.csv")
beijing <- read.csv("data/china_air/beijing-air-quality.csv")
dalian <- read.csv("data/china_air/dalian-air-quality.csv")
qingdao <- read.csv("data/china_air/qingdao-air-quality.csv")
shanghai <- read.csv("data/china_air/shanghai-air-quality.csv")
shenyang <- read.csv("data/china_air/shenyang-air-quality.csv")
tianjin <- read.csv("data/china_air/tianjin-air-quality.csv")
traffic_17 <- read.csv("data/교통량/traffic_7.csv")
traffic_18 <- read.csv("data/교통량/traffic_8.csv")
traffic_19 <- read.csv("data/교통량/traffic_9.csv")

weather_train <- rbind(weather_17, weather_18)
traffic_train <- rbind(traffic_17, traffic_18)
str(air_train)
names(air_train)[names(air_train) == "측정일자"] <- c("일시")
names(air_train)[names(air_train) == "측정소명"] <- c("지점명")
names(air_test)[names(air_test) == "측정일자"] <- c("일시")
names(air_test)[names(air_test) == "측정소명"] <- c("지점명")
names(beijing)[names(beijing) == "date"] <- c("일시") 
names(dalian)[names(dalian) == "date"] <- c("일시") 
names(qingdao)[names(qingdao) == "date"] <- c("일시") 
names(shanghai)[names(shanghai) == "date"] <- c("일시")
names(shenyang)[names(shenyang) == "date"] <- c("일시")
names(tianjin)[names(tianjin) == "date"] <- c("일시")
names(traffic_train)[names(traffic_train) == "일자"] <- c("일시")
names(weather_19)[names(weather_19) == "일자"] <- c("일시")
names(traffic_train)[names(traffic_train) == "city"] <- c("지점명")
names(traffic_19)[names(traffic_19) == "city"] <- c("지점명")
names(traffic_19)[names(traffic_19) == "일자"] <- c("일시")
str(dalian)
str(shenyang)

weather_train$일시 <- as.Date(weather_train$일시, origin="1970-1-1")
beijing$일시 <- ymd(beijing$일시)
dalian$일시 <- ymd(dalian$일시)
qingdao$일시 <- ymd(qingdao$일시)
shanghai$일시 <- ymd(shanghai$일시)
shenyang$일시 <- ymd(shenyang$일시)
tianjin$일시 <- ymd(tianjin$일시)
traffic_train$일시 <- ymd(traffic_train$일시)
weather_19$일시 <- ymd(weather_19$일시)
traffic_19$일시 <- ymd(traffic_19$일시)
air_train$일시 <- ymd(air_train$일시)
air_test$일시 <- ymd(air_test$일시)

str(air_train)
str(weather_train)
str(beijing)
str(dalian)
str(qingdao)
str(shanghai)
str(shenyang)
str(tianjin)
str(traffic_train)
str(air_test)
str(weather_19)
str(traffic_19)

weather_train$지점명 <- paste0(weather_train$지점명, "구")
weather_19$지점명 <- paste0(weather_19$지점명, "구")
str(air_train)
# 학습 데이터 일시 있는 곳만 합치기
train_left <- left_join(air_train, weather_train,
                     by=c('일시', "지점명"))
train_left <- left_join(train_left, beijing,by='일시')
train_left <- left_join(train_left, dalian,by='일시')
train_left <- left_join(train_left, qingdao,by='일시')
train_left <- left_join(train_left, shanghai,by='일시')
train_left <- left_join(train_left, shenyang,by='일시')
train_left <- left_join(train_left, tianjin,by='일시')
train_left <- left_join(train_left, traffic_train,
                          by=c('일시', "지점명"))

# 테스트 데이터 날짜 있는 곳만 합치기
test_left <- left_join(air_test, weather_19,
                          by=c('일시', "지점명"))
test_left <- left_join(test_left, beijing,by='일시')
test_left <- left_join(test_left, dalian,by='일시')
test_left <- left_join(test_left, qingdao,by='일시')
test_left <- left_join(test_left, shanghai,by='일시')
test_left <- left_join(test_left, shenyang,by='일시')
test_left <- left_join(test_left, tianjin,by='일시')
test_left <- left_join(test_left, traffic_19,
                          by=c('일시', "지점명"))



str(train_left)
head(train_left)
str(test_left)
head(test_left)

write.csv(train_left, "C:/Users/stand/code/2020/Datamining_Analysis/data/train_최종.csv")
write.csv(test_left, "C:/Users/stand/code/2020/Datamining_Analysis/data/test_최종.csv")













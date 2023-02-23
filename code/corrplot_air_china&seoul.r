getwd()

library(tidyr)

library(ggplot2)
library(dplyr)

install.packages("corrplot")
library(corrplot)

beijing_air = read.csv('project_rawdata/china_air/beijing-air-quality.csv')
dalian_air = read.csv('project_rawdata/china_air/dalian-air-quality.csv')
qingdao_air = read.csv('project_rawdata/china_air/qingdao-air-quality.csv')
shanghai_air = read.csv('project_rawdata/china_air/shanghai-air-quality.csv')
shenyang_air = read.csv('project_rawdata/china_air/shenyang-air-quality.csv')
tianjin_air = read.csv('project_rawdata/china_air/tianjin-air-quality.csv')

seoul_air = read.csv('seoul_air/air_train.csv')
seoul_air_test = read.csv('seoul_air/air_test.csv')

qingdao_air <- subset(qingdao_air, select=-c(co))

cut_data <- function(dat) {
    dat <- na.omit(dat)
    dat <- dat[!grepl("201[3-6]", dat$date),]
    dat <- dat[!grepl("2020", dat$date),]
    return(dat)
}

sum(is.na(qingdao_air))
str(qingdao_air)

beijing_air <- cut_data(beijing_air)
dalian_air <- cut_data(dalian_air)
qingdao_air <- cut_data(qingdao_air)
shanghai_air <- cut_data(shanghai_air)
shenyang_air <- cut_data(shenyang_air)
tianjin_air <- cut_data(tianjin_air)

sum(is.na(beijing_air))
str(beijing_air)

rename_cols <- function(dat, txt){
    dat_col_name <- names(dat)
    new_name <- c('date')
    for(n in dat_col_name[2:length(dat_col_name)]){
        new_name <- c(new_name, paste0(txt,n))
    }
    names(dat) <- new_name
    return(dat)
}

beijing_air <- rename_cols(beijing_air, "beijing_")
dalian_air <- rename_cols(dalian_air, "dalian_")
qingdao_air <- rename_cols(qingdao_air, "qingdao_")
shanghai_air <- rename_cols(shanghai_air, "shanghai_")
shenyang_air <- rename_cols(shenyang_air, "shenyang_")
tianjin_air <- rename_cols(tianjin_air, "tianjin_")

head(qingdao_air)
str(qingdao_air)

china_air <- merge(x=beijing_air, y=dalian_air, by='date', all=TRUE)
china_air <- merge(x=china_air, y=qingdao_air, by='date', all=TRUE)
china_air <- merge(x=china_air, y=shanghai_air, by='date', all=TRUE)
china_air <- merge(x=china_air, y=shenyang_air, by='date', all=TRUE)
china_air <- merge(x=china_air, y=tianjin_air, by='date', all=TRUE)

head(china_air)
str(china_air)

china_air <- transform(china_air, date=as.Date(as.character(date), format="%Y-%m-%d"))
head(china_air)
str(china_air)

head(seoul_air)
str(seoul_air)

head(seoul_air_test)
str(seoul_air_test)

seoul_air_combined <- rbind(seoul_air, seoul_air_test)
str(seoul_air_combined)

seoul_air_combined <- subset(seoul_air_combined, select=-c(2,3))
str(seoul_air_combined)

seoul_air_m <- aggregate(seoul_air_combined[,2:7], list(seoul_air_combined$측정일자), mean)
names(seoul_air_m) <- c('date', 'Seoul_PM10', 'Seoul_PM25', 'Seoul_O3', 'Seoul_NO2', 'Seoul_CO', 'Seoul_SO2')
str(seoul_air_m)

seoul_air_m <- transform(seoul_air_m, date=as.Date(as.character(date), format="%Y%m%d"))
head(seoul_air_m)
str(seoul_air_m)

seoul_air <- seoul_air_m

joined_data.0day <- merge(x=seoul_air, y=china_air, by='date')

china_air.dplus1 <- transform(china_air, date=date+1)
china_air.dplus2 <- transform(china_air, date=date+2)

joined_data.1day <- merge(x=seoul_air, y=china_air.dplus1, by='date')
joined_data.2day <- merge(x=seoul_air, y=china_air.dplus2, by='date')

joined_data.0day <- na.omit(joined_data.0day)
joined_data.1day <- na.omit(joined_data.1day)
joined_data.2day <- na.omit(joined_data.2day)

joined_data.0day.cor <- cor(joined_data.0day[2:length(names(joined_data.0day))])
print(joined_data.0day.cor)
corrplot(joined_data.0day.cor, method="circle")

joined_data.1day.cor <- cor(joined_data.1day[2:length(names(joined_data.1day))])
joined_data.2day.cor <- cor(joined_data.2day[2:length(names(joined_data.2day))])

corrplot(joined_data.1day.cor, method="circle")
corrplot(joined_data.2day.cor, method="circle")

china_air.dplus3 <- transform(china_air, date=date+3)
joined_data.3day <- merge(x=seoul_air, y=china_air.dplus3, by='date')
joined_data.3day <- na.omit(joined_data.3day)
joined_data.3day.cor <- cor(joined_data.3day[2:length(names(joined_data.3day))])
corrplot(joined_data.3day.cor)



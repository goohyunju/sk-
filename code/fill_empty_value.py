from os import listdir, getcwd, chdir
import pandas as pd
import numpy as np
import locale
import string
import csv

TARGET_FILE_LIST = list()
#CWD = getcwd()
CWD = "C:\\Users\\한형석\\Documents\\광운대\\데이터마이닝분석\\project_rawdata\\traffic\\2018_modified"


def fill_csv_list():
    global TARGET_FILE_LIST
    files = listdir(CWD)
    for f in files:
        f_ext = f.split('.')
        if f_ext[1]=="csv":
            TARGET_FILE_LIST.append(f)


def fill_na_with_avg(data):
    # - Change dtype to Float64 for NaN values -
    data = data.replace(r'^\s*$', np.nan, regex=True)
    cols = data.columns
    data[cols[1:]]=data[cols[1:]].apply(np.float64)
    
    return pd.concat([data.ffill(),data.bfill()]).groupby(['date'], dropna=False).mean()


def fill_na_with_weekday_avg(data):
    # - Change dtype to Float64 for NaN values -
    cols = data.columns
    data.drop(cols[30:], axis=1, inplace=True)
    cols = data.columns
    data[cols[6:]]=data[cols[6:]].apply(np.float64)
    data.dropna(subset=['지점명','요일'], inplace=True)
    

    outway_index = data[data['구분'] == "유출"].index
    data.drop(outway_index, inplace=True)
    data.drop(['구분','방향'], axis=1, inplace=True)
    mean_data = data.groupby(['요일','지점명']).mean()
    for col_i in cols[6:]:
        mean_data[col_i] = mean_data[col_i].fillna(mean_data.groupby(['지점명'])[col_i].transform('mean'))
    # mean_data.to_csv("meandata2018.csv", encoding='utf-8-sig')
    
    # - Make list of mean values for lambda func. -
    # i[0]==요일, i[1]==지점명
    mean_cols = mean_data.columns
    mean_values = {}
    for i in mean_data.index:
        if i[1] not in mean_values:
            mean_values[i[1]] = {}
        traffic_size_list = []
        for col_i in mean_cols[1:]:
            traffic_size_list.append(mean_data.at[i,col_i])
        mean_values[i[1]][i[0]] = traffic_size_list
    # print(mean_values)
    
    # - Save mean data -
    traffic_size = []
    for i in data.index:
        cur_col_num = 0
        sum_of_traffic = 0
        for col_i in cols[6:]:
            val = data.at[i,col_i]
            if np.isnan(val):
                val = data.at[i,col_i] = mean_values[data.at[i,'지점명']][data.at[i,'요일']][cur_col_num]
                cur_col_num += 1
            sum_of_traffic += val
        traffic_size.append(sum_of_traffic/24)

    # - Drop useless column and add TrafficSize column -
    cols = data.columns
    data.drop(cols[3:], axis=1, inplace=True)
    data['교통량'] = traffic_size

    # = Drop rows that doesn't have any data -
    #data.dropna(inplace=True)

    return data


if __name__ == "__main__":
    chdir(CWD)
    fill_csv_list()

    #pd.set_option('max_columns', None)
    #pd.set_option('max_rows', None)
    locale.setlocale(locale.LC_NUMERIC, '')

    merged_csv = pd.DataFrame()

    print("Starting preprocessing of csv files:")
    print(TARGET_FILE_LIST)
    for c in TARGET_FILE_LIST:
        target_path = CWD + '\\' + c

        # - Load data -
        loaded_csv = pd.read_csv(target_path, encoding='utf-8', thousands=',')
        

        # modified_csv = fill_na_with_weekday_avg(loaded_csv)
        # c_ext = c.split('.')
        # c_newname = c_ext[0] + "_modified." + c_ext[1]
        # modified_csv.to_csv(c_newname, encoding='utf-8-sig', index=False, header=True)
        # print("Saved csv file with name: " + c_newname)

        if merged_csv.empty:
            merged_csv = loaded_csv
        else:
            # print("append csv: "+c)
            merged_csv = merged_csv.append(loaded_csv, ignore_index=True)

    # - Fill missing data -
    # for China air data:
    # modified_csv = fill_na_with_avg(loaded_csv)
    # for Seoul traffic data:
    print(merged_csv)
    modified_csv = fill_na_with_weekday_avg(merged_csv)

    # - Save processed data -
    c_newname = "2018_modified.csv"
    # modified_csv.to_csv(c_newname)
    modified_csv.to_csv(c_newname, encoding='utf-8-sig', index=False, header=True)
    print("Saved csv file with name: " + c_newname)

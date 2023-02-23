import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers.core import Dense, Dropout, Activation
from keras.utils import np_utils
from keras import metrics

TARGET_CSV_FILE = "C:/Users/HS/Documents/seoul_pm_proj/train_modified.csv"
np.random.seed(5)

csv_dat = pd.read_csv(TARGET_CSV_FILE)
csv_dat = csv_dat.dropna(axis=0)
# print(csv_dat.shape)
# print(csv_dat.columns)


# Create train dataset
data_x = csv_dat.drop(['PM10','PM25'], axis=1)
# data_y = csv_dat['PM10']
data_y = pd.concat([csv_dat['PM10'], csv_dat['PM25']], axis=1) 
# print(data_x.shape)
# print(data_y.shape)


# X Regularization
data_x = (data_x-data_x.mean())/data_x.std()

epoch_sizes = [25, 50, 75, 100]
batch_sizes = [5, 10, 20, 50, 100]

for i in epoch_sizes:
    for j in batch_sizes:
        print()
        model_file_name = "mt_model_128x128_"+str(i)+"_"+str(j)+".h5"
        print("Model: "+model_file_name)
        print("Epoch: "+str(i)+", Batch size: "+str(j))

        # Model configuration
        model = Sequential()
        model.add(Dense(128, input_dim=data_x.shape[1], activation='relu', kernel_initializer='normal'))
        # model.add(Dense(256, activation='relu', kernel_initializer='normal'))
        # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
        # model.add(Dropout(rate=0.3))
        # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
        # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
        model.add(Dense(128, activation='relu', kernel_initializer='normal'))
        model.add(Dense(data_y.shape[1], activation='relu', kernel_initializer='normal'))

        # Training options
        model.compile(loss='mean_squared_error', optimizer='adam', metrics=[metrics.mse, metrics.mean_absolute_percentage_error])

        # Model Training
        model.fit(data_x, data_y, epochs=i, batch_size=j, validation_split=0.2, verbose=2)

        # Prediction
        #y = model.predict(data_x)

        # Save model (layernum_dropoutnum_epoch_batchsize)
        model.save(model_file_name)
        print()



# # Model configuration
# model = Sequential()
# model.add(Dense(64, input_dim=data_x.shape[1], activation='relu', kernel_initializer='normal'))
# # model.add(Dense(256, activation='relu', kernel_initializer='normal'))
# # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
# # model.add(Dropout(rate=0.3))
# # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
# # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
# model.add(Dense(64, activation='relu', kernel_initializer='normal'))
# model.add(Dense(1, activation='relu', kernel_initializer='normal'))


# # Training options
# model.compile(loss='mean_squared_error', optimizer='adam', metrics=[metrics.mse, metrics.mean_absolute_percentage_error])


# # Model Training
# model.fit(data_x, data_y, epochs=50, batch_size=20, validation_split=0.2, verbose=1)


# # Prediction
# y = model.predict(data_x)


# # Save model (layernum_dropoutnum_epoch_batchsize)
# model.save("pm10_model_64x64_50_20.h5")
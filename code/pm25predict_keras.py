import numpy as np
import pandas as pd
from keras.models import Sequential
from keras.layers.core import Dense, Activation
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
data_y = csv_dat['PM25']
# print(data_x.shape)
# print(data_y.shape)


# X Regularization
data_x = (data_x-data_x.mean())/data_x.std()


# # Model configuration
# model = Sequential()
# model.add(Dense(256, input_dim=data_x.shape[1], activation='relu', kernel_initializer='normal'))
# model.add(Dense(256, activation='relu', kernel_initializer='normal'))
# # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
# # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
# # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
# # model.add(Dense(64, activation='relu', kernel_initializer='normal'))
# model.add(Dense(1, activation='relu', kernel_initializer='normal'))


# # Training options
# model.compile(loss='mean_squared_error', optimizer='adam', metrics=[metrics.mse, metrics.mean_absolute_percentage_error])


# Model Training
epoch_sizes = [25, 50, 75, 100]
batch_sizes = [5]
# e_size = 200
# b_size = 10

# model_file_name = "pm25_model_3_"+str(e_size)+"_"+str(b_size)+".h5"
# print("Model name: "+model_file_name)
# print("Epoch: "+str(e_size)+", Batch size: "+str(b_size))

# model.fit(data_x, data_y, epochs=e_size, batch_size=b_size, validation_split=0.2, verbose=2)

# # Prediction
# # y = model.predict(data_x)

# # Save model (layernum_dropoutnum_epoch_batchsize)
# model.save(model_file_name)

for i in range(len(epoch_sizes)):
    for j in range(len(batch_sizes)):
        # Model configuration
        model = Sequential()
        model.add(Dense(256, input_dim=data_x.shape[1], activation='relu', kernel_initializer='normal'))
        model.add(Dense(256, activation='relu', kernel_initializer='normal'))
        # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
        # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
        # model.add(Dense(512, activation='relu', kernel_initializer='normal'))
        # model.add(Dense(64, activation='relu', kernel_initializer='normal'))
        model.add(Dense(1, activation='relu', kernel_initializer='normal'))


        # Training options
        model.compile(loss='mean_squared_error', optimizer='adam', metrics=[metrics.mse, metrics.mean_absolute_percentage_error])

        model_file_name = "pm25_model_3_"+str(epoch_sizes[i])+"_"+str(batch_sizes[j])+".h5"
        print("Model name: "+model_file_name)
        print("Epoch: "+str(epoch_sizes[i])+", Batch size: "+str(batch_sizes[j]))

        model.fit(data_x, data_y, epochs=epoch_sizes[i], batch_size=batch_sizes[j], validation_split=0.2, verbose=2)

        # Prediction
        ### y = model.predict(data_x,data_y)

        # Save model (layernum_dropoutnum_epoch_batchsize) 
        model.save(model_file_name)
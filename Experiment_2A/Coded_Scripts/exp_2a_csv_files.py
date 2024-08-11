import numpy as np
import pandas as pd

# filling time data array
time_data_1 = np.array([[1.45, 0.94, 1.79, 5.73], [3.91, 1.66, 2.31, 18.80], [1.71, 1.12, 1.47, 6.47], [2.07, 1.27, 2.04, 8.12], [1.85, 3.18, 1.26, 5.77], [4.24, 1.98, 3.43, 8.53]])
time_data_2 = np.array([[1.50, 0.92, 1.72, 5.76], [3.80, 1.71, 2.29, 18.61], [1.71, 1.13, 1.51, 6.18], [2.77, 1.46, 1.87, 8.07], [2.41, 3.25, 1.41, 6.33], [4.01, 2.00, 3.21, 8.56]])

time_data_3_all = np.genfromtxt('T3_data.csv', delimiter=',')
time_data_3 = time_data_3_all[1:, 1:]

time_data = (time_data_1 + time_data_2 + time_data_3) / 3 # in seconds
distance_data = np.array([1.446, 0.754, 0.906, 0.872]) # in meters

# avg speed data
speed_avg = time_data * 0
speed_avg[:, 0] = 1.446 / time_data[:, 0]
speed_avg[:, 1] = 0.754 / time_data[:, 1]
speed_avg[:, 2] = 0.906 / time_data[:, 2]
speed_avg[:, 3] = 0.872 / time_data[:, 3]

# saving data to files
DF_time = pd.DataFrame(time_data) 
DF_time.to_csv("Tavg_data.csv")
DF_time = pd.DataFrame(distance_data) 
DF_time.to_csv("Height_data.csv")
DF_time = pd.DataFrame(speed_avg) 
DF_time.to_csv("ut_avg_data.csv")


time_data_3 = np.round(time_data_3, 2)
time_data = np.round(time_data, 2)

print("---------------------------------------------------------")
print("---------------------------------------------------------")
print("Time 1: seconds")
print(time_data_1)
print("---------------------------------------------------------")
print("---------------------------------------------------------")
print("Time 2: seconds")
print(time_data_2)
print("---------------------------------------------------------")
print("---------------------------------------------------------")
print("Time 3: seconds")
print(time_data_3)
print("---------------------------------------------------------")
print("---------------------------------------------------------")
print("Time Avg: seconds")
print(time_data)
print("---------------------------------------------------------")
print("---------------------------------------------------------")
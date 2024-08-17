# @author : Deepanjhan Das
# use 'python <name_script.py>' to run in terminal
# import csv
import numpy as np
import pandas as pd

#-------------------------------------------------------#
## to create comma-separated list of data
# def create_CSV(file_name, row_list):
#     with open(file_name, 'w', newline='') as file:
#         writer = csv.writer(file)
#         writer.writerows(row_list)


#-------------------------------------------------------#
## to create a data frame and to convert it into a CSV
def create_CSV(file_name, data):
    column_values = ['x(cm)', 'time(s)']
    df = pd.DataFrame(data, columns=column_values)
    df.to_csv(f"{file_name}.csv")


#---------------------------------------------------------------------------#
#========== Part 1 : Diff. concn. CaCO3 solution in similar tubes ==========#
# x vs time data (cm gradient in scale used, [min, sec])
# 5% (w/w) solution
T1_5_percent = [[0.0, 0.0], [1.0, 1.63], [2.0, 10.32], [3.0, 20.02], [4.0, 28.15], [5.0, 38.69], [6.0, 42.71],
                [7.0, 51.39], [8.0, 57.78], [10.0, 4.35], [11.0, 10.46], [12.0, 16.74], [13.0, 19.74], [14.0, 29.22], 
                [15.0, 34.75], [16.0, 41.91], [17.0, 46.59], [18.0, 52.34], [20.0, 6.12], [21.0, 6.10], [22.0, 10.41]]
x1_5_percent = np.array([i for i in range(81,60,-1)])
t1_5_percent = np.array([(i[0]*60.0 + i[1]) for i in T1_5_percent])
# print(list(zip(x1_5_percent, t1_5_percent)))
create_CSV('t1_5_percent', list(zip(x1_5_percent, t1_5_percent)))

# 10% (w/w) solution
T1_10_percent = [[0.0, 0.0], [3.0, 35.36], [7.0, 16.76], [10.0, 56.14], [14.0, 35.73], [18.0, 8.11], [21.0, 50.79], 
                 [25.0, 26.70], [29.0, 8.0], [32.0, 55.57], [36.0, 42.24], [40.0, 25.58], [44.0, 17.33], [48.0, 7.59],
                 [52.0, 1.42], [56.0, 1.25], [60.0, 5.01], [64.0, 18.20]]
x1_10_percent = np.array([i for i in range(84,66,-1)])
t1_10_percent = np.array([(i[0]*60.0 + i[1]) for i in T1_10_percent])
# print(list(zip(x1_10_percent, t1_10_percent)))
create_CSV('t1_10_percent', list(zip(x1_10_percent, t1_10_percent)))

# 15% (w/w) solution
T1_15_percent = [[0.0, 0.0], [14.0, 27.53], [29.0, 10.11], [44.0, 11.84],
                 [59.0, 22.86], [74.0, 40.44], [87.0, 42.41], [101.0, 2.01]]
x1_15_percent = np.array([i for i in range(87,79,-1)])
t1_15_percent = np.array([(i[0]*60.0 + i[1]) for i in T1_15_percent]) 
# print(list(zip(x1_15_percent, t1_15_percent)))
create_CSV('t1_15_percent', list(zip(x1_15_percent, t1_15_percent)))

# 20% (w/w) solution
T1_20_percent = [[0.0, 0.0], [24.0, 41.75], [48.0, 21.55], [70.0, 20.0], [94.0, 19.0]]
x1_20_percent = np.array([i for i in range(91,86,-1)])
t1_20_percent = np.array([(i[0]*60.0 + i[1]) for i in T1_20_percent])
# print(list(zip(x1_20_percent, t1_20_percent)))
create_CSV('t1_20_percent', list(zip(x1_20_percent, t1_20_percent)))



#---------------------------------------------------------------------------#
#========== Part 2 : 5% CaCO3 solution in 4 different tubes ==========#

# diameter values (mm) with LC of the vernier valiper = 0.02 mm
d1, d2, d3, d4 = 22.3, 17.88, 11.7, 5.8

# x vs time data (cm gradient in scale used, [min, sec])
# for d1
T2_d1 = [[0.0, 0.0], [0.0, 49.21], [1.0, 53.99], [2.0, 47.71], [3.0, 50.25], [4.0, 48.35], [5.0, 45.99],
        [6.0, 37.33], [7.0, 36.49], [8.0, 35.07], [9.0, 37.09], [10.0, 21.85], [11.0, 21.53], [12.0, 17.28],
        [13.0, 14.96], [14.0, 11.48], [15.0, 13.56], [16.0, 8.43], [17.0, 0.93], [17.0, 56.14], [18.0, 52.67], [18.0, 54.91]]

x2_d1 = np.array([i for i in range(85,63,-1)])
t2_d1 = np.array([(i[0]*60.0 + i[1]) for i in T2_d1])
# print(list(zip(x2_d1, t2_d1)))
create_CSV('t2_d1', list(zip(x2_d1, t2_d1)))

# for d2
T2_d2 = [[0.0, 0.0], [0.0, 56.18], [1.0, 53.23], [2.0, 49.38], [3.0, 48.07], [4.0, 48.04], [5.0, 41.80], [6.0, 37.98],
        [7.0, 35.09], [8.0, 30.57], [9.0, 23.79], [10.0, 14.24], [11.0, 8.98], [12.0, 3.27], [12.0, 57.42], [13.0, 51.17],
        [14.0, 53.82], [15.0, 50.66], [16.0, 43.18], [17.0, 37.03], [18.0, 34.47], [19.0, 30.11], [20.0, 23.53]]
x2_d2 = np.array([i for i in range(85,62,-1)])
t2_d2 = np.array([(i[0]*60.0 + i[1]) for i in T2_d2])
# print(list(zip(x2_d2, t2_d2)))
create_CSV('t2_d2', list(zip(x2_d2, t2_d2)))

# for d3
T2_d3 = [[0.0, 0.0], [1.0, 26.0], [2.0, 50.0], [4.0, 14.0], [5.0, 39.0], [7.0, 3.0], [8.0, 28.0], [9.0, 53.0],
        [11.0, 16.0], [12.0, 38.0], [14.0, 2.0], [15.0, 27.0], [16.0, 54.0], [18.0, 16.0], [19.0, 36.0], [20.0, 58.0],
        [22.0, 23.0], [23.0, 45.0], [25.0, 7.0], [26.0, 30.0], [27.0, 54.0]]
x2_d3 = np.array([i for i in range(85,64,-1)])
t2_d3 = np.array([(i[0]*60.0 + i[1]) for i in T2_d3])
# print(list(zip(x2_d3, t2_d3)))
create_CSV('t2_d3', list(zip(x2_d3, t2_d3)))

# for d4
T2_d4 = [[0.0, 0.0], [0.0, 49.47], [1.0, 45.57], [2.0, 37.21], [3.0, 26.93], [4.0, 16.19], [5.0, 11.45], [6.0, 11.76],
        [7.0, 3.98], [7.0, 55.69], [8.0, 45.36], [9.0, 37.07], [10.0, 32.01], [11.0, 26.73], [12.0, 18.99], [13.0, 9.45],
        [14.0, 7.61], [14.0, 54.99], [15.0, 46.91], [16.0, 38.79], [17.0, 28.82], [18.0, 15.92], [19.0, 12.59]]
x2_d4 = np.array([i for i in range(90,67,-1)])
t2_d4 = np.array([(i[0]*60.0 + i[1]) for i in T2_d4])
# print(list(zip(x2_d4, t2_d4)))
create_CSV('t2_d4', list(zip(x2_d4, t2_d4)))
% EXP - 5
% Transient Conduction of Heat (Cylinder)

% MTMO - group 2
% Ch22b008
% Aayush Bhakna

clear all;
clc;

%-------------------------------------------------------------------------%

% AUTOMATIC HEATING

Time_heat = [0:10:360]';

Temp_heat = zeros(37, 3);

Temp_heat(:, 1) = [34.8, 35.6, 42.7, 51.4, 58.4, 64.3, 68.8, 72.9, 75.9, ...
    78.5, 81.1, 83.3, 85.2, 87.0, 88.5, 89.9, 91.2, 92.4, 93.5, 94.5, ...
    95.3, 96.1, 96.8, 97.4, 98.0, 98.5, 99.0, 99.4, 99.8, 100, 100, ...
    100, 100, 100, 100, 100, 100]';

Temp_heat(:, 2) = [34.6, 34.6, 36.0, 39.9, 44.4, 49.1, 53.7, 58.3, 61.9, ...
    65.3, 68.8, 71.9, 74.5, 77.3, 79.6, 81.5, 83.6, 85.4, 87.0, 88.5, ...
    89.9, 91.0, 92.2, 93.3, 94.2, 95.1, 95.8, 96.4, 97.1, 97.7, 98.4, ...
    98.6, 99.2, 99.6, 99.9, 100, 100]';

Temp_heat(:, 3) = [34.6, 34.6, 34.7, 36.2, 39.4, 43.4, 47.9, 52.6, 56.9, ...
    60.9, 64.6, 68.4, 71.3, 74.4, 77.0, 79.3, 81.6, 83.6, 85.4, 87.0, ...
    88.6, 89.8, 91.1, 92.3, 93.3, 94.3, 95.1, 95.8, 96.5, 97.2, 97.9, ...
    98.2, 98.8, 99.3, 99.6, 99.9, 100]';

heatTable = table;
heatTable.Time = Time_heat;
heatTable.Thermocouple_Temp = Temp_heat;

% writetable(heatTable, "automatic_cylinder_heating.csv");


%-------------------------------------------------------------------------%

% AUTOMATIC COOLING

Time_cool = [0:30:2070]';

Temp_cool = zeros(70, 3);

Temp_cool(:, 1) = [100, 99.8, 99.2, 98.5, 97.9, 97.0, 96.0, 95.2, ...
    94.3, 93.4, 92.5, 91.6, 90.9, 90.2, 89.5, 88.9, 88.4, 87.5, 86.9, ...
    86.3, 85.9, 85.2, 84.7, 84.2, 83.6, 83.1, 82.6, 82.1, 81.6, 81.0, ...
    80.5, 80.0, 79.5, 79.1, 78.9, 78.0, 77.5, 77.0, 76.6, 76.1, 75.7, ...
    75.2, 74.7, 74.4, 73.9, 73.6, 73.2, 72.8, 72.4, 71.9, 71.5, 71.0, ...
    70.7, 70.3, 69.9, 69.5, 69.2, 68.9, 68.6, 68.2, 67.9, 67.5, 67.2, ...
    66.8, 66.5, 66.2, 65.8, 65.6, 65.3, 65.0]';

Temp_cool(:, 2) = [100, 100, 100, 99.7, 99.0, 98.1, 97.1, 96.3, 95.3, ...
    94.3, 93.5, 92.6, 91.9, 91.1, 90.4, 89.7, 89.2, 88.4, 87.9, 87.2, ...
    86.7, 86.0, 85.5, 85.0, 84.4, 83.9, 83.3, 82.8, 82.4, 81.8, 81.3, ...
    80.8, 80.3, 79.9, 79.7, 78.7, 78.2, 77.6, 77.3, 76.8, 76.3, 75.9, ...
    75.4, 75.1, 74.5, 74.2, 73.7, 73.4, 72.9, 72.4, 72.0, 71.6, 71.3, ...
    70.9, 70.5, 70.1, 69.7, 69.4, 69.0, 68.7, 68.4, 68.0, 67.7, 67.3, ...
    67.0, 66.6, 66.3, 66.0, 65.7, 65.5]';

Temp_cool(:, 3) = [100, 100, 100, 100, 99.3, 98.4, 97.3, 96.5, 95.5, ...
    94.6, 93.8, 92.9, 92.1, 91.3, 90.6, 89.9, 89.4, 88.6, 88.1, 87.3, ...
    86.8, 86.1, 85.7, 85.2, 84.6, 84.0, 83.5, 83.0, 82.6, 81.9, 81.4, ...
    81.0, 80.5, 80.1, 79.8, 78.9, 78.4, 77.8, 77.4, 77.0, 76.5, 76.0, ...
    75.5, 75.2, 74.6, 74.3, 73.8, 73.4, 73.0, 72.5, 72.1, 71.7, 71.4, ...
    71.0, 70.6, 70.2, 69.8, 69.4, 69.1, 68.7, 68.4, 68.1, 67.7, 67.3, ...
    67.1, 66.7, 66.4, 66.0, 65.8, 65.5]';

coolTable = table;
coolTable.Time = Time_cool;
coolTable.Thermocouple_Temp = Temp_cool;

% writetable(coolTable, "automatic_cylinder_cooling.csv");


%-------------------------------------------------------------------------%
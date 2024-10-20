% CH3510
% Mass Transfer and Mass Operations Lab

% EXP - 9
% Calculating Diffusivity using Stefan's Tube

% CH22B008
% Aayush Bhakna

clear all;
clc;

%-------------------------------------------------------------------------%

% NOTATIONS USED

global rho; global M; global P; global R;

rho = 790; % kg/m^3
M = 58.08; % kg/kmol

P = 101.325; % in kPa
R = 8.3145; % in Pa * m^3 / K*mol

%-------------------------------------------------------------------------%

% THEORETICAL VALUES OF D12

D12 = zeros(3, 1);

T_val = [40 45 50] + 273.15; % in kelvin
P_val = 101325; % in pascal

M1 = M;
M2 = 28.96; % in kg/kmol

v1 = (3 * 16.5) + (6 * 1.98) + (1 * 5.481);
v2 = 20.1;

for i = 1:3
    D12(i) = eqTheoreticalD12(T_val(i), P_val, M1, M2, v1, v2); % in m^2/s
end

D12 = D12 .* (10^4); % in cm^2/s

%-------------------------------------------------------------------------%

% CALCULATIONS @ 40 Celcius

T_celcius = 40; % celcius
time = 60 .* [0 5 10 15 20 25]; % in seconds
TSR = [23.03 22.78 22.61 22.25 22.00 21.83]; % in mm

eqDiffusivity(T_celcius, time, TSR, D12(1))

%-------------------------------------------------------------------------%

% CALCULATIONS @ 45 Celcius

T_celcius = 45; % celcius
time = 60 .* [0 5 10 15 20 25]; % in seconds
TSR = [21.73 21.82 21.55 21.27 21.00 20.62]; % in mm

% Presence of Outlier
% Outlier : t = 0, TSR = 21.73

x_data = time(2:end);
y_data = TSR(2:end);

x_mean = mean(x_data, "all");
y_mean = mean(y_data, "all");

Sxy = sum(((x_data - x_mean).*(y_data - y_mean)), "all");
Sxx = sum((x_data - x_mean).^2, "all");

slope = Sxy/Sxx;
intercept = y_mean - (slope * x_mean);

y_hat = (slope .* x_data) + intercept;
SSresidual = sum((y_data - y_hat).^2, "all");
SStotal = sum((y_data - y_mean).^2, "all");

R2 = 1 - (SSresidual / SStotal);

TSR_processed = TSR;
TSR_processed(1) = (slope .* time(1)) + intercept;

figure('Name', "Outlier in Case-2")
hold on
plot(time, TSR_processed, LineWidth=1.5, Marker="o")
scatter(time(1), TSR(1), 50, "filled")
hold off
grid on
legend('Data Points', 'Outlier', Location='best')
xlabel('time in sec')
ylabel('TSR in mm')

eqDiffusivity(T_celcius, time, TSR_processed, D12(2))

%-------------------------------------------------------------------------%

% CALCULATIONS @ 50 Celcius

T_celcius = 50; % celcius
time = 60 .* [0 5 10 15 20 25]; % in seconds
TSR = [20.60 20.00 19.65 19.10 18.80 18.55]; % in mm

eqDiffusivity(T_celcius, time, TSR, D12(3))

%-------------------------------------------------------------------------%

% LOCAL FUNCTION

function f = eqTheoreticalD12(T, P, M1, M2, v1, v2)

% T : Kelvin
% P : Pa
% D12 : m^2/s

netM = (1/M1) + (1/M2);
netV = (v1^(1/3)) + (v2^(1/3));

f = 0.01013 * (T^1.75) * (netM^0.5) / (P * (netV^2));

end

function f = eqDiffusivity(T_celcius, time, TSR, D12)

global rho; global M; global P; global R;

T = T_celcius + 273.15; % in K

% Antoine Equation
A = 4.42448;
B = 1312.253;
C = -32.445;
P_vap = 100 * (10^(A -(B/(T+C)))); % in kPa

% Calculating mole fractions

% Bottom
yA1 = P_vap / P;
yB1 = 1 - yA1;

% Top
yA2 = 0;
yB2 = 1 - yA2;

% Total concentration
C_total = P / (R * T); % in kmol/m^3

% Measured values
H = 55; % in mm

% z = z2 - z1
Z = H - TSR; % in mm
Z = (10^-3) .* Z; % in m

% ignoring t = 0 case
z = Z(2:end);     % in m
z0 = Z(1);        % in m
t = time(2:end);  % in sec

% calculating tau
tau = 2 * (C_total * M / rho) * log(yB2/yB1);

% Calculating D
lambda = ((z.^2) - (z0.^2)) ./ t;
D_vec = lambda ./ tau;
D = mean(D_vec, "all");

% plotting graph
str = strcat('Diffusivity at ', int2str(T_celcius), ' Celcius');
figure('Name', str)
hold on
plot(t, D_vec, Marker="o", LineWidth=1.5)
plot(t, D.*ones(size(t)), LineWidth=1.5, LineStyle="--")
hold off
grid on
legend('Data Points', 'Mean value', Location='best')
xlabel('Time in sec')
ylabel('Diffusivity in m^2/s')

err = abs((D12 - (D*10^4))/D12) * 100;

% printing results
outputTable = table;
outputTable.Variable = ["Temperature"; "Vapour Pressure"; "yA1"; "yA2"; ...
    "Tau"; "Calculated D12"; "Theoretical D12"; "Error"];
outputTable.Value = [T_celcius; P_vap; yA1; yA2; tau; D*10^4; D12; err];
outputTable.Unit = ["Celcius"; "kPa"; "-"; "-"; "-"; "cm^2/s"; "cm^2/s"; "%"];

fprintf('\nFinal Results : \n\n')
disp(outputTable)

end

%-------------------------------------------------------------------------%

% ANOTHER METHOD TO CALCULATE DIFFUSIVITY

% % method-2
% x_data = z - z0;
% x_mean = mean(x_data, "all");
% y_data = t ./ (z - z0);
% y_mean = mean(y_data, "all");
% 
% Sxy = sum(((x_data - x_mean).*(y_data - y_mean)), "all");
% Sxx = sum((x_data - x_mean).^2, "all");
% 
% slope = Sxy/Sxx;
% intercept = y_mean - (slope * x_mean);
% 
% y_hat = (slope .* x_data) + intercept;
% SSresidual = sum((y_data - y_hat).^2, "all");
% SStotal = sum((y_data - y_mean).^2, "all");
% 
% R2 = 1 - (SSresidual / SStotal);
% 
% % plotting
% figure('Name', "Linear Regression")
% hold on
% plot(x_data, y_data, LineStyle="-", Marker="o", LineWidth=1.5)
% plot(x_data, y_hat, LineStyle="--", Marker="o", LineWidth=1.5)
% hold off
% grid on
% legend('Data Points', 'Regressed Line', Location='best')
% xlabel('z - z_o')
% ylabel('t / (z - z_o)')
% 
% lambda_mean = 1 / slope;
% D2 = lambda_mean / tau;
% 
% fprintf('\nMethod 2 : D = %0.3e\n\n', D2);

%-------------------------------------------------------------------------%


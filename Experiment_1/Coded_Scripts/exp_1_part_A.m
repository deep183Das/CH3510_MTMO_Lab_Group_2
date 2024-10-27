% CH3510
% Mass Transfer and Mass Operations Lab

% EXP - 1 PART - A
% Calculating Darcy's Friction Factor

% CH22B008
% Aayush Bhakna

clear all;
clc;

%-------------------------------------------------------------------------%

% GIVEN DATA

% setup 1
del_p_1 = [1.3, 2.5, 2.5, 4.0, 5.4, 6.8, 9.1, 10.2]; % in psi
Q_1 = [118, 143, 166, 198, 225, 253, 278, 309]; % in lph

del_p_1 = del_p_1 .* 6894.76; % in Pa
Q_1 = Q_1 ./ (36 * (10^5)); % in m^3/s

% setup 2
del_p_2 = [3.2, 5.5, 7.1, 8.8, 10.5, 12.5, 13.9, 15.4, 16.5, 16.5]; % in psi
Q_2 = [190, 218, 267, 291, 317, 341, 365, 386, 391, 400]; % in lph

del_p_2 = del_p_2 .* 6894.76; % in Pa
Q_2 = Q_2 ./ (36 * (10^5)); % in m^3/s

rho = 1000; % in kg/m^3
eta = 0.7972 * (10^-3); % in Pa.s

D = 3 / 100; % in m
A = pi * (D^2) / 4; % in m^2

L = 80; % in m
H = 0.5; % in m
g = 9.81; % in SI units

%-------------------------------------------------------------------------%

% PLOTTING

v_1 = Q_1 ./ A; % in m/s
v_2 = Q_2 ./ A; % in m/s

% del_p vs velocity in 1
figure(1)
plot(v_1.^2, del_p_1, LineWidth=1.5, Marker="o")
grid on
xlabel('v^2 in (m/s)^2')
ylabel('Pressure Drop in Pa')

% del_p vs velocity in 2
figure(2)
plot(v_2.^2, del_p_2, LineWidth=1.5, Marker="o")
grid on
xlabel('v^2 in (m/s)^2')
ylabel('Pressure Drop in Pa')

Re_1 = rho .* D .* v_1 ./ eta;
Re_2 = rho .* D .* v_2 ./ eta;

fD_1 = 0.3164 .* (Re_1.^(-1/4));
fD_2 = 0.3164 .* (Re_2.^(-1/4));

% Theoretical Friction Factor
figure(4)
plot(v_1, fD_1, LineWidth=1.5, Marker="o")
hold on
plot(v_2, fD_2, LineWidth=1.5, Marker="o")
hold off
grid on
legend('Setup 1', 'Setup 2')
xlabel('v in m/s')
ylabel('Darcy Friction Factor')

%-------------------------------------------------------------------------%


% EXP 3B
% MTMO LAB - Group 2
% Aayush Bhakna Ch22b008

% Packed Bed | Structured Packing
% Assuming Laminar + Turbulent (Ergen's equation)
% Del_p or Phi_s are unknown

clear all;
clc;

%-------------------------------------------------------------------------%

% VARIABLE INITIALIZATION

g = 9.81; % in m^2/s

% volume of voids in column
V_void = 2400; % in mL
V_void = V_void * (10^-6); % in m^3
V_water = 2640 * (10^-6); % in m^3

% diameter of column
D = 100; % in mm
D = D / 1000; % in m

% cross-section area of column
A = (pi/4)*(D^2); % in m^2

% height of column
H = (59.5/100); % in m

% volume of column
V_bed = (A*H); % in m^3

% porosity
eps = V_void / V_bed;

% pressure drop
del_p = [2, 3.9, 6, 8, 9.3, 10, 10.9, 10, 9.2, 8, 6.1, 4.3, 3, 2]; % in cm CCl4
del_p = (del_p)./100; % in meter CCl4

rho_CCl4 = 1590; % in kg/m^3
del_p = rho_CCl4 .* g .* del_p; % in Pa

% volumetric flow rate
del_V = [1120, 760, 780, 1100, 1480, 980, 760, 1040, 980, 880, 960, 800, 820, 580]; % in mL
del_t = [3.59, 1.75, 1.53, 1.83, 2.02, 1.41, 1.06, 1.39, 1.38, 1.51, 1.76, 1.77, 2.28, 2.01]; % in sec

Q = del_V ./ del_t; % in mL/s
Q = Q .* (10^-6); % in m^3/s

% superficial velocity
v_sf = Q ./ A; % in m/s

% fluid parameters
rho_f = 995.7; % in kg/m^3
nu = 0.7972 * (10^-3); % in Pa*s

%-------------------------------------------------------------------------%

% CALCULATING THEORETICAL DEL_P

% plotting graph
figure(1)
plot(v_sf(1:7), del_p(1:7), 'o-', Color="Blue", LineWidth=1.5)
hold on
plot(v_sf(7:end), del_p(7:end), 'o-', Color="Cyan", LineWidth=1.5)
hold off
grid on
legend('Exp P drop (forward)', 'Exp P drop (backward)', Location='southeast')
xlabel('Superficial velocity (m/s)')
ylabel('Pressure Drop (Pa)')
title('Pressure Drop in Structured packing')
% saveas(gcf, "left_pressure_vsf.png")

%-------------------------------------------------------------------------%
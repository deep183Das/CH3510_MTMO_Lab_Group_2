% EXP - 4
% PUMP CHARACTERISTICS

% MTMO Group - 2
% Aayush Bhakna
% Ch22b008

clear all;
clc;

%-------------------------------------------------------------------------%

% CENTRIFUGAL PUMP

Vf_cent = [2500, 2600, 2690, 2790, 2919, 3039, 3276, 3396, 3513, 3626, ...
    3752, 3877, 4000, 4128, 4240, 4355, 4472, 4609, 4762, 4840, 4900, 5000];

del_p_cent = [0, 0, 0, 1.4, 1.5, 1.6, 1.8, 1.9, 2.0, 2.2, 2.3, 2.4, ...
    2.5, 2.7, 2.8, 2.8, 3.0, 3.1, 3.5, 3.6, 3.6, 3.6];


% plotting graph
figure(1)

plot(del_p_cent, Vf_cent, 'o-', Color="Red", LineWidth=1.5)
grid on

xlabel('Pressure Drop due to Pump (psi)')
ylabel('Volumetric Flow Rate in Outlet (L/hr)')
title('V_f vs Del p')

%-------------------------------------------------------------------------%

% PERISTALTIC PUMP

Vf_peri_machine = [50, 100, 150, 200, 300, 400]; % mL/min
Vf_peri_machine = Vf_peri_machine ./ 60; % mL/s

V_peri = [46, 98, 140, 190, 287, 392]; % mL
T_peri = [60.73, 60.82, 60.80, 60.61, 60.68, 60.84]; % sec

Vf_peri_actual = V_peri ./ T_peri; % mL/s

% plotting graph
figure(2)
plot(Vf_peri_machine, Vf_peri_actual, 'o-', Color="Red", LineWidth=1.5)
grid on
xlabel('Pump Volumetric Flow Rate (mL/s)')
ylabel('Measured Volumetric Flow Rate (mL/s)')
title('V_f measured vs V_f input')

Err = (Vf_peri_machine - Vf_peri_actual).*100./Vf_peri_machine; % err%

figure(3)
plot(Vf_peri_machine, Err, 'o-', Color="Blue", LineWidth=1.5)
grid on
xlabel('Pump Volumetric Flow Rate (mL/s)')
ylabel('Error Percentage (%)')
title('Percent Err in V_f vs V_f input')

%-------------------------------------------------------------------------%


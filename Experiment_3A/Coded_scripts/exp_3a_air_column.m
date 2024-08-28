% EXP - 3A
% Mtmo group 2
% fluidized bed studies

clear all;
clc;

%-------------------------------------------------------------------------%

% CASE : Air + Sand Grains

h_del_p = [2.7, 3.7, 4.4, 4.3, 4.3, 4.3, 4.3, 4.3, 3.2, 2.4]'; % cm Hg
h_del_p = h_del_p ./ 100; % m Hg

h = [4.1, 4.5, 5.0, 5.5, 6.5, 5.2, 4.5, 4.4, 4.3, 4.1]'; % cm
h = h ./ 100; % m

D = 50 / 1000; % m
m_p = 250 / 1000; % kg
H = 60 / 100; % m

T_std = 273.15; % kelvin
T = 273.15 + 30.1; % kelvin

Q = [2.4, 3.8, 4.2, 4.8, 5.4, 4.8, 4.2, 3.6, 2.6, 2.0]'; % Nm3/Hr

Q = Q .* T ./ T_std; % m3/Hr
Q = Q ./ 3600; % m3/s

rho_p = mean([(30.15 / 10.1), (30.68 / 10.2)], "all"); % gcc
rho_p = rho_p * 1000; % kg/m3

rho = 1.164; % kg/m3 at 30 C

eps = 0.34; % porosity
g = 9.81; % m2/s

%-------------------------------------------------------------------------%

% CALCULATIONS (assuming porosity is known, rho_m is not)

del_p_1 = h .* g .* (1 - eps) .* (rho_p - rho);
del_p_2 = rho .* g .* (H - h);
del_p = del_p_2 + del_p_1; % total pressure drop
theoretical_press_drop = del_p;

rho_m = del_p ./ (g .* h_del_p); % density of manometer fluid
rho_m_mean = mean(rho_m, "all");

%-------------------------------------------------------------------------%

% PLOTTING DATA

pres_drop = rho_m_mean .* g .* h_del_p; % pressure drop by manometer

V_s = Q ./ ((pi * (D^2))/4); % superficial velocity

x = [V_s(10), 0,0,0,0,0];
y = [pres_drop(10), 0,0,0,0,0];
x(2:end) = V_s(1:5);
y(2:end) = pres_drop(1:5);

figure(1)
plot(x, y, 'o-', Color='Red', LineWidth=2)
hold on
plot(V_s(6:10), pres_drop(6:10), 'o-', Color='Blue', LineWidth=2)
hold off
grid on
legend('Forward', 'Backward')
xlabel('Superficial Velocity (m/s)')
ylabel('Pressure Drop (Pa)')
% saveas(gcf, 'presure_drop_vs_velocity.png')

figure(2)
plot(V_s(1:5), h(1:5), 'o-', Color='Red', LineWidth=2)
hold on
plot(V_s(5:10), h(5:10), 'o-', Color='Blue', LineWidth=2)
hold off
grid on
legend('Forward', 'Backward', Location='northwest')
xlabel('Superficial Velocity (m/s)')
ylabel('Bed Height (m)')
% saveas(gcf, 'bed_height_vs_velocity.png')

figure(3)
scatter(h_del_p, rho_m, MarkerFaceColor="Blue")
hold on
plot([0.02, 0.045], [rho_m_mean, rho_m_mean], Color="Red", LineWidth=2)
hold off
grid on
legend('Data Points', 'Mean Value')
xlabel('Manometer Height Difference (m)')
ylabel('Calculated Density of Manometer Fluid (kg/m^3)')
% saveas(gcf, 'calculated_density_manometer.png')

%-------------------------------------------------------------------------%
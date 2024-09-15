% EXP - 5
% Transient Conduction of Heat (Cylinder)

% MTMO - group 2
% Ch22b008
% Aayush Bhakna

clear all;
clc;

%-------------------------------------------------------------------------%

% DATA AVAILABLE

global R
global R1
global R2
global R3

% Cylinder Measurements
L = (150.70 + 152.70)/2; % in mm
D = (75.46 + 71.70)/2; % in mm

% Automatic Data
Data_auto = readtable("automatic_cylinder_cooling.csv");
Data_auto = table2array(Data_auto);
Data_auto(:, 2:4) = Data_auto(:, 2:4) + 273.15; % in Sec, Kelvin

% Manual Data
Data_man = readtable("manual_cylinder_cooling.csv");
Data_man = table2array(Data_man);
Data_man(:, 2:4) = Data_man(:, 2:4) + 273.15; % in Sec, Kelvin

% Distance of Thermocouples from center
R1 = (D/2) - 15; % in mm
R2 = (D/2) - 25; % in mm
R3 = (D/2) - 35; % in mm

% SI units
L = L / 1000; % in m
D = D / 1000; % in m
R1 = R1 / 1000; % in m
R2 = R2 / 1000; % in m
R3 = R3 / 1000; % in m
R = D/2;

% Thermal Conductivity in W/m*K
k1 = 79.5; % iron
k2 = 50.2; % steel

% Density in kg/m^3
rho1 = 7860; % iron
rho2 = 7900; % steel

% Cp in J/kg*K
Cp1 = 449; % iron
Cp2 = 490; % steel

%-------------------------------------------------------------------------%

% PLOTTING

global k

% k = k1; rho = rho1; Cp = Cp1; % iron
k = k2; rho = rho2; Cp = Cp2; % steel

h0 = 100; % air
alpha = k / (rho * Cp);

h1 = fsolve(@(h) h_finder(h, alpha, Data_auto), h0);
h2 = fsolve(@(h) h_finder(h, alpha, Data_man), h0);

h = (h1+h2)/2;

t_final = 360 * (alpha / (R^2)); % t* = t alpha / R^2

x = [0, (R3/R), (R2/R), (R1/R), 1]; % x* from 0 to 1
t = linspace(0, t_final, length(Data_auto)); % t* from 0 to t_final

m = 1;
sol = pdepe(m,@heatpde,@heatic,@(xl,ul,xr,ur,t) heatbc(xl,ul,xr,ur,t,h),x,t);

colormap hot
pcolor(x,t,sol)
colorbar
xlabel('Distance x','interpreter','latex')
ylabel('Time t','interpreter','latex')
title('Heat Equation for $0 \le x \le 1$ and $0 \le t \le 5$', ...
    'interpreter','latex')

%-------------------------------------------------------------------------%

% PLOTTING

for i = 1:3
figure("Name", "Cylinder Cooling | Thermocouple " + int2str(i))
plot(Data_auto(:, 1), Data_auto(1:70, i+1), '-', Color="Red", LineWidth=1.75)
hold on
plot(Data_auto(:, 1), Data_man(1:70, i+1), '-', Color="Blue", LineWidth=1.75)
plot(Data_auto(:, 1), sol(1:70, 5-i), '-', Color="Black", LineWidth=1.75)
hold off
axis([-220, 2220, 330, 380])
legend('Automatic Data', 'Manual Data', 'PDE solver', Location='best')
xlabel('Time (seconds)')
ylabel('Temperature (kelvin)')
% saveas(gcf, "cylinder_cooling_therm_"+int2str(i)+".png")
end


%-------------------------------------------------------------------------%

% LOCAL FUNCTIONS

function [c,f,s] = heatpde(x,t,u,dudx)
c = 1;
f = dudx;
s = 0;
end

function u0 = heatic(x)
u0 = 373.15; % kelvin
end

function [pl,ql,pr,qr] = heatbc(xl,ul,xr,ur,t,h)

global k
global R

pl = 0; %ignored by solver since m=1
ql = 0; %ignored by solver since m=1
pr = h*R*(ur - 303.45)/k;
qr = 1; 

end

function f = h_finder(h, alpha, Data)

global R
global R1
global R2
global R3

t_final = 360 * (alpha / (R^2)); % t* = t alpha / R^2

x = [0, (R3/R), (R2/R), (R1/R), 1]; % x* from 0 to 1
t = linspace(0, t_final, length(Data)); % t* from 0 to t_final

m = 1;
sol = pdepe(m,@heatpde,@heatic,@(xl,ul,xr,ur,t) heatbc(xl,ul,xr,ur,t,h),x,t);

Data_pde = [sol(:, 4), sol(:, 3), sol(:, 2)];
Error = Data_pde - Data(:, 2:4);
f = sum(Error.^2, "all");

end

%-------------------------------------------------------------------------%
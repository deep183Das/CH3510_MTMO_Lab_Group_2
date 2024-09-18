% Exp-5 : Transient Heat Conduction
% Deepanjhan Das [CH22B020] ~ Code From Aayush

clear; close all;
format long;

%% Cooling of Sphere [Both Manual and Automatic]
%-------------------------------------------------------------------------%

% DATA AVAILABLE

global R
global R1
global R2
global R3

% Sphere Measurements
D = 118.9; % in mm   (diameter)

% Automatic Data
Data_auto = readtable("automatic_sphere_cooling.csv");
Data_auto = table2array(Data_auto);
Data_auto(:, 2:4) = Data_auto(:, 2:4) + 273.15; % in Sec, Kelvin

% Manual Data
Data_man = readtable("manual_sphere_cooling.csv");
Data_man = table2array(Data_man);
Data_man(:, 2:4) = Data_man(:, 2:4) + 273.15; % in Sec, Kelvin

% Distance of Thermocouples from center
R1 = (D/2) - 15; % in mm
R2 = (D/2) - 25; % in mm
R3 = (D/2) - 35; % in mm

% SI units
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

h0 = [100; 0.5]; % air
alpha = k / (rho * Cp);

A = [];
b = [];
Aeq = [];
beq =[];
lb = [0, 0];
ub = [10000, 1];

h1 = fmincon(@(h) h_finder(h(1), h(2), alpha, Data_auto), h0, A, b, Aeq,beq,lb,ub);
h2 = fmincon(@(h) h_finder(h(1), h(2), alpha, Data_man), h0, A, b, Aeq,beq,lb,ub);

h = (h1(1)+h2(1))/2;
eps = (h1(2)+h2(2))/2;
% biot number for this system
Bi = h*R/k;

t_final = Data_auto(end, 1) * (alpha / (R^2)); % t* = t alpha / R^2

x = [0, (R3/R), (R2/R), (R1/R), 1]; % x* from 0 to 1
t = linspace(0, t_final, length(Data_auto)); % t* from 0 to t_final

m = 2;
sol = pdepe(m,@heatpde,@heatic,@(xl,ul,xr,ur,t) heatbc(xl,ul,xr,ur,t,h,eps),x,t);

x2 = linspace(0, 1, 10^2); % x* from 0 to 1
t2 = linspace(0, t_final, 10^2); % t* from 0 to t_final
sol2 = pdepe(m,@heatpde,@heatic,@(xl,ul,xr,ur,t) heatbc(xl,ul,xr,ur,t,h,eps),x2,t2);

sol2 = sol2 - 273.15; % celcius

figure(1)
colormap hot
pcolor(x2,t2,sol2)
colorbar
xlabel('Dimensionless Distance r* = r/R','interpreter','latex')
ylabel('Dimensionless Time t* = \alpha t / R^2','interpreter','latex')
saveas(gcf, "sphere_cooling_pde.png")

%-------------------------------------------------------------------------%

% PLOTTING

for i = 1:3
figure("Name", "Cylinder Cooling | Thermocouple " + int2str(i))
plot(Data_auto(:, 1), Data_auto(:, i+1), '-', Color="Red", LineWidth=1.75)
hold on
% plot(Data_auto(:, 1), Data_man(1:length(Data_auto), i+1), '-', Color="Blue", LineWidth=1.75)
plot(Data_man(:, 1), Data_man(:, i+1), '-', Color="Blue", LineWidth=1.75)
plot(Data_auto(:, 1), sol(:, 5-i), '-', Color="Black", LineWidth=1.75)
hold off
axis([-100, Data_auto(end, 1)+100, 60+273-10, 100+273+10])
legend('Automatic Data', 'Manual Data', 'PDE solver', Location='best')
xlabel('Time (seconds)')
ylabel('Temperature (kelvin)')
saveas(gcf, "sphere_cooling_therm_"+int2str(i)+".png")
end

% Lumped System
h_new_1 = fsolve(@(h) h_finder2(h, alpha, Data_auto), h0);
h_new_2 = fsolve(@(h) h_finder2(h, alpha, Data_man), h0);
h_lumped = (h_new_2 + h_new_1)/2;

Fo = t(2);   % for 30 seconds
disp(Bi)
disp(Fo)
disp(h)

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

function [pl,ql,pr,qr] = heatbc(xl,ul,xr,ur,t,h,eps)

global k
global R

sigma = 5.67*(10^-8); % in W m^-2 K^-4
Tsurr = 303.15; % kelvin
pl = 0; %ignored by solver since m=1
ql = 0; %ignored by solver since m=1
pr = (R/k)*((h*(ur - Tsurr)) + (eps*sigma*((ur^4)-(Tsurr^4))));
qr = 1; 

end

function f = h_finder(h, eps, alpha, Data)

global R
global R1
global R2
global R3

t_final = Data(end, 1) * (alpha / (R^2)); % t* = t alpha / R^2

x = [0, (R3/R), (R2/R), (R1/R), 1]; % x* from 0 to 1
t = linspace(0, t_final, length(Data)); % t* from 0 to t_final

m = 2;
sol = pdepe(m,@heatpde,@heatic,@(xl,ul,xr,ur,t) heatbc(xl,ul,xr,ur,t,h,eps),x,t);

Data_pde = [sol(:, 4), sol(:, 3), sol(:, 2)];
Error = Data_pde - Data(:, 2:4);

f = sum(Error.^2, "all");

end

function f = h_finder2(h, alpha, Data_auto)

global R
global k

Tsurr = 303.45;
Ti = 373.15;

T = (Data_auto(:, 2) + Data_auto(:, 3) + Data_auto(:, 4))./3;

t_final = 4 * Data_auto(end, 1) * (alpha / (R^2)); % t* = t alpha / R^2
t = linspace(0, t_final, length(T)); % t* from 0 to t_final

Bi = h*R/(2*k);
T_new = Tsurr + ((Ti - Tsurr).*exp(-Bi.*t));

Error = T_new - T';
f = sum(Error.^2, "all");

end

%-------------------------------------------------------------------------%
% EXP-7
% Aayush Bhakna Ch22b008

% Batch Distillation
% Ethanol-Water Solution

clear all;
clc;

%-----------------------------------------------------------------------%

% VARIABLE INITIALIZATION

data.P = 1.01325; % bar

%-----------------------------------------------------------------------%

% THEORETICAL DATA

% Antoine eq parameters

% log10(P) = A − (B / (T + C))
%    P = vapor pressure (bar)
%    T = temperature (K)

data.A1 = 4.92531;
data.B1 = 1432.526;
data.C1 = -61.819;

data.A2 = 4.6543;
data.B2 = 1435.264;
data.C2 = -64.848;

% VLE data from Paper_1

data.T = [95.5, 89.0, 86.7, 85.3, 84.1, 82.7, 82.3, 81.5, 80.7, 79.8, ...
    79.7, 79.3, 78.74, 78.41, 78.15];

data.x1 = [0.019, 0.0721, 0.0966, 0.1238, 0.1661, 0.2337, 0.2608, ...
    0.3273, 0.3965, 0.5079, 0.5198, 0.5732, 0.6763, 0.7472, 0.8943];

data.x2 = 1 - data.x1;

data.y1 = [0.1700, 0.3891, 0.4375, 0.4704, 0.5089, 0.5445, 0.5580, ...
    0.5826, 0.6122, 0.6564, 0.6599, 0.6841, 0.7385, 0.7815, 0.8943];

data.y2 = 1 - data.y1;

% Calculating VanLaar Parameters

Axx_0 = [1 1]';
options = optimoptions('fsolve', ...
    'Display', 'none', ...
    'Algorithm', 'trust-region');
Axx = fsolve(@(X) eqVanLaar(data, X), ...
    Axx_0, options);

data.A12 = Axx(1);
data.A21 = Axx(2);

% Calculating Temp and y from x

x1 = 0.001:0.001:0.998;
x1 = x1';

T0 = 300.*ones(size(x1));
T = fsolve(@(T) x1toTemp(data, x1, T), ...
    T0, options);

y1 = x1toy1(data, x1, T);

data.vanlaar_x1 = x1;
data.vanlaar_y1 = y1;
data.vanlaar_T = T;

% Calculated plotting

figure('Name', "Calculated VLE data from VanLaar equation")

subplot(1, 2, 1)
plot(data.x1, data.T, Color='Blue', LineWidth=1.5, Marker='o')
hold on
plot(data.y1, data.T, Color='Red', LineWidth=1.5, Marker='o')
hold off
grid on
legend('Liquid phase', 'Vapor phase')
xlabel('Mole frac of Ethanol')
ylabel('Temperature in Celsius')
title('Experimental data')

subplot(1, 2, 2)
plot(x1, T, Color='Blue', LineWidth=1.5)
hold on
plot(y1, T, Color='Red', LineWidth=1.5)
hold off
grid on
legend('Liquid phase', 'Vapor phase')
xlabel('Mole frac of Ethanol')
ylabel('Temperature in Celsius')
title('Fitted Model')

figure('Name', "Calculated VLE data from VanLaar equation")

subplot(1, 2, 1)
plot(data.x1, data.y1, Color='Red', LineWidth=1.5, Marker='o')
hold on
plot([0 1], [0 1], Color='Black', LineWidth=1.5)
hold off
grid on
xlabel('Mole frac of Ethanol in Liquid Phase')
ylabel('Mole frac of Ethanol in Vapor Phase')
title('Experimental data')

subplot(1, 2, 2)
plot(x1, y1, Color='Red', LineWidth=1.5)
hold on
plot([0 1], [0 1], Color='Black', LineWidth=1.5)
hold off
grid on
xlabel('Mole frac of Ethanol in Liquid Phase')
ylabel('Mole frac of Ethanol in Vapor Phase')
title('Fitted Model')

% VLE data from Paper_2

eq_xe = zeros(1, 52);
eq_xe(1:5) = 0.01:0.01:0.05;
eq_xe(6:end) = 0.06:0.02:0.98;
data.eq_xe = eq_xe;

data.eq_ye = [0.104, 0.190, 0.250, 0.297, 0.332, 0.364, 0.410, ...
    0.442, 0.468, 0.488, 0.505, 0.519, 0.531, 0.541, 0.551, 0.560, ...
    0.568, 0.576, 0.584, 0.591, 0.599, 0.607, 0.614, 0.621, 0.629, ...
    0.637, 0.646, 0.654, 0.663, 0.672, 0.681, 0.690, 0.699, 0.709, ...
    0.719, 0.730, 0.741, 0.753, 0.765, 0.777, 0.790, 0.804, 0.818, ...
    0.833, 0.848, 0.864, 0.881, 0.898, 0.917, 0.936, 0.956, 0.978];

figure('Name', "Ethanol-Water Equilibrium Curve")
plot(data.eq_xe, data.eq_ye, Color='Red', ...
    LineWidth=1.5, Marker='o')
hold on
plot(x1, y1, Color='Blue', LineWidth=1.5)
plot([0, 1], [0, 1], Color='Black', LineWidth=1.5)
hold off
grid on
legend('Experimental Data', 'Fitted VanLaar model', 'y=x', ...
    Location='best')
xlabel('Mole frac of Ethanol in Liquid')
ylabel('Mole frac of Ethanol in Vapor')
% saveas(gcf, "model_accuracy_plot.png")

% Model Accuracy

x = data.eq_xe;
x = x';

T0 = 300.*ones(size(x));
T = fsolve(@(T) x1toTemp(data, x, T), ...
    T0, options);

y_data = data.eq_ye;
y_hat = x1toy1(data, x, T);
y_hat = y_hat';

SSres = sum((y_data - y_hat).^2, "all");
SSt = sum((y_data - mean(y_data, "all")).^2, "all");
R2 = 1 - (SSres / SSt);

data.SSres = SSres;
data.R2 = R2;

% calibration data

data.mW1 = 46.068; % g/mol
data.mW2 = 18.015; % g/mol

rho_1 = 0.784;
rho_2 = 0.997;

data.mass_frac_1 = 0:0.1:1;
data.rho_mix = [0.996, 0.979, 0.964, 0.947, 0.928, 0.906, 0.883, ...
    0.859, 0.835, 0.809, 0.781]; % in g/mL at 30 celcius

data.mol_frac_1 = (1/data.mW1) ./ ( (1/data.mW1) + ...
    ((1/data.mW2) .* ((1 - data.mass_frac_1)./(data.mass_frac_1))) );

p = polyfit(data.mol_frac_1, data.rho_mix, 2);

vol_frac_1 = [1, 0.8, 0.6, 0.4, 0.2, 0];
rho_mix = [0.784, 0.844, 0.900, 0.936, 0.995, 0.997];

% (0.2, 0.995) is an Outlier
% Remove it to get better values

mol_frac_1 = (rho_1/data.mW1) ./ ( (rho_1/data.mW1) + ...
    ((rho_2/data.mW2) .* ((1 - vol_frac_1)./(vol_frac_1))) );

p2 = polyfit(mol_frac_1, rho_mix, 2);

figure('Name', "Density of Ethanol-Water Mixture (from Paper)")
scatter(data.mol_frac_1, data.rho_mix, 50, ...
    Marker='o', MarkerFaceColor='red');
hold on
plot(0:0.05:1, polyval(p, 0:0.05:1), ...
    Color='red', LineWidth=1.5');
scatter(mol_frac_1, rho_mix, 50, ...
    Marker='o', MarkerFaceColor='blue');
plot(0:0.05:1, polyval(p2, 0:0.05:1), ...
    Color='blue', LineWidth=1.5');
hold off
grid on
legend('Exp Data', 'Fitted Polynomial', ...
    'Exp Data iitm', 'Fitted Polynomial iitm', ...
    Location='best')
xlabel('Mole frac of Ethanol')
ylabel('Density in g/mL')

z1 = polyval(p, 0:0.05:1);
z2 = polyval(p2, 0:0.05:1);

SSres = sum((z1 - z2).^2, "all");
SSt = sum((z1 - mean(z1, "all")).^2, "all");
R2 = 1 - (SSres / SSt);

% calculting still total moles

% at t = 0

data.V10 = 200; % mL
data.V20 = 400; % mL

data.M10 = data.V10 * polyval(p, 1); % g
data.M20 = data.V20 * polyval(p, 0); % g

data.N10 = data.M10 / data.mW1; % moles
data.N20 = data.M20 / data.mW2; % moles
data.N0 = data.N10 + data.N20;

x_i = data.N10 / data.N0;

% at t = final

data.V1 = 354; % mL
rho_mix = (0.9878 + 0.9876) / 2; % g/mL

p_dash = p;
p_dash(end) = p_dash(end) - rho_mix;
x_roots = roots(p_dash);

x_f = min(x_roots, [], "all"); % mol frac of ethanol
x_ff = x_f;

xm_f = 1 / ((((1-x_f)/x_f) * (data.mW2/data.mW1)) + 1); % mass frac

data.M11 = xm_f * data.V1 * rho_mix; % in g
data.M21 = (1-xm_f) * data.V1 * rho_mix; % in g

data.V11 = data.M11 / polyval(p, 1); % in mL
data.V21 = data.M21 / polyval(p, 0); % in mL

data.N11 = data.M11 / data.mW1; % moles
data.N21 = data.M21 / data.mW2; % moles
data.N1 = data.N11 + data.N21;

% distillate final

data.Vd = 212; % mL
rho_mix = (0.878 + 0.877) / 2; % g/mL

p_dash = p;
p_dash(end) = p_dash(end) - rho_mix;
x_roots = roots(p_dash);

x_f = min(x_roots, [], "all"); % mol frac of ethanol

xm_f = 1 / ((((1-x_f)/x_f) * (data.mW2/data.mW1)) + 1); % mass frac

data.Md1 = xm_f * data.Vd * rho_mix; % in g
data.Md2 = (1-xm_f) * data.Vd * rho_mix; % in g

data.Vd1 = data.Md1 / polyval(p, 1); % in mL
data.Vd2 = data.Md2 / polyval(p, 0); % in mL

data.Nd1 = data.Md1 / data.mW1; % moles
data.Nd2 = data.Md2 / data.mW2; % moles
data.Nd = data.Nd1 + data.Nd2;

% verify mass conservation

Mi = data.M10 + data.M20;
Mf = data.M11 + data.M21 + data.Md1 + data.Md2;

% verify rayleigh equation

x = linspace(x_ff, x_i, 1000);
x = x';

T0 = 300.*ones(size(x));
T = fsolve(@(T) x1toTemp(data, x, T), ...
    T0, options);

y = x1toy1(data, x, T);

RHS = eqRayleigh(x, y);
LHS = log(data.N0 / data.N1);


%-----------------------------------------------------------------------%

% LOCAL FUNCTIONS

% fsolve - Van Laar equation

function f = eqVanLaar(data, X)

% finding A12 and A21
A12 = X(1);
A21 = X(2);

% fsolve f
f = zeros(2, 1);

ln_gamma_1 = A12 ./ ...
    (( 1 + ((A12 .* data.x1) ./ (A21 .* data.x2)) ).^2);

ln_gamma_2 = A21 ./ ...
    (( 1 + ((A21 .* data.x2) ./ (A12 .* data.x1)) ).^2);

gamma_1 = exp(ln_gamma_1);
gamma_2 = exp(ln_gamma_2);

T = data.T + 273.15; % kelvin

log10Psat1 = data.A1 - (data.B1 ./ (T + data.C1));
Psat1 = 10.^log10Psat1; % in bar

log10Psat2 = data.A2 - (data.B2 ./ (T + data.C2));
Psat2 = 10.^log10Psat2; % in bar

P = data.P; % in bar

ff1 = gamma_1 - ((data.y1 .* P)./(data.x1 .* Psat1));
ff2 = gamma_2 - ((data.y2 .* P)./(data.x2 .* Psat2));

f(1) = norm(ff1);
f(2) = norm(ff2);

end

%-----------------------------------------------------------------------%

% calculating temp from x

function f = x1toTemp(data, x1, T)

% known A12 and A21
A12 = data.A12;
A21 = data.A21;

ln_gamma_1 = A12 ./ ...
    (( 1 + ((A12 .* x1) ./ (A21 .* (1-x1))) ).^2);

ln_gamma_2 = A21 ./ ...
    (( 1 + ((A21 .* (1-x1)) ./ (A12 .* x1)) ).^2);

gamma_1 = exp(ln_gamma_1);
gamma_2 = exp(ln_gamma_2);

log10Psat1 = data.A1 - (data.B1 ./ (T + data.C1));
Psat1 = 10.^log10Psat1; % in bar

log10Psat2 = data.A2 - (data.B2 ./ (T + data.C2));
Psat2 = 10.^log10Psat2; % in bar

P = data.P; % in bar

f = (x1 .* gamma_1 .* Psat1) + ((1-x1) .* gamma_2 .* Psat2) - P;

end

%-----------------------------------------------------------------------%

% calculating y from x

function f = x1toy1(data, x1, T)

% known A12 and A21
A12 = data.A12;
A21 = data.A21;

ln_gamma_1 = A12 ./ ...
    (( 1 + ((A12 .* x1) ./ (A21 .* (1-x1))) ).^2);

gamma_1 = exp(ln_gamma_1);

log10Psat1 = data.A1 - (data.B1 ./ (T + data.C1));
Psat1 = 10.^log10Psat1; % in bar

P = data.P; % in bar

f = (x1 .* gamma_1 .* Psat1) ./ P;

end

%-----------------------------------------------------------------------%

% integration using trapezoid method

function f = xtoInt(x, y)

step = x(2:end) - x(1:end-1);
area = 0.5 .* step .* (y(1:end-1) + y(2:end));

f = sum(area, "all");

end

%-----------------------------------------------------------------------%

% rayleigh's formula

function f = eqRayleigh(x, y)

int_func = 1 ./ (y - x);
f = xtoInt(x, int_func);

end


% EXP - 2B
% Mtmo group 2
% sedimentation studies

%-------------------------------------------------------------------------%

% all DATA

conc = [5, 10, 15, 20]; % in w/w percentage

u_p_conc = [0.014991, 0.00443334, 0.0011421, 0.0007112]; % in cm/s
u_p_conc = u_p_conc ./ 100; % in m/s

u_p_dia = [0.01781, 0.01804, 0.011957, 0.01902]; % in cm/s
u_p_dia = u_p_dia ./ 100; % in m/s

conc_dia = 42.50 / 1000; % in m
dia_four = [22.30, 17.88, 11.70, 5.80] ./ 1000; % in m

rho_w = 0.997 * 1000; % in kg/m^3
rho_s = 2.71 * 1000; % in kg/m^3

Dp = ((0.2 + 30)/2) * (10^-6); % avg diameter of particle in meters
mu = 0.7972 * (10^-3); % in Pa.s

g = 9.81; % in m^2/s

m_w = 1200 * (10^-6) * rho_w; % in kg
m_s = m_w .* conc ./ (100 - conc); % in kg

V_s = m_s ./ rho_s; % in m^3
V_t = V_s + 1200 * (10^-6); % in m^3

H = 4 .* V_t ./ (pi .* (conc_dia .^ 2)); % in m

h1 = H; % in m
h2 = [61, 67, 80, 87] ./ 100; % in m
eps1 = 1 - ((H .* V_s)./(h1 .* V_t)); % dimensionless
eps2 = 1 - ((H .* V_s)./(h2 .* V_t)); % dimensionless

u_t_conc = g .* (Dp.^2) .* (rho_s - rho_w) ./ (18 .* mu);

n1 = (log(u_p_conc) - log(u_t_conc)) ./ (log(eps1));
n2 = (log(u_p_conc) - log(u_t_conc)) ./ (log(eps2));
n = (n1 + n2) ./ 2;

% fprintf('\n')
% fprintf('Value of n at D_p = 15 : \n')
% disp(n)

N_re = rho_w .* Dp .* u_p_conc ./ mu;
% fprintf('\n')
% fprintf('Value of N_re : \n')
% disp(N_re)

%-------------------------------------------------------------------------%

% error

u_p_th_1 = u_t_conc .* (eps1.^4.5);
u_p_th_2 = u_t_conc .* (eps2.^4.5);
u_p_th = (u_p_th_1 + u_p_th_2)./2;

err = abs(u_p_th - u_p_conc) ./ u_p_th;

% fprintf('\n')
% fprintf('Value of obs u_p : \n')
% disp(u_p_conc .* 100)
% fprintf('\n')
% fprintf('Value of theoretical u_p : \n')
% disp(u_p_th .* 100)
% fprintf('Value of error : \n')
% disp(err)

%-------------------------------------------------------------------------%

eps = (eps1 + eps2)./2;
% fprintf('Eps values at n=4.5 : \n')
% disp(eps)

u_t_values = u_p_conc .* (eps.^(-4.5));
% fprintf('u_t (cm/s) values at n=4.5 : \n')
% disp(u_t_values .* 100)

Dp_guess = ((u_t_values .* 18 .* mu) ./ (g .* (rho_s - rho_w))) .^ 0.5;
% fprintf('Dp (um) guess values at n=4.5 : \n')
% disp(Dp_guess .* (10^6))

%-------------------------------------------------------------------------%

figure(1)

x_data = conc;
y_data = u_p_conc;

Sxy = sum((x_data - mean(x_data, "all")).*(y_data - mean(y_data, "all")), "all");
Sxx = sum((x_data - mean(x_data, "all")).^2, "all");
m = Sxy / Sxx;
c = mean(y_data, "all") - (m * mean(x_data, "all"));
disp(m)
disp(c)

x = linspace(2, 22, 100);
y = (m .* x) + c;

scatter(x_data, y_data, MarkerFaceColor='Red')

hold on
plot(x, y, LineStyle="-", LineWidth=2, Color='black')
hold off

grid on
legend('Data Points', 'Regression Line')
text(12, 7.0e-5, ['y = ( -0.0922x + 1.685 ) * 10^{-4}'], 'FontSize', 14)
xlabel('Concentration % (w/w)')
ylabel('Settling velocity')
title('U_p vs Conc')
% saveas(gcf, 'up_conc_exp_2b.png')

%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%

c = 0.05; % in fraction
H = 0.9; % in m

h1 = [84, 84, 84, 89] ./ 100; % in m
h2 = [65, 63, 65, 68] ./100; % in m

eps1 = 1 - ( (H ./ h1) ./ ( (((1 - c) ./ c).*(rho_s ./ rho_w)) + 1)); % dimensionless 
eps2 = 1 - ( (H ./ h2) ./ ( (((1 - c) ./ c).*(rho_s ./ rho_w)) + 1)); % dimensionless 

u_t_conc = g .* (Dp.^2) .* (rho_s - rho_w) ./ (18 .* mu);

n1 = (log(u_p_dia) - log(u_t_conc)) ./ (log(eps1));
n2 = (log(u_p_dia) - log(u_t_conc)) ./ (log(eps2));
n = (n1 + n2) ./ 2;

% fprintf('\n')
% fprintf('Value of n at D_p = 15 : \n')
% disp(n)

N_re = rho_w .* Dp .* u_p_dia ./ mu;
% fprintf('\n')
% fprintf('Value of N_re : \n')
% disp(N_re)

%-------------------------------------------------------------------------%

% error

u_p_th_1 = u_t_conc .* (eps1.^4.5);
u_p_th_2 = u_t_conc .* (eps2.^4.5);
u_p_th = (u_p_th_1 + u_p_th_2)./2;

err = abs(u_p_th - u_p_dia) ./ u_p_th;

% fprintf('\n')
% fprintf('Value of obs u_p : \n')
% disp(u_p_dia .* 100)
% fprintf('\n')
% fprintf('Value of theoretical u_p : \n')
% disp(u_p_th .* 100)
% fprintf('Value of error : \n')
% disp(err)

%-------------------------------------------------------------------------%

eps = (eps1 + eps2)./2;
% fprintf('Eps values at n=4.5 : \n')
% disp(eps)

u_t_values = u_p_dia .* (eps.^(-4.5));
% fprintf('u_t (cm/s) values at n=4.5 : \n')
% disp(u_t_values .* 100)

Dp_guess = ((u_t_values .* 18 .* mu) ./ (g .* (rho_s - rho_w))) .^ 0.5;
% fprintf('Dp (um) guess values at n=4.5 : \n')
% disp(Dp_guess .* (10^6))

%-------------------------------------------------------------------------%
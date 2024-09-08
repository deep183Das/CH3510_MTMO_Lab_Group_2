% EXP 3B
% MTMO LAB - Group 2
% Aayush Bhakna Ch22b008

% Packed Bed | Ceramic Berl Saddle
% Assuming Laminar + Turbulent (Ergen's equation)
% Del_p or Phi_s are unknown

clear all;
clc;

%-------------------------------------------------------------------------%

% VARIABLE INITIALIZATION

Np = 12; % no of paricles taken

Mp = 11.1; % in grams
Mp = Mp / 1000; % in kg

Vp = 5; % in mL
Vp = Vp * (10^-6); % in m^3

rho_p = Mp/Vp; % in kg/m^3
Vp_1 = Mp/(Np*rho_p); % Volume of 1 burl saddle in m^3

g = 9.81; % in m^2/s

% effective diameter of berl saddle
Dp = (6*Vp_1/pi)^(1/3); % in m

% sphericity of burl saddle
d_th = 0.5; % thickness of burl saddle in mm
A_per_V = 2/(d_th/1000); % in m^-1
phi_s = (6/Dp)/(A_per_V);

% volume of voids in column
V_void = 3780; % in mL
V_void = V_void * (10^-6); % in m^3

% diameter of column
D = 73; % in mm
D = D / 1000; % in m

% cross-section area of column
A = (pi/4)*(D^2); % in m^2

% height of column
H = 64.5 + 61.4; % in cm
H = H / 100; % in m

% volume of column
V_bed = A*H; % in m^3

% porosity
eps = V_void / V_bed;

% pressure drop
p1 = [10.1, 13, 16.1, 19.6, 22, 25.2, 28, 25, 22, 19, 16, 13, 11, 8.5]; % in cm CCl4
p2 = [5, 2.1, -1.3, -4.7, -7, -10.3, -13.2, -10.2, -7.2, -4.1, -1.2, 1.7, 3.8, 6.2]; % in cm CCl4
del_p = (p1 - p2)./100; % in meter CCl4

rho_CCl4 = 1590; % in kg/m^3
del_p = rho_CCl4 .* g .* del_p; % in Pa

% volumetric flow rate
del_V = [660, 820, 740, 960, 720, 680, 760, 540, 680, 760, 700, 700, 560, 440]; % in mL
del_t = [9.81, 7.59, 5.74, 5.81, 3.86, 3.28, 3.38, 2.55, 3.38, 4.74, 5.12, 6.10, 6.77, 11.13]; % in sec

Q = del_V ./ del_t; % in mL/s
Q = Q .* (10^-6); % in m^3/s

% superficial velocity
v_sf = Q ./ A; % in m/s

% fluid parameters
rho_f = 995.7; % in kg/m^3
nu = 0.7972 * (10^-3); % in Pa*s

%-------------------------------------------------------------------------%

% CALCULATING THEORETICAL DEL_P

n = length(del_p);
th_del_p_0 = 0; % initial guess
th_del_p = zeros(1, n);
for i = 1:n
    options = optimoptions('fsolve', 'Display', 'none', 'Algorithm', 'levenberg-marquardt');
    th_del_p(i) = fsolve(@(th_del_p) ergen(th_del_p, H, v_sf(i), nu, rho_f, eps, phi_s, Dp), th_del_p_0, options);
end

% percent error in del_p
err_del_p = abs((th_del_p - del_p)./th_del_p) .* 100;

% plotting graph
figure(1)
plot(v_sf(1:7), del_p(1:7), 'o-', Color="Blue", LineWidth=1.5)
hold on
plot(v_sf(7:end), del_p(7:end), 'o-', Color="Cyan", LineWidth=1.5)
plot(v_sf, th_del_p, 'o-', Color="Red", LineWidth=1.5)
hold off
grid on
legend('Exp P drop (forward)', 'Exp P drop (backward)', 'Theoretical pressure drop', Location='southeast')
xlabel('Superficial velocity (m/s)')
ylabel('Pressure Drop (Pa)')
title('Pressure Drop in Water + Berl Saddles')
% saveas(gcf, "right_pressure_vsf.png")

%-------------------------------------------------------------------------%

% CALCULATING PHI_S

exp_phi_s_0 = 1; % initial guess
exp_phi_s = zeros(1, n);
for i = 1:n
    options = optimoptions('fsolve', 'Display', 'none', 'Algorithm', 'levenberg-marquardt');
    exp_phi_s(i) = fsolve(@(exp_phi_s) ergen(del_p(i), H, v_sf(i), nu, rho_f, eps, exp_phi_s, Dp), exp_phi_s_0, options);
end

% mean value of phi_s
mean_phi_s = mean(exp_phi_s, "all");

% percent error in phi_s
err_phi_s = abs((mean_phi_s - phi_s)./mean_phi_s) .* 100;

% plotting graph
figure(2)
scatter(1:n, exp_phi_s, 30, "red", "filled")
hold on
plot(0:n+1, mean_phi_s.*ones(1, n+2), Color="Black", LineWidth=2)
hold off
grid on
legend('Data points', 'Mean Value', Location='southeast')
xlabel('Iterations')
ylabel('Sphericity')
title('Calculated Sphericity of Berl Saddle')
% saveas(gcf, "right_phi_s.png")

%-------------------------------------------------------------------------%

% FINAL RESULTS

fprintf('\n')
fprintf('RIGHT COLUMN : BERL SADDLES\n')
fprintf('\n')
fprintf('Column Height = %0.4f meters\n', H)
fprintf('Column Diameter = %0.4f meters\n', D)
fprintf('Column Area (cross-section) = %0.6f m^2\n', A)
fprintf('Column Volume = %0.6f m^3\n', V_bed)
fprintf('\n')
fprintf('Volume of void in column = %0.6f m^3\n', V_void)
fprintf('Porosity = %0.4f\n', eps)
fprintf('\n')
fprintf('Density of packing material = %0.2f kg/m^3\n', rho_p)
fprintf('Dp = %0.6f m\n', Dp)
fprintf('Sphericity = %0.4f\n', phi_s)
fprintf('\n')

%-------------------------------------------------------------------------%

% LOCAL FUNCTION

function f = ergen(del_p, H, v_sf, nu, rho_f, eps, phi_s, Dp)

laminar = 150*nu*((1-eps)^2)/((phi_s^2)*(Dp^2)*(eps^3));
turbulent = 1.75*rho_f*(1-eps)/(phi_s*Dp*(eps^3));

f = (laminar * v_sf) + (turbulent * (v_sf^2)) - (del_p / H);

end

%-------------------------------------------------------------------------%
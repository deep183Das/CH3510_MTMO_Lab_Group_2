% Exp-6 : Multiphase Gas Absorption
% Deepanjhan Das [CH22B020]

% Calculation File
clear; close all;
format long;


%% known data values (theoretical and given)
mw_g = 44/1000;     % kg/mol
mw_l = 18/1000;     % kg/mol 

% henry's constant 
H = 0.186*(10^(-4));    % in (atm/mol-fraction)
% column ID in both cases
col_ID = 6/1000;        % in (m)
% packing weight
berl_w = 0.695;         % kg
pall_w = 0.290;         % kg
% packing height
berl_h = 0.61;          % m
pall_h = 0.55;          % m
% density of packing materials (theoretical values)
% berl_rho = 2350;         % kg/m^3 (ceramic)
% pall_rho = 7500;         % kg/m^3 (assuming steinless steel)

% concentration of NAOH (N)
c_NAOH = 1/10;

% time range (t) in minutes
t1 = [30, 20, 10];
t2 = [10, 20, 30];


%% loading the data and extracting the required information
load data;

% L and G values are in LPH (L per Hour)
L_berl = berl_saddle(:,1);
G_berl = berl_saddle(:,2);

L_pall = pall_ring(:,1);
G_pall = pall_ring(:,2);

% -- find the P values from the literature curve using x-y coordinates --%
[x_berl, y_berl] = xy_cord(L_berl, G_berl, 'berl');
[x_pall, y_pall] = xy_cord(L_pall, G_pall, 'pall');

% then manually write the P values
P_berl = ones(size(x_berl, 1), 1)*0.05;
P_pall = ones(size(x_pall, 1), 1)*0.05;
% in this range of P value and at 30 deg C saturation concentration of CO2:
c_co2_saturation = 0.03;        % mol / L

% volume of NaOH required for titration
vol_NAOH_berl = berl_saddle(:,5)./1000; % L 
vol_NAOH_pall = pall_ring(:,5)./1000;   % L

% after titration, total volume of mixture
vol_tol_berl = vol_NAOH_berl + berl_saddle(:,6)./1000;
vol_tol_pall = vol_NAOH_pall + pall_ring(:,6)./1000;

% concentration of CO2 dissolved in water (mol/L)
c_co2_berl = (c_NAOH .* vol_NAOH_berl) ./ vol_tol_berl;     
c_co2_pall = (c_NAOH .* vol_NAOH_pall) ./ vol_tol_pall;


%% Calculation of packing fraction
% vol_effective_berl = berl_w / berl_rho; % (m^3)
% vol_effective_pall = pall_w / pall_rho; % (m^3)
% col_vol_berl = berl_h * (pi * (col_ID/2)^2);
% col_vol_pall = pall_h * (pi * (col_ID/2)^2);

% packing_fraction_berl = vol_effective_berl / col_vol_berl;
% packing_fraction_pall = vol_effective_pall / col_vol_pall;

% V_liq_berl = (1-packing_fraction_berl)*col_vol_berl;
% V_liq_pall = (1-packing_fraction_pall)*col_vol_pall;


%% Theoretical values of a (surface area property) for 1 inch of each 
a_berl = 249.344832;        % m^2/m^3
a_pall = 206.6929134;       % m^2/m^3


%% Now plotting the values and generating a fitting line
y_val_berl = log((c_co2_saturation - c_co2_berl)./c_co2_saturation);
y_val_pall = log((c_co2_saturation - c_co2_pall)./c_co2_saturation);


% Regression (OLS)
[alpha1_berl, beta1_berl] = ols_func(t1, y_val_berl(1:3));
[alpha2_berl, beta2_berl] = ols_func(t1, y_val_berl(4:6));
[alpha1_pall, beta1_pall] = ols_func(t2, y_val_pall(1:3));
[alpha2_pall, beta2_pall] = ols_func(t2, y_val_pall(4:6));

k_l_berl = -(alpha1_berl + alpha2_berl)/(2*a_berl);
k_l_pall = -(alpha1_pall + alpha2_pall)/(2*a_pall);
% display results
disp(k_l_berl);
disp(k_l_pall);

figure();
hold on;
% 10 LPH
scatter(t1, y_val_berl(1:3), 45, "filled");
plot(t1, (alpha1_berl.*t1 + beta1_berl));
% 15 LPH
scatter(t1, y_val_berl(4:6), 25, "filled");
plot(t1, (alpha2_berl.*t1 + beta2_berl));
grid on;
legend('Data(10LPH)', 'Best Fit Line (10LPH)',  'Data(15LPH)', 'Best Fit Line (15LPH)', Location='best');
xlabel('t (minutes)');
ylabel('ln((C_{sat} - C)/(C_{sat} - C_0))');
title('Results for Berl Saddle as packing materials');
% saveas(gcf, 'berl.png');
hold off;

figure();
hold on;
% 10 LPH
scatter(t2, y_val_pall(1:3), "filled");
plot(t2, (alpha1_pall.*t2 + beta1_pall));
% 15 LPH
scatter(t2, y_val_pall(4:6), "filled");
plot(t2, (alpha2_pall.*t2 + beta2_pall));
grid on;
legend('Data(10LPH)', 'Best Fit Line (10LPH)',  'Data(15LPH)', 'Best Fit Line (15LPH)', Location='best');
xlabel('t (minutes)');
ylabel('ln((C_{sat} - C)/(C_{sat} - C_0))');
title('Results for Pall Rings as packing materials');
% saveas(gcf, 'pall.png');
hold off;


%% Function to calculate the x and y coordinates for different L and G
%  where L and G are liquid and gas flow rates respectively.
function [x, y] = xy_cord(L, G, type)
    % L (liquid: water) and G (gas: CO2) are in LPH
    % The following methods are followed as per the theoretical plot,
    % which is in english system and hence all the units are converted

    rho_g = 1.98;       % kg/m^3
    rho_l = 996;        % kg/m^3

    % conversion factors
    kg_to_lb = 2.204622476;
    m_to_ft = 1250/381;
    m3_to_L = 1000;   

    mu_l = 0.0008;      % viscosity of water at 30C (kg/m.s)
    nu_l = mu_l/rho_l;  % kinematic viscosity of water (m^2/s)
    nu_l_cst = (10^4)*nu_l*(10^2);
    
    D = 6/1000;     % inner diameter of the column (m)
    
    % considering each of the packing material to be of 1 in size
    % the following are the standard theoretical values
    if strcmp(type, 'berl')
        F = 110;
    elseif strcmp(type, 'pall')
        F = 56;
    end

    % mass flux rate
    G_dash = ((G.*(rho_g./m3_to_L).*kg_to_lb)./3600)./(pi.*(D.*m_to_ft./2).^2);

    % x coordinate
    x = (L./G).*((rho_g./rho_l).^0.5);
    % y coordinate
    y = (G_dash .* (F.^0.5) .* (nu_l_cst.^0.05))./((rho_g.*(rho_l - rho_g).*((kg_to_lb./(m_to_ft^3)).^2)).^0.5);
end

%% Function to obtain the parameters of the regression line
function [alpha, beta] = ols_func(x, y)
    % N = length(x);
    covxy = cov(x,y,1);

    meanx = mean(x);
    meany = mean(y);

    % The slope term
    alpha = covxy(1,2)/covxy(1,1);

    % The off-set term
    beta = meany - alpha*meanx;
end
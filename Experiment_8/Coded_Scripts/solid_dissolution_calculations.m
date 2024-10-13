%% Solid Dissolution Calculations
%  Deepanjhan Das [CH22B020]
clear; close all;
format long;

%% Dataset (cases 1, 2, 3)

D = [30.15, 21.70, 22.20] ./ 1000;      % diameter(m)
H = [60.54, 52.05, 55.34] ./ 1000;      % height(m)

V_water_batch = 2400 ./ 1000;           % in L

L_to_m3 = 0.001;

T = [50, 60, 60] + 273.15;              % temperature (K)
rho_water = [0.98802, 0.98313, 0.98313];% density of water @ 50, 60, 60 deg C

% volume of benzoic acid used (each cases in each column)
V_ba = [5.8, 5.0, 5.0;
        4.8, 5.0, 5.0;
        5.0, 5.0, 5.2;
        5.0, 5.0, 5.0;
        5.0, 5.0, 5.2];
% volume of NaOH used for titration (each cases in each column)
V_naoh = [1.7, 2.4, 0.8;
          2.4, 4.4, 2.2;
          2.8, 5.3, 2.4;
          3.7, 6.3, 2.7;
          4.0, 7.1, 2.9];
% normality of NaOH = molarity of NaOH (N_NaOH = C_NaOH)
N_naoh = 0.05;


%% Solubility in molality form of benzoic acid in water at the above temp 
Molal_solubility_ba = [0.07705, 0.0976, 0.0976];    % (mol / kg of solvent)
% the solubility value of benzoic acid in molar format (mol / L)
C_solubility_ba = Molal_solubility_ba .* rho_water;


%% *a* value in all the three cases (m^-1)
a = (2*pi*(D./2).*H) ./ (V_water_batch * L_to_m3);


%% Computation of C values using the formula : N1*V1 = N2*V2

% since the n-factor for benzoic acis is 0.5, so M = N/0.5 = 2*N
N_benzoic_acid = (N_naoh .* V_naoh) ./ (V_ba);
C_benzoic_acid = 2.*N_benzoic_acid;         % molarity (mol / L)

t = linspace(5, 25, 5);     % time in minutes
y1 = log(abs(C_solubility_ba(1) - C_benzoic_acid(:,1))./C_benzoic_acid(1))';
% C_benzoic_acid(:,2) = [C_benzoic_acid(1,2); C_benzoic_acid(5,2); ...
    % C_benzoic_acid(4,2); C_benzoic_acid(3,2); C_benzoic_acid(2,2)];
y2 = log(abs(C_solubility_ba(2) - C_benzoic_acid(:,2))./C_benzoic_acid(2))';
y3 = log(abs(C_solubility_ba(3) - C_benzoic_acid(:,3))./C_benzoic_acid(3))';

% obtaining the solpe and bias terms of the best fit lines
[alpha1, beta1] = ols_func(t, y1);
[alpha2, beta2] = ols_func(t, y2);
[alpha3, beta3] = ols_func(t, y3);


%% Plotting the results
% case 1
figure();
hold on;
scatter(t, y1, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
x1 = linspace(min(t), max(t), 201);
plot(x1, (beta1 + alpha1*x1), 'r-', LineWidth=1.1);
grid on;
legend('Data at 50^o C', 'Best Fit Line', Location='best');
xlabel('Time (minutes)');
ylabel('ln[(C* - C)/(C*)]');
% saveas(gcf, 'case_1.png');
hold off;

% case 2
figure();
hold on;
scatter(t, y2, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
x2 = linspace(min(t), max(t), 201);
plot(x2, (beta2 + alpha2*x2), 'r-', LineWidth=1.1);
grid on;
legend('Data at 60^o C, 900 RPM', 'Best Fit Line', Location='best')
xlabel('Time (minutes)');
ylabel('ln[(C* - C)/(C*)]');
% saveas(gcf, 'case_2.png');
hold off;

% case 3
figure();
hold on;
scatter(t, y3, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
x3 = linspace(min(t), max(t), 201);
plot(x3, (beta3 + alpha3*x3), 'r-', LineWidth=1.1);
grid on;
legend('Data at 60^o C, 400 RPM', 'Best Fit Line', Location='best');
xlabel('Time (minutes)');
ylabel('ln[(C* - C)/(C*)]');
% saveas(gcf, 'case_3.png');
hold off;


%% Display the results
k1 = -alpha1*a(1);
k2 = -alpha2*a(2);
k3 = -alpha3*a(3);
fprintf('\nThe mass transfer coefficient values are:\n');
fprintf('k1 = %.10f\n', k1);
fprintf('k2 = %.10f\n', k2);
fprintf('k3 = %.10f\n', k3);


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
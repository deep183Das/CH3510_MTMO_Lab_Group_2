%% Flow through micro-channels | Exp - 1
%  Deepanjhan Das 
clear; close all;
format long;


%% Data
L = 20 / 100;       % m
L_long = 65 / 100;  % m
D = 1 / 1000;       % m

% mL/h = 10^-6 / 3600  m^3 / s
Q_alpha = (1/(10^6 * 3600)) .* [4.0, 3.0, 2.5, 4.0, 10.0, 30.0, 20.0, 25.0];
Q_beta = (1/(10^6 * 3600)) .* [4.0, 3.0, 4.0, 2.5, 10.0, 20.0, 30.0, 45.0];

V = pi * (D/2)^2 * L;           % m^3
V_long = pi * (D/2)^2 * L_long; % m^3


%% Residence Time

Tau_alpha = V ./ Q_alpha;
Tau_beta = V ./ Q_beta;
Tau_alpha_beta = V_long ./ (Q_alpha + Q_beta);


%% The fields of phas flow characteristics

figure();
hold on;
scatter(Q_alpha(1:4), Q_beta(1:4), 'r+');
scatter(Q_alpha(5:8), Q_beta(5:8), 'bo', 'filled');

grid on;
title("Ranges of Flow Characteristics");
xlabel("Q_{alpha} (mL/hr)");
ylabel("Q_{beta} (mL/hr)");
legend("Slug", "Stratified", Location="best");
saveas(gcf, "flow_char.png");
hold off;
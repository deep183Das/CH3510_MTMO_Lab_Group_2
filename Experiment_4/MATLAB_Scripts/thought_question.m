% EXP - 4
% THOUGHT QUESTION

% MTMO Group - 2
% Aayush Bhakna
% Ch22b008

clear all;
clc;

%-------------------------------------------------------------------------%

% CENTRIFUGAL PUMP

% Volumetric flow rate = Vf = L/hr
% Pressure Drop = del_p = psi

Vf = [2700, 2790, 2919, 3039, 3276, 3396, 3513, 3626, ...
    3752, 3877, 4000, 4128, 4240, 4355, 4472, 4609, 4762, 4850];

del_p = [0, 1.4, 1.5, 1.6, 1.8, 1.9, 2.0, 2.2, 2.3, 2.4, ...
    2.5, 2.7, 2.8, 2.8, 3.0, 3.1, 3.5, 3.6];

% Changing L/hr to L/min
Vf = Vf ./ 60;

% Range of this pump (L/min) = 45 to 80.83

% plotting graph
figure(1)
x = Vf(2:end);
y = del_p(2:end);
plot(x, y, 'o-', Color="Red", LineWidth=1.5)
grid on
ylabel('Pressure Drop due to Pump (psi)')
xlabel('Volumetric Flow Rate in Outlet (L/min)')

% Linear Regression
X = ones(17, 2);
X(:, 2) = x;
Y = y';
W = inv((X') * X) * (X') * Y;

% Value of del_p at 10 L/min
Del_p_10 = W(1) + ( W(2) * 10 ); % in psi

%-------------------------------------------------------------------------%


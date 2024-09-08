% EXP - 4
% VALVE CHARACTERISTICS

% MTMO Group - 2
% Aayush Bhakna
% Ch22b008

clear all;
clc;

%-------------------------------------------------------------------------%

% ALL DATA

% Row 1 -> Needle Valve
% Row 2 -> Globe Valve
% Row 3 -> Gate Valve
% Row 4 -> Ball Valve

rowName = ["Needle Valve"; "Globe Valve"; "Gate Valve"; "Ball Valve"];

open_percent = zeros(4, 4);
open_percent(1, :) = [22.22, 50, 77.78, 100];
open_percent(2, :) = [14.29, 42.86, 71.43, 100];
open_percent(3, :) = [25, 50, 75, 100];
open_percent(4, :) = [25, 50, 75, 100];

V = zeros(4, 4); % L
V(1, :) = [1.020, 1.060, 1.060, 1.020];
V(2, :) = [10, 10, 10, 10];
V(3, :) = [10, 10, 9.1, 10];
V(4, :) = [10, 10, 10, 9.1];

T = zeros(4, 4); % sec
T(1, :) = [34.19, 28.66, 26.40, 29.28];
T(2, :) = [35.70, 24.61, 21.43, 20.25];
T(3, :) = [13.17, 5.47, 4.44, 4.46];
T(4, :) = [27.92, 10.06, 4.88, 3.66];

Vf = V ./ T; % L/s
max_Vf_row = max(Vf, [], 2);
percent_Vf = (Vf ./ max_Vf_row) .* 100;

del_p = zeros(4, 4); % psi
del_p(1, :) = [8.8, 8.8, 8.8, 10.2];
del_p(2, :) = [11.7, 9.2, 9.2, 9.2];
del_p(3, :) = [11.5, 6.0, 1.9, 0.9];
del_p(4, :) = [11.2, 7.9, 2.6, 0.0];

%-------------------------------------------------------------------------%

% PLOTTING

figure(1)
plot(open_percent(1, :), percent_Vf(1, :), 'o-', LineWidth=1.5)
hold on
plot(open_percent(2, :), percent_Vf(2, :), 'o-', LineWidth=1.5)
plot(open_percent(3, :), percent_Vf(3, :), 'o-', LineWidth=1.5)
plot(open_percent(4, :), percent_Vf(4, :), 'o-', LineWidth=1.5)
hold off
grid on
legend('Needle Valve', 'Globe Valve', 'Gate Valve', 'Ball Valve', Location='best')
xlabel('Percentage of Valve opened')
ylabel('Percentage of Volumetric Flow Rate')
title('Valve Opened vs Flow Rate')

for i = 1:4

x = Vf(i, :);
y = del_p(i, :);
figure(i+1)
plot(x, y, 'o-', 'color', 0.5.*(rand(1,3)), LineWidth=2)
axis([min(x, [], "all")-(0.005*i^2), max(x, [], "all")+(0.005*i^2), ...
    min(y, [], "all")-1, max(y, [], "all")+1])
grid on
xlabel('Volumetric Flow Rate (L/s)')
ylabel('Pressure Drop (psi)')
title(rowName(i))

end

figure(6)
plot3(open_percent(1, :), percent_Vf(1, :), del_p(1, :), 'o-', LineWidth=1.5)
hold on
plot3(open_percent(2, :), percent_Vf(2, :), del_p(2, :), 'o-', LineWidth=1.5)
plot3(open_percent(3, :), percent_Vf(3, :), del_p(3, :), 'o-', LineWidth=1.5)
plot3(open_percent(4, :), percent_Vf(4, :), del_p(4, :), 'o-', LineWidth=1.5)
hold off
grid on
legend('Needle Valve', 'Globe Valve', 'Gate Valve', 'Ball Valve', Location='best')
xlabel('Percentage of Valve opened')
ylabel('Percentage of Volumetric Flow Rate')
zlabel('Pressure Drop (psi)')
title('Master Plot of all data')







ut_avg = csvread('ut_avg_data.csv');
ut_avg = ut_avg(2:end, 2:end);

ut_avg(5, 2) = 0.754 / 1.14201; % in m/s

m_p = [0.985, 0.6025, 2.1125, 5.115, 11.425]'; % in grams
D_p = [6.28, 7.59, 10.275, 15.49, 20.12]'; % in mm

m_p = m_p ./ 1000; % in kg
D_p = D_p ./ 1000; % in meters

A_p = (pi/4).*(D_p.^2); % in m^2
V_p = (pi/6).*(D_p.^3); % in m^3
rho_p = m_p ./ V_p; % in kg/m^3

% Liquid -> 0, 50, 75, 100 GL
rho = [995.67, 1120.8, 1188.2, 1260.0]; % in kg/m^3
mu = [0.0007972, 0.004203, 0.021471, 0.6468]; % in Pa*s

g = 9.81; % in SI units

C_d = zeros(5, 4);
N_re = zeros(5, 4);
F_d = zeros(5, 4);

for i = 1:5
    for j = 1:4
        C_d(i, j) = (2.*g).*m_p(i).*((1./rho(j)) - (1./rho_p(i)))./(A_p(i).*(ut_avg(i, j).^2));
        N_re(i, j) = (rho(j)/mu(j)).*D_p(i).*ut_avg(i, j);
        F_d(i, j) = C_d(i, j).*A_p(i).*rho(j).*(ut_avg(i, j).^2)./2;
    end
end

% disp(C_d.*N_re)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stokes regime

ut_s = zeros(5, 4);
C_d_s = zeros(5, 4);
N_re_s = zeros(5, 4);

for i = 1:5
    for j = 1:4
        ut_s(i, j) = g*(D_p(i)^2)*(rho_p(i) - rho(j))/(18*mu(j));
        C_d_s(i, j) = (2.*g).*m_p(i).*((1./rho(j)) - (1./rho_p(i)))./(A_p(i).*(ut_s(i, j).^2));
        N_re_s(i, j) = (rho(j)/mu(j)).*D_p(i).*ut_s(i, j);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Newtons regime

ut_n = zeros(5, 4);
C_d_n = zeros(5, 4);
N_re_n = zeros(5, 4);

for i = 1:5
    for j = 1:4
        ut_n(i, j) = 1.75*((g*D_p(i)*(rho_p(i) - rho(j))/rho(j))^0.5);
        C_d_n(i, j) = (2.*g).*m_p(i).*((1./rho(j)) - (1./rho_p(i)))./(A_p(i).*(ut_n(i, j).^2));
        N_re_n(i, j) = (rho(j)/mu(j)).*D_p(i).*ut_n(i, j);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Graphing plots

x_s = N_re(:, 4);
y_s = C_d(:, 4);
Sxx = sum((x_s - mean(x_s, "all")).^2, "all");
Sxy = sum((x_s - mean(x_s, "all")).*(y_s - mean(y_s, "all")), "all");
m_s = Sxy / Sxx;
c_s = mean(y_s, "all") - (m_s * mean(x_s, "all"));

x_n = zeros(15, 1);
y_n = zeros(15, 1);

for i = 1:3
    x_n((5*(i-1))+1:(5*(i-1))+5) = N_re(:, i);
    y_n((5*(i-1))+1:(5*(i-1))+5) = C_d(:, i);
end

% Sxx = sum((x_n - mean(x_n, "all")).^2, "all");
% Sxy = sum((x_n - mean(x_n, "all")).*(y_n - mean(y_n, "all")), "all");
% m_n = Sxy / Sxx;
m_n = 0;
c_n = mean(y_n, "all") - (m_n * mean(x_n, "all"));

x = linspace(min(x_s, [], "all")-2, max(x_s, [], "all")+2, 100);
y = m_s.*x + c_s;

figure(1)
scatter(x_s, y_s, MarkerFaceColor='red')
hold on
plot(x, y, '-', Color='black', LineWidth=2)
hold off
grid("on")
legend('100% GL', 'Regressed Line')
text(2.5, 30, ['y = -5.8377x + 39.7291'], 'FontSize', 12)
xlabel("Reynold's number")
ylabel("Drag Coefficient")
title("STOKES REGIME")
% saveas(gcf,'stokes_data.png')

x = linspace(0, max(x_n, [], "all")+100, 100);
y = m_n.*x + c_n;

figure(2)
scatter(N_re(:, 1), C_d(:, 1), MarkerFaceColor='red')
hold on
scatter(N_re(:, 2), C_d(:, 2), MarkerFaceColor='blue') 
scatter(N_re(:, 3), C_d(:, 3), MarkerFaceColor='green')
plot(x, y, '-', Color='black', LineWidth=2)
hold off
grid("on")
legend('0% GL', '50% GL', '75% GL', 'Regressed Line')
text(6000, 0.75, ['y = 0.0001x + 0.7950'], 'FontSize', 12)
xlabel("Reynold's number")
ylabel("Drag Coefficient")
title("NEWTON REGIME")
% saveas(gcf,'newtons_data.png')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Irregular Points

m_p = [2.042, 3.511, 1.946, 3.944]';
D_p = [14.4, 18.25, 15.9, 18.2]';

m_p = m_p ./ 1000; % in kg
D_p = D_p ./ 1000; % in meters

A_p = (pi/4).*(D_p.^2); % in m^2
V_p_1 = (pi/6).*(D_p.^3); % in m^3
V_p_2 = [2, 3, 1, 3]'; % in mL
V_p_2 = V_p_2 * 10^-6;
V_p = (V_p_2 + V_p_1)./2;
rho_p = m_p ./ V_p; % in kg/m^3

g = 9.81; % in SI units

C_d_irr = zeros(1, 4);
N_re_irr = zeros(1, 4);
F_d_irr = zeros(1, 4);

for j = 1:4
    C_d_irr(j) = (2.*g).*m_p(j).*((1./rho(j)) - (1./rho_p(j)))./(A_p(j).*(ut_avg(6, j).^2));
    N_re_irr(j) = (rho(j)/mu(j)).*D_p(j).*ut_avg(6, j);
    F_d_irr(j) = C_d(j).*A_p(j).*rho(j).*(ut_avg(6, j).^2)./2;
end

figure(3)
scatter(N_re_irr, C_d_irr, MarkerFaceColor='blue')
grid("on")
xlabel("Reynold's number")
ylabel("Drag Coefficient")
title("IRREGULAR PARTICLES")
% saveas(gcf,'irregular_data.png')
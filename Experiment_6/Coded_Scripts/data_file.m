% Exp-6 : Multiphase Gas Absorption
% Deepanjhan Das [CH22B020]

% Data Files Generation
clear; close all;
format long;


%-------------------------------------------------------------------------%
% berl saddle data
berl_saddle = [
        10.0, 5.0, 14.0, 15.7, 1.7, 25.0;
        10.0, 10.0, 15.7, 17.2, 1.5, 25.0;
        10.0, 15.0, 17.2, 18.5, 1.3, 25.0;
        15.0, 5.0, 18.5, 20.2, 1.7, 25.0;
        15.0, 10.0, 20.2, 21.6, 1.4, 25.0;
        15.0, 15.0, 21.6, 22.9, 1.3, 25.0
    ];
writeCSV(berl_saddle, 'berl_saddle_data.csv');

% metallic pall ring data
pall_ring = [
        10.0, 5.0, 22.9, 23.7, 0.8, 25.0;
        10.0, 10.0, 23.9, 25.0, 1.1, 25.0;
        10.0, 15.0, 25.0, 26.0, 1.0, 25.0;
        15.0, 5.0, 26.0, 26.4, 0.4, 24.0;
        15.0, 10.0, 26.4, 27.0, 0.6, 25.0;
        15.0, 15.0, 27.0, 28.0, 1.0, 25.0
    ];
writeCSV(pall_ring, 'pall_ring_data.csv');


%% To Create CSV Files
function writeCSV(M, file_name)
    T = array2table(M);
    T.Properties.VariableNames(1:6) = {'Q_W (LPH)', 'Q_CO2(LPH)', ...
    'V1 (mL)', 'V2 (mL)', 'del_V (mL)', 'VM (mL)'};
    
    writetable(T, file_name);
end
%% Init
clear;
clc;
close all;
set(0,'DefaultLineLineWidth',1.5)
set(0,'DefaultAxesFontSize', 14);
global printPlots
printPlots = true;

%% Load
% CHAMP satellite magnetic field observations (Earth's main field removed)
% 06-Nov-2001 07:55:28 UT to 08:08:30 UT
% dipole     vertical northward component     
% latitude   d.B_z     d.B_x
% [deg]      [nT]     [nT]
data = load('CHAMP_satellite_dB.txt');

lat = data(:,1);            % Seperation of data
d.B_z = data(:,2);          % into the used values
d.B_x = data(:,3);          % for ease of use.

clear data;                 % Removal of unnecessary data

% Plot the observed data
figure;
hold on;
plot(lat,d.B_z);
plot(lat,d.B_x);
grid on;
xlabel('Latitude [deg]');
ylabel('Magnetic intensity [nT]');
legend('B_z','B_x');
save2eps('fig\observedData');

%% Model
% Line currents
x_I = 40:1:85;              % [deg] lat
h = 3;                      % [deg] = 333 km

% Model size
N = length(d.B_z);
M = length(x_I);

% Permability term with corrected for units
perm = 200 / 111;                 %[nT km/(deg kA)]

% Generation of G matrices
G.B_z = zeros(N,M);         % Empty matrices to optimize script
G.B_x = zeros(N,M);
for i = 1:N
    for j = 1:M
        x = ((lat(i) - x_I(j)));        % The distance to line currents from current location
        G.B_z(i,j) = perm * x/(x^2+h^2); % G matrix for B_z
        G.B_x(i,j) = perm * h/(x^2+h^2); % G matrix for B_x
    end
end
clear x i j;                    % Garbage collection

% Define alpha
alpha = 10.^(-30:0.1:1);

%% Model based on B_z
% Tikhonov regularisation
[rms.z, m_norm.z, m_ls.z] = tikhonovRegularisation(G.B_z, d.B_z,N, M, alpha);

% L-curve plot B_z
LCurve(rms.z, m_norm.z, alpha, [275, 290, 296, 305, 310]);
save2eps('fig\LCurveBz');

% Best alpha value from L-curve for B_z model
alpha_bestIndex.z = 296;

% Model covariance / correation
[C_m.z, rho_m.z] = covarianceCorrelation(G.B_z, d.B_z);

% Plot correlation
plotCovCorr(rho_m.z);
save2eps('fig\corZ');

% Model plotted against observed data
plotModel(lat, d.B_z, d.B_x, G.B_z, G.B_x, m_ls.z(:,alpha_bestIndex.z));
save2eps('fig\BzModel');

% Plot modeled line currents
plotLC(x_I, m_ls.z, alpha_bestIndex.z);
save2eps('fig/LCz');

%% B_z currents for B_x
dBx_model = G.B_x * m_ls.z(:,alpha_bestIndex.z);
r_x = d.B_x - dBx_model;
rms_xBestAlpha = sqrt(r_x'*r_x);

%% B_x model
% Tikhonov regularisation
[rms.x, m_norm.x, m_ls.x] = tikhonovRegularisation(G.B_x, d.B_x, N, M, alpha);

% L-curve plot B_x
LCurve(rms.x, m_norm.x, alpha, [275, 290, 298, 305, 310]);
save2eps('fig\LCurveBx');

% Best alpha value from L-curve for B_x model
alpha_bestIndex.x = 296;

% Model covariance / correation
[C_m.x, rho_m.x] = covarianceCorrelation(G.B_x, d.B_x);

% Plot correlation
plotCovCorr(rho_m.x);
save2eps('fig\corX');

% Model plotted against observed data
plotModel(lat, d.B_z, d.B_x, G.B_z, G.B_x, m_ls.x(:,alpha_bestIndex.x));
save2eps('fig\BxModel');

% Plot modeled line currents
plotLC(x_I, m_ls.x, alpha_bestIndex.x);
save2eps('fig/LCx');

%% Joint model
% Joining matrices for joint model analysis
d.B_j = [d.B_z; d.B_x];        % Vertical concatenation
G.B_j = [G.B_z; G.B_x];        % new row number is 2N

% Tikhonov regularisation
[rms.j, m_norm.j, m_ls.j] = tikhonovRegularisation(G.B_j, d.B_j, 2*N, M, alpha);

% L-curve plot B_z
LCurve(rms.j, m_norm.j, alpha, [275, 290, 302, 308, 310]);
save2eps('fig\LCurveBj');

% Best alpha value from L-curve for B_x model
alpha_bestIndex.j = 302;

% Model covariance / correation
[C_m.j, rho_m.j] = covarianceCorrelation(G.B_j, d.B_j);

% Plot correlation
plotCovCorr(rho_m.j);
save2eps('fig\corJ');

% Model plotted against observed data
plotModel(lat, d.B_z, d.B_x, G.B_z, G.B_x, m_ls.j(:,alpha_bestIndex.j));
save2eps('fig\BjModel');

% Plot modeled line currents
plotLC(x_I, m_ls.j, alpha_bestIndex.j);
save2eps('fig/LCj');
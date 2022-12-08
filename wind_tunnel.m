% WIND_TUNNEL  Gather and plot lab results.
%
% The code below was written for the project carried out as part of the
% aerodynamics course (AERO0001-1).

% TODO:
% - wind tunnel corrections. Apparently, the corrections are quite negligible.
% Caculate the eps factor, and say in the report that we would not take into
% account this negligible correction.

clear; close all;

% Import the wind tunnel experiment setup.
lab_set = load('setup.mat');
lab_res = load('group_5.mat');
% Choose a configuration (aoa and speed, see group_6 data).
cfg = 1;
% Unpack.
aoa   = lab_res.AoA(cfg);
v_inf = lab_res.Uinf(cfg);
rho   = lab_set.rho;
c     = lab_set.chord;

% Wind tunnel corrections.
K1 = 0.52; % TODO: make sure of this coef.
wt_width = 2.5;
wt_height = 1.8;
wt_S = wt_width * wt_height;
wg_L = 1; % Approx of the wing length [m].
wg_t = lab_set.chord * 0.18; % Max tickness of the airfoil [m].
wg_V = lab_set.chord * wg_t * wg_L;
eps = K1 * wg_V / wt_S^(3/2);
% -> 2e-3 -> correction factor is negligible.


xc = lab_set.coord_taps(1, :)/lab_set.chord;
cp = lab_res.p / (0.5 * lab_set.rho * lab_res.Uinf(cfg)^2);

% Pressure coefficient graph.
figure('WindowStyle', 'docked'); hold on; grid;
plot( ...
	xc(1:floor(end/2)),         ...
	cp(cfg, 1:floor(end/2)), ...
	'color', 'red',             ...
	'Marker', 'x',              ...
	'Linewidth', 1);
plot( ...
	xc(ceil(end/2):end),         ...
	cp(cfg, ceil(end/2):end), ...
	'color', 'blue',             ...
	'Marker', 'x',               ...
	'Linewidth', 1);
xlabel('x/c');
ylabel('Cp');
legend('Upper surface', 'Lower surface');
title('Distribution of the pressure coefficient Cp along the chord');
set(gca, 'YDir', 'reverse')

%% Computation of lift and drag coefficients.

x = lab_set.coord_taps(1, 1:ceil(end/2));
dx = diff(x);
y = lab_set.coord_taps(2, 1:ceil(end/2));
dy = diff(y);

diff_p = lab_res.p(cfg, 1:ceil(end/2)) - flip(lab_res.p(cfg, ceil(end/2):end));

% Axial and normal forces.
Nprime = trapz(x, diff_p);
Aprime = trapz(x, -diff_p .* (dy./dx));

% Lift and drag forces.
Lprime = Nprime*cosd(aoa) - Aprime*sind(aoa);
Dprime = Nprime*sind(aoa) + Aprime*cosd(aoa);

% Lift and drag coefficients.
cl = Lprime / (0.5*rho*v_inf^2*c);
cd = Dprime / (0.5*rho*v_inf^2*c);

%% Write in csv.
% Uncomment this section to write plotting data into external file.

% plot_up = [ ...
% 	xc(1:floor(end/2)); ...
% 	cp(config, 1:floor(end/2))]';
% plot_low = [ ...
% 	xc(ceil(end/2):end); ...
% 	cp(config, ceil(end/2):end)]';
% writematrix(plot_up, 'Results/lab-cp-a15v25up.csv')
% writematrix(plot_low, 'Results/lab-cp-a15v25low.csv')

%% Refrigeration Lab - Summer 21
% Written by: Mykala Sinclair
% Created: 07-07-2021
% Last edit: 07-14-2021

clear all
clc

%% Load Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load '60Psig_T4c_T5.mat'

%% Given/Known Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R = 287; % Gas Constant (Dry Air) [J/(kg*K)]
c_p = 1006; % Specific Heat Constant [J/(kg*K)]
P_amb = 14.84.*6895; % Ambient Pressure (N/m^2)
T_F = 71.15; % Ambient Temperature [Celsius]
T_amb = (5/9)*(T_F-32)+273.15; % Ambient Temperature (K)
T_3 = T_amb; % Vortex tube input ambient temperature assumptumption [K]
m_block = 454.3; % mass of aluminum block [g]
b_length = 26; % length of insulation [mm]
b_thick = 25.4; % thickness of block [mm]
b_height = 127.3; % height of block [mm]
b_width = 76.4; % width of block [mm]

%% Measured Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Absolute Pressure [N/m^2]
Pg_3 = P_gauge_PSI.*6895; % Gauge Pressure at Station 3 [N/m^2]
P_3 = Pg_3 + P_amb; % Absolute Pressure at Station 3 [N/m^2]

% Absolute Temperatures [K]
T_4c = (5/9).*(T_4c_F-32)+273.15; % Temperature at Station 4c [K]
T_4h = (5/9).*(T_4h_F-32)+273.15; % Temperature at Station 4h [K]
T_5 = (5/9).*(T_5_F-32)+273.15; % Temperature at Station 5 [K]
T_load = (5/9).*(T_load_F-32)+273.15; % Temperature at Station load [K]

% Mass Flow Rates
    % Converting Volumetric Rate from L/min --> m^3/s
    V_cold = Vdot_c./60000; % Cold Output Volumetric Flow Rate [m^3/s] 
    V_hot = Vdot_h./60000; % Hot Output Volumetric Flow Rate [m^3/s] 
mdot_c = (P_amb.*V_cold)./(R.*T_5); % Vortex Tube cold output mass flow rate [kg/s]
mdot_h = (P_amb.*V_hot)./(R.*T_4h); % Vortex Tube cold output mass flow rate [kg/s]

%% Sensor Offset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
offset_t4c = T_4c(1) - T_amb; % Offset of T_4c
offset_t4h = T_4h(1) - T_amb; % Offset of T_4h
offset_t5 = T_5(1) - T_amb; % Offset of T_5
offset_tload = T_load(1) - T_amb; % Offset of T_load
offset_p = P_3(1) - P_amb; % Offset of P_3

% Adjusted Sensor Values
T_4c_adj = T_4c - offset_t4c;
T_4h_adj = T_4h - offset_t4h;
T_5_adj = T_5 - offset_t5;
T_load_adj = T_load - offset_tload;
P_3_adj = P_3 - offset_p;

%% York Fit Regression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Matlab "eps" (2.2204e-16) used for York Regression uncertainty inputs

% Case 1: T_4c vs. P_3
[B_K, M_Nm2, Uc_B_K,Uc_M_Nm2] = york_fit(P_3, T_4c, eps, eps);
Reg_T_4c_K = P_3 .* M_Nm2 + B_K; % Regression result for T_4c (Y) Points for each P_3 (X) Value

% Case 2: T_4h vs. P_3
[B_K2, M_Nm2_2, Uc_B_K2,Uc_M_Nm2_2] = york_fit(P_3, T_4h, eps, eps);
Reg_T_4h_K = P_3 .* M_Nm2_2 + B_K2; % Regression result for T_4h (Y) Points for each P_3 (X) Value

 % Case 3: mdot_c vs. P_3
[B_kgs, M_Nm2_3, Uc_B_kgs,Uc_M_Nm2_3] = york_fit(P_3, mdot_c, eps, eps);
Reg_mdot_c_kgs = P_3 .* M_Nm2_3 + B_kgs;  % Regression result for mdot_c (Y) Points for each P_3 (X) Value

 % Case 4: mdot_h vs. P_3
[B_kgs_2, M_Nm2_4, Uc_B_kgs_2,Uc_M_Nm2_4] = york_fit(P_3, mdot_h, eps, eps);
Reg_mdot_h_kgs = P_3 .* M_Nm2_4 + B_kgs_2;  % Regression result for mdot_h (Y) Points for each P_3 (X) Value

%% Plot York Regression Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
% Plot of Case 1
figure(1)
plot(P_3, Reg_T_4c_K, 'r');
hold on
plot(P_3, T_4c, 'bo');
hold off
title('$T_{4c} [K] vs.  P_{3} [N/m^2]$','interpreter','latex')

% Legend
legend('Regression Data','Data Points','Location','northwest','interpreter','latex')

% Axis Labels
xlabel('Temperature at Station 4 cold output $(T_{4c}) [K]$','interpreter','latex');
ylabel('Gauge Pressure at Station 3 $(P_3) [N/m^2]$','interpreter','latex');

% String to Print Slope (M) and Uncertainty in Slope (Uc_M) to Console
Reg_M_str = ['M_T_4c = ', num2str(M_Nm2), ';   ','Uc_M_T_4c = ', num2str(Uc_M_Nm2.*2), '\n'];

% String to Print Intercept (B) and Uncertainty in Intercept (Uc_B) to Console
Reg_B_str = ['B_T_4c = ', num2str(B_K), ';   ','Uc_B_T_4c = ', num2str(Uc_B_K.*2), '\n'];

% Write Strings to Console
fprintf('\n');
fprintf(Reg_M_str);
fprintf('\n');
fprintf(Reg_B_str);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot of Case 2
figure(2)
plot(P_3, Reg_T_4h_K, 'r');
hold on
plot(P_3, T_4h, 'bo');
hold off
title('$T_{4h} [K] vs.  P_{3} [N/m^2]$','interpreter','latex')

% Legend
legend('Regression Data','Data Points','Location','northwest','interpreter','latex')

% Axis Labels
xlabel('Temperature at Station 4 hot output $(T_{4h}) [K]$','interpreter','latex');
ylabel('Gauge Pressure at Station 3 $(P_3) [N/m^2]$','interpreter','latex');

% String to Print Slope (M) and Uncertainty in Slope (Uc_M) to Console
Reg_M_str = ['M_T_4h = ', num2str(M_Nm2_2), ';   ','Uc_M_T_4h = ', num2str(Uc_M_Nm2_2.*2), '\n'];

% String to Print Intercept (B) and Uncertainty in Intercept (Uc_B) to Console
Reg_B_str = ['B_T_4h = ', num2str(B_K2), ';   ','Uc_B_T_4h = ', num2str(Uc_B_K2.*2), '\n'];

% Write Strings to Console
fprintf('\n');
fprintf(Reg_M_str);
fprintf('\n');
fprintf(Reg_B_str);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot of Case 3
figure(3)
plot(P_3, Reg_mdot_c_kgs, 'r');
hold on
plot(P_3, mdot_c, 'bo');
hold off
title('$\dot{m}_{cold} [kg/s] vs.  P_{3} [N/m^2]$','interpreter','latex')
    
% Legend
legend('Regression Data','Data Points','Location','northwest','interpreter','latex')

% Axis Labels
xlabel('Vortex Tube Cold Output Mass Flow Rate $(\dot{m}_{cold}) [kg/s]$','interpreter','latex');
ylabel('Gauge Pressure at Station 3 $(P_3) [N/m^2]$','interpreter','latex');

% String to Print Slope (M) and Uncertainty in Slope (Uc_M) to Console
Reg_M_str = ['M_m_cold = ', num2str(M_Nm2_3), ';   ','Uc_m_cold = ', num2str(Uc_M_Nm2_3.*2), '\n'];

% String to Print Intercept (B) and Uncertainty in Intercept (Uc_B) to Console
Reg_B_str = ['B_m_cold = ', num2str(B_kgs), ';   ','Uc_m_cold = ', num2str(Uc_B_kgs.*2), '\n'];

% Write Strings to Console
fprintf('\n');
fprintf(Reg_M_str);
fprintf('\n');
fprintf(Reg_B_str);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot of Case 4
figure(4)
plot(P_3, Reg_mdot_h_kgs, 'r');
hold on
plot(P_3, mdot_h, 'bo');
hold off
title('$\dot{m}_{hot} [kg/s] vs.  P_{3} [N/m^2]$','interpreter','latex')

% Legend
legend('Regression Data','Data Points','Location','northwest','interpreter','latex')

% Axis Labels
xlabel('Vortex Tube Hot Output Mass Flow Rate $(\dot{m}_{hot}) [kg/s]$','interpreter','latex');
ylabel('Gauge Pressure at Station 3 $(P_3) [N/m^2]$','interpreter','latex');

% String to Print Slope (M) and Uncertainty in Slope (Uc_M) to Console
Reg_M_str = ['M_m_hot = ', num2str(M_Nm2_4), ';   ','Uc_m_hot = ', num2str(Uc_M_Nm2_4.*2), '\n'];

% String to Print Intercept (B) and Uncertainty in Intercept (Uc_B) to Console
Reg_B_str = ['B_m_hot = ', num2str(B_kgs_2), ';   ','Uc_m_hot = ', num2str(Uc_B_kgs_2.*2), '\n'];

% Strings to Console
fprintf('\n');
fprintf(Reg_M_str);
fprintf('\n');
fprintf(Reg_B_str);
fprintf('\n');

%% Insulation Thermal Resistance (R_ins) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R_ins = (T_amb - T_load)./(mdot_c.*c_p.*(T_5-T_4c)); % [K*s/J]
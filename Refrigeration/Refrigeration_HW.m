% Refrigeration Homework
% Last Modified: 07-12-2021
% Last Modified By: Aidan Brook

% Reset Console
clc
clear all
clf
%% recreate table

%constants
    plab = 990 * 100; %990 mbar to N/m2
    amb_temp = 20.5 + 273.15; %20.5 C to K
    R = 287; %gas constant
    cp = 1006; %pressure constant

%initialize table variables
    nom_psi = [0,20,40,60,80];
    P3 = [0.028,20.67,39.66,60.55,80.78];
    T4h = [71.7,90.1,108,125.6,139.4];
    T4c = [71.4,53.9,42.6,36.4,33.6];
    Tload = [71.8,65.1,53.7,46.4,42.4];
    T5 = [71.6,68.9,62.0,56.4,53];
    Vc = [0.07,8.85,13.83,19.19,25.5];
    Vh = [0.06,5.84,9.44,12.31,14.8];

%convert gauge p to N/m2 absolute pressure = gauge_p + ambient_p
    P3 = (P3 .*6895)  + plab; 

%absolute temperatures (K)
    T4h = ((5./9) .* (T4h - 32)) + 273.15;
    T4c = ((5./9) .* (T4c - 32)) + 273.15;
    Tload = ((5./9) .* (Tload - 32)) + 273.15;
    T5 = ((5./9) .* (T5 - 32)) + 273.15;

%mass flow rates to kg/s
    Vc = Vc ./ 60000;
    Vh = Vh ./ 60000;
    mc = (plab .* Vc)./(R .* T5);
    mh = (plab .* Vh)./(R .* T4h);
    input_m = mc + mh;

%% Regression

[x1,y1] = polyfit(P3,T4c,1);%lin reg T4c
[x2,y2] = polyfit(P3,T4h,1);%lin reg T4h
[x3,y3] = polyfit(P3,mc,1);%lin reg mc
[x4,y4] = polyfit(P3,mh,1);%lin reg mh

%plotting T4c vs P3
figure(1)
hold on
grid on
plot(P3,(x1(1).*P3) + x1(2),'k-')
plot(P3,T4c,'bo')
xlabel('Pressure [N/m^2]')
ylabel('Temperature [K]')
legend('T4c vs P3 Regression','Raw Data')
title('T4c vs P3 Linear Regression')
hold off

%plotting T4h vs P3
figure(2)
hold on
grid on
plot(P3,(x2(1).*P3) + x2(2),'k-')
plot(P3,T4h,'bo')
xlabel('Pressure [N/m^2]')
ylabel('Temperature [K]')
legend('T4h vs P3 Regression','Raw Data')
title('T4h vs P3 Linear Regression')
hold off

%plotting mc vs P3
figure(3)
hold on
grid on
plot(P3,(x3(1).*P3) + x3(2),'k-')
plot(P3,mc,'bo')
xlabel('Pressure [N/m^2]')
ylabel('Mass Flow Rate [kg/s]')
legend('mc vs P3 Regression','Raw Data')
title('mc vs P3 Linear Regression')
hold off

%plotting mh vs P3
figure(4)
hold on
grid on
plot(P3,(x4(1).*P3) + x4(2),'k-')
plot(P3,mh,'bo')
xlabel('Pressure [N/m^2]')
ylabel('Mass Flow Rate [kg/s]')
legend('mh vs P3 Regression','Raw Data')
title('mh vs P3 Linear Regression')
hold off

%% Insulation Thermal Resistance

Rins_0 = (amb_temp - Tload(1)) ./ (mc(1) .* cp .* (T5(1) - T4c(1))) %for nom psi = 0
Rins_20 = (amb_temp - Tload(2)) ./ (mc(2) .* cp .* (T5(2) - T4c(2))) %for nom psi = 20
Rins_40 = (amb_temp - Tload(3)) ./ (mc(3) .* cp .* (T5(3) - T4c(3))) %for nom psi = 40
Rins_60 = (amb_temp - Tload(4)) ./ (mc(4) .* cp .* (T5(4) - T4c(4))) %for nom psi = 60
Rins_80 = (amb_temp - Tload(5)) ./ (mc(5) .* cp .* (T5(5) - T4c(5))) %for nom psi = 80


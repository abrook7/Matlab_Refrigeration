% Reset Console
clc
clear all
clf
%%

%load('0psi_T4c-T5');
load('20psi_T4c-T5');
%load('20psi_T3-Tamb_ss');
load('p4c20');

%constants
    plab = 14.84; %psi
    plab = plab * 6894.76; %convert to [N/m2]
    amb_temp = 71.15; %F
    amb_temp = (5/9) .* (amb_temp - 32) + 273.15; %convert to [K]
    R = 287; %gas constant
    cp = 1006; %pressure constant
    
%convert gauge p to N/m2 absolute pressure = gauge_p + ambient_p
    P3_20 = (P_3_20psi .*6895)  + plab;
    P4c20 = (p4c(1:end,2) .*6895)  + plab;
    P5_20 = (P_5_20psi .*6895)  + plab;
    
%absolute temperatures (K)
    T4h20 = ((5./9) .* (T_4_h_20psi - 32)) + 273.15;
    T4c20 = ((5./9) .* (T_4_c_20psi - 32)) + 273.15;
    Tload = ((5./9) .* (T_load_20psi - 32)) + 273.15;
    T5 = ((5./9) .* (T_5_20psi - 32)) + 273.15; 
    
%mass flow rates to kg/s
    Vc20 = v_dot_cold_20psi ./ 60000;
    Vh20 = v_dot_hot_20psi ./ 60000;
    mc20 = (plab .* Vc20(1:end-1))./(R .* T5);
    mh20 = (plab .* Vh20(1:end-1))./(R .* T4h20);
    input_m20 = mc20 + mh20;
    
%load steady state analysis
figure(1)
hold on
grid on
plot(p4c(1:end,1),T4h20,'r.')
plot(p4c(1:end,1),T4c20,'b.')
plot(p4c(1:end,1),Tload,'k.')
plot(p4c(1:end,1),T5,'c')
xlabel('Time [s]')
ylabel('Temperature [K]')
legend('T4h','T4c','Tload','T5')
title('Load Energy Balance 20 PSI')
hold off
    
%Rins_20 = (amb_temp - Tloadss) ./ (mcss .* cp .* (T5ss - T4css)) %for nom psi = 20

% T4h20_s = mean(T4h20(2000:end));
% T4c20_s = mean(T4c20(2000:end));
% mc20_s = mean(mc20(2000:end));
% mh20_s = mean(mh20(2000:end));
% P3_20_s = mean(P3_20(2000:end));
% P4c20_s = mean(P4c20(2000:end));
% P5_20_s = mean(P5_20(2000:end));
% Tload_s = mean(Tload(2000:end));
% T5_s = mean(T5(2000:end));

load('points')

[x1,y1] = polyfit(P3_20_s,T4c20_s,1);%lin reg T4c
[x2,y2] = polyfit(P3_20_s,T4h20_s,1);%lin reg T4h
[x3,y3] = polyfit(P3_20_s,mc20_s,1);%lin reg mc
[x4,y4] = polyfit(P3_20_s,mh20_s,1);%lin reg mh

figure(2)
hold on
grid on
%plot(P3_s,(x1(1).*P3) + x1(2),'k-')
subplot(2,2,1)
hold on
grid on
plot(P3_20_s,T4c20_s,'bo')
plot(P3_20_s,(x1(1).*P3_20_s) + x1(2),'r')
title('T4c vs P3 Regression')
legend('raw data', 'regression')
xlabel('Pressure [N/m2]')
ylabel('Temperature [K]')
subplot(2,2,2)
hold on
grid on
plot(P3_20_s,T4h20_s,'bo')
plot(P3_20_s,(x2(1).*P3_20_s) + x2(2),'r')
title('T4h vs P3 Regression')
legend('raw data', 'regression')
xlabel('Pressure [N/m2]')
ylabel('Temperature [K]')
subplot(2,2,3)
hold on
grid on
plot(P3_20_s,mc20_s,'bo')
plot(P3_20_s,(x3(1).*P3_20_s) + x3(2),'r')
title('mc vs P3 Regression')
legend('raw data', 'regression')
xlabel('Pressure [N/m2]')
ylabel('Mass flow rate [kg/s]')
subplot(2,2,4)
hold on
grid on
plot(P3_20_s,mh20_s,'bo')
plot(P3_20_s,(x4(1).*P3_20_s) + x4(2),'r')
title('mh vs P3 Regression')
legend('raw data', 'regression')
xlabel('Pressure [N/m2]')
ylabel('Mass flow rate [kg/s]')
% xlabel('Pressure [N/m^2]')
% ylabel('Temperature [K]')
% legend('Raw Data')
% title('T4c vs P3 Linear Regression')
hold off

%steady state raw
figure(3)
subplot(2,1,1)
hold on
grid on
plot(P3_20(2000:end,1),T4h20(2000:end),'ro')

plot(P3_20(2000:end,1),T4c20(2000:end),'bo')

plot(P3_20(2000:end,1),Tload(2000:end),'ko')

plot(P3_20(2000:end,1),T5(2000:end),'co')
legend('T4 hot','T4 cold', 'T load', 'T5')
title('Temperatures vs P')
xlabel('Pressure [N/m2]')
ylabel('Temperature [K]')
subplot(2,1,2)
hold on
grid on
plot(P3_20(2000:end,1),mh20(2000:end),'ro')

plot(P3_20(2000:end,1),mc20(2000:end),'bo')
legend('mass flow hot', 'mass flow cold')
title('mass flow vs P')
xlabel('Pressure [N/m2]')
ylabel('Mass flow rate [kg/s]')
%plotting T4c vs P3
% figure(2)
% hold on
% grid on
% subplot(2,2,1)
% plot(P3_20_s,T4h20_s,'k.')
% subplot(2,2,2)
% plot(P3_20_s,T4c20_s,'b.')
% subplot(2,2,3)
% plot(P3_20_s,mc20_s,'r.')
% subplot(2,2,4)
% plot(P3_20_s,mh20_s,'c.')
% xlabel('Pressure [N/m^2]')
% ylabel('Temperature [K]')
%legend('T4c vs P3 Regression','Raw Data')
%title('T4c vs P3 Linear Regression')
% hold off

%%
load('20psi_T3-Tamb_ss');

T_3_20psi = ((5./9) .* (T_3_20psi - 32)) + 273.15;
T_amb_20psi = ((5./9) .* (T_amb_20psi - 32)) + 273.15;
T3_avg = [mean(T_3_20psi),mean(T_3_20psi)];
T_amb_avg = [mean(T_amb_20psi),mean(T_amb_20psi)];

figure(4)
hold on
grid on
plot(p4c(1:157,1),T_3_20psi,'r')
plot(p4c(1:157,1),T_amb_20psi,'b')
plot([p4c(1,1),p4c(157,1)],T3_avg,'k')
plot([p4c(1,1),p4c(157,1)],T_amb_avg,'k')
xlabel('Time [s]')
ylabel('Temperature [K]')
legend('T3','T ambient','T3 average = 295.38','T amb average = 293.82')
title('Verify T3 = Tambient 20 PSI')
hold off
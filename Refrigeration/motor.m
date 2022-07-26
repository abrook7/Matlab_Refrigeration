% Reset Console
clc
clear all
clf
%%
load('rpm_0');
load('rpm_20');
load('rpm_40');

%constants
    plab = 14.84; %psi
    plab = plab * 6894.76; %convert to [N/m2]
    amb_temp = 71.15; %F
    amb_temp = (5/9) .* (amb_temp - 32) + 273.15; %convert to [K]
    R = 287; %gas constant
    cp = 1006; %pressure constant
    
%convert gauge p to N/m2 absolute pressure = gauge_p + ambient_p
    P3_0 = (P3_0 .*6895)  + plab;
    P3_20 = (P3_20 .*6895)  + plab;
    P3_40 = (P3_40 .*6895)  + plab;
%absolute temperatures (K)
    T4h_0 = ((5./9) .* (t4h_0 - 32)) + 273.15;
    T4c_0 = ((5./9) .* (t4c_0(1:end,1) - 32)) + 273.15;
    Tload_0 = ((5./9) .* (tload_0 - 32)) + 273.15;
    T5_0 = ((5./9) .* (t5_0 - 32)) + 273.15; 
    
    T4h_20 = ((5./9) .* (t4h_20 - 32)) + 273.15;
    T4c_20 = ((5./9) .* (t4c_20(1:end,1) - 32)) + 273.15;
    Tload_20 = ((5./9) .* (tload_20 - 32)) + 273.15;
    T5_20 = ((5./9) .* (t5_20 - 32)) + 273.15; 
    
    T4h_40 = ((5./9) .* (t4h_40 - 32)) + 273.15;
    T4c_40 = ((5./9) .* (t4c_40(1:end,1) - 32)) + 273.15;
    Tload_40 = ((5./9) .* (tload_40 - 32)) + 273.15;
    T5_40 = ((5./9) .* (t5_40 - 32)) + 273.15; 
%mass flow rates to kg/s
%     Vc20 = mc60 ./ 60000;
%     Vh20 = mh60 ./ 60000;
%     mc20 = (plab .* Vc20(1:end-1))./(R .* T5_0);
%     mh20 = (plab .* Vh20(1:end-1))./(R .* T4h_0);
%     input_m20 = mc20 + mh20;
  
load('index')
%load steady state analysis
figure(1)
hold on
grid on
plot(index_0,T4h_0,'r.')
plot(index_0,T4c_0,'b.')
plot(index_0,Tload_0,'k.')
plot(index_0,T5_0,'c.')
xlabel('Time [s]')
ylabel('Temperature [K]')
legend('T4h','T4c','Tload','T5')
title('Load Energy Balance 0 PSI')
hold off

figure(6)
hold on
grid on
plot(index_0,P3_0,'r.')
plot(index_20,P3_20,'b.')
plot(index_40,P3_40,'k.')
xlabel('Time [s]')
ylabel('Pressure [N/m2]')
title('Graphing P3')
legend('0 psi P3 data','20 psi P3 data','40 psi P3 data')
hold off

%load steady state analysis
figure(2)
hold on
grid on
plot(index_20,T4h_20,'r.')
plot(index_20,T4c_20,'b.')
plot(index_20,Tload_20,'k.')
plot(index_20,T5_20,'c.')
xlabel('Time [s]')
ylabel('Temperature [K]')
legend('T4h','T4c','Tload','T5')
title('Load Energy Balance 20 PSI')
hold off

%load steady state analysis
figure(3)
hold on
grid on
plot(index_40,T4h_40,'r.')
plot(index_40,T4c_40,'b.')
plot(index_40,Tload_40,'k.')
plot(index_40,T5_40,'c.')
xlabel('Time [s]')
ylabel('Temperature [K]')
legend('T4h','T4c','Tload','T5')
title('Load Energy Balance 40 PSI')
hold off

%% 
load('T1')
P3_0_s = mean(P3_0);
P3_20_s = mean(P3_20);
P3_40_s = mean(P3_40);

%absolute temperatures (K)
    T1_0 = ((5./9) .* (T1_0 - 32)) + 273.15;
    T1_20 = ((5./9) .* (T1_20 - 32)) + 273.15;
    T1_40 = ((5./9) .* (T1_40 - 32)) + 273.15;
    T3_0 = ((5./9) .* (T3_0 - 32)) + 273.15;
    T3_20 = ((5./9) .* (T3_20 - 32)) + 273.15;
    T3_40 = ((5./9) .* (T3_40 - 32)) + 273.15;     
    
T1_0_s = mean(T1_0);
T1_20_s = mean(T1_20);
T1_40_s = mean(T1_40);

T3_0_s = mean(T3_0);
T3_20_s = mean(T3_20);
T3_40_s = mean(T3_40);

figure(4)
hold on
grid on
plot([rpm_0,rpm_20,rpm_40],[P3_0_s, P3_20_s,P3_40_s],'r-o')
xlabel('Motor speed [rpm]')
ylabel('Pressure [N/m2]')
legend('raw data')
title('Motor/Compressor characterization (rpm vs P3)')
hold off

figure(5)
hold on
grid on
plot([P3_0_s, P3_20_s,P3_40_s],[T1_0_s,T1_20_s,T1_40_s,],'r-o')
plot([P3_0_s, P3_20_s,P3_40_s],[T3_0_s,T3_20_s,T3_40_s,],'b-o')
xlabel('Pressure [N/m2]')
ylabel('Temperature [N/m2]')
legend('P3 vs T1','P3 vs T3')
title('Heat Exchanger and Accumulator (P3 vs T1/T3)')
hold off
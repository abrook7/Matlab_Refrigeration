% Reset Console
clc
clear all
clf
%%
load('60psi');

%constants
    plab = 14.84; %psi
    plab = plab * 6894.76; %convert to [N/m2]
    amb_temp = 71.15; %F
    amb_temp = (5/9) .* (amb_temp - 32) + 273.15; %convert to [K]
    R = 287; %gas constant
    cp = 1006; %pressure constant
    
%convert gauge p to N/m2 absolute pressure = gauge_p + ambient_p
    P3 = (P3 .*6895)  + plab;
    P4c = (P4c .*6895)  + plab;
    P5 = (P5 .*6895)  + plab;
    
%absolute temperatures (K)
    T4h = ((5./9) .* (t4h40 - 32)) + 273.15;
    T4c = ((5./9) .* (t4c60(1:end,1) - 32)) + 273.15;
    Tload = ((5./9) .* (tload60 - 32)) + 273.15;
    T5 = ((5./9) .* (t5 - 32)) + 273.15; 
    
%mass flow rates to kg/s
    Vc20 = mc60 ./ 60000;
    Vh20 = mh60 ./ 60000;
    mc20 = (plab .* Vc20(1:end-1))./(R .* T5);
    mh20 = (plab .* Vh20(1:end-1))./(R .* T4h);
    input_m20 = mc20 + mh20;
    
%load steady state analysis
figure(1)
hold on
grid on
plot(t4c60(1:end,2),T4h,'r.')
plot(t4c60(1:end,2),T4c,'b.')
plot(t4c60(1:end,2),Tload,'k.')
plot(t4c60(1:end,2),T5,'c')
xlabel('Time [s]')
ylabel('Temperature [K]')
legend('T4h','T4c','Tload','T5')
title('Load Energy Balance 60 PSI')
hold off
    
%Rins_20 = (amb_temp - Tloadss) ./ (mcss .* cp .* (T5ss - T4css)) %for nom psi = 20
load('points')

T4h20_s(3) = mean(T4h(1000:end))
T4c20_s(3) = mean(T4c(1000:end))
mc20_s(3) = mean(mc20(1000:end))
mh20_s(3) = mean(mh20(1000:end))
P3_20_s(3) = mean(P3(1000:end))
P4c20_s(3) = mean(P4c(1000:end));
P5_20_s(3) = mean(P5(1000:end));
Tload_s(3) = mean(Tload(1000:end))
T5_s(3) = mean(T5(1000:end))



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
plot(P3(1000:end,1),T4h(1000:end),'ro')

plot(P3(1000:end,1),T4c(1000:end),'bo')

plot(P3(1000:end,1),Tload(1000:end),'ko')

plot(P3(1000:end,1),T5(1000:end),'co')
title('T vs P')
subplot(2,1,2)
hold on
grid on
plot(P3(1000:end,1),mh20(1000:end),'ro')

plot(P3(1000:end,1),mc20(1000:end),'bo')
title('mfr vs P')
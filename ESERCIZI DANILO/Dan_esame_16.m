clc
close all
clear all


s=tf([1 0],1);
P0 = 0.1*(4*s+2)/(s*(12*s+1));

pole(P0) % il processo nominale e semplicemente stabile 
rit = exp(-0.05*s);
K=300;
L0 = K*P0;
Wyr = minreal(L0/(1+L0));
figure(1)
rlocus(L0)

figure(2)
margin(L0);

figure(3)
step(Wyr)

% vediamo come si comporta con il ritardo

[gm,pm,wc,wt]=margin(L0);

MF = pm*pi/180;

T_max = MF/wt; %0.077473612450896 ritardo massimo ammissibile 
L1 = K*P0*rit;
Wyr1 = minreal(L1/(1+L1));


figure(3)
step(Wyr1,Wyr)
legend
grid on


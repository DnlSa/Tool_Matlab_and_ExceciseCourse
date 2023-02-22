clc
clear all
close all

%% Impianto + specifiche
%tempo di assestamento il più piccolo possibile
%sovraelongazione < 20%
%margine di fase > 60 gradi
%reiezione asintotica di disturbo costante
%reiezione asintotica di disturbo sinusoidale a 350rad/s
s = tf('s');
P = 5*(s+2)/(s^2-4*s+2);

%% vediamo la reiezione al disturbo
H=(1/(1+s/35)); % filtro passa basso per la reiezione al disturbo sinusoidale 
%di 350 rad/s
L0= P*H;
 
%% vediamo come usare il pid per stabilizzare il sistema

syms kd ki kp
%den(Wyr)= den(L)+num(L);

myRouth([5*kd+1, 5*kp+10*kd-4, 5*ki+10*kp+2, 10*ki]);
%5*kd + 1 >=0
% 10*kd + 5*kp - 4 >=0
% 10*ki>=0
kp =5;
ki =1 ;
kd = 0.1;
roots([5*kd+1, 5*kp+10*kd-4, 5*ki+10*kp+2, 10*ki])



%% PID REALE 
N=200;
C0= (s^2*(kd+kp/N)+s*(kp+ki/N)+ki)/(s*(1+s/N));
k=1;
L1= C0*P*H*k;
Wyr= minreal((P*C0*k)/(1+L1));% H e messo in controreazione e non bisogna prenderlo

figure(1)
margin(L1);

figure(2)
nyquist(L1);

figure(4)
rlocus(L1);

figure(3)
step(Wyr);



%% NON funziona bene una rete antricipatrice 
% il sistema e stabile e funziona però ha una sovraelongazione troppo elevata 
% alpha_ra =  5;
% omega_tau = 50;
% tau_ra  = 1/(omega_tau*sqrt(alpha_ra));
% 
% Ra = (1+tau_ra*s)/(1+tau_ra*alpha_ra*s);
% L2 = C0*P*H*k*Ra;
% Wyr2= minreal((P*C0*k*Ra)/(1+L2));
% figure(1)
% bode(L2, L1);
% legend('L1' , 'L2');
% grid on
% 
% figure(2)
% nyquist(L2);
% 
% figure(3)
% step(Wyr2);

%% mettiamo un filtro segnale 
tau_fr = 1/3;
Fr= (1+tau_fr)/(1+tau_fr*s);

Wyr3 = minreal(Wyr*Fr);
figure(3)
step(Wyr3);

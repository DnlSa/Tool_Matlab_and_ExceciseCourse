clear all 
close all 
clc

%% 

s = tf('s');
P0 = (s+3)/(s*(s-3)*(s-5));
rit = exp(-0.01*s);
P = P0*rit;

%% inziamo con errore nullo per riferimenti rampa 

C0 = 1/s;
k= 1
L0 = P0*k*C0;

figure(1)
rlocus(L0);

% dal luogo della radici ci conviene tenere il luogo diretto
% in quanto i rami all infinito nel semipiano DX sono meglio attraibili 

%% 
zita = 0.7;
omega_n = 1; 
C1 = (s^2+omega_n*zita*2*s+omega_n^2)/(s*(s/500+1));


K1= 60;

L1 = minreal(K1*C1*P0);
Wyr1 = minreal(L1/(1+L1));

figure(1)
rlocus(L1);

figure(2)
margin(L1)

figure(3)
nyquist(L1)

figure(4)
step(Wyr1);

%  %% MIGLIORABILE CON UNA RETE ANTICIPATRICE
%  alpha =0.1;
%  omega_t = 55;
% tau_ra = 1/(omega_t*sqrt(alpha));
%  Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
% K2 =10;
% L2 = K2*C1*P0;
% Wyr2 = minreal(L2/(1+L2));
% figure(1)
% rlocus(L2);
% figure(2)
% margin(L2)
% figure(3)
% nyquist(L2)
% figure(4)
%step(Wyr2);

% non si puo inserire un filtro in qunanto inserirebbe un errore
%  limitato sul ingresso rampa 



%% 
K2 = 6000;
C2 = ((s/5+1)*(s/10+1))/(s*(s/500+1));
L2 = K2*C2*P0;
Wyr2 = minreal(L2/(1+L2));

figure(1)
rlocus(L2);

figure(2)
margin(L2)

figure(3)
nyquist(L2)

figure(4)
step(Wyr2);

%% confronto 
figure(4)
step(Wyr2,Wyr1);
legend

%% 
%%
[gm,pm,wc,wt]= margin(L1);

MF = pm*pi/180;
T_max = MF/wt ;
%   0.020953631866932 perfetto (con il controllore 1 ) si sceglie il primo
%   perche resiaste meglio alle perturbazioni 
%    0.009543160014768 (con il controllore 2)

L1_r = K1*C1*P;

Wyr1_r = minreal(L1_r/(1+L1_r));

figure(4)
step(Wyr1,Wyr1_r);
legend

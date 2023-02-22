clc
clear all
close all

%% Esame
%specifiche:
%riferimento a rampa con errore nullo a regime
%sovraelongazioni < 20 %
%tempo di assestamento il più piccolo possibile
%reiezioni di un disturbo sinusoidale a 80hz;
s = tf('s');
P = (1-s)/((1+2*s)*(1+0.5*s)); % il sistema e a fase non minima 
H = 1/(s/50 + 1);
[num , den]= tfdata (P);
myRouth(den{1}); 
C0= 1/s^2;
L0 = C0*P*H;
figure(1)
nyquist(L0)
figure(2)
rlocus(L0)

%% vediamo di stemare il transitorio 
C1 = ((s/0.5+1)^2)/(s/50+1);
k=0.05;
L1 = k*C0*P*H*C1;
Wyr = minreal(L1/(1+L1));
[gm,pm,wg,omega_t]=margin(L1);
figure(1)
subplot(2,2,1);
margin(L1)
subplot(2,2,2);
nyquist(L1)
subplot(2,2,3); 
rlocus(L1)
subplot(2,2,4); 
step(Wyr)

%% per migliorare le prestazioni inserisco una reteanticipatrice

alpha = 0.1;
omega_t2 = omega_t
tau_ra = 1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
K1=0.015;
L2 = K1*C0*P*H*C1*Ra;

tau_fr = 26/3;
Fr = 1/(tau_fr*s+1)

Wyr2 = minreal(L2/(1+L2));
Wyr21 = minreal(Fr*L2/(1+L2));


figure(1)
subplot(2,2,1);
%margin(L2);
bode(L2,L1);
legend
subplot(2,2,2);
nyquist(L2)
subplot(2,2,3); 
rlocus(L2)
subplot(2,2,4); 
step(Wyr2,Wyr21)




%% filtro segnale FEED FORWARD (NON VA BENE )

% Ff= 1/50*(1+2*s)*(1+0.5*s)/((s/100+1)^2); % biproprio
% Wyr3 = Wyr2+minreal(Ff*P/1+L2);
% pole(Wyr3) 
% figure(1)
% subplot(1,2,1);
% margin(Wyr3);
% subplot(1,2,2); 
% step(Wyr3)
%% Introduzione del ritardo 
r = exp(-0.05*s);
Pr=P*r;
%% %% METODO 1 RITARDO 

[gm,pm,wg,omega_t1]=margin(L2);
Mf= pm*pi/180;

R_max = Mf/omega_t1 %    0.347497847788274
L3 = K1*C0*Pr*H*C1*Ra;
Wyr3 = minreal(L3/(1+L3));
figure(1)
subplot(2,1,1);
%margin(L2);
bode(L2,L1,L3);
legend
subplot(2,1,2); 
step(Wyr3)
%% METODO 2 RITARDO CON PADE

delay=pade(r,10);
L4 = K1*C0*P*delay*H*C1*Ra;
Wyr4 = minreal(L4/(1+L4));
figure(1)
subplot(2,1,1);
bode(L2,L1,L3,L4);
legend
subplot(2,1,2); 
step(Wyr3, Wyr , Wyr4 , Wyr2);
legend
%% analisi del disturbo 

Wd2y = minreal(-H*K1*P*C1*C0*Ra^2/(1+L3));
Wur = minreal(K1*C1*C0*Ra^2/(1+L3));
Wetrue = minreal(1/(1+L3));

ts = 0.01;
t = 0:ts:1000;

d2 = 0.1*sin(2*pi*80*t) + 0.2*randn(1, length(t));

figure(1);
lsim(Wyr3, t, t);
title("Inseguimento riferimento a rampa");
grid on;

figure(2);
lsim(Wd2y, d2, t);
title("Reiezione del disturbo sinusoidale");
grid on;

figure(3);
bode(Wyr2, Wyr3, Wetrue, Wyr2+Wetrue);
title("Sensitività e Sensitività Complementare");
legend;
grid on;

figure(4);
bode(Wd2y, Wur);
title("Sensitività del disturbo sinusoidale e del controllo");
legend;
grid on;


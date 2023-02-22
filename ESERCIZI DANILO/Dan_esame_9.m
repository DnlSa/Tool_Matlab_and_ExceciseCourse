clc
clear all
close all

%% Esame
%riferimento sinusoidale a 50hz con errore nullo a regime
%margine di fase > 60'
%sovraelongazioni < 20%
%tempo di assestamento il più piccolo possibile

s = tf('s');
P = (1-80*s)/((1+s)*(1+100*s));

%% Vediamo come fare 

% impostiamo la omega
w = 2*pi*50 ; % abbiamo creato la 50 Hz
C0 = 1/s; % per errori costanti a regime 
C1 = 1/(s^2+w^2); % controllore per eliminare la 50Hz
K= 300;

alpha=0.1;
tau_ra = 1/(sqrt(alpha)*w);
Ra= (1+tau_ra*s)/(1+alpha*tau_ra*s);
tau_fr = 800/3
Fr= 1/(1+tau_fr*s)

L0 = Ra*P*C0*C1*K;
Wyr0 = Fr*minreal(L0/(1+L0));

% Si costruisce adesso il nostro segnale sinusoidale

ts= 0.01;
t= 0:ts:10;
u= sin(2*pi*50*t);
figure(1);
margin(L0);
grid on;

figure(2);
rlocus(L0);
grid on;

figure(3);
nyquist(L0);
grid on;

figure(4);
step(Wyr0);
legend;
grid on;

figure(5);
lsim(Wyr0, u, t);
legend;
grid on;





clc
clear all
close all

%errore nullo per riferimento a rampa
%overshoot più piccolo possibile
%tempo di assestamento più piccolo possibile

s = tf('s');
P = -(s+5)/(s*(s^2+4*s+2));
pole(P) % il sistema e stabile semplicemente 

%% SOLUZIONE 1 
C0 = ((s/3+1)*(s/1.1+1))/(s*(s/100+1)*(s/50+1)) ; % errore nullo per riferimenti rampa 
k=-1;
K2 = 35;
L0= K2*k*C0*P;
Wyr= minreal(L0/(1+L0));
figure(1)
rlocus(L0)
figure(2)
margin(L0)
figure(3)
nyquist(L0)
figure(4)
step(Wyr)
 % inseriamo una rete anticipatrice per migliorare i transitori e ridurre
 % anche l overshoot

alpha = 0.1 ; 
omega_t = 13.2;
tau_ra = 1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
K1=13;
L1 = k*C0*Ra*K1*P;

Wyr1= minreal(L1/(1+L1));
figure(1)
rlocus(L1)
figure(2)
margin(L1);
%bode(L1,L0)
grid on;
legend;
figure(3)
nyquist(L1)
figure(4)
step(Wyr1,Wyr)
grid on;
legend;
%% si aggiunge un filtrino segnale in ingresso 

tau_fr = 1.4/3;
Fr = 1/(1+tau_fr*s);
Wyr2 = minreal(Fr*Wyr1);
pole(Wyr2);
figure(4)
step(Wyr1,Wyr,Wyr2)
grid on;
legend

%% simuliamo l ingresso rampa per vedere se il nostro sistema si comporta bene 
pole (Wyr2); % osserviamo poli a ciclo chiuso 
ts= 0.1;
t = 0:ts:100;
figure(1)
hold on
lsim(Wyr2,t,t);
% lsim(Wyr1,t,t);
% lsim(Wyr,t,t);
legend;


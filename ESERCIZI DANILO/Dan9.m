clc
clear all
close all

s = tf('s');
P = (s+3)/(s-2);
% sistema instabile allora dobbiamo sistemarlo 
% non abbiamo ritardi di tempo allora puo esserci utile adottare rlocus
C= 1/s; % garantisce errore a regime nullo
Kp=15;
L = Kp*C*P;
Wyr = minreal(L/(1+L));
figure(1)
rlocus(L);
figure(2)
step(Wyr);
%% inseriamo una rete anticipatrice
alpha_ra = 0.1;
omega_tau= 10;
tau_ra = 1/(omega_tau *sqrt(alpha_ra));
Ra = (1+tau_ra*s)/(1+alpha_ra*tau_ra*s);
L1= Kp*C*P*Ra;
Wyr1 = minreal(L1/(1+L1));

figure(3)
subplot(2,2,1)
margin(L1);
legend('L1');

subplot(2,2,2)
nyquist(L1);
grid on

subplot(2,2,3)
rlocus(L1);

subplot(2,2,4)
step(Wyr1);

%% inserisco un filtro segnale per rendere i transitori piu smooth
tau_fr = 1/3;
Fr= 1/(1+tau_fr*s);
Wyr2 = Wyr1*Fr;
figure(5)
step(Wyr2);




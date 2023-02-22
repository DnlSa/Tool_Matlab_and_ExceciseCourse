clc
clear all
close all

%Errore nullo per riferimenti a gradino e valutare max ritardo
%ammissibile, con overshoot sotto il 15%, con miglior tempo di
%assestamento possibile.

s = tf('s');
P = (s-1)/(s^2 + 3*s +1);
figure(1)
rlocus(P)

%% controllore  con un polo in 0 per riferimenti a regime 

zita= 0.7 ; % coefficente di smorzamento 
omega_n =2; % pulsazione naturale
kg =-1 ; % guadagno statico impostato nel controllore 
%C0 = kg*(s^2+2*zita*omega_n*s+omega_n^2)/(s*(s/1.3+1));
C0 = (s/1+1)/(s*(s/50+1))
L0 = kg*P*C0;
% 
figure(1)
rlocus(L0)

figure(2)
nyquist(L0)

figure(3)
margin(L0)
%% INSERIAMO UNA RETE ANTICIPATRICE 

alpha = 0.1;

omega_t = 4;
omega_t_old = 1;

tau_ra = 1/(omega_t*sqrt(alpha));
tau_ra_old = 1/(omega_t_old*sqrt(alpha));

Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
Ra_old = (1+tau_ra_old*s)/(1+tau_ra_old*alpha*s);

kg1 =-1/2;
kg_old=-1/2.8;
L1 = minreal(kg1*P*C0*Ra); 
L1_old = minreal(kg_old*P*C0*Ra_old); 

Wyr1 = minreal(L1/(1+L1));
Wyr1_old = minreal(L1_old/(1+L1_old));

figure(1)
bode(L1,L0,L1_old)
legend
grid on
% 
% figure(2)
% nyquist(L1)
% 
 figure(3)
 margin(L1)
% 
 figure(4)
 step(Wyr1,Wyr1_old)
 legend;
%% inseriamo un filtro segnale (ho gia un peak response del 15 % posso non filtrare il riferimento)

% piu smooth ma perdiamo 2 secondi nei transitori 
tau_fr = 4/3;
Fr = 1/(1+tau_fr*s);
Wyrfr = minreal(Wyr1*Fr);
figure(4)
step(Wyr1,Wyrfr);
legend
%% valutiamo i ritardo massimo ammissibile 
[gm,pm,wc,wt]=margin(L1)
MF = pm*pi/180;
Tmax = MF/wt;  %2.491056507873583 il sistema e insensibile fino a 2.49 secondi di ritardo 

%% prioviamo a fare un controllore parametrico 

kp = dcgain(P);
syms  s z0 z1 p0 p1 % 1 definisco i poli e zeri che dovrebbe avere il mio controllore 
% accoppiamo il tutto all den(Wyr)= den(L)+num(L);

%      (s-1)*(z0+z1*s)
% kp* _______________________________
%     (s^2 + 3*s +1)*(p0+p1*s);
%
kp = dcgain(P)

expand((s-1)*(z0+z1*s)) % s*z0 - z0 - s*z1 + s^2*z1 
expand((s^2 + 3*s +1)*(p0+p1*s)) % p0 + p0*s^2 + 3*p1*s^2 + p1*s^3






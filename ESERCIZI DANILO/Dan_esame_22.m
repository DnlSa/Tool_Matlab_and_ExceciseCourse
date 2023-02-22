
clc
close all
clear all
%%
%e=0 per r=10/s P(s)=-10*(s^2+2*s+1)/(s+10)^2
s=tf('s');
P0=-10*(s^2+2*s+1)/((s+10)^2);
E=exp(-0.1*s);
P=P0*E;

% si vede subito che il sistema e asintoticamente  stabile in quanto ha 2
% poli in -10 essendo abbastanza lontani . 
roots([1 2 1]) % inoltre ho gia 2 zeri in -1 quindi e anche a fase minima 
%% Sintesi del controllore 

C0 = (s/3+1)/(s^2*(s/2+1)); % applico approssimazione ai poli dominanti 
K0=-13;
L0 = K0*P0*C0;

Wyr0= minreal(L0/(1+L0));
figure(1)
rlocus(L0);

figure(2)
margin(L0);

figure(3)
step(Wyr0)
%% per come abbiuamo costruito il controllore possiamo inserire subito una
% rete anticipatrice 

alpha= 0.3;
omega_t= 3;
tau_ra = 1/(omega_t*sqrt(alpha));
K1=-15;
Ra= (1+tau_ra*s)/(1+tau_ra*alpha*s);
L1 = K1*P0*C0*Ra;

Wyr1= minreal(L1/(1+L1));
figure(2)
%margin(L1)
bode(L0,L1);
legend;
% 
figure(3)
step(Wyr0,Wyr1);
legend;

%% aggiungiamo un filtro segnale (rendiamo solamente il segnale un po piu smooth )

tau_fr= 1/3;
Fr = 1/(s*tau_fr+1);
Wyr2= minreal(Fr*Wyr);
figure(3)
step(Wyr0,Wyr1,Wyr2);
legend;

%% applichiamo il ritardo 
[gm,pm ,wg,omega_t] = margin(L0);
MF = pm*pi/180;
Rmax= MF/omega_t; % risponde ad un ritardo massimo di  0.535165687557662
L2= K0*P*C0;
Wyr_r = minreal(L2/(1+L2));
tau_fr= 1/5;
Fr = 1/(s*tau_fr+1);
Wyr_r_fr = minreal(Wyr_r*Fr);
ts=0.1;
t= 0:ts:100;
figure(2)
lsim(Wyr_r,10*t,t);
%% altro metodo applicando pade
ret = pade(E,10);
L3= K0*P0*ret*C0;
Wyr_r2 = minreal(L3/(1+L3));
figure(1)
step(Wyr_r2,Wyr_r,Wyr_r_fr , Wyr0);
legend ; 
grid on






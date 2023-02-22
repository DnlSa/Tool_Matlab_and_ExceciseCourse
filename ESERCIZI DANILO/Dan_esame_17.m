clc
clear all
close all

%%
T = -0.05;
s = tf('s');
P0 = ((-s+10)/((s+5)*(s^2+5*s+10)));
rit = exp(T*s);
P = P0*rit;

pole(P0)
% -5.000000000000004 + 0.000000000000000i
% -2.499999999999997 + 1.936491673103707i
% -2.499999999999997 - 1.936491673103707i

%% richieste 

% sovraelongazione inferiore al 20% 
% tempo di assestamento inferiore ai 2 secondi 
% errore a regime limitato per ingressi ramopa

%% Si inizia con il pensare al regime 

C0 = ((s/4+1)^2)/(s*(s/100+1));
k = 10;
L0 = k*C0*P0;
Wyr = minreal(L0/(1+L0));

figure(1)
margin(L0);

figure(2)
rlocus(L0)

figure(3)
nyquist(L0);

figure(4)
step(Wyr);

%% inserisco una rete anticipatrice

alpha = 0.1; 
omega_t = 10;
tau_ra = 1/(omega_t*sqrt(alpha));

k1=12;
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
L1 = k1*C0*P0*Ra;

Wyr1 = minreal(L1/(1+L1));


figure(1)
margin(L1);

figure(2)
rlocus(L1)

figure(3)
nyquist(L1);

figure(4)
step(Wyr , Wyr1);
legend; 

%% applicazzione del ritardo 

ret = pade(rit , 10);
L2 = k1*C0*P0*ret*Ra;
Wyr2 = minreal(L2/(1+L2));

figure(1)
step(Wyr , Wyr1, Wyr2);
legend; 
 

ts = 0.1; 
t = 0:ts:100
figure(2)
lsim(Wyr2,t,t)

% 5% 0.05 -> 1/0.05 -> 20 
% P0 = 10((-s/10+1)/(5*(s/5+1)*((s^2)/5+s+2)));
% guadagno statico kp 10/5 = 2
%(1+2*Kc)<= 20 % kc > 19/2 













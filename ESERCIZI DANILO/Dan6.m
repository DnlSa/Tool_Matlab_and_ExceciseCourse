clear all 
close all 
clc
%%
%tempo di assestamento il più piccolo possibile
%overshoot < 20% -> non ho sovraelongazoni 
%errore a regime < 5% -> ho fatto l errore nullo 

s = tf('s');
P = (s+1)/(s*(s+2)*(s+4));

[num , den] =  tfdata(P);

myRouth(den{1}); % sitema stabile semplicemente per via di un polo in 0 

%% L'Errore a regime per ingressi a step e nullo in quanto presenta gia un polo in 0
%% vediamo le specifiche nel transitorio 
% inserisco una rete anticipatrice cosida riuscire ad aumentare la omega di
% taglio tenendo un margine fase che mi garantisca un overshoot <20%

K= 20 ;% gain
L0= K*P;

figure(1)
rlocus(L0);

figure(2)
margin(L0);

figure(3)
nyquist(L0);

Wyr= minreal(L0/(1+L0));
figure(4)
step(Wyr);
%% agiungiamo una reta anticipatrice per alzare le fasi e aumentando il guadagno riusciremo a rendere il sistema piu veloce 
alpha= 0.01;
w_ra= 50;
tau_ra= 1/(w_ra*sqrt(alpha));
K=1000;
Ra =(1+tau_ra*s)/(1+tau_ra*alpha*s);


L1= Ra*P*K;


figure(1)
bode(L0,L1);
grid on 
legend('L0','L1');

figure(2)
margin(L1);

Wyr1=minreal(L1/(1+L1))

[num , den] =  tfdata(Wyr1);

myRouth(den{1}) % sitema stabile semplicemente per via di un polo in 0 

figure(3)
step(Wyr1);


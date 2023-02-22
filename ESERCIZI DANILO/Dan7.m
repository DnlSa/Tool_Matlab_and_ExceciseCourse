clear all 
close all 
clc

%riferimento a rampa, errore nullo
%tempo di assestamento il più piccolo possibile
%overshoot < 20%
%margine di fase >= 60 gradi

s = tf('s');
P = (s-1)/(s*(s^2+3*s+1));% e a fase non minima presentando uno zero in 1 

[num,den]= tfdata(P);
myRouth(den{1})


%% aggiustiamo l errore limitato a regime 

C0=((s/0.1+1)^2)/(s*((s/100+1)^2)); % gia mi presenta un polo in 0 dalla funzione di trasferimento se desidero errori nulli a regime 
% devo avere almeno 2 poli in 0 
K=-1/100;
L0 = K*C0*P;
[num,den]= tfdata(L0);
myRouth(den{1}) ;
 
time = [0:0.1:50];
Wyr= minreal(L0/(1+L0));

figure(3)
rlocus(L0)

figure(1)
margin(L0);
grid on;

figure(2)
nyquist(L0);

%% rete anticipatrice per riuscire a rendere piu veloce il sistema 
% alpha= 0.1;
% w_ra = 10;
% tau_ra = 1/(w_ra*sqrt(alpha));
% Ra= (1+tau_ra*s)/(1+alpha*tau_ra*s);
% K1=-1/10;
% L1= K1*C0*P*Ra;
% 
% figure(1)
% bode(L0, L1);
% legend('L0','L1');
% grid on;
% 
% figure(2)
% margin(L1);
% grid on;


%% inseriamo un filtro in ingresso per rendere piu smooth il sistema
tau_fr= 50/3;
Fr = 1/(tau_fr*s+1);
Wyr1= Fr*Wyr;

%% simulazione ingresso rampa
figure(5);
lsim(Wyr1,time ,time);
grid on;
% simulazione ingresso gradino
figure(6)
step(Wyr1);

%%
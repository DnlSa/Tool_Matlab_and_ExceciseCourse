%% Procedura eseguita dal professore


clc
clear all
close all

s = tf('s');

%% Processo nominale datoci 
P = (s-5)/(s^2 + 4);
pole(P)
figure(1)
rlocus(P)

%NOTE 
% Abbiamo un processo a fase non minima e semplicemente stabile  questo potrebbe darci problemi
% grossi inoltre abbiamo 2 poli sull asse immaginario 
%% SPECIFICHE A REGIME  

C0 = 1/s ; % ci assicuriamo che per riferimenti a gradino unitario abbiamo errore nullo
L0  = P*C0;

figure(1)
rlocus(L0);
% NOTA 
% cio ancora non ci basta per stabilizare il sistema allora iniziamo il
% vero design del controllore inoltre da qui possimo iniziare a vedere se
% ci e piu comodo adottare un guadagno positivo o negativo in base alle
% traiettorie percroso dal mio sistema all aumentare del guadagno 
% Abbiamo appurato che ci conviene adottare un guadagno negativo in quanto
% i rami sono piu facilmente attraibili con degli zeri .
%% CONTROLLORE PER STABILIZZARE IL SISTEMA 
% avendo questi poli immaginari nel processo ci e piu comodo adottare 
omega_n =  2 ; % pulsazione naturale MAGGIORE DI 0 
zita = 0.7; % coefficente di smorzamento  MAGGIORE DI 0 
kg = -0.865; % guadagno statico 
C1 = kg*(s^2+2*zita*omega_n*s+omega_n^2)/(s*(s/500+1)^2);
L1 = minreal(C1*P);
Wyr1= minreal(L1/(1+L1))
pole(Wyr1)
% 
 figure(1)
 rlocus(L1)
% 
 figure(2)
 margin(L1)
% 
 figure(6)
 nyquist(L1)

figure(3)
step(Wyr1,10)

%% vediamo di migliorare le performance con un filtro segnale 

tau_fr = 1/3;
Fr = (1/(tau_fr*s+1))

Wyr2=Wyr1*Fr; 
figure(3)
step(Wyr1,Wyr2)

%abbiamo muigliorato la nostra performance assicurandoci una
%sovraelongazione limitata



clc
clear all
close all

s=tf('s');
P=-(s+5)/(s*(s^2 + 4*s +2));

pole(P)
% Assicurare errore nullo per riferimento a rampa
% Overshoot più piccolo possibile
% Tempo assestamento più piccolo possibile

%% Controllore con errore nullo per riferimenti rampa

% APPROSSIMO IL CONTROLLORE  CANCELLANDO I POLI PRESENTI NEL SEMIPIANO DX 
%C0 = (s^2 + 4*s +2)/s; 
C0 = 1/s; 
K=-1;
L0 = K*P*C0;

figure(1)
rlocus(L0)
 
%% POSIZIONIAMO UN CONTROLLORE CON 2 ZERI IMMAGINARI COSI DA POTER SISTEMARE I RAMI 

k1=-200;
C1= ((s/0.6+1)*(s/12+1)^2)/((s/50+1)*(s/100+1));


L1=k1*P*C0*C1;
Wyr=minreal(L1/(1+L1))
pole(Wyr)
% 
 figure(1)
 rlocus(L1)
%  
 figure(2)
 margin(L1)
% %  
  figure(3)
  nyquist(L1)
% 
 figure(4)
 step(Wyr)

%% vedo come va con un filtro 
tau_fr= 1/30;
Fr = 1/(tau_fr*s+1)
Wyr2 = minreal(Wyr*Fr)
figure(1)
step(Wyr2,Wyr)
% non va bene per le rampe perche introduce errore limitato 

%% simulazione rampa 
ts = 0.1;
t = 0:ts:100;
figure(2)
lsim(Wyr1,t,t)



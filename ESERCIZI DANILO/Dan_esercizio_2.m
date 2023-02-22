clear all 
close all 
clc

%% Processo nominale 

s= tf('s');% dichiarazione della variabile  s
P0 = (s+1)/(s*(s+2)*(s-4)); % processo nominale

% consideriamo un 
% errore nullo per riferimenti rampa 
% overshoot inferiore al 20% 
% rise time inferiore al 3 secondi Ta,5 < 3 secondi 
%% controllore primario 
k=50;
C0  = (s/0.5+1)/(s/500+1) ; 
L0 = k*P0*C0;


Wyr = minreal(L0/(1+L0))

figure(1)
rlocus(L0)

figure(2)
step(Wyr,20)

figure(3)
nyquist(L0)

figure(4)
margin(L0)






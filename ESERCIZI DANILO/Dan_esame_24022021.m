clc
clear all
close all

% S% < 20% con errore nullo per riferimenti costanti

s = tf('s');
P = -0.2*(s+1)/(s*(s-2));

pole(P)  % 0 2 Sistema Instabile 

%% Comportamento a Regime  
% si desidera errore nullo per riferimenti costanti gia lo abbiamo avendo 
% un polo in 0 

%% STABILIZZIAMO IL SISTMA
K=-120;
L0 = K*P;

Wyr = minreal(L0/(1+L0));

figure(1)
rlocus(L0)

figure(2)
nyquist(L0)

figure(4)
margin(L0)

figure(3)
step(Wyr)
% il sistema va bene cosi





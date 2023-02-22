clc
clear all
close all
%% Esame 4
%errore nullo a rampa
%overshoot < 20%, tempo di assestamento il più piccolo possibile

s = tf('s');
P = (s^2 + 10*s + 5)/(s^2*(s+2));

pole(P) ; % sistema stabile in quanto presenta 2 poli in 0 un polo in -2
zero(P) ; % fase minima

% il sistema quindi e un fase minima di tipo 2 resiste ai riferimenti rampa
% inseguendo il segnale di ingresso su detto con un errore nullo a regime
% avendo gia un sistema di tipo 2 non ci occorre doveer creare un
% controllore che inserisca i poli in quanto li abbiamo già

figure(1)
rlocus(P);
% dal luhogo delle radici vediamo prima di subito che che il sistema
% si comporta molto bene per guadagni anche alti in quanto le radici della
% funzione Wyr convergono a valori negativi 

K=100;
L0  = K*P;

figure(3)
margin(L0)


Wyr = minreal(L0/(1+L0))
figure(2)
step(Wyr);



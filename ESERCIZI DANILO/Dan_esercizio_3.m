
close all 
clear all
clc
%% 
s= tf('s');
P0 = (s/10+1)/((s^3+s+4)*(s/5-1));
kp = dcgain(P0) ; %-0.2500
figure(1)
rlocus(P0)

%% vogliamo erore nullo per riferimenti a gradino 
% primo design del controllore 
zita = 0.9 ; %   0<zita<1 coefficente di smorzamento
omega_n = 1; %   pulsazione naturale 
C0  =  (s^2+s*zita*omega_n*2+omega_n^2)*(s/5+1)/(s*(s/500+1)^2);
% Ho creato un controllore del terzo ordine al numeratore 2 zeri sono nel
% complessi coniugati atti ad attrarre anche con il minor gain possibile i
% 2 poli a positivi a parte reale e immaginaria >0 
% ho inserito un ulteriore 0 in -5 atto ad attrarre i restanti poli su asse
% reale e farli convergere . in seguito aggiusteremo il gain e
% verificheremo tramite il criterio di nyquist l'asintotica stabilità della
% funzione d'anello  e utilizzeremo un ulteriore prova tramite al funzione
% pole
k= 1;
L0 = k*C0*P0;

figure(1) % Risulta soddisfatto 
rlocus(L0)

figure(3) % non devo compiere 3 giri attorno a -1 NON LI FA  
nyquist(C0)

% SOLUZIONE DA SCARTARE 

%% Redesign del controllore 

% il prossimo controllore sarà progettato per avere un errore limitato 
% e abbastanza difficile gestire 3 poli instabili 

C1 = (s/100+1)/(s/500+1);
k1 = 500;
L1 = minreal(k1*P0 *C0);
Wyr1 = minreal(L1/(1+L1));
% pole(Wyr1) poli tutti con parte reale negativa e molto vicini allo 0
% quindi Dalla funzione di sensitività ingresso uscita mi risulta che e
% asintoticamente stabile 
% -6.3763 + 0.0000i
%   -5.0000 + 0.0000i
%   -5.0000 - 0.0000i
%   -3.0460 + 0.0000i
%   -0.2341 + 0.1495i
%   -0.2341 - 0.1495i
%   -0.0415 + 0.0000i
%   -0.0090 + 0.0045i
%   -0.0090 - 0.0045i


Wur = minreal(C1/(1+L1));

figure(1)
rlocus(L1)

figure(2)
margin(L1)

figure(3)
nyquist(L1) % nyquist gira 3 volte intorno a -1 quindi il sistema e A.S 
% secondo il criterio di nyquist

figure(5) % diagramma di bode della funzione di sensitività tra ingresso e controllore 
bode(Wur) % deve comportarsi come un passa basso 

%% inseriamo un filtro segnale 
% per riferimenti a gradino va piu che bene 
tau_fr = 1/20 ; 
% generalmente piu il valore di tau_fr e piccolo e piu l azione filtrante 
% del segnale di entrata e bassa , vale il viceversa 
Fr = 1/(1+tau_fr*s); 
Wyr2 = minreal(Wyr1*Fr);
figure(4)
step(Wyr1,Wyr2)
legend

%% vogliamo dare un certificato all inseguimento ad errore minimo

% Wer  = (1/(1+L0))
% kp = guadagno statico 
% kc = guadagno dato al controllore che agira sul nostro processo nominale
% per stimare l errore dobbiamo adottare il limite del valor finale 
% lim(s->0)s*(Wer)*r(s) = |R0/(1+kp*kc)| <10% R0
%|1/(1+kp*kc)| < 0.1  -> |kc| > 10-1/(kp) -> |kc|> 9/kp
% POS kc > 9/kp -> kc > 36
% il negativo non mi intressa in quanto sto considerando un gain positivo 
% Concludendo per gain maggiori di 36 mi viene assicurato per il teorema
% del limite del valor finale che il mio sistema ha errori inferiori al 10%
% del valore di regime (errore di inseguimento inferiore al 10%)





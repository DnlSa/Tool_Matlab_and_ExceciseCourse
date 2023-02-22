% in questo esercizio vediamo come lavorare sul nostro sistema 
% con ritardo gia dall inizio

clc
clear all
close all

%%
s = tf('s'); % definisco la s
P0 = (s-5)/(s^2+4*s+1); % funzione di impoanto 
r = exp(-1*s); % definiamo un ritardo veramente alto che normalmente sarebbe
% impossibile lavorarci , con il metodo cassico dovrei rallentare il mio sistema cosi che 
% il rapporto per calcolarmi 
% [gm,pm,wg,omega_t]= margin(L0)
% MF= pm*pi/180;
% R_max = MF/omega_t ; % mi da il ritardo massimo ammissibile dal mio
% sistema 

T = pade(r, 10); % approssimamo con pade 
P = P0*T; % definiamo il nostro sistema con ritardo approssimato

figure(1);
margin(P);
grid on;

figure(2);
rlocus(P);
grid on;

figure(3);
nyquist(P);
grid on;
%% Uso un Predittore di Smith per lavorare sull'impianto senza tenere conto del ritardo

M = P0*(1-T); 
Kc = -0.125; % gain 

alpha = 0.1;
w = 1;
tau_ra = 1/(w*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+alpha*tau_ra*s); % rete anticipatrice 
C = (Kc/s)*Ra; % messa nel controllore direttamente per una questione di semplicità
L1 = minreal(C*M + C*P); % funzione d anello C*M e la parte con il predittore smith
Wyr1 = minreal(P*C/(1+L1)); % calcolo funzione di anello chiuso 

tau_fr = 4.5/3;
Fr = 1/(1+tau_fr*s);
Wyrr = Fr*Wyr1;



figure(1);
margin(L1);
grid on;

figure(2);
rlocus(L1);
grid on;

figure(3);
nyquist(L1);
grid on;

figure(4);
step(Wyr1,Wyrr);
legend;
grid on;

%% Analisi funzioni di trasferimento
Wer = minreal((1-P*C*(1-Fr))/(1+L1));
Wur = minreal(Fr*C/(1+L1));

Wyd1 = minreal(P/(1+L1)); % sensitività del disturbo uno con l uscita y 
Wyd2 = minreal(-P*C/(1+L1)); % sensitivita del disturbo due con l uscita y 
Wed1 = minreal(-P/(1+L1)); % 
Wed2 = minreal(-1/(1+L1));

t = 0:0.1:50;
d2 = sin(50*pi*t); % disturbo d2 ingresso al filtro h
d1 = ones(length(t), 1); % disturbo d1 fra controllore e processo 

figure(1);
bode(Wyr1, Wer, Wur, Wyrr+Wer);
legend;
title("Funzioni di sensitività");
grid on;

figure(2);
bode(Wyd1, Wyd2, Wed1, Wed2);
legend;
title("Funzioni di sensitività dei disturbi");
grid on;

figure(3);
lsim(Wyd1, d1, t);
grid on;

figure(4);
lsim(Wyd2, d2, t);
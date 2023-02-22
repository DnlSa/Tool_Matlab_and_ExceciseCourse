clc
clear all
close all

%% Esame 3
% Errore sotto il 10% (rampa), overshoot < 20%:

s = tf('s');
P = (s+4)/(s^2+9*s-10);;

% Impianto a fase minima (non ci aspettiamo sottoelonazioni), è tuttavia
% instabile a causa della presenza di un polo in +1 (dal Criterio di Cartesio il denominatore 
% non è di Hurwitz). Studiamo le caratteristiche del sistema:

%% Errore nullo a regime per rampa:

C1= 1/s^2;

L1= minreal(C1 * P);

Wyr1= minreal(L1/(1+L1));

figure(1);
margin(L1);
grid on;

figure(2);
nyquist(L1);
grid on;

figure(3);
rlocus(L1);
grid on;

figure(4);
step(Wyr1);
grid on;

%% Sintetizzo il controllore:
Kc= 16.8;

zita= 0.7; % Coefficiente di smorzamento;
w_n= 1;

tau_p1= 1/100;
tau_p2= 1/200;

C2= Kc* C1 * (s^2 + 2*w_n*zita*s + w_n^2)/((1+tau_p1*s)*(1+tau_p2*s));

L2= minreal(C2 * P);

Wyr2= minreal(L2/(1+L2));

figure(1);
margin(L2);
grid on;

figure(2);
nyquist(L2);
grid on;

figure(3);
rlocus(L2);
grid on;

figure(4);
step(Wyr2);
grid on;

% Si osserva (imponendo all'inizio un Kc unitario, poi guardando il luogo
% delle radici) che si può stabilizzare l'impianto (con risultati ottimi)
% grazie a Kc= 16.8dB. Miglioriamo le prestazioni (settling time) tramite
% una rete anticipatrice. Il sistema attraversa a 0db per omega1= 14rad/s.

%% Rete anticipatrice:

alpha = 0.01; 
omega_t = 20; 
tau = 1/(omega_t*sqrt(alpha));
Ra = tf([tau 1],[tau*alpha 1]);

L3= minreal(Ra * C2 * P);

Wyr3= minreal(L3/(1+L3));

figure(1);
bode(L3, L2);
legend;
grid on;

figure(2);
nyquist(L3);
grid on;

figure(3);
rlocus(L3);
grid on;

figure(4);
step(Wyr3);
grid on;

% Si nota che il diagramma dei moduli è quasi un passa banda: non va bene 
% perché vogliamo un passa basso. Aggiungiamo un filtro nella zona che
% vogliamo "appiattire" tra 10^0 e 10^1. L'azione di quel polo toglie 20dB
% per decade facendo attraversare prima il diagramma dei moduli.

%% Filtro passa-basso:

tau_p3= 1/5;

C4= L3 * 1/(1+tau_p3*s);

L4= minreal(C4 * P);

Wyr4= minreal(L4/(1+L4));

figure(1);
bode(L3, L4);
legend;
grid on;

figure(2);
nyquist(L4);
grid on;

figure(3);
rlocus(L4);
grid on;

figure(4);
step(Wyr4);
grid on;

%% Proviamo ora a sintetizzare in una maniera differente il controllore:

% Riprendendo il primo root locus, vediamo infatti che c'è un gap appena
% prima del polo in -10. Proviamo ad aggiungere uno zero lì per attrarre i
% rami impropri a più infinito e vediamo che accade:

tau_z5= 1/9;
tau_p5= 1/100;
Kc= 600;

C5= Kc* (1+tau_z1*s)/(s^2*(1+tau_p1*s));

L5= minreal(C5 * P);

Wyr5= minreal(L5/(1+L5));

figure(1);
margin(L5);
grid on;

figure(2);
nyquist(L5);
grid on;

figure(3);
rlocus(L5);
grid on;

figure(4);
step(Wyr5);
grid on;

% Perciò in questo caso non va bene aggiungere uno zero, perché quei due
% rami non ne sono attratti. 
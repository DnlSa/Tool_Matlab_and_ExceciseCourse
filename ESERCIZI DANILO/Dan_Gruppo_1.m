clc
clear all
close all

%% Esame 2:
% errore <= 10% a regime con ingresso a gradino;
% sovraelongazioni <= 20%
s = tf('s');
P = 10*(2-s)/(s*(s+12));

% Impianto instabile a fase non minima. Studiamone le caratteristiche:

figure(1);
rlocus(P);
grid on;

figure(2);
step(P);
grid on;

figure(3);
nyquist(P);
grid on;

% L'impianto prevede già un polo con parte reale nulla, quindi l'errore a
% gradino è soddisfatto. Possiamo passare alla stabilizzazione del sistema:

%% Primo tentativo di stabilizzazione:

% Guardando il luogo delle radici della sezione precedente, intuiamo che
% nel punto di incrocio dei due rami, il gain è di 0.542. In questo punto
% otteniamo il polo dominante più negativo (minimo settling time) e sono
% entrambi puramente reali (sovraelongazioni bassissime). 

Kc= 0.542;

L1= minreal(Kc * P);

Wyr1= minreal(L1/(1+L1));

figure(1);
rlocus(L1);
grid on;

figure(2);
step(Wyr1);
grid on;

figure(3);
margin(L1);
grid on;

figure(4);
nyquist(L1);
grid on;

% Da step(Wyr1): settling time= 2.08;

%% Filtro sul riferimento Fr:
% Utilizzo tale filtro per diminuire la sottoelongazione dovuta al fatto
% che il sistema è a fase non minima:

tau_fr= 0.1/3; 

% Si parte con Settling_time/3. Tuttavia, sebbene tale filtro riesca
% effettivamente a ridurre la sottoelongazione, peggiora il settling time
% (che è del tutto normale). Si possono fare vari tentativi e si vede che
% per certi valori di tau_fr (in questo caso metto 0.1 a numeratore) si
% riesce a diminuire leggermente la sottoelongazione e a ridurre il
% settling time, ma più tau_fr diventa piccolo più, ovviamente, l'effetto
% del filtro diventa trasacurabile (si provi a sostituire per esempio
% 0.01/3). Attenzione: non si usa con riferimenti a rampa, perché il
% sistema non riesce a riprodurre bene la rampa, e quindi seguirà
% asintoticamente il segnale filtrato (che non è la rampa richiesta). 

Fr= 1/(1+tau_fr*s);

L2= minreal(Fr * L1);

Wyr2= minreal(L2/(1+L2));

figure(1);
rlocus(L2);
grid on;

figure(2);
step(Wyr2, Wyr1);
legend;
grid on;

figure(3);
margin(L2);
grid on;

figure(4);
nyquist(L2);
grid on;




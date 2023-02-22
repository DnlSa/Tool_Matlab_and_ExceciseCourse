clc;
close all;
clear all;

% Il test è svolto su Simulink e riportato in Matlab

%% Processo P di un motore
s = tf('s');

KM = 10;
J = 0.1;
c = 2;
P = KM/(s*(J*s+c));
% Errore nullo a regime per riferimenti costanti
% Sovraelongazione < 20%
% Tempo di assestamento < 1s

figure(2)
rlocus(P);
title("P root locus");
grid on;

figure(1)
nyquist(P);
title("P nyquist");
grid on;

figure(3)
bode(P);
title("P bode");
grid on;


%% Catena aperta
% Sebbene il Processo P (motore) possiede un polo nullo, per avere a regime errore = 0 deve essere 
% presente un'azione integrale (polo nullo) nel Controllore C, a causa del disturbo sul controllo 
% (coppia esterna). Per cui:
C1 = 1/s;
L1 = P * C1;

figure(1);
rlocus(L1);
title("L1 root locus");
grid on;

figure(2)
nyquist(L1);
title("L1 nyquist");
grid on;

figure(3)
bode(L1);
title("L1 bode");
grid on;


%% Stabilizzazione
% Si nota che solamente l'azione integrale rende instabile il sistema. Occorre quindi aggiunge
% al numeratore uno zero a fase minima per rialzare la fase. Occorre scegliere uno zero più
% piccolo (meno negativo) del polo -20 del Processo P (motore). L'obiettivo è attrarre il
% luogo delle radice dei due poli complessi coniugati a parte reale positiva al fine di
% renderli più veloci possibili e senza generare altre coppie di poli complessi coniugati

C2 = (s/3+1)/s;
L2 = P * C2;

figure(1)
rlocus(L2, 0:0.001:100);
title("L2 root locus");
grid on;

figure(2)
nyquist(L2);
title("L2 nyquist");
grid on;

figure(3)
bode(L2);
title("L2 bode");
grid on;

% Con un guadagno k = 5 si ha una configurazione soddisfacente


%% Controllore C
kc = 5; % guadagno del controllore 
C3 = kc * C2;
L3 = P * C3;

figure(1)
rlocus(L3, 0:0.001:100);
title("L3 root locus");
grid on;

figure(2)
nyquist(L3);
title("L3 nyquist");
grid on;

figure(3)
bode(L3);
title("L3 bode");
grid on;


%% Verifica prestazioni
W1 = minreal(L3 / (1 + L3));

figure(1)
rlocus(W1, 0);
title("W1 root locus");
grid on;

figure(2)
step(W1);
title("W1 step response");
grid on;


%% Aggiunta azione derivativa
% Occorre l'aggiunta di un'azione derivativa per smorzare le oscillazioni. Dato che il Controllore
% finora progettato era un regolatore PI, si ottiene complessivamente un controllore PID. Si
% riproggetta perciò il Controllore come un regolatore PID

KP = 5;     % 10
KI = 5;     % 10
KD = 0.1;   % 1
N = 100;

% Con l'altra tripla di parametri si ottengono dei risultati davvero otiimi, con un tempo di salita
% l'ordine dei centesimi di secondi e oscillazioni ancora più contenute. Tuttavia, prevedendo 
% l'aggiunta della saturazione sul controllo tali performance non saranno mai raggiungibili in
% quanto richiedoni elevati valori del controllo, che comunque stresserebbero il sistema.
% Inoltre tempi di salita troppo elevati potrebbero amplificare eccessivamente anche disturbi,
% in quanto implica una banda passante troppo elevata

C_P = KP;
C_I = KI *(1/s);
C_D = KD * (s/(s/N+1));

C_PID = C_P + C_I + C_D;
L = P * C_PID;

figure(1)
rlocus(L, 0:0.001:100);
title("L root locus");
grid on;

figure(2)
nyquist(L);
title("L nyquist");
grid on;

figure(3)
bode(L);
title("L bode");
grid on;

% Occorre aggiungere un filtro F per l'azione derivativa


%% Verifica nuove prestazioni - aggiunta Filtro F
W =minreal(L/(1 + L));

F = 1/(s*0.05+1);
W_filter = W * F;
W_filter = minreal(W_filter);

figure(1)
hold on;
rlocus(W);
title("W root locus");
grid on;

figure(2)
step(W,W_filter);
title("W step response");
legend("W", "W_{filter}");
grid on;

clc;
close all;
clear all;

%% Esempio predittore di Smith preso dal libro
s=tf('s');
P0 = 1/(s^2 + 2*s + 1); % P0 = tf(1, [1 1]) ^ 2 processo nominale 
T = 4; % ritardo 

[num, den] = pade(T, 1); % approssimazione del ritardo 
Pade1 = tf(num, den);
Delay = exp(-T*s); % ritardo 

P = P0 * Delay; % processo con rritardo 

C = (s+1)/(s); % C = tf([1 1], [1 0]); controllore 

C_classic = 0.2 * C; % controllore classico 
C_smith = 3.46 * C; % controllore smith

M_pade1 = P0 * (1 - Pade1); % apprissimazione con pade 
M_ideal = P0 * (1 - Delay); % approssimazione classica con il ritardo 


C_smith_pade1 = C_smith / (1 + M_pade1 * C_smith);% controllore con pade e smith 
C_smith_ideal = C_smith / (1 + M_ideal * C_smith); % controllore ideale con smith NO PADE

L_classic     = P * C_classic; % funzione d annello classica 
L_smith_pade1 = P * C_smith_pade1; % funzione con PADE + SMITH
L_smith_ideal = P * C_smith_ideal; % funzione CLASSIC + SMITH

figure(1);
hold on;
nyquist(L_classic);
nyquist(L_smith_pade1);
nyquist(L_smith_ideal);
title("L nyquist");
legend("Classic","Smith pade1","Smith ideal");
grid on;

figure(2)
hold on;
bode(L_classic);
bode(L_smith_pade1);
bode(L_smith_ideal);
title("L bode");
legend("Classic","Smith pade1","Smith ideal");
grid on;

% Nota: viene approssimato solamente il ritardo all'interno del blocco M, in quanto, per essere
% usato nelle f.d.t., ovvero per essere un oggetto realizzabile, deve essere razionale. 
% Il ritardo sul Processo P invece, in quanto vero, non va approssimato con padè. Tale ritardo 
% esiste, è presente, reale, e si manifesta sul sistema così come è


%% Risposta sistema
W_classic     = L_classic     / (1 + L_classic); % sensitivita ingresso uscita CLASSICA 
W_smith_pade1 = L_smith_pade1 / (1 + L_smith_pade1); % sensitività ingresso uscita con PADE+SMITH
W_smith_ideal = L_smith_ideal / (1 + L_smith_ideal); % sensitività ingresso uscita con CLASSIC+SMITH

% SEMPLIFICAZIONI TRAMITE MINREAL
W_classic     = minreal(W_classic); 
W_smith_pade1 = minreal(W_smith_pade1);
W_smith_ideal = minreal(W_smith_ideal);

figure(1);
hold on;
step(W_classic);
step(W_smith_pade1);
step(W_smith_ideal);
title("W step response");
legend("Classic","Smith pade1","Smith ideal");
grid on;


%% Confronto tra uscita predittore di Smith con e senza ritardo
L = P0 * C_smith;
W1 = L / (1 + L);
W2 = L / (1 + L) * Delay;

W1 = minreal(W1);
W2 = minreal(W2);

figure(1);
step(W_smith_ideal,W1,W2, 0:0.01:15);
title("W step response comparison");
legend("W smith ideale","W smith ideale ricalcolata","W smith senza ritardo");
grid on;

% Si nota che nel caso ideale la W è uguale alla W progettata in modo classico alla quale è stato
% aggiunto il ritardo. Tuttavia non è realizzabile ed è necessario utilizzare l'approssimante di padè,
% che degrada le performance complessive, in quanto non si ottiene più la W del caso senza ritardo
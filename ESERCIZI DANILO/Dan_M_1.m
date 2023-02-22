clc;
close all;
clear all;

%% in questo esercizi vediamo il comportamento di un sistema del secondo
% ordine ai vari input del sistema 
% gradino unitario
% impulso 
% pwm

%% Sistema del secondo ordine
Kp = 2;         % Guadagno uscita di P rispetto al controllo u
omega = 2;      % Modulo dei poli. Maggiore è il valore e minore è il tempo di salita (poli più veloci)
zita = 0.6;    % Se =1 i poli sono reali. Maggiore è il valore e maggiore è la sovrelongazione
s = tf('s');
P0= Kp*(omega^2/(s^2+2*zita*omega*s+omega^2))
t = 0:0.01:20;  % Tempo simulazione

figure(1)
rlocus(P0)

%% Simulazioni con diversi controlli

t = 0:0.01:20; % tempo di simulazione 
u = 0.2 * square(2*pi*t, 50);   % PWM

omega_d2 = 2*pi*50 ;  % creazione di un segnale sinusoidale a 50HZ 
u2= sin(omega_d2*t);

% u = t >= 0;   % gradino unitario
% u = t <= 1;   % impulso unitario in ampiezza e durata

figure(1);
step(P0, t);    % gradino unitario
title("gradino unitario")
grid on;
% si assesta intorno al valore del guadagno unitario del mio sistema 
% in questo caso KP =2 allora si assesta intorno a 2 


figure(2)
impulse(P0, t); % impulso unitario in ampiezza e durata
title("impulso")
grid on;

figure(3)
lsim(P0, u, t); % PWM
title("ingresso PWM")
grid on;

figure(4)
lsim(P0, u2, t); % ingresso 50HZ
title("ingresso 50Hz")
grid on;



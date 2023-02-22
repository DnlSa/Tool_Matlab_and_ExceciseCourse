clc
clear all
close all

%% Esame 2:
%errore <= 10% a regime con ingresso a rampa;
%sovraelongazioni <= 20%
s = tf('s');
P = 10*(2-s)/(s*(s+12));

% Sistema a fase non minima (zero in +2) instabile (per il Criterio di
% Cartesio, infatti manca il termine di grado zero). 

%% Studiamo le caratteristiche del sistema:

figure(1);
margin(P);
grid on;

figure(2);
nyquist(P);
grid on;

figure(3);
rlocus(P);
grid on;

figure(4);
step(P);
grid on;

%% Errore a regime per un ingresso a rampa:

C1= 1/s;

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
step(Wyr1, P);
legend;
grid on;

% Notiamo che un polo nello zero si può negativizzare, mentre l'altro parte
% ad uno zero improrpio a più infinito. Vogliamo portare quel ramo a
% transitare, anche per un breve periodo, nel semipiano sinistro. Per
% farlo, proviamo a cancellare il polo più negativo (veloce) che si trova
% in -3.41421 +oJ.

%% Cancellazione polo veloce stabile:


tau_z1= 1/3.41421;
tau_p1= 1/5;

C2= Kc * C1 * (1+tau_z1*s)/(1+tau_p1*s);

L2= minreal(C2*P);

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
step(Wyr2, Wyr1);
legend;
grid on;

% Si nota che ci sono due rami nel semipiano sinistro che "convergono" ad
% uno zero a meno infinito: questo è un problema in quanto il ramo che va a
% più infinito non può intersecarli per andare nel semipiano sinistro.
% Inoltre, non ci sono "spazi liberi" tra il polo instabile in zero e gli
% altri poli, impedendo, quindi, di aggiungere uno zero e sistemarla così.
% Quel che possiamo fare è accartocciare i due rami a meno infinito su uno
% zero stabile e sperare che il polo instabile in zero se ne vada ad uno
% zero improprio a meno infinito.

%% Aggiunta di uno zero ad hoc:

Kc= -1;

tau_z2= 1/3; % Basta che sia dopo ambo i poli stabili;
tau_p2= 1/50;

C3= Kc*C2*(1+tau_z2*s)/(1+tau_p2*s);

L3= minreal(C3*P);

Wyr3= minreal(L3/(1+L3));

figure(1);
margin(L3);
grid on;

figure(2);
nyquist(L3);
grid on;

figure(3);
rlocus(L3);
grid on;

figure(4);
step(Wyr3, Wyr2);
legend;
grid on;

% Notiamo che con un guadagno negativo riusciamo a ribaltare il luogo e a
% creare un gap tra il polo instabile nell'origine e gli altri poli, un gap
% dove è finalmente possibile aggiungere uno zero:

%% Aggiunta zero stabilizzante:

Kc2= 9.9;
tau_z3= 1/0.5;
tau_p3= 1/100;

C4= Kc2* C3*(1+tau_z3*s)/(1+tau_p3*s);

L4= minreal(C4 * P);

Wyr4= minreal(L4/(1+L4));

figure(1);
margin(L4);
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

% Il sistema risulta quindi essere stabilizzato per ingressi a rampa. 

%% Simulazione ingresso a rampa:

time = 0:0.1:100;
y = lsim(Wyr4, time, time);
% Plot inseguimento rampa
figure(1)
hold on
plot(time, y)
plot(time,time)
hold off
legend('Wyr4')
grid on



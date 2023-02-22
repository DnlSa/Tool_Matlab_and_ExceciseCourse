clc
clear all
close all
%% Esame 4
% errore nullo a rampa
% overshoot < 20%, tempo di assestamento il più piccolo possibile

s = tf('s');
P = (s^2 + 10*s + 5)/(s^2*(s+2));

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

% 1) L'errore nullo per la rampa è già garantito dal fatto che il Processo
% stesso presenta un doppio polo nell'origine. 


%% Stabilità asintotica del sistema a ciclo chiuso:

Kc= 80;

L1= Kc*P;

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

%% Simulazione rampa:

time = 0:0.01:1;
u = time;
y = lsim(Wyr1, u, time);
figure(3)
plot(time, u,'b--',time, y,'r-')
legend('U','Y')
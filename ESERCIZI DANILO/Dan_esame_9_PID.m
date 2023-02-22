clc
clear all
close all

%% Esame
%riferimento sinusoidale a 50hz con errore nullo a regime
%margine di fase > 60'
%sovraelongazioni < 20%
%tempo di assestamento il più piccolo possibile

s = tf('s');
P = (1-80*s)/((1+s)*(1+100*s));

kc = dcgain(P) ; 
%% 
% impostiamo la omega
w = 2*pi*50 ; % abbiamo creato la 50 Hz
C0 = 1/s; % per errori costanti a regime 
C1 = 1/(s^2+w^2); % controllore per eliminare la 50Hz
K= 300;



%% controllore pid 
% 
 C1 = 1/((s^2+w^2)); % controllore per eliminare la 50Hz
% syms kp ki kd s
% 
% 
% expand((1-80*s)*(ki+kp*s+kd*s^2));
% expand((1+s)*(1+100*s)*s);
% myRouth([-80*kd+100 , +kd - 80*kp + 101 ,-80*ki + kp + 1  , ki ]);


L1 = C1*P;

kd = 0; 
ki = 0;
kp = 1.1212;
% 
roots([-80*kd+100 , +kd - 80*kp + 101 ,-80*ki + kp + 1  , ki])
N=100;
C2 = (s^2*(kd+kp/N) + s*(kp+ki/N) + ki)/(s*(s/N + 1));

L2 = C2*C1*P; 

Wyr2 = minreal(L2/(1+L2));
figure(1)
step(Wyr2)
grid on

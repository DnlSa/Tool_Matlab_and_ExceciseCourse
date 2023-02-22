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

%% costruzione del riferimento 
freq = 2*pi*50
t=0:0.1:100;
u = sin(freq*t);

%% rendiamo stabile al segnale sinusoidale 

w=freq;
C0 = 1/(s^2+(w^2));
L0 = P*C0;
Wyr0= minreal(L0/(1+L0));
figure(1)
rlocus(L0)
figure(2)
lsim(Wyr0,u,t);
hold on 
lsim(P,u,t);
legend;


%%  cediamo di sistemare il sistema in modo da avere errore nullo a regime 
% da qui dobbiamo stabilizzare come se fosse un sistema normale 
C1 =1/s; % errore nullo 
L1 = P*C0*C1;
figure(1)
rlocus(L1) 



%% sistemiamo il luogo delle radici e stabilizziamo il sistema 
k=0.02;
zita = 0.7;
omega_n = 100;
C2 = (s^2+2*s*zita*omega_n+omega_n^2)*(s/0.9+1)/(s/100+1)
L2 = k*P*C0*C1*C2

Wyr2 = minreal(L2/(1+L2));

pole(Wyr2)
figure(1)
rlocus(L2) 

figure(2)
step(Wyr2)
grid on;

figure(3)
margin(L2)

% il sistmea e troppo lento  



%  -0.000000000029775 + 3.141592653639689i
%  -0.000000000029775 - 3.141592653639689i
%  -0.000004089294370 + 3.141565919511371i
%  -0.000004089294370 - 3.141565919511371i
%  -1.000009825321562 + 0.000000000000000i
%  -0.009998168089623 + 0.000000000000000i
%  -0.000041913929682 + 0.000016432651741i
%  -0.000041913929682 - 0.000016432651741i














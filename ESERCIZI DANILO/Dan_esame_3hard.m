clear all 
close all 
clc
%% 

s = tf('s');
P = (s-4)/(s^2+9*s-10);
pole(P); % il processo nominale e instabile
%  -10
%    1
% Overshoot <20%, errore nullo per riferimenti a gradino.
% figure(1)
% rlocus(P)


%% errore nullo per riferimenti a gradino quindi 
C0 =((s/10+1)*(s/1+1))/(s*(s/500+1));
kc=-6;

L0 =kc*C0*P; % strettamente proprio 
Wyr = minreal(L0/(1+L0)); % strettamente proprio 

% pole(Wyr)
% -1.970004684915532 + 0.000000000000000i
%  -0.100000000000000 + 0.000000003561465i
%  -0.100000000000000 - 0.000000003561465i
%  -0.009997657542234 + 0.022565071480106i
%  -0.009997657542234 - 0.022565071480106i

Wur = minreal(C0/(1+L0));
figure(5)
bode (Wur)


figure(1)
rlocus(L0)

figure(2)
margin(L0)

figure(3)
nyquist(L0) % si compie un giro in -1 e mezzo giro in chiusura all infinito 
% per il criterio di nyquist dove ho n giri antiorario intorno a -1 e
% uguale al numero di poli instabili in questo caso -1;

figure(4)
step(Wyr);

%% inseriamo un filtro segnale per  migliorare overshoot 
tau_fr = 4/3; 
Fr = (1/(1+tau_fr*s));
Wyr2 = Wyr*Fr; 
figure(1)
step(Wyr,Wyr2);
legend; 

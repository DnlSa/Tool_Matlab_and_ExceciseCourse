clc
clear all
close all


s = tf([1,0],1);
P0 = 5/(s^2+2*0.6*1*s + 1);
T = 0.1; % 10 secondi 
P = P0*exp(-T*s); % Effetto discretizzazione introduco un ritardo inevitabilmente 

%%  POLI DELLA P0

% pole(P0)
%  -0.6000 + 0.8000i
%   -0.6000 - 0.8000i


%% disturbi a cui e sottoposto il sistema

% d1 = 0.1; % disturbo d1 
% omega_d2 = 2*pi*50; % pulsazione del disturbo d2 a 50HZ
% ts = 0.1;
% time = 0:ts:150;
% r = 1*ones(1,length(time));
% disturbo1 = d1*ones(1,length(time));
% disturbo2 = 100*sin(omega_d2*time);

%% per si costruisce un Filtro per il disturbo D2
N=4; % ordine del filtro di butter
omega_d2_filter = 2*pi*20;  % impostiamo il polo del da cui iniziera l azione filtrante 
[num,den]= butter(N,omega_d2_filter, 's'); % definiamo il filtro 
H = tf(num,den);% si costruisce la funzione di trasferimento del filtro 
% 
% figure(1)
% bode(H) % Controllo della corretta creazione del filtro (PER SICUREZZA)

%% Si desidera un riferimento costante o nullo per rampe quindi :

C0 = ((s/7+1)^2)*(s/2+1)/((s^2)*(s/500+1));
K0 = 400;
L0 =minreal(K0*C0*P0*H);
%L0 =K0*C0*P0;

Wyr = minreal((C0*P0)/(1+L0));
pole(Wyr)

% il luogo delle radici ci sta dicendo che il sistema e asintoticamente
% stabile per range frequenziali 10 rad/s < omega_taglio < 55 rad/s circa
figure(1) 
rlocus(L0)


 % nyquist risulta soddisfatto in quanto viene fatto un giro
 % in senso antiorario e un giro orario tesi ad annullarsi
figure(2) 
nyquist(L0)

% margin mi indica che abbiamo un basso indice di robustezza 
% margine di fase di  23
% margine di guadagno di 4
figure(3)
margin(L0)

figure(4)
step(Wyr)

%% Rete anticipatrice in quanto voglio aumentare la fase in seguito al ritardo che dovrò considerare
alpha = 0.1;
omega_t = 23;
tau_ra = 1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);

%% filtro segnale non utilizzabile in quanto per riferimenti a rampa 
% il segnale filtrato darebbe uno scostamento se pir limitato all
% inseguimento del segnale di riferimento reale 


%% ho un idea provo a sintetizzare un controllore del secondo ordine 
% poi sistemando opportunamente la pulsazione naturale e il coefficente di
% smorzamento riusciamo a sistemare il problema
zita = 0.4;
omega_n =  5 ;
C1 = ((s^2+2*s*zita*omega_n +omega_n^2)*(s/7+1))/((s^2)*(s/500+1));
K1 =7.2;
L1 =minreal(K1*C1*P0*H*Ra);
Wyr1 = minreal((K1*C1*P0)/(1+L1));

% pole(Wyr1) % poli tutti nel semipiano SX ok
% -4.9938 + 0.0000i
%   -1.8525 + 0.0000i
%   -0.9018 + 1.2594i
%   -0.9018 - 1.2594i
%   -0.1366 + 0.8148i
%   -0.1366 - 0.8148i
%   -0.0105 + 0.0574i
%   -0.0105 - 0.0574i
%   -0.0396 + 0.0252i
%   -0.0396 - 0.0252i

figure(1) 
rlocus(L1)

figure(2)
nyquist(L1)

figure(3)
margin(L1)
% marigne di fase 90° circa 
% margine di guadagno un po meno 4,13dB circa

figure(4)
step(Wyr1)
legend; 


%% VEDIAMO QUANTA FASE SI MANGIA IL MIO RITARDO GRAFICANDO IL SISTMEA REAL 
L1_real =minreal(K1*C1*P*H*Ra);
figure(2)
nyquist(L1_real)

figure(3)
margin(L1_real)
legend
grid on 

%% vediamo il ritardo 
[gm,pm,wc,wt] = margin(L1);
MF = pm*pi/180; 
Tmax = MF/(wt)   %0.1075 devo superare 0.1

L1_real =minreal(K1*C1*P*H*Ra);
Wyr1_real = minreal((K1*C1*P*Ra)/(1+L1_real));

% adottiamo pade 
ret = pade((exp(-T*s)),10);
L1_real_pade =minreal(K1*C1*P0*ret*H*Ra);
Wyr1_real_pade = minreal((K1*C1*P0*ret*Ra)/(1+L1_real_pade));

figure(4)
step(Wyr1,Wyr1_real,Wyr1_real_pade);
legend; 


%% verifica della stabilità

%pole(Wyr1_real) IL SISTEMA E STABILE SEMPLICEMENTE PER EFFETTO DEI 2 POLI
%IN 0 
%    0.0000 + 0.0000i
%    0.0000 + 0.0000i
%   -4.9956 + 0.0000i
%   -1.7321 + 0.0000i
%   -0.8423 + 1.1930i
%   -0.8423 - 1.1930i
%   -0.2150 + 0.7800i
%   -0.2150 - 0.7800i
%   -0.0064 + 0.0563i
%   -0.0064 - 0.0563i
%   -0.0365 + 0.0223i
%   -0.0365 - 0.0223i
%   -5.0000 + 0.0000i
%   -0.6325 + 0.0000i
%   -0.0060 + 0.0080i
%   -0.0060 - 0.0080i
figure(1) 
nyquist(L1_real)

% IL Criterio di NYQUIST indica che il mio sistema e Asintoticamente stabile in quanto 
% viene compiuto un giro in senso antiorario in -1 e poi orario annullando
% il primo . il processo iniziale non ha poli con parte reale positiva
% quindi il criterio e soddisfatto 

%% analisi dei disturbi 

d1 = 0.1; % disturbo d1 
omega_d2 = 2*pi*50; % pulsazione del disturbo d2 a 50HZ
ts = 0.1;
time = 0:ts:150;
r = 1*ones(1,length(time));
disturbo1 = d1*ones(1,length(time));
disturbo2 = 100*sin(omega_d2*time);
%L1_real =minreal(K1*C1*P*H*Ra); funzione d anello impianto reale 
% riportata solo per riscrivere le funzioni di sensitività ai disturbi 
Wd2y = minreal(K1*C1*P*H*Ra/(1+L1_real)); % sensitivita del disturbo d2 con y 
Wd1y = minreal(P/(1+L1_real)); % sensitivtà del processo a fronte dei disturbi d1

figure(1)
lsim(Wd1y,disturbo1,time)

figure(2)
lsim(Wd2y,disturbo2,time)







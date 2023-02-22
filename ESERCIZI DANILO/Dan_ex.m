close all 
clear all 
clc


s= tf('s');
T = 1; % valore fittizzio per darlo  in pasto a matlab 
rit = exp(-T*s);
P0 = 1/(s*(0.7*s-1)); % processo nominale 
P = P0 *rit ; 

pole(P0); 
% 
%  figure(1)
% rlocus(P0)


%% errore  a nfinito nullo per ingressi rampa 


%% CONSEIDERAZIONI INIZIALI 
% il mio sistema e un porcesso instabile a fase minima 
% pole(P0)
%        0
%     1.4286

% presetnea gia un polo in 0 quindi il processo e gia di TIPO 1
% dovremmo inserire un ulteriore polo con un controllore 1/s per garantire
% che venga seguito il segnale di riferimento a rampa con errore nullo 

%% MODO 2 (SFRUTTANDO IL TEOREMA DEL VALOR FINALE CHE CONVERGE A 0 )
% consiste nel impostare un controllore di tipo 1 che accoppiato con il
% processo nominale (QUANDO DICHIAREREMO LA FUNZIONE D'ANELLO) in modo che
% i rifeirmenti rampa siano seguiti con errore nullo a regime 

C0  = 1/s; % controllore iniziale di tipo 1 per le specifiche a regime 
kc0 = -1  ; 

L0  = minreal(P0 *C0*kc0);
% figure(1)
% rlocus(L0)

% vediamo di sistemare il luogo delle radici 
zita  = 1; % coefficente di smorzamento (per zita = 1 abbimo 2 zeri coeincidenti sull asse reale )
omega_n =  10 ; % pulsazione naturale

C1  = C0*(s^2+2*s*omega_n*zita +omega_n^2)/(s/500+1); % controllore biproprio

kc1 = 60; 
L1  = minreal(P0*C1 *kc1); % funzione d anello strettamente propria
Wyr1 = minreal((P0*C1*kc1)/(1+L1));

figure(1)
rlocus(L1)
figure(2)
margin(L1)
figure(3)
nyquist(L1)
figure(4)
step(Wyr1)


%% Verifica della stabilità 
% tutti i miei poli sono a parte reale minore di 0 
 pole(Wyr1)
% -398.0368
%   -73.6473
%   -19.3201
%    -7.5672

% seconda certificazione dell asintotica stabilità del mio sistema 
% tramite criterio di nyquist 
% viene compiuto un giro antiorario attorno a -1  
figure(3) 
nyquist(L1)


%% Simulazione del segnale Rampa 
ts = 0.1 ; 
time  = 0: ts : 10;
figure(1)
lsim(Wyr1, time , time)
legend

%% 










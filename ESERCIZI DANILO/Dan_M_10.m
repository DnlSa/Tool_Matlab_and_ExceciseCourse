clc;
close all;
clear all;
%% Processo P a fase non minima
s=tf('s');
kp = -2;
P = kp*(-s+1)/(0.4*s^2+0.7*s+1)
pole(P) ; % processo nominale asintoticamente stabile 
zero(P); % 1 fase non minima 

% Si vuole:
% - errore a regime inferiore al 5% per riferimenti a gradino (R/s)
% - sovraelongazione inferiore al 25%
% - tempo di assestamento al 5% di 2s

% Non occorre aggiungere nessun polo nullo. Dato che il processo presenta un guadagno negativo
% si può considerare di scegliere per C un guadagno negativo così eliminare l'offset di -180° 
% sulla fase del processo P

%% IMPOSTIAMO UN VINCOLO SU I GUADAGNI 

%|R0/(1+kp*kc)|< 5%*R0
% 1/(1-2*KC)<0.05 -> 1-2*KC > 20

% POS ->  KC < 19(1/-2);  KC<-9.50
% NEG ->  KC > (21)*(1/2) ; KC > 10.50

% SE IMPOSTEREMO UN CONTROLLORE DI TIPO 1 QUESTO VINCOLO SARA EVITABILE IN
% QUANTO A REGIME NON DEVO GARANTIRE UN ERRORE LIMITATO MA AVRO UN ERRORE
% NULLO 

%% IMPOSTIAMO IL VINCONO SU LA OMEGA DI TAGLIO DESIDERATA PER RISPETTARE  IL TEMPO DI ASSESTAMENTO 
% troviamo zita
%  (s^2/omega_n^2+2*s*zita/omega_n+1)= (0.4*s^2+0.7*s+1)
%1/omega_n^2 = 0.4 -> omega_n = sqrt(1/0.4) -> omega_n = 1.58; 
% zita = (0.7*1.5811)/2 ; zita = 0.553385000000000

epsilon = 5;
zita = 0.55;
T = 2
omega_t_des = -log(0.01*epsilon)/(T*zita)
%omega_t_des = 2.723392975958173
%% costruiamo il controllore 

k0 = -0.3;
zita_c= 0.7;
omega_c= 1;
%C0 = tf([1 1], [100 1]);
C0  = (s^2+2*s*zita_c*omega_c+omega_c^2)/(s*(s/0.7+1));
%C0 = 1
L0 = k0*P*C0;
Wyr = minreal(L0 / (1+L0));

% INSERIAMO UNA RETE ANTICIPADTRICE 

alpha = 0.1;
omega_t = 4;
tau_ra = 1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
k1 = -0.2;
L1 = k1*P*C0*Ra;
Wyr1 = minreal(L1/(1+L1));
figure(1)
rlocus(L1)
 
figure(2)
margin(L1)

figure(3)
step(Wyr, Wyr1)

%% Filtro in feed forword

Ff = 1/350 *((0.4*s^2+0.7*s+1))/((s/100+1)*(s/50+1));
Wyr2 = Wyr1+minreal(P*Ff/(1+L1));
% non migliora le prestazioni :(

%% INSERIAMO UNA FILTRO SEGNALE 
tau_fr = 10/3; 
Fr  = 1/(tau_fr*s+1);
Wyr_filter = minreal(Wyr1*Fr) ; 

% rallenta troppo il sistema a :(


%%  Verifica delle prestazioni 

pole(Wyr1);
%  RADICI DELLA FUNZIONE INGRESSO USCITA OK 
%  -5.233694634150188 + 0.000000000000000i
%  -0.987371086012717 + 2.247145060593276i
%  -0.987371086012717 - 2.247145060593276i
%  -0.445336917248950 + 0.287215086684650i
%  -0.445336917248950 - 0.287215086684650i

[num,den] = tfdata(Wyr1);
myRouth(den{1});

figure(3)
step(Wyr, Wyr1,Wyr_filter, Wyr2)
legend

figure(4)
nyquist(L1) % non vengono compiuti giri attorno a -1  OK 

%
% Si vuole:
% - errore a regime inferiore al 5% per riferimenti a gradino (R/s) -> OK
% GARANTITO IN FORZA DEL LIMITE DEL VALOR FINALE IMPOSTANDO UN CONTORLLORE
% DI TIPO 1 

% - sovraelongazione inferiore al 25%
% GARANTITO DA STEP 

% - tempo di assestamento al 5% di 2s
% NON SONO RIUSCITO A SODDISFARLO HO UN SETTLING TIME DI 6.66 SECONDI 




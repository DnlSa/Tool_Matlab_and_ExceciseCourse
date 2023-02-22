clc;
close all;
clear all;


%% Processo P
Kp = 2;
s= tf('s'); %s = tf([1 0], 1);
P1 = (s+1)/(2*s^2+s+1);
P2 = 1/(0.1*s+1);
P3 = 1/(0.05*s+1);
P0 = Kp * P1 * P2 * P3
T = 0.3;    % Ritardo in secondi
Delay = exp(-T*s);
P = P0 * Delay;

% Si vuole:
% - errore a regime in modulo < 0.05 (5%) <- NON serve aggiungere un polo nell'origine
% - tolleranza a ritardi di 0.3s;
%   - significa che il rapporto tra margine di fase e la frequenza di taglio
%     deve essere maggiore del ritardo 
% Se possibile:
% - sovraelongazione < 20%
% - tempo di assestamento < 3s
%% Errore a regime 
% ci viene questo un erore a regime inferiore a 5%
% dobbiamo porre dei vincoli al guadagno per assicurarci un errore a regime
% USIAMO IL LIMITE DEL VALOR FINELA lim(s->0)s*Wer(s)*r(s)
% r(s) -> varia in base all ingresso nell impianto che abbiamo 
% generalmente se l'ingresso e a gradino e noi abbiamo una funzione d
% annello di tipo uno avremo il nostro errore limitato a regime 
% |R0/(1+kp*kc)|<5%R0 ->(1+KP*KC)>1/0.05 -> KC > (20-1)/KP
% KP = 2
% POS -> KC>(20-1)/2 -> KC>9.50
% NEG -> KC<(-20-1)/2 -> KC <-10.50
% ABBIAMO IL NOSTRO VINCOLO

kc = 10.5;
L0 = P0*kc;

figure(1)
rlocus(L0)

figure(2)
margin(L0)

%% SODDISFIAMO I TRANSITORI

kc = 9.5;
C0 = (s/1+1)*(s/15+1)/((s/500+1)*(s/1000+1));
L1 = C0*P0*kc;
Wyr = minreal(L1/(1+L1));

figure(1)
rlocus(L1)

figure(2)
margin(L1)

figure(3)
step(Wyr)
%% vediamo di ritardare le fasi 
w = 1; % omega di taglio desiderata 
alpha = 0.1; % facciamo agire una decade prima 
tau_rd =10;% come scegliamo ->  tau_ra >> omega_t
Rd = (1+alpha*tau_rd*s)/(1+tau_rd*s); % 
kc2 = 9.5;
L2= C0*P0*kc2*Rd;

Wyr2 = minreal(L2/(1+L2));

figure(1)
margin(L2)

figure(2)
step(Wyr2,Wyr);
legend


%% veidiamo il ritardo (prima della rete ritardatrice )
[GM,PM,WC,WT]=margin(L1);
mg = PM*pi/180;  %1.323161488289863
T_max = mg/WT  %0.010927637336010 < 0.3 -> NON VA BENE 

%% veidiamo il ritardo (dopo la rete ritardatrice 
[GM_1,PM_1,WC_1,WT_1]=margin(L2);
mg_1 = PM_1*pi/180;  %1.323161488289863
T_max_1 = mg_1/WT_1  %0.552723864536934 > 0.3 -> VA BENE 
% il sistema e stato rallentato abbastanza per poter sopportare il ritardo 

L3 = C0*P*kc2*Rd;

Wyr3 = minreal(L3/(1+L3));

figure(2)
step(Wyr2,Wyr,Wyr3);
legend
 
% nonostante il abbia inserito una rete ritardatrice atta a sistemare il
% ritardo questo sovraelonga creando dei moti armonici smorzati non e stato
% possibile migliorare ulteriormente 




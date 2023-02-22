clc
clear all
close all
%% 
% overshoot inferiore al 20% 
% errore a regime nullo per riferimenti a gradino 
% errore riferimento sinusoidale con errore inferiore del 10% per 
% omega_bar= 1

%Colonna 2, ES1
s = tf([1 0],1);
P0 = (s-5)/(7*s^2 + 2*s+8);
rit = exp(-0.1*s);
P = P0*rit;


%% iniziamo con il determinare l errore nullo a regime 
C0 = 1/s; 
K=-1;
L0 = K*C0*P0;
figure(1)
rlocus(L0)

%% PROVIAMO SUBITO A INSERIRE DUE ZERI 
zita = 0.3;
omega_n = 1;
C1 = (s^2+zita*s*omega_n*2+omega_n^2)/(s*(s/1000+1));
% K=-3; % con questo guadagno e perfetto 
K=-3;
L1 = K*C1*P0;
Wyr1 = minreal(L1/(1+L1));

figure(1)
rlocus(L1)
 
 figure(2)
 margin(L1)

% figure(3)
% nyquist(L1)

figure(4)
step(Wyr1)


% %% inseriamo una rete anticipatrice per migliorare le fasi 
% 
% alpha = 0.1;
% omega_t  = 5;
% tau_ra = 1/(omega_t*sqrt(alpha));
% Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
% K2=-1/2
% L2 = K2*C1*P0*Ra; 
%  figure(2)
%  margin(L2)
% NOTA : usando una rete anticipatrice si genera un enorme problema con le
% fasi
% impostiamo un filtr segnale per migliorare il transitorio 

tau_fr = 1/3; 
Fr = 1/(tau_fr*s+1);
Wyr1_filter = Wyr1*Fr;
figure(1)
step(Wyr1_filter,Wyr1);
legend


% % inseriamo un filtro in feed forword (inutile)
% Ff  = 1/300*((7*s^2 + 2*s+8))/((s/1000+1)^2)
% Wyr3 = Wyr1_filter+minreal(Ff*P/(1+L1))

% vediamo l impianto reale 
[gm, pm , wc ,wt]= margin(L1);
MF = pm*pi/180;
T_max = MF/wt  % 0.378656013766905
L2 = K*C1*P;
Wyr1_rit = minreal(L2/(1+L2));
W_ritardo= Wyr1_rit*Fr;
figure(4)
step(W_ritardo, Wyr1)
legend
grid on 



%% analisi della stabilita del sistema 

% pole(Wyr1)
% sistema ASINTOTICAMENTE STABILE 
%  -2.823975381404773 + 0.000000000000000i
%  -0.016966635564312 + 0.012871434913425i
%  -0.016966635564312 - 0.012871434913425i
%  -0.002091347466609 + 0.000000000000000i

figure(1) % IDEALE
nyquist(L1)%  IL CRITERIO DI NYQUIST E SODDISFATTO 

% pole(Wyr1_rit) % anche processo reale il sitema e STABILE 
%  0.000000000000000 + 0.000000000000000i
%  -5.000000000000001 + 0.000000000000000i
%  -2.823975381404771 + 0.000000000000000i
%  -0.016966635564312 + 0.012871434913425i
%  -0.016966635564312 - 0.012871434913425i
%  -0.001428571428571 + 0.010594569267279i
%  -0.001428571428571 - 0.010594569267279i
%  -0.002091347466609 + 0.000000000000000i

figure(1) % RITARDATA
nyquist(L2) %% IL CRITERIO DI NYQUIST E SODDISFATTO NESSUN GIRO ATTORNO A -1

%% anche qui analizziamo al wer per errore di riferimento sinusoidale 
% inferiore al 10% 
Wer = minreal(1/(1+L1));
figure(1)
bode(Wer);
grid on 
% K =6 RISLTEREBBE SODDISFATTO PERO IL RITARDO NON RISULTEREBBE SODDISFATTO 
% -12.4db ---  quindi 10^(-17.4/20) -> 13% SUPERIORE AL 10% RICHIESTO
% NON VA BENE 
% LA PROCEDURA E ANDARE SUL GRFICO DELLA WER vedere a che corrisponde in dp
% 10^0 = 1 = omega_bar e rigirare la formula  xDB= 20*log10(k)
% k = *10^(xdb/20) -> k valore che cerco e poi esprimerlo in % 
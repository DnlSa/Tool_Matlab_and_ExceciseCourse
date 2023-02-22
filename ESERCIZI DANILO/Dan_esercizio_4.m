clear all
close all 
clc

%% processo nominale 

s = tf ('s');
k = 4; 
P0 = k*(s+1)^2/(s*(s-1)*(s+2)*(s+3))

disturbo2 =  2*pi*50;  % disturbo sinusoidale in  entrata 
disturbo1 = 40 ;  % distrubo costante in entrata 



%% richieste 
% sovralongazioni inferiori al 20% 
% tempo di asssesstamenteo inferiore a 3s
% errore nullo per riferimenti a rampa 


%% prima di tutto studiamo le caratteristiche del nostro processo nominale 

% pole(P0)
%         0
%    -3.0000
%    -2.0000
%     1.0000
% il processo e instabile presentando un polo in +1

% zero(P0)
%     -1
%     -1
% il nostro processo e a fase minima in quanto non ha poli a parte reale
% positiva

% il processo assegnatoci inoltre e di tipo 1 quindi se necessitiamo di un 
% errore a regime nullo dobbiamo aggiungere un altro polo in 0 

%%  Soddisfiamo le specifiche a regime 

C0 =1/s ;  % ci assicura che l errore a regime sia nullo  (TEOREMA DEL VALOR FINALE)

%% inserimento di un filtro H per il disturbo d2
omega = 2*pi*20; 
N = 10;
[num_H,den_H] = butter(N,omega,'s');
H = tf(num_H,den_H)
figure(1)
bode(H)

%% costruisco la funzione d'anell aperto e ne studiamo il luogo
K0 = 1 ; % GUADAGNO DEL CONTROLLORE 
L0 = minreal(C0*P0*H); % FUNZIONE D'ANELLO 
L0_0 =  minreal(C0*P0); % FUNZIONE D'ANELLO NON FILTRATA 

Wyr  = minreal(C0*P0/(1+L0)); % FUNZIONE DI SENSITIVITà INGRESSO USCITA
% NON ANCORA UTILIZZABILE. 

figure(1)  % PER RENDERE PIU COMPRESNBILE LA FUNZIONE D'ANELLO GRAFICO UNA
% FUNZIONE NON FILTRATA IN QUANTO IL  FILTROP BUTTER INSERIREBBE UNA SERIE
% DI POLI TUTTI SU LA CIRCONFERENZA UNITARIA
rlocus(L0_0);


%% CONTROLLORE PER MIGLIORARE LE PRESTAZIONI DEL MIO SISTEMA 
K1 = 2.5;
zita = 1; % aumentando la zita i 2 poli sotto inseriti convergono in prossimità dell' asse reale 
% cio ci aiuterebbe a rendere il transitorio del nostro sistema con
% sovraelongazioni limitate . 


omega_n  = 3 ; 
C1 = (s^2+2*omega_n*zita*s+omega_n^2)/(s/500+1);

L1 = minreal(K1*C0*P0*H*C1); % FUNZIONE D'ANELLO 
L1_0 =  minreal(K1*C0*P0*C1); % FUNZIONE D'ANELLO NON FILTRATA 

Wyr1  = minreal((K1*C0*P0*C1)/(1+L1)); % FUNZIONE DI SENSITIVITà INGRESSO USCITA

figure(1)
rlocus(L1) % con una omega di taglio di circa 10rad/s abbiamo la nostra
% minor sovraelongazione possibile . contemplando anche un filtro H

figure(2) % NYQUIST CI ASSICURA CHE IL PROCESSO E ASINTOTICAMENTE STABILE 
nyquist(L1) 
% VENGONO COMPIUTI N=1 GIRI ATTORNO A -1 QUANTI SONO I POLI NEL SEMIPIANO 
% DX del nostro processo nominale instabile 

figure(3)
margin(L1)
% tramite il diagramma di bode ci asscuriamo un omega taglio di 10 rad/s
% margine di fase accettabile e margine di guadagno buono (deducibili facilmente anche da nyquist)

figure(4)
step(Wyr1)
%% 
% il nostro impianto si comporta benino ma ancora non va bene dobbiamo
% migliorare le prestazioni
% In questo caso potremmo vedere di usare una rete anticipatrice anche se
% con delle prove gia effettuate il nostro sistema e molto sensibile all
% aumento di guadagni quindi i nostri passi saranno : 
% inserire una rete 
% agire sul guadagno di controllore in modo da limitare un omega di taglio
% troppo alta e quindi l instabilità

alpha = 0.3 ; 
omega_t = 11 ; 
tau_ra = (1/(omega_t*sqrt(alpha)));
K2 = 1.2;
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
L2 = minreal(K2*C0*P0*H*C1*Ra); % FUNZIONE D'ANELLO 
Wyr2  = minreal((K2*C0*P0*C1*Ra)/(1+L2)); % FUNZIONE DI SENSITIVITà INGRESSO USCITA

%  pole(Wyr2) % poli dela funzion d'anello chiuso 
%   -5.0000 + 0.0000i
%   -5.0000 - 0.0000i
%   -1.6508 + 0.0000i
%   -1.4704 + 0.6639i
%   -1.4704 - 0.6639i
%   -1.0174 + 1.1163i
%   -1.0174 - 1.1163i
%   -0.4873 + 1.2562i
%   -0.4873 - 1.2562i
%   -0.1579 + 1.2143i
%   -0.1579 - 1.2143i
%   -0.1338 + 0.2826i
%   -0.1338 - 0.2826i
%   -0.0180 + 0.0250i
%   -0.0180 - 0.0250i
%   -0.0300 + 0.0000i
%   -0.0300 - 0.0000i
%   -0.0167 + 0.0000i
%   -0.0069 + 0.0000i

figure(3)
margin(L2)

figure(4)
step(Wyr2,Wyr1);
legend; 

% la nuove prestazioni sono un po peggiorate pero ne abbiamo aumentato in
% modo considerevole il margine di fase . 
% il margine di guadagno rimane sempre un po bassino  . 


% %% per milgiorare ulteriormente le prestazioni non possiamo adottare un filtro in feed forward 
% P0 = k*(s+1)^2/(s*(s-1)*(s+2)*(s+3))
% k_f = 1/45; % approssimazione del filtraggio piu e alta e piu l azione filtrante e rilevante 
% Ff = k_f*(s+2)*(s+3)/((s/500+1)^2)
% Wyr3 = Wyr2+minreal(Ff*P0/(1+L2));
% figure(4)
% step(Wyr2,Wyr1,Wyr3);
% legend; 
% SI CANCELLA VERAMENTE POCA ROBA DEL PROCESSO NOMINALE LE COMPONENTI CHE
% GENERANO INSTABILITA E MODI ARMONICI DEBOLMENTE SMORZATI QUINDI
% BYPASSIAMO TALE FLTRO 

% IL FILTRO SUL SEGNALE NON SI POTREBBE ADOTTARE IN QUANTO INTRODURREMO A
% REGIME UN ERRORE LIMITATO PER RIFERIMENTI A RAMPA 


% RICUDENDO LA FORZA DELLA NOSTRA RETE ANTICIPATRICE IL DIAGRAMMA DI BODE
% DELLA FUNZIONE D' ANELLO HA CONSERVATO LA SUA PENGENZA IN PROSSIMITA DELL
%  OMEGA DI TAGLIO E SIAMO RIUSCITI A SISTEMARE IL PROCESSO NEL MODO PIU
%  PULITO POSSIBILE E  CON PRESTAZIONI PIU CHE OTTIME 
% DI SEGUITO ANALIZZIAMO LE SENSITIVITà AI DISTURBI 



%% Analisi dei disturbi

Wd2y = minreal(L2/(1+L2)); % sensitivita del disturbo d2 con y 
Wd2e = minreal(-H/(1+L2));% sensitività del disturbo d2 con la variabile e 
Wd1y = minreal(P0/(1+L2)); % sensitivtà del processo a fronte dei disturbi d1
Wd1e = minreal(-P0*H/(1+L2)); % sensitivita di d1 con e

figure(1);
bode(Wd1e, Wd2e, Wd1y, Wd2y);
title("Funzioni di sensitività dei disturbi");
legend;
grid on;


Ts = 0.01;
t = 0:Ts:100; % definizione di un tempo di simulazione 
d1 = 40*ones(length(t), 1)'; % creazione di un disturno 
d2 = 0.1*sin(2*pi*50*t) + 0.01*randn(length(t),1)';

%vediamo come la risposta ha effetto su d1: dopo 40 secondi viene
%completamente filtrato (un filtro ricordiamo che ha sempre i suoi
%transitori.

figure(3);
subplot(3,1,1)
lsim(Wd1y, d1, t);
title('Sensitivita uscita e disturbo d1')
grid on;
% come la risposta ha effetto su d2 . 
subplot(3,1,2)
lsim(Wd2y, d2, t);
title('Sensitivita uscita e disturbo d2')
grid on;

% infine simuliamo l'ingresso rampa e vediamo come viene inseguito .
subplot(3,1,3)
lsim(Wyr2, t, t);
title('Sensitivita ingresso uscita')
grid on;

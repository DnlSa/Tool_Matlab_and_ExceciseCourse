clc;
close all;
clear all;

fig = 0;

%% Processo P da Test1 con aggiunto un polo nell'origine

s = tf('s')
Kp = 2;         % Guadagno uscita di P rispetto al controllo u
omega = 2;      % Modulo dei poli. Maggiore è il valore e minore è il tempo di salita (poli più veloci)
zita = 0.25;    % Se =1 i poli sono reali. Maggiore è il valore e maggiore è la sovrelongazione
P = Kp *(omega^2/(s^2+2*zita*omega*s));
% Si vuole stabilizzare il sistema con:
% - errore a regime costante a riferimenti a gradino < 1% per riferimenti a gradino
% - Sovraelongazione < 20%
% - tempo di salita <= 1s

%% ERRORE A REGIME 
% Dato che è già presente un polo nell'origine la specifica di errore è già soddisfatta (errore nullo)

%%  DETERMINARE VINCOLO PER AVERE UN SETTLING TIME SPECIFICO 
% possiamo iniziare a determinare un omega di taglio 
% minima che ci assicura il settling time 
% in sostanza definiamo un primo vincolo inviolabile
% T <= -log(0,01*epsilon)/(omega_t *zita) % formula di riferimento 
 epsilon =5; 
 T = 1; % secondi
 omega_taglio_des = (-log(0.01*epsilon))/(T*zita)

% omega_taglio_des =  11.982929094215963  (per tempi di salita inferiori a 1 secondo 
% dobbiamo come minimo avere un omega taglio inferiore  di circa 6 rad/s)

%% di genera il controllore per i transitori 

C0=1;
k = 8.5;
L0 = k*P*C0;

%dobbiamo alzare le fasi per rendere il nostro sistema con sovralongazione 
% accettabile

alpha =0.05;
omega_t = 17;
tau_ra = 1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
L1 = k*P*C0*Ra;
Wyr1= minreal(L1/(1+L1));

Wyr= minreal(L0/(1+L0));
figure(1)
rlocus(L1)

figure(2)
bode(L0,L1)
legend
grid on 

figure(3)
step(Wyr,Wyr1)
legend;
grid on 

%% faccimo un prova se i conti sono gisti

C0=1;
k = 5.45; 
% con un guadagno di 5.45 abbiamo un omega_t di 11.9 rad/s e con tempo di 
% assestamento inferiore al 1 secondo 
L2= k*P*C0*Ra;
Wyr2= minreal(L2/(1+L2));
Wyr= minreal(L0/(1+L0));


figure(2)
margin(L2)
legend
grid on 

figure(3)
step(Wyr2)
legend;
grid on 

figure(4)
nyquist(L2)


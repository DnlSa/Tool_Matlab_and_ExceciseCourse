clear all 
close all 
clc

%% Esame 1
%overshoot <20%
%errore <10% a regime (rampa)
s = tf('s');
P = 4*(s-1)/(s^2+3*s+1); % il polinomio al denominatore e di secondo grado
% cio mi dice che le sue radici sono tutte con parte reale negativa
% per il teorema di nyquist dovrò evitare di fare giri intorno a -1
% il problema e la fase non minima il quale avro uno zero interno al
% percors


roots([1 3 1])
% il sistema e a fase non minima 
% e di tipo 0 quindi se ci viene richiesto un errore a regime limitato
% per ingressi a rampa il controllore dovra avere almento un polo in 0 
% questo per il teorema del valor finale. 
C0 = 1/s; % errore a regime nullo 

L0= P*C0;
Wyr=minreal(L0/(1+L0));


figure(1)
margin(L0);

figure(2)
rlocus(L0);

figure(3)
nyquist(L0);
 
%figure(4)
%step(Wyr);
%% adoperiamo un controllore analitico per riuscire a spostare tutti i poli e gli zeri
% sistemiamo il nostro sistema con 1 polo in 0 questo avrà avra un errore
% nullo per ingressi a scalino ma avrà un errore limitato per ingressi
% rampa 

C1 =((s/0.1+1)^2)/s^2; % controllore biproprio on grado relativo = 0 
k= -1/250;% aggistato quando il sistema e diventato asintoticamente stabile 
L1 = k*C1*P;
Wyr1= minreal(L1/(1+L1));

figure(1)
margin(L1);

figure(2)
rlocus(L1);

figure(3)
nyquist(L1);

figure(4)
step(Wyr1);
%% NOTA
% Per stabilizzare il sistema il diagramma di nyquist della funzione di
% anello deve fare tanti giri intorno a -1 quanti sono i poli giacenti nel
% semipiano DX  in questo caso abbiamo solamente uno ZERO nel semipiano DX
% e cio mi dice che il sistema e a fase non minima. 



%% rendiamo piu smooth il transitorio
% aggiungendo un gradi di libertà
tau_fr = 1/2;
Fr = 1/(1+tau_fr*s);
Wyr2 = minreal(Wyr1*Fr);

[num, den] = tfdata(Wyr1);
roots(den{1}) % secondo il criterio della stabilità  tutti i poli del sistema a ciclo chiuso 
% giacciono sul semipiano SX cio vuol dire che il sistema e 
% ASINTOTICAMENTE STABILE 


figure(4)
step(Wyr2,Wyr1);
grid on  
legend( 'Wyr2', 'Wyr1');


%% si aggiunge un ulteriore grdo di libertà 
% cerchiamo di migliorare i transitori con un filtro in feed forward
% si cerca di costruire un filtro fisicamente realizzabile 
% come lo creiamo ?
% 1)il filtro in feedforward potra cancellare tutto cio che  giace sul 
% sempiano SX -> (s^2+3*s+1)
% 2) aggiungiamo modelliziamo sempre il solito filtro 

tau_ff = 1/50;
Ff =  -1/200*(s^2+3*s+1)/(1+tau_ff*s);
Wyr3 = Wyr2+minreal((Ff*P)/(1+L1));

% grafichiamo e vediamo come si comporta con il nuovo filtro 
figure(1);
step(Wyr3, Wyr2, Wyr1);
legend;
grid on;

%% vediamo la risposta del sistema al gradino
time = 0: 0.1 : 50 ; % vettore di tempi lsim(Wyr , time, time);
figure(1);
lsim(Wyr3, 10*time , time);
legend;
grid on;

%% vediamo come funziona il ritado di tempo 
rit = exp(-0.01*s); 
alpha = 0.01; % ripresa dal ritardo 
omega_tau = 0.5; % omega taglio  vista da margin
tau_ra  = 1/(omega_tau*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
L2 = k*P*C1*rit;
Wyr4 = minreal(L2/(1+L2));

figure(1)
step(Wyr4 ,time );
grid on

figure(2)
nyquist(L2);

figure(3)
margin(L2);



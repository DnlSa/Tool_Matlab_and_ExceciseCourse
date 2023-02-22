clear all
close all 
clc

%% FAR VEDERE L ESERCIZIO


s = tf([1 0],[1]);
P = 4/(s^2+3*s+1)

[num,den] = tfdata(P);
roots(den{1}) ; 
% -4.791287847477920
%  -0.208712152522080
% sistema asintoticamente stabile 

myRouth(den{1})


%Progettare C(s) tale che il sistema di controllo
% assicuri una sovraelongazione minore del 20%.
% errore nullo a regime per ingressi scalino ; 
% con epsilon = 5 significa che in un secondo e mezzo devo arrivare al 95%

%% DESIGN DEL CONTROLLORE (SPECIFICHE A REGIME )
% definiamo prima le specifiche a regime la funzione d impianto e di tipo 0
% e quindi per ingressi a scalino per avere errori a regime nullo dovremmo
% seguitare a mettere un polo nell origine nel controllore 

% in caso di ingressi a rampa ci occorrevano 2 poli nell origine
% complicando ulteriormente la situazione 

C0 = (1/s); 
L0= P*C0;
% 
 figure(1)
 margin(L0); % vediamo subito i margini di fase e guadagno
% 
% Wyr0 = minreal(L0/(1+L0));
% figure(2)
% step(Wyr0); % si nota che  all infinito il sistema diverge dobbiamo sistemare questo problema


%% Design del controllore (SPECIFICHE NEL TRANSITORIO)
% pho dei margini di fase e guadagno adesso che fanno pena potremmo vedere 
% se anticipando in fase e quindi tentare di alzare la fase miglioriamo 
% % come visto 
 alpha_a = 0.08 ; 
 omega_tau = 1 ;  
 tau = 1/omega_tau*sqrt(alpha_a);
% %tau = 10/omega_tau*alpha_a;
 Ra = (1+tau*s)/(1+tau*alpha_a*s);
% 
 C1 = C0*Ra*(1/(s/50+1));
 L1= C1*P;
 figure(1)
 margin(L1);

Wyr1 = minreal(L1/(1+L1));
figure(2)
rlocus(L1);
%step(Wyr1);


%% Provando con le reti non ne cavo nulla il problema e dato dal fatto 
% che il sistema di presenta con pochi margini di fase e guadagno e pure
% nulli , e gia lento di suo e aumentare il guadagno ne sono peggiorerebbe
% le prestazioni 


% con la seguente strategia non va bene in quanto il controllore non e
% fisicamente realizzabile anche se stabilizza bene 

%Cz = ((s/5+1)*(s/0.3+1)*(s/2+1))/((s/50+1)^2); % controllore scelto su la base del luogo delle radici
% aggiungo i poli veloci per rendere il controllore fisicamente realizzabile
K= 5; % guadagno statico 
Cz = ((s/5+1)*(s/0.3+1))/((s/50+1)^2);  % Polinomio analitico con zeri per attrarre poli che tendono ad andare nel semipiano dx
C1 = C0*Cz; % qui vedo il controllore totale se e fisicamente realizzabile 
L2= K*C1*P;

figure(1)
margin(L2); 

Wyr2 = minreal(L2/(1+L2));

[num,den]= tfdata(Wyr2);
myRouth(den{1}) ; % ho verificato che ci la funzione di sensitività ad anello chiuso sia AS
figure(2)
rlocus(L2);
figure(3)
step(Wyr2); % arrivati qui gia va molto bene ho un overshoot inferiore al 20% e un esaurimento dei transitori di 0.5 secondi 

%% aggiungiamo un filtro per rendere piu smooth il transitorio 
tau_fr= 1/20; % scegliere un valore tale da evitare che peggiori la prestazione e 
% cercare di rendere la salita uniforme (inoltre attenua la sovraelongazione )
% di contro mi rallenta un pò il transitorio all inizio
Fr= 1/(1+tau_fr*s);
Wyr3= Wyr2*Fr;
figure(3)
step(Wyr3);



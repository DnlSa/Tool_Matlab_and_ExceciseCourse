%% CONTROLLER DESIGN EXAMPLE - 30 November 2022

clc
clear all
close all
%% 
s = tf([1 0],[1]); % definaiamo la s 

zita_p = 0.7; % definiamo il coefficente di smorzamento 
omega_p = 5; % definiamo la omega n del sistema di secondo ordine 
P  = 10*(s/4+1) / ...
((s/50 + 1)*(s^2/omega_p^2 + 2*zita_p/omega_p*s + 1)) % funzione  d impianto nominale 

figure(1)
margin(P) % grafichiamo  con bode il sistema 



%% Richieste da rispettare 


% errore a regime per riferimenti rampa <= del 10% del valore di regime 
% sovralongazione minore del 20% del valore di regime 
% tempo di salita inferiore ai 2 secondi T_{a,5} <= 2 secondi



%% DESIGN del controllore (iniziamo con il sistemare il nostro sistema a regime ) 
% Approssimiamo ai poli dominanti in quanto ho un polo nel processo che sta
% in -50 e abbastanza lontano da poter essere tolto e mantenere
% attentibilità con il processo originale 
% inseriamo un polo in 0 per avere almento un sistema di tipo 1 in grado di
% inseguire con erroe finito l ingresso r 
C0 = (s/50 + 1)/s ;
L0 = minreal(C0*P)
Wyr0 = minreal(L0/(1+L0));

figure(1)
subplot(2,1,1)
margin(L0)
legend('L0')
subplot(2,1,2)
rlocus(L0) % vediamo come si stanno comportando  i poli e sta tutto bene 

figure(2)
step(Wyr0) % pissiamo osservare che gia siamo sotto i 2 secondi 
legend;


%%  Errore a regime . 
% non abbiamo bisogno di inserire ulteriori poli in quanto tramite il
% limite del valor finale con un sistema di tipo 1 possiamo assicurarci un
% errore 5limitato per riferimenti rampa
%P  = 10*(s/4+1) / ...
%P  = mu_p*(s/zero+1) / ...
kp=10%mu_p=10;  % guadagno statico del mio processo 
% mu_c % Kc -> margine di guadagno da impostare al mio controllore 

% e = lim s->0 ( s * W_er(s) * r(s)) = R /(1+ 10 * Kc)
% |R/(1+10*Kc)| <= 0.1*R  ->  |1 + 10*Kc| > 1/0.1    10*Kc > 10-1  
% Kc > 9/10 ; -> margine di guadagno superiore a 0.9

% R0/(kp*kc)<=0.1*R0;
% kc > 1/(0.1*kp)
%kc > 1; vincolo sul margine di guadagno 

%% 
% possiamo ricavare inoltre la omega_t desiderata invertendo la relazione 
% dataci per il tempo di assestamento
% Ta,epsilon con 
 epsilon =5;
 zita =0.4; 
 T = 2; % secondi
% T <= -log(0,01*epsilon)/(omega_t *zita) % formula delle dispense
omega_t = (-log(0.01*epsilon))/(2*zita); % 3.7 di omega taglio mi assicura un assestamento minore di 2 secondi 


%%  Transitori
% dobbiamo arrivare ad avere una sovraelongazione inferiore al 20% 
% notiamo che il coefficente di smorzamento e 0.4 
% il tempo di assestamento e rucavabile tramite 

%10/(tau_r*alfa_r) <= 3.7 (omega di taglio (anello aperto) desiderata)

alpha_r = 0.37 % facciamo agira la rete una decade prima  della omega taglio che mi sono calcolato su 
tau = 10*(1/(omega_t * alpha_r)); % scelta del tau delal rete ritardatrice 

% rete ritardatrice dove prima agisce lo zero e poi il polo 
% diminuisce l oscillazione dle sistema in quanto attenuameglio i 
% moduli alle frequenza piu alte.
% di contro abbiamo rallentato il sistema 
Rd = (alpha_r*tau*s+1)/(tau*s + 1); 
 
C1 = C0*Rd*(1/(s/100 +1)); % si aggiunge un polo veloce per rendere causale il controllore  
L1 = C1*P; % funzione d anello aperto 

figure(2)
bode(L0,L1);
legend('L_0','L_1')

W =  L1/(1+L1)
figure(3)
margin(L1)

figure(4)
step(W,Wyr0);
legend
grid on

% confrintando gli step vediamo che il sistema e rallentato 
% creando dei problemi al settling time che e diventato di circa 4 secondi 


%% Tempo di assestamento non soddisfatto rioperiamo con un nuovo design 
% SE AUMENTO IL GUADAGNO NON ARRIVO A RIDOSSO DELLA OMEGA DI TAGLIO E HO
% DEI PROBLEMI 
k=1.25 ; % si inserisce un gain
L2 = C1*k*P;

figure(1)
margin(L2)

figure(2)
bode(L0,L2)
legend('L_0','L_2')

W =  minreal(L2/(1+L2));
figure(3)
bode(W);

figure(4)
step(W)
grid on





%% NUOVE Richieste da rispettare 
% 1)errore a regime per riferimenti rampa <= del 10% del valore di regime 
% 2)sovralongazione minore del 15% del valore di regime 
% 3)tempo di salita inferiore ai 2 secondi T_{a,5} <= 2 secondi

%% definiamo la omega taglio 
zita =0.4; % DATO ALL INIZIO 
T = 2; % secondi DATO DAL 3 PUNTO 
epsilon =5; % DATO DAL 3 PUNTO  
omega_t = (-log(0.01*epsilon))/(2*zita) % 3.7 di omega taglio mi assicura un assestamento minore di 2 secondi 

% adesso vigliamo impostare una omega taglio piu grande di 3,7 cosi da
% stare al sicuro con i tempi di assestamento e e anticipando le fasi
% riusciremo a migliorare anche la sovraelongazione 


%% PROVIAMO AD INSERIRE UNA RETE ANTICIPATRICE 

% 1/tau_a approx poco prima la omega desiderata, circa 4.5
alpha_a = 0.1 ; 

alpha_ra =0.1;
omega_tau  =17.7; % ho scelto la 

tau_ra = 1/(omega_tau*sqrt(alpha_ra)) ;
Ra2 = (tau_ra*s+1)/(alpha_ra*tau_ra*s + 1);
% lo zero agice in 1/0.17 = 5.882352941176470
% il polo  1/0.017865975481177 = 55.972314584981206
% sappiamo che in una rete anticipatrice agisce prima lo zero in 5 e poi 
% il polo in 55 
% lo zero aumenta le fasi da 0.5 fino a 55 poi il polo tra 5 e 500 diminuisce le fasi 
% infatti verso una frequenza di 500 nel diagramma delle fasi comincia a
% tornare asintotico a 0 

tau_a =  0.8/4.5; % esce 0.17 ma non vedo molto guadagno in cio 
Ra = (tau_a*s+1)/(alpha_a*tau_a*s + 1); % adottiamo una rete anticipatrice



k=2 ; % guadagno statico 
% e utile fare cosi per rispettare sempre la causalità 
% controllando che ogni controllore sia causale cio ci aiuta a non
% dovercene preoccupare piu di tanto 
C3 = (Ra2*k*C0*Rd)/(s/100 +1); % polo veloce per renderlo cusale
L3 = C3*P; %faccio la funzione ad anello chiuso 

figure(1)
bode(Ra, Ra2)
legend;

figure(2)
bode(L3,L1) % SI NOTA UN RIGONFIAMENTO DA QUANTO E STATA APPLICATA DOVE MI SERVIVA A ME 
legend;


Wyr3 =  minreal(L3/(1+L3));

 figure(3)
 margin(L3)

figure(4)
step(Wyr3,Wyr0);
legend
grid on

% Abbiamo una sovralongazione limitata
% errore a regime limitato 
% tempo di assestamento limitato 

%% Aggiungiamo un ritardo di 100ms 
Prit = P*exp(-0.1*s) 

alpha_a = 0.1
tau_a =  0.8*1/4.5 ; % 0.17
Ra1 = (tau_a*s+1)/(alpha_a*tau_a*s + 1); 

C4 = Ra1*C0*Rd*(1/(s/500 +1));
L4 = C4*Prit;
C5 =  (C4*Ra1)/(s/1000+1);
L5 = C5*Prit
figure(2)
bode(L4,L5)
legend('L_4','L_5')

Wur = minreal(C5/(1+L5));
W =  minreal(L5/(1+L5));
figure(3)
bode(W,Wur)
legend('W','W_{ur}')


figure(4)
step(W)
grid on


%% Input filter (filtro segnale Fr)

C6 =  C5
L6 = C6*Prit
tau = 1/7
F = 1/(tau*s+1);
Wur = minreal(F*C6/(1+L6));

W =  minreal(F*L6/(1+L6));
figure(3)
bode(W,Wur)
legend('W','W_{ur}')

figure(4)
step(W)
grid on


%% Feed-forward

%1/(s/8+1)
Ff = (((s/50 + 1)*(s^2/omega_p^2 + 2*zita_p/omega_p*s + 1))/(10*(s/4+1)));
%Wur?
W_Ff =  W+minreal(Ff*Prit/(1+L6));
figure(3)
bode(W)
legend('W')

figure(4)
step(W)
grid on
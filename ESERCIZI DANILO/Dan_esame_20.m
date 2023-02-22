clc
clear all
close all


% 1) Per ingresso a rampa R0/s^2 voglio un errore inferiore al 10% di Ro
% per la P(s) = (-s+10)/(s+5)*(s^2 + 5s +10) * e^(0.05)

%2) La fdt di sensitività del controllo

%3) Css per asservire segnali di riferimento sinusoidali.

%% RUNNARE IL CODICE PER SEZIONI

s= tf('s')
r =  exp(-0.05*s);
P0= (-s+10)/((s+5)*(s^2 + 5*s +10));
% da notare che l'impianto assegnatomi e un impianto a fase non minima 
% ha uno zero nel semipiano dx che potrebbe creare dei problemi 

[num , den ] = tfdata (P0);

roots(den{1}) % verifico che il mio sistema sia asintoticamente stabile 
% le radici sono 3 , 2 complesse e coniugate ,  1 reale lo spettro quindi 

 

%% modello ingresso Rampa quindi (ci servirà dopo )
% ts = 0.1;
% t = 0: ts : 100;
% lsim(Wyr ,t, t );

%%
% pensiamo a stabililizzare il nostro sistema a regime poi penseremo al
% ritardo 
%% 1 assicuriamoci un errore di inseguimento nullo 
% controllore con 2 poli in 0 per errore a regime nullo 
%C0 = ((s/0.1+1)^2)/s^2; 
%C0 = ((s/4+1)*(s/10+1))/(s*(s/50+1)*(s/100+1));
%C0 = ((s/0.3+1)*(s/4+1))/s^2;  % VARIANTI CON ERRORE A REGINE NULLO 
C0 = 1/s;
% e 2 zeri atti ad attrarre i poli in 0 perche essendo un sistema a fase
% non minima questi andtranno nel semipiano DX
%k=4;
L0= P0*C0;
Wyr = minreal(L0/(1+L0));

% figure(1)
% nyquist(L0);
% 
 figure(2)
 margin(L0)

figure(3)
rlocus(L0)

 figure(4)
 step(Wyr);

%%  ADESSO PENSIAMO AI TRANSITORI E COME RIUSCIRE A MIGLIORARLI 
% La prima idea che ho e quella di aumentare inserire una rete
% anticipatrice (in questa rete prima agisce il polo e poi lo zero )

alpha = 0.1;
w=10;
%w = 1; % VARIANTE 2 (ERRORE A REGIME NULLO )
tau_ra = 1/(1+w*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+alpha*tau_ra*s);
k=5.5; 
%k=1.2; % VARIANTE 2 (ERRORE A REGIME NULLO )
L1 = P0*C0*k*Ra;
Wyr1 = minreal(L1/(1+L1));
figure(1)
nyquist(L1);

figure(2)
%margin(L1)
bode(L1, L0);
legend; 
grid on;

figure(3)
rlocus(L1)

figure(4)
step(Wyr1);
%% INSERISCO UN FILTRINO PER RENDERE IL TRANSITORIO PIU SMOOTH
% aumento un gradi di libertà al mio sistema 
tau_fr =1/10; % wt/3; la omega taglio e circa 1 
Fr = 1/(1+tau_fr*s);
Wyr2 = Fr * Wyr1;
figure(1)
step(Wyr2, Wyr1);
legend;


%% vediamo se possiamo muglirare ulteriormente adottando un filtro in feedforward
tau_ff = 1/100; % inserisco un polo veloce per rendere realizzabile il fitro 
Ff= 1/10*((s+5)*(s^2 + 5*s +10))/((1+tau_ff*s)^3);
Wyr4 = Wyr2+minreal(Ff*P0/(1+L1));

figure(1)
step(Wyr2, Wyr1, Wyr4);
legend;

%% modello ingresso Rampa 
 ts = 0.1;
 t = 0: ts : 100;
 lsim(Wyr4 ,t, t ); % il modello si comporta abbastanza bene possiamo procedere a vedere il ritardo di tempo



%% Analizziamo il RITARDO

[Gm, Pm ,wg ,omega_t]= margin(L1)
Mf= Pm*pi/180 ; % conversione il margine di fase da radiante al secondo a gradi centesimi 
R_max = Mf/omega_t % circa    0.260089500435551

% il sitema dovrebbe rimanere stabile a fronte di ritardi  non supeirori a
% 0.26
P=P0*r;
L = P*C0*k*Ra;

[num , den ] = tfdata (L);
roots(den{1}) 

Wyr3= minreal(L/(1+L));
pole(Wyr3) % ho perso la stabilità qui dentro 

figure(1)
time = [0:0.2:100];
R = 1;
u = R*time; %riferimento di tipo t ( r = t)
lsim(Wyr3,u,time) % inseguimento a regime della risposta a rampa
grid on

% L'esercizio  e stato fatto con piu controllori 
% uno di tipo 2 e quindi con errore a regime nullo 
% uno di tipo 1 molto piu semplice ma con errore a regime limitato 
% si nota che i 2 controllori risultano differenti per un fattore chiave
% molto importante ed e esattamente nel tempo di esaurimento dei transitori
% mentre il tipo 1 puo arrivare sotto i 3 secondi quello piu complesso non
% arriva sotto i 10 secondi tale fatto rispecchia la complessita
% esponenziale che abbiamo nel immettere un polo in 0 ulteriore per
% asservire meglio un segnale 




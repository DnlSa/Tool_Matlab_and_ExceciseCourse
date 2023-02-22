clc
clear all
close all

%% Esame 1
%overshoot <20%
%errore <10% a regime (rampa)
s = tf('s');
P0 = 4*(s-1)/(s^2+3*s+1);


figure(1)
rlocus(P0)

%% CONTROLLORE PER IL REGIME 

C0 = 1/s; 
L0=P0*C0;
figure(1)
rlocus(L0)

%% VINCOLO SU I GUADAGNI 
%%  Errore a regime 1. 
% non abbiamo bisogno di inserire ulteriori poli in quanto tramite il
% limite del valor finale con un sistema di tipo 1 possiamo assicurarci un
% errore limitato inferire al 10% per riferimenti rampa
%P  =4*(s-1)/(s^2+3*s+1)
%P  = mu_p*(s/zero+1) / ...
%kp=4 guadagno statico del mio processo 
% Kc -> margine di guadagno da impostare al mio controllore
%
% e = lim s->0 ( s * W_er(s)*r(s)) = R /(1 + 4 * Kc)
% |R/(1+4*Kc)| <= 0.1*R  ->  |1 + 4*Kc| > 10   
%
%POSITIVO -> 1+4*Kc > 10 -> Kc > 9/4 ; -> MG superiore a  2.25
%NEGATIVO -> 1+4*Kc <-4 -> Kc < -11/4;-> MG inferirore a -2.75

%% come ha fatto il professore 

%|R/(4*Kc)| <= (10%)*R  ->  |4*Kc| > 1/0.1  
% POS -> Kc > 1/(0.1*4)   Kc > 2.5
% NEG -> KC < -1/(0.4)    KC < -2.5
% kc > 1/(0.1*kp)
%kc > 1; vincolo sul margine di guadagno 




%% adesso cerchiamo di controllare il transitorio 
zita = 0.6; % 0<zita<1
omega_n  = 0.5;

C1 = (s^2+2*s*omega_n*zita+omega_n^2)*(s/10+1)/((s/50+1)*(s/0.5+1));
k=-0.9; % impostiamo un guadagno negativo in quanto con rlocus il luogo inverso
% discrimina l attrattività del polo nello zero verso uno zero del processo
% che crea una fase non minima 
L1 = k*C0 *P0*C1;

Wyr = minreal(L1/(1+L1))

figure(1)
rlocus(L1)

 figure(2)
 margin(L1);
% 
% figure(3)
% nyquist(L1)
% 
 figure(4)
 step(Wyr)
% 

%% insriremo un arete anticipatrice per alzare le fasi 

alpha=0.1,
omega_t = 1;
tau_ra=1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
L2 = k*C0 *P0*C1*Ra;
%% Filtro in feed forward


Ff = 1/300*(s^2+3*s+1)/((s/50+1)*(s/50+1));
Wyr2 = Wyr+minreal(Ff*P0/(1+L1));
figure(1)
step(Wyr2)
ts= 0.1;
t = 0:ts:100;
figure(5)
lsim(Wyr2,t,t)


%% filtro segnale di riferimento non lo posso usare perche introduce un
% errore limitato per via dell inseguimento di un segnale che non e
% originale 



clc
clear all
close all

%% SEZIONE PROGETTO CONTROLLORE
% Definizioni iniziali

s = tf('s');
% ritardo e relativa variabile di tempo
tau = 0.05;
rit = exp(-tau*s);
% Parte razionale della funzione dell'impianto
P0 = 0.2*(1+2*s)/(s*(1+12*s));
% Funzione impianto
P = P0*rit;
pole(P0)


%% impostiamo un errore snullo a regime perrigferimenti rampa 


C0 = (s/0.05+1)/(s*(s/100+1));
k=11;
L0 = k*C0*P0;
Wyr=minreal(L0/(1+L0));


figure(1)
rlocus(L0)

figure(2)
margin(L0);

figure(3)
step(Wyr,10);
%% studio dell errore 

Wer = 1/(1+L0)

figure(1)
margin(Wer)


%% CALCOLIAMO IL RITARDO 


[gm,pm , wc, omega_t] = margin(L0);


MF = pm*pi/180;

Rmax = MF/omega_t ; %    0.142998168650404 ritardo massimo 

L1 =  k*C0*P;
Wyr1=minreal(L1/(1+L1));

figure(3)
step(Wyr1,Wyr,10);
legend;



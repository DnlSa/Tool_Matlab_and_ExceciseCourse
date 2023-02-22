clear all 
close all 
clc

%% il sistema da stabilizzare 

s= tf([1 0],[1]);
P = 1/((s+1)*(s+3)*(s-2)); % NON e asintoticamente stabile  poli con parte reale positiva 1 , giri intorno a -1 = 0 
% per il teorema dell indice logaritmico 2pi*(np-nz); si traduce in un
% sistema non asintoticamente stabile 

[num,den] = tfdata(P);

% errore nullo a regime
roots(den{1});% dalle radici del denominatore denotiamo subito un polo nel semipiano DX 
% nelle radici compare un termine negativo 
myRouth(den{1})  % la seconda prova viene eseguita con routh hurwitzh il quale denota che i valori della prima colonna non hanno lo stesso segno 

%% Requirements

% Si desidera sovraelongazione inferiore al 20% 
% Ta,5 tempo assestamento al 5 percento < 2 secondi
% errore a regime nullo per ingressi a gradino

%% iniziamo sintesi del controllore stabilizzando inizialmente il processo a regime 
% inoltre dobbiamo chiudere la funzione d anello e verificare l asintotica
% stabilità del sistema a ciclo chiuso 

C0 = ((s/2+1)^2)*(s/0.5+1)/(s*(s/100+1)*(s/50+1)) % aggiungendo un polo in 0 ci garantiamo sin da subito un errore a regime nullo 
k= 30;
L0 = C0*P*k ; % funzione d anello 
figure(1)
margin(L0); % il sistema gia risponde molto bene avengo un buon margine di fase e di guadagno PERO E LENTO 
legend('L0');
figure(2)
rlocus(L0);
figure(3)
nyquist(L0);
Wyr= minreal(L0/(1+L0));
figure(4)
step(Wyr);
%% aggiungo una rete anticipatrice

alpha = 1; % sapendo che questo polo funzina sin da subito 
omega_tau= 30;% sposto la banda passante piu a destra per aumentare il guadagno di fase
tau_a = 1/(omega_tau*sqrt(alpha));
Ra = (1+tau_a*s)/(1+alpha*tau_a*s);

L1 = C0*P*k *Ra;
figure(1)
margin(L1);
legend('L1');
figure(2)
rlocus(L1);
figure(3)
nyquist(L1);
Wyr1= minreal(L1/(1+L1)); % sistema a ciclo chiuso e asintoticamente stabile 
[num,den] = tfdata(Wyr1);
myRouth(den{1});

figure(4)
step(Wyr1);


%% finiamo aggiungendo un filtro 

tau_fr = 1/15;
Fr= 1/(1+tau_fr*s);

Wyr2 = minreal(Fr*Wyr1);

figure(5)
step(Wyr2);


clc
clear
close all

s = tf([1 0],1);
P0 = (s-2)/(s^2+5*s+1);         %Impianto nominale (SISTEMA A FASE NON MINIMA )
ritardo = exp(-0.01*s);         %Ritardo che va ad incidere sull'impianto

P = P0*ritardo;                 %Impianto totale

[num,den] = tfdata(P0);
disp("poli della funzione P0(s): ");
roots(den{1}) % il sistema e asintoticamente stabile 


%%  iniziamo co il fare il controllore

C0=((s/3+1)^2)/(s*(s/100+1));
k=-1/8;
L0= k*P0*C0;

Wyr0= minreal(L0/(1+L0));

figure(1)
rlocus(L0);

figure(2)
margin(L0);

figure(3)
nyquist(L0);

figure(3)
step(Wyr0);

%% inserisco una rete anticipatrice perchge il mio sistema e troppo lento 
alpha= 0.1;
omega_t = 1;
tau_ra = 1/(omega_t *sqrt(alpha)); 
Ra= (1+tau_ra*s)/(1+tau_ra*alpha*s);
k1=-1/2;
L1= k1*P0*C0*Ra;
Wyr1= minreal(L1/(1+L1));

figure(1)
rlocus(L1);

figure(2)
margin(L1);

figure(3)
nyquist(L1);

figure(3)
step(Wyr0,Wyr1);
legend;
%% vediamo come e stato fatto dall altro studente 
% si esegue un approssimazione ai poli dominanti
% di norma e sempre fattibile purche non vengano cancellati poli nel
% semipiano DX o poli in 0 
% poi aggiungiamo i poli veloci al controllore per soddisfare il principio
% id causalita
C2 =(s^2+5*s+1)/(s*(s/50+1)*(s/50+1)); % NON FARE 
k4=-1/2;
L4= k4*P0*C2;
Wyr4= minreal(L4/(1+L4));

figure(1)
rlocus(L4);

figure(2)
margin(L4);

figure(3)
nyquist(L4);

figure(3)
step(Wyr0,Wyr1,Wyr4);
legend;


%% sistemiamo il ritardo 

[gm, pm , omega_c , omega_t ] = margin(L1);
MF= pm*pi/180;
R_max= MF/omega_t;   % 1.564697338520357 ritardo massimo ammissibile
L2 = k1*P*C0*Ra;
Wyr2_rit= minreal(L2/(1+L2));


%% sistemo il ritardo con pade 
ret = pade(ritardo,10);
L4_r = k4*P0*ret*C2;
Wyr4_rit= minreal(L4_r/(1+L4_r));
figure(1)
step(Wyr0,Wyr1,Wyr2_rit,Wyr4,Wyr4_rit);
legend;

%% inizialmente il mio sistema girava intorno ai 10 secondi 
% con l approssimazione ai poli dominanti siamo arrivati ad avere 2.15
% secondi 





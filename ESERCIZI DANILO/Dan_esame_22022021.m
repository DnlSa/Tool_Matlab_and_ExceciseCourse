%Esercizio 11/1
%% Overshoot minore 20% errore limitato su riferimento rampa
s=tf('s');
P0=0.1*(4*s+2)/(s*(12*s+1))
ritardo=exp(-0.05*s);
P=P0*ritardo;
%% Andiamo a studiare P0
[num den]=tfdata(P0)
roots(den{1})
roots(num{1})
% Stabile semplicemente e a fase minima
%Abbiamo L di tipo 1 che per riferimento rampa (tipo2) ha errore finito
figure(1)
rlocus(P0)
%% Complichiamo le cose e rendiamo L di tipo 2 così da avere errore nullo
C0=1/s;
L0=C0*P0;
rlocus(L0)
%% Viene instabile quindi cambiamo il controllore, ci aggiungiamo uno zero
%%(fisicamento realizzabile con polo veloce)
C1=(s+1)/(s+100)
K=10000;  %scelto per tentativi
L1=K*C1*C0*P0;
figure(1)
%rlocus(L1)
figure(2)
nyquist(L1)
figure(3)
margin(L1)
%%
Wyr=minreal(L1/(1+L1))
figure(4)
step(Wyr)

%% Mettiamo lo zero più a ridosso del polo vicino l'asse immaginario, in modo da eliminare la parte sotto -180°
C2=(s+0.05)/(s+100)
K2=10000;
L2=K2*C2*C0*P0;
figure(1)
rlocus(L2)
figure(2)
nyquist(L2)
figure(3)
margin(L2)

%%
figure(5)
bode(L1,L2)
grid on
legend

%%
Wyr2=minreal(L2/(1+L2))
figure(4)
step(Wyr,Wyr2)
legend
%% 3=ritardo
[gm,pm,wc,wt]=margin(L2);
Rmax=(pm*pi/180)/wt  %formula vista a lezione, rmax=0.4156s<ritardo  OK
L3=K2*C2*C0*P0;
%figure(1)
%rlocus(L3) SBAGLIATO, NON SI PUO FARE rlocus con ritardi
figure(2)
nyquist(L3)
figure(3)
margin(L3)
Wyr3=minreal(L3/(1+L3))
figure(4)
step(Wyr2,Wyr3)
legend
%% prova
figure(6)
margin(ritardo)
%%proviamo il riferimento rampa
t=0:0.1:100;
figure(7)
lsim(Wyr3,t,t);

%% proviamo a mettere un filtro in ingresso
tau_fr=4.33/3;
fr=1/(s*tau_fr+1);
Wyr4=fr*Wyr3
figure(10)
step(Wyr4,Wyr3)
legend
grid on
figure (11)
lsim(Wyr4,t,t)
grid on
%% Feedforward provare

%%Esempi di Reti anticipatrici e ritardatrici

alpha=0.1 %a caso per ora
omegat=100  %omega desiderata
tau=1/(omegat*sqrt(alpha))
A=(1+tau*s)/(1+alpha*tau*s)
L4=A*K2*C2*C0*P0;
figure(1)
bode(L3,L4)
grid on
legend


clc
clear all
close all

%Errore a regime < 10% con S% e T% più piccoli possibile
%Per ingressi a rampa

s = tf('s');
P = (s-2)/((s+3)*(s+10));
pole(P)

%% abbiamo un controllore con un solo polo nell origine quindi il controllore di topo 1 
% ma dobbiao inseguire riferimenti rampa allora usando il teorema del valor
% finale determiniamo i valori utili per cui ci assicuriamo l errore minore

%s^2 + 13 s + 30
% 30(s/3+1)*(s/10+1)  giusto 
% kp >-10





%% rete anticipatrice 
alpha = 0.1;
omega_t  = 10;
tau_ra = 1/(1+omega_t*sqrt(alpha));
Ra= (1+tau_ra*s)/(1+tau_ra*alpha*s);
%% Controllore statico 


% C0  = ((s+3)*(s+10)*(s/0.5+1))/((s^2)*(s/100+1));
% prova con controllore
omega_n = 0.1;
zita = 0.5;
kg = -10;
%C0  = kg*(s^2+2*zita*omega_n*s+omega_n^2)*((s+3))/((s^2)*(s/0.6+1)^2)
k=-0.5;
C0  = k*((s+3)*(s+10)*(s/10+1))/((s)*(s/5+1)*(s/4+1));

L0 = minreal(C0*P);
Wyr0 =  minreal(C0*P/(1+L0));
pole(Wyr0) % poli sistemati 

figure(2)
margin(L0)
legend
grid on

figure(1)
rlocus(L0)
grid on 

L1 = minreal(C0*P*Ra);
Wyr1 =  minreal(C0*P*Ra/(1+L1));

step(Wyr1,Wyr0)
legend



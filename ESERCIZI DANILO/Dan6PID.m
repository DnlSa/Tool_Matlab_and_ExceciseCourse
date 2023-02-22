clc
clear all
close all

%% Specifiche + Impianto
%tempo di assestamento il più piccolo possibile
%overshoot < 20%
%errore a regime < 5%

s = tf('s');
P = (s+1)/(s*(s+2)*(s+4));

%andiamo a risolvere l'esercizio di prima usando i PID
syms ki kp kd

% C=kp+ki/s+kd*s;controllore pid ideale
% C=(kp*s+ki+kd*s^2)/s
% L= C*P;

myRouth([1 6+kd 8+kp+kd kp+kd ki]);
% valori probabili messi a occhio dopo aver visto le condizioni 
kd=5; 
ki=0;
kp=8;


roots([1, 6+kd, 8+kp+kd, ki+kp, ki]) % stampiamo le radici per vedere se i valori possono andare bene 
%% definiamo adesso il PID IDEALE
K0= 0.86; % gain visto da margin
kd=5; 
ki=0;
kp=8;

C0=kp+ki/s+kd*s;

L0=K0*C0*P;

figure(1)
margin(L0);

figure(2);
rlocus(L0);
grid on;

figure(3);
nyquist(L0);
grid on;

Wyr0= minreal(L0/(1+L0));

figure(4);
step(Wyr0);
grid on;
%% Vediamo di fare il PID reale (sporco)
N=100;
C1=(s^2*(kd+kp/N)+s*(kp+ki/N)+ki)/(s*(1+s/N));
K1= 0.86;
L1 = K1*C1*P;
Wyr1= minreal(L1/(1+L1));

figure(1)
bode(L1,L0);
legend('L1','L0');

figure(2);
rlocus(L1);
grid on;

figure(3);
nyquist(L1);
grid on;

figure(4);
step(Wyr1, Wyr0);
legend('Wyr1','Wyr0');
grid on;

%% applichiamo un filtro finale 

tau_fr = 0.25/3;
Fr= 1/(1+tau_fr*s);

Wyr2= Fr*Wyr1;
figure(4);
step(Wyr1, Wyr0, Wyr2);
legend('Wyr1','Wyr0','Wyr2');
grid on;








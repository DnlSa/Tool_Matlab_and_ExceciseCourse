clc
clear all
close all

 %%
%riferimento a rampa, errore nullo
%tempo di assestamento il più piccolo possibile
%overshoot < 20%
%margine di fase >= 60 gradi

s = tf('s');
P = (s-1)/(s*(s^2+3*s+1));  % sistema a fase non minima 


%% AFFRONTIAMO L'ESERCIZIO CON IL CONTROLLORE PID

syms kd kp ki

%dobbiamo prendere il numerator di l e il denominatore di L
% den(Wyr)= den(L)+num(L) = (s-1)(kd*s+ki+kp*s^2)+(s^2*(s^2+3*s+1))
% den(Wyr)= 
% +1*s^4
% +kp*s^3 +3s^3
% +kd*s^2-kp*s^2 +1*s^2
% +ki*s -kd*s
% -ki
% definiti i coefficenti adotto il critrio di routh hurwitz per determinare
% i coefficenti kd ki kp e infine vado a vedere se le radici risultati sono
% buone con i valori decisi 

myRouth([1 kp+3 kd-kp+1 ki-kd -ki]);
% kp+3>=0
% ki<=0
% kp lo definiremo a tentativi in quando oggetto di un equazione piu lunga 

kd =  -1;
ki = 0;
kp = -1 ; % scelto a caso 
roots([1 kp+3 kd-kp+1 ki-kd -ki])
%% impostiamo il controllore ideale

C0= (kd+ki/s+kp*s);
k=1;
L0 = k*C0*P;

figure(1);
margin(L0)

figure(2)
nyquist(L0);

%% implementiamo il pid reale 
N=100;
C1= (s^2*(kd+kp/N)+s*(kp+ki/N)+ki)/(s*(1+s/N));
k=1/3;
L1=k*C1*P;
figure(1);
margin(L1)
figure(2)
nyquist(L1);
Wyr= minreal(L1/(1+L1));
figure(3)
step(Wyr);

%% agiungiamo un filtro in feed forward
tau_ff= 1/10;% DA VEDERE 
Ff=(s*(s^2+3*s+1))/((1+tau_ff*s)^2);
Wyr1 = minreal(L1*(Ff*P)/(1+L1));

figure(5);
step(Wyr1);
grid on;
clc
clear all
close all

%% Esame 5
s = tf('s');
P = 10*(s-1)/(4*s^2+5*s+100);

pole(P); % processo nominale asintoticamente stabile

zero(P); % fase non minima (vincoli nei guadagni)


zita= 0.7;
omega_n=4;
C0= ((s^2+2*zita*omega_n*s+omega_n^2))/(s*(s/60+1)*(s/2+1));
k = -1/10;

L0 = k*P*C0;
Wyr = minreal(L0/(1+L0));
pole(Wyr)

figure(1)
rlocus(L0)

figure(2)
margin(L0)

figure(3)
step(Wyr);

%% inseriamo un fr 
tau_fr = 7/3;
Fr = 1/(tau_fr*s+1);
Wyr1 =  Fr *Wyr ; 
figure(3)
step(Wyr,Wyr1);

% prestzioni Molto simili al PID 


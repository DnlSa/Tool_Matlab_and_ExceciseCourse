close all 
clear all 
clc

s= tf([1 0],[1]);

P= (s+2)/(5*s^2-4*s+2);
C=1/s; % abbiamo un inseguimento a regime nullo per ingressi costanti 
K= 100%48.5;


C1 = C*K * (1*(s/100+1));
L1 = C1*P;

figure(1)
rlocus(L1);


Wyr= minreal(L1/(1+L1));
figure(2);
step(Wyr);

figure(3)
margin(L1);



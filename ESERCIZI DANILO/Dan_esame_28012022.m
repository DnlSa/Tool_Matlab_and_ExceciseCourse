clc
clear all
close all

%errore a regime < 5% per riferimenti costanti
%sovraelongazione più piccolo possibile
%tempo di assestamento più piccolo possibile

s = tf('s');
P = -(s-3)/((s^2+4*s+1)*(s-4)); 

figure(1)
rlocus(P)

%% 
C1 = ((s^2+4*s+1)*(s/10+1))/((s/200+1)*(s/100+1)*(s/100+1));

K=3;
L1 = K*P*C1;
Wyr= minreal(L1/(1+L1));

figure(1)
rlocus(L1)

figure(2)
nyquist(L1)


figure(3)
margin(L1)

figure(4)
step(L1)

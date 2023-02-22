clc
clear all
close all
%%
%P(s) = 0.1*((4s+2)/s(12s+1))*e(-0.05s)
%assicurare S%<20% e inseguimento asintotico per riferimenti a rampa.
s = tf([1 0],[1])
T = 0.05;
P0 = 0.1*(4*s+2)/(s*(12*s+1));
P=P0*exp(-T*s);

%% Controllore  per le specifiche a regime 

C0 = (s/0.05+1)/(s*(s/100+1)) ; 
k= 10;
L0 =  k*C0*P0;

Wyr0 = minreal((L0)/(1+L0));

figure(1)
margin(L0);
figure(2)
nyquist(L0);
figure(3)
rlocus(L0);
figure(4)
step(Wyr0,10)

%% RITARDO 
% 
% [gm , pm , wc , wt] = margin(L0);
% MF = pm*(pi/180);
% R_max = MF/wt  %  0.068928496586691

ret = pade(exp(-T*s),10);
L2 = k*C0*P0*ret;
Wyr2 = minreal((L2)/(1+L2));
figure(1)
margin(L2);
figure(2)
nyquist(L2);
figure(4)
step(Wyr2,10);













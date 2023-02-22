%%
% è stato richiesto un asservimento con errore costante sotto il 5% di un riferimento costante per un 
% processo descritto dalla seguente fdt
close all
clear all
clc

s = tf([1 0],1);
P = (s-3)/((s-4)*(s^2+4*s+2));

[num,den] = tfdata(P);

roots(den{1});
figure(1)
rlocus(P)

%% 
% zita = 0.7;
% omega_n =1 ;
% C0 =  (s^2+2*zita*omega_n*s+omega_n^2)*(s/0.586+1);
C0 = (s^2+4*s+2)*(s/60+1)/((s/300+1)^3)
kc = -1;
L0 = kc*C0*P;


figure(1)
rlocus(L0)



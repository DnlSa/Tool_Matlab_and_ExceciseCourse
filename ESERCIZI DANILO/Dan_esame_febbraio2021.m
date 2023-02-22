clc 
clear all
close all

%errore nullo per riferimenti costanti e S% < 20%
s = tf('s');
P=(-0.2)*(s+1)/(s*(s-2))
% NOTE : 
% IL processo nominale non e ASINTOTICAMENTE STABILE  per la presenza
% di un polo in +2 pero e a fase minima (non abbiamo problemi di attrattivita
% indesiderate dovuto a poli nel semipiano SX) , inoltre una fase minima ci
% indica sin da subito che nell performance del transitorio non avremo
% sottoelongazioni introdotte per l appunto dallo zero nel semipiano SX 

% IL PROCESSO essendo presenta di per se ga un polo in 0 e quindi per il 
% limite del valor finale possimao dire che il nostro sistema avra un erroe
% di inseguimento rispetto all infresso nullo (e_true = 0 ). 

% per verificare l asintotica stabilita avremo bisogno di usare nyquist
% che ci assicura in qualisasi condizione e valutando il suo diagramma 
% (diagramma di nyquist) che se il numero di giri intorno a -1+j0 sono pari
% al numnero di poli instabili del mio sistema (giacenti nel semipiano SX)
% il sistema a ciclo chiuso sarà asintoticamente stabile 

k =-100;
L0 =k*P;
Wyr= minreal(L0/(1+L0));

pole(Wyr)
figure(1)
rlocus(L0)

figure(2)
nyquist(L0)

figure(3)
margin(L0)

figure(4)
step(Wyr)



clc
clear all
close all

%%
%errore nullo a gradino
%stabilità del sistema

s = tf('s');
P = (s+3)/(s^3+4*s^2-4*s-1);

% 1) verifichiamo la stabilità asintotica 
pole (P); % -4.8 , 1 , -0.28 il sistema non e asintoticamente stabile 

% 2) erorre nullo al gradino
C0 = ((s/0.5+1)^2)/(s*(s/100+1)); % grado relativo 0 il controllore e b-proper

% 3) stabilità asintotica 
k = 10;
L0  = k*C0*P;

Wyr= minreal(L0/(1+L0));


 figure(1)
 rlocus(L0);

 figure(2)
 nyquist(L0); % viene compiuto un solo giro intorno a -1 e il numero di poli nel semipiano dx e 1
 % allora possiamo dire che il sistema e asintoticamente stabile 
 figure(3)
 margin(L0)

 figure(4)
 step(Wyr);

%  pole(Wyr) % il sitema a ciclo chiuso e asintoticamente stabile 
%  -50.0956 +38.7508i
%  -50.0956 -38.7508i
%   -2.7424 + 0.0000i
%   -0.6410 + 0.0000i
%   -0.4255 + 0.0000i
 % rendiamo piu smooth il sitema con un filtro segnael 

 tau_fr =0.2/3 % di solito e omega_t/3
 Fr = 1/(1+tau_fr*s);
 Wyr1 = minreal(Fr*L0/(1+L0));
 figure(4)
 step(Wyr1 , Wyr);

 
 



 
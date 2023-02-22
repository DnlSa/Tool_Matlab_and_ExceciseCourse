clc
clear all
close all

%Errore nullo per riferimenti costanti e cancellazione disturbi costanti
%con P(s) = (-s+2)/((s+2)*(s^2+1))

s = tf('s');
P = (-s+2)/((s+2)*(s^2+1));


pole(P) ;%  -2 , +i e -i 
zero(P) ;% 2

% figure(1)
% rlocus(-P)

K = 1.2;
zita = 0.3;
omega_n = 0.7;
C0 = K*((s^2+2*zita*omega_n*s+omega_n^2)*(s/2+1))/(s*(s/500+1)^2)

L0 = minreal(C0*P);
Wyr=minreal(L0/(1+L0));

pole(Wyr);
% -8.876425444042525 + 0.000000000000000i
% -4.999999999999991 + 0.000000128157780i
% -4.999999999999991 - 0.000000128157780i
% -1.099503868846680 + 0.000000000000000i
% -0.007743564518647 + 0.010747658021135i
% -0.007743564518647 - 0.010747658021135i
% -0.008583558073536 + 0.000000000000000i

figure(2)
rlocus(L0)

figure(1)
margin(L0)

figure(3)
step(Wyr);

figure(3)
nyquist(L0);


tau_fr = 1/3;
Fr = (1/(tau_fr*s+1))

Wyr2=Wyr*Fr; 
figure(5)
step(Wyr,Wyr2)


clear all 
close all
clc
 
%%  processo nominale 

s = tf('s');

P0  = (s^2-3*s+2)/((s+2)*(s+10)*(s^2+2*s+5)); 

% processo nominale asintoticamente stabile 
% pole(P0)
%  -10.0000 + 0.0000i
%   -1.0000 + 2.0000i
%   -1.0000 - 2.0000i
%   -2.0000 + 0.0000i

% Processo nominale a fase non minima
% zero(P0)
%      2
%      1

figure(1)
rlocus(P0)

%% c0 
zita = 1
omega_n =4
C0 = (s^2+2*omega_n*zita*s+omega_n^2)/(s*(s/500+1));
%C0 =(s/0.5+1)*(s/5+1)/(s*(s/500+1)); 

k0 =1;
L0 = k0*C0*P0

Wyr0  = minreal(L0/(1+L0))

figure(1) % finche sono al di sotto di 0.80 rad/s on frequenza il mio sitema si comporta abbastanz bene 
rlocus(L0)

figure(2)% oltre a darmi i margini di guadagno e fase , omega taglio e critica dall andamento della funzione d anello mi sarebbe impossibile adottare
% una rete anticipatrice in quanto farebbe altare  il diagramma dei moduli
% in prossimità dell omega di taglio portando ad un comportamento da filtro
% passa banda ma soprattutto il grafico inizierebbe a valicare le omega di
% l asse a 0 db piu volte creandomi non pochi problemi 
margin(L0)

figure(3)% asintotica stabilità verificata tramite criterio di nyquist(nessun giro attorno a -1)
nyquist(L0)

figure(4)
step(Wyr0)



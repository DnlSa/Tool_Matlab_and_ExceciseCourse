clc;
close all;
clear all;

%% Processo P
s= tf('s');

P = 1.2 * (10*s+1)/(4*s^2+9*s+1);

pole(P)
%-2.132782218537319
%  -0.117217781462681

% Si vuole:
% - Errore a regime nullo per riferimenti a gradino
% - Sovraelongazione inferiore al 20%
% - Tempo di assestamento di 10s

% Occorre un'azione integrale per soddisfare la specifica di errore

% Nel caso in cui si volesse usare il filtro H, è necessario considerare 
% la f.d.t. di sensitività dell'errore vero e_true, ovvero:
%
%              1 + P(s) * C(s) * ( H(s) - 1 )
% W_etrue_r = --------------------------------
%                  1 + H(s) * P(s) * C(s)

% Inoltre nel caso in cui fossero presenti più disturbi in diversi punti del sistema,
% è necessario annullare l'errore per ognuno di essi, i quali in genere presentano una
% f.d.t. sull'errore differente
%%  iniziamo con il sistemare il nostro processo a regime 

C0 = 1/s; 
k0 =12;
% rete anticipatrice 
alpha = 0.1;
omega_t = 8;
tau_ra = 1/(omega_t*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);

L0 = k0*C0 *P*Ra;
Wyr= minreal(L0/(1+L0));

% pole(Wyr); POLI DELLA Wyr
% -12.420530798086823 +13.978277080582567i
% -12.420530798086823 -13.978277080582567i
%  -2.607261000241778 + 0.000000000000000i
%  -0.099898684931600 + 0.000000000000000i


figure(1)
rlocus(L0)

figure(2)
nyquist(L0) % nessun giro attorno a -1 nyquist soddisfatto 

figure(3)
margin(L0)

%% CON c1 applichiamo la tecnica della sovrascrittura 
tau_p = 2.132782218537319;
C1 = (s/tau_p+1)*(s/1+1)/(s*(10*s+1));
k=200;
L1 = k*C1 *P;
Wyr1= minreal(L1/(1+L1));

% pole(Wyr1)
% -27.215811676720755 + 0.000000000000000i
%  -2.132782218537318 + 0.000000084369114i
%  -2.132782218537318 - 0.000000084369114i
%  -1.033673655785424 + 0.000000000000000i
%  -0.100000001597035 + 0.000000000000000i
%  -0.099999998402966 + 0.000000000000000i




figure(1)
rlocus(L1)

figure(2)
nyquist(L1) % nyquist soddisfatto 

figure(3)
margin(L1)

%% verifica delle prestazioni 

% Wyr(l aumento del guadagno e limitato )
% gm -> INF
% pm -> 61.6°
% omega_t -> 12.8 rad/s

%Wyr1 (posso aumentare ancora il guadagno )
% gm -> ING
% pm ->  88.2°
% omega_t -> 28.2 rad/s 

figure(4)
step(Wyr,Wyr1)
legend

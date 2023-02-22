clc
clear all
close all

%%

s = tf('s');
P0 = (s-5)/(s^2+4*s+1);
T = pade(exp(-0.1*s), 10);
P = P0*T;

figure(1)
rlocus(P)
grid on

figure(2)
step(P)
grid on

%% iplementiamo il pid 

syms kd ki  kp  g
% s = g
% expand((g-5)*(kd*g^2 + kp*g + ki));
% expand(g*(g^2+4*g+1));

%myRouth([kd+1, kp+4-5*kd , 1+ki-5*kp, -5*ki ]);

%kd+1 > 0 -> kd >-1
%kp - 5*kd + 4 >0
% -5*ki>0  -> ki<0

ki = -1; 
kd = -0.2 ; 
kp = -2 ; 
myRouth([kd+1, kp+4-5*kd , 1+ki-5*kp, -5*ki ])


% inseriamo il pd reale 
N = 200; 
C0 = (s^2*(kd+kp/N) + s*(kp+ki/N) + ki)/(s*(s/N + 1));
L0 = minreal(C0*P); 
Wyr0 = minreal(L0/(1+L0))


% filtrino segnale 
tau_fr = 2/3; % piu e alto questo numero piu il segnale risulterà filtrato 
Fr = 1/(tau_fr*s+1); % filtro 
Wyr0_filter = Wyr0 * Fr; % inserimento a cascata nel sistema a ciclo chiuso 

figure(1) % confronto prestazionale 
step(Wyr0, Wyr0_filter)
legend

% verifica del ritardo massimo accettabile 

[gm, pm , wc,wt] = margin(L0);

MF  = pm*pi/180;

T_max = MF /wt;%  0.1720 ritardo massimo accettabile 


%% verifica della stabilità

% tutti i poli sono a parte reale complessa 
% il sistema risulta quindi asintoticamente stabile 
% pole(Wyr0_filter)
%   -4.9677 + 4.3367i
%   -4.9677 - 4.3367i
%   -0.7129 + 2.8773i
%   -0.7129 - 2.8773i
%   -0.2152 + 1.8191i
%   -0.2152 - 1.8191i
%   -0.1650 + 1.1982i
%   -0.1650 - 1.1982i
%   -0.1522 + 0.5957i
%   -0.1522 - 0.5957i
%   -0.1727 + 0.0000i
%   -0.0078 + 0.0296i
%   -0.0078 - 0.0296i
%   -0.0150 + 0.0000i
%   -0.0058 + 0.0000i

figure(1)
nyquist(L0) % non vengono compiuti giri attorno a -1
% pole(P0) % IL Processo nominale non presenta poli a parte reale positiva 
%    -3.7321
%    -0.2679
% per il criterio di nyquist mi risulta  asintoticamente stabile il sistema
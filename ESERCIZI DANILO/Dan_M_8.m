clc;
close all;
clear all;
%% Processo P

s = tf('s')
Kp = 2.4;
P1 = (s*6+1)/(4*s^2+3*s+1);
P2 = 1/(0.15*s+1);
P3 = 1/(25*s+1);
P = Kp * P1 * P2 * P3


% Si vuole:
% - errore a regime nullo per riferimenti costanti
% - sovrealongazione < 25 %
% - tempo di assestamento < 2 s

% Utilizzazione PID per controllo del processo P


%% Controllo C prima del regolatore PID
% Si nota che è presente un polo troppo lento per le specifiche richieste, ovvero il polo -1/25
% Per rendere realizzabile il controllo C è necessario un polo. Per semplicare il progetto
% Si prende come polo -1/6, così da semplificare anche il numeratore

C = (25*s+1)/(6*s+1);
L1 = P * C;

figure(1);
rlocus(L1);
title("L1 root locus");
grid on;

figure(2)
nyquist(L1);
title("L1 nyquist");
grid on;

figure(3);
bode(L1);
title("L1 bode");
grid on;


%% Regolatore PID
KP = 9;     % KP t.c. la prima sovraelongazione sia prima del tempo di assestamento richiesto
KI = 4;     % KI t.c l'uscita entra nell'area di errore poco dopo il tempo di assestamento senza aumentare troppo la sovraelongazione
KD = 9;     % KD t.c le oscillazione vengono smorzate e si soddisfi il tempo di assestamento
N = 100;

PID_P = KP;
PID_I = KI * (1/s);
PID_D = KD * (s/(s/N +1));
% Si dovrebbe aggiungere un filtro per evitare che l'azioni derivativa genere in controllo troppo
% elevato nel momento in cui il riferimento cambia livello (derivata infinita)

PID = PID_P + PID_I + PID_D;
L = L1 * PID;

% 
% figure(1);
% rlocus(L);
% title("L root locus");
% grid on;
% 
% figure(2)
% nyquist(L);
% title("L nyquist");
% grid on;
% 
% figure(3)
% bode(L);
% title("L bode");
% grid on;


% Verifica prestazioni
W = minreal(L / (1 + L));


F = 1/(s*0.05+1);    % Applicazione del filtro per l'azione derivativa
W_filter = W * F;
W_filter = minreal(W_filter);

% figure(1);
% hold on;
% rlocus(W, 0);
% rlocus(W_filter, 0);
% title("W root locus");
% legend("W", "W_{filter}");
% grid on;

figure(2)
step(W,W_filter);
title("W step response");
legend("W", "W_{filter}");
grid on;

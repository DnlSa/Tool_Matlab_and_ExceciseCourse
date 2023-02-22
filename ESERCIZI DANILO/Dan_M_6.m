clc;
close all;
clear all;

%% Processo P da Test4 - Uso del predittore di Smith
Kp = 2;
s=tf('s');
P1 = (s+1)/(2*s^2+s+1),
P2 = 1/(s*0.1+1);
P3 = 1/(0.05*s+1);
P0 = Kp * P1 * P2 * P3; % processo finale 
T = 0.3;    % Ritardo in secondi
Delay = exp(-T*s); % ritardo 
P = P0 * Delay; % processo con ritardo 

%% REQUIREMENTS (RICHIESTE)

% Si vuole:
% - errore a regime in modulo < 0.05 <- NON serve aggiungere un polo nell'origine
% - tolleranza a ritardi di 0.3s;
%   - significa che il rapporto tra margine di fase e la frequenza di taglio
%     deve essere maggiore del ritardo 
% Se possibile:
% - sovraelongazione < 20%
% - tempo di assestamento < 3s
%% STUDIO DELL ERRORE LIMITATO PER EVITARCI DI INSERIRE UN ILTERIORE POLO CHE 
% ASICURA IL REGIME NULLO 
% S i usa il limite del valor finale comprendendo un guadagno statico
% inizile del mio processo . una volta preso possiamo inserire il guadagno
% del controllore minimo o massimo che possiamo inserire 

% Per quanto riguarda l'errore: 
% lim [s->0] ( s*e(s) = s*Wer(s)*r(s) ) = |1 / (1 + Kp * Kc)| < 0.05   ->   |1 + Kp * Kc| > 20
% ->  |1 + 2 * Kc| > 20
% POS >  1 + 2*Kc > 20  ->  10*Kc > 19  -> 
% Kc > 9.5 PER UN GUADAGNO POS USIAMO QUESTO VALORE 
% NEG >  1 + 2*Kc < -20  ->  10*Kc < -21  ->  
% Kc < -10.5 SE IMPOSTIAMO UN GADAGNO NEGATIVO FAREMO RIFERIMENTO A QUESTO VALORE 
 
% Il predittore di Smith può essere usato solamente su un processo stabile
% Nel caso in cui P non lo fosse occorre prima stabilizzarlo e poi usare il
% predittore di Smith sul blocco stabilizzato

% COME DETTO SU DOVREMMO CREARE UNA SORTA DI SOTTORETRAZIONE TRA P E UN
% CONTROLLORE ATTO A PRESTABILIZZARE IL MIO SITEMA IN SEUGUITO TUTTO QUESTO
% BLOCCO VERRÀ ADOTTATO COME SE FOSSE UN PROCESSO STABILE E QUINDI SI
% UTILIZZA IL PREDITTORE DI SMITH 
%% Verifica stabilità Processo P
figure(1);
rlocus(P0);
title("P0 Luogo delle Radici ");
grid on;

figure(3) 
nyquist(P0);         % N = 0, Np = 0 -> Stabile
title("P0 Nyquist");
grid on;

figure(4)
bode(P0);
title("P0 bode");
grid on;

% Risulta che P è già stabile. Si progetta quindi C(s) per soddisfare le specifiche di
% errore, sovraelongazione e tempo di salita volute


%% Progetto Controllore C

C1 = 9.5;       % Soddisfacimento l'errore a regime
L1 = P0 * C1;

figure(1);
rlocus(L1);
title("L1 root locus");
grid on;

figure(2)
nyquist(L1);            % N = 0, Np = 0  -> stabile
title("L1 nyquist");
grid on;

figure(3)
bode(L1);
title("L1 bode");
grid on;


%% Verifica prestazioni Sistema
W1 = minreal(L1 / (1 + L1));

figure(1);
rlocus(W1);
title("W1 root locus");
grid on;

figure(2)
step(W1);
title("W1 step response");
grid on;


%% Miglioramento performance
%C2 = tf([1/15 1], [1/150 1]);   % Aggiunta di uno zero in -15 per attrarre il luogo delle radici
C2 = (s/15+1)/(s/150+1);
% Di fatto si è aggiunta una rete anticipatrice
L2 = L1 * C2;

figure(1);
rlocus(L2);
title("L2 root locus");
grid on;

figure(2)
nyquist(L2);
title("L2 nyquist");
grid on;

figure(3)
bode(L2);
title("L2 bode");
grid on;

% Si nota che con k=1 (feedback puro) si ha una condizione particolarmente favorevole:
% - Si ha solo una coppia di poli complessi coniugati, con overshoot = 13.1% e damping = 0.544
% - Il polo più lento è -1.11 -> tempo assestamento di 2.7 secondi nelle specifiche

% Si osserva che (non necessario ai fini della progettazione - uso predittore smith):
% - margine di fase = 51.3 deg = 0.8954 rad
% - frequenza di taglio = 7.93 rad/s
% => ritardo massimo = 0.8954 / 7.93 = 0.1129  <- Non sufficiente


%% Verifica nuove prestazioni Sistema
W2 = L2 / (1 + L2);
W2 = minreal(W2);

figure(1)
rlocus(W2, 0);
title("W2 root locus");
grid on;

figure(2)
step(W2);
title("W2 step response");
grid on;

% Specifiche soddisfacenti


%% Applicazione predittore di Smith
[num1, den1] = pade(T, 1); % apposttimazione con pade di ordine 1 
[num2, den2] = pade(T, 2); % approssimazione con pade di ordine 2 
[num3, den3] = pade(T, 3); % approssimazione con pade di ordine 3
M_pade1 = P0 * (1 - tf(num1, den1)); % questo e il blocco M di retrazione 
M_pade2 = P0 * (1 - tf(num2, den2));
M_pade3 = P0 * (1 - tf(num3, den3));
M_ideal = P0 * (1 - Delay);

C = C1 * C2;
% di seguito c e il controllore totale che definisce il controllore totale
% (con la retrazione del blocco M definiamo un controllore )
C_pade1 = C / (1 + M_pade1 * C);
C_pade2 = C / (1 + M_pade2 * C);
C_pade3 = C / (1 + M_pade3 * C);
C_ideal = C / (1 + M_ideal * C);

% costruiamo le funzioni d'anello facendo pade e controllore 
L_pade1 = P * C_pade1;
L_pade2 = P * C_pade2;
L_pade3 = P * C_pade3;
L_ideal = P * C_ideal;


figure(1);
hold on;
rlocus(P0 * C_pade1);
rlocus(P0 * C_pade2);
rlocus(P0 * C_pade3);
title("L root locus (no delay)");
legend("L_{pade1}","L_{pade2}","L_{pade3}");
grid on;

figure(2)
hold on;
nyquist(L_pade1);
nyquist(L_pade2);
nyquist(L_pade3);
nyquist(L_ideal);
title("L nyquist");
legend("L_{pade1}","L_{pade2}","L_{pade3}","L_{ideal}");
grid on;

figure(3)
hold on;
bode(L_pade1);
bode(L_pade2);
bode(L_pade3);
bode(L_ideal);
title("L nyquist");
legend("L_{pade1}","L_{pade2}","L_{pade3}","L_{ideal}");
grid on;


%% Verifica prestazioni Sistema con predittore di Smith

W_pade1 = minreal(L_pade1 / (1 + L_pade1));
W_pade2 = minreal(L_pade2 / (1 + L_pade2));
W_pade3 = minreal(L_pade3 / (1 + L_pade3));
W_ideal = minreal(L_ideal / (1 + L_ideal));

figure(1)
hold on;
step(W_pade1);
step(W_pade2);
step(W_pade3);
step(W_ideal);
step(W2);
title("W step response");
legend("W_{pade1}","W_{pade2}","W_{pade3}","W_{ideal}","W_{no}_{delay}");
grid on;

% Risultati di molto migliori a Test5. Si nota inoltre che più alto è il grado dell'approssimante
% di padé e migliori sono i risultati. Tuttavia ciò potrebbere rendere il sistema troppo sensibile
% alle alte frequenze, amplificando i disturbi
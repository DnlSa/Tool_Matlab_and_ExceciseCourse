
%% richieste 
% l errore a regime in risposta a una rampa non superiore al 4% del segnale
% di rifierimento 
% banda passsante ad anello chiuso maggiore di 6 radianti al secondo 
% margine di fase maggiore di 50°
%% studiamo inizialmente il nostro porcesso P0
s = tf('s');
P0 = 100*(s+1)/((s+5)*(s^2+12*s+20));
% pole(P0) % PROCESSO NOMINALE ASINTOTICAMENTE STABILE 
% -10.0000
%    -5.0000
%    -2.0000
% GUADAGNO STATICO KP = 100
% UN SOLO ZERO IN -1  fase minima ; 

figure(1)
rlocus(P0);

%% soddisfiamo le specifiche a regime 

% metodo 1  possiamo definire un vincolo su il guadagno di controllore
% affinche mi risulti un errore garantito inferiore al 4% 




%% MODO (1)
kp = dcgain(P0) ; % Guadagno statico del mio processo 
% kc = guadagno di controllore su cui vigerà il vincolo  
% Sfruttanto il limite del valor finale otterremo che 
% lim(s-> 0) s*Wer(s)*r(s) = |R0/(1+kp*kc)|< 4% R0

% |(1+kp*kc)|> 1/0.04 -> |kc|>(25-1)/kp
% POS -> kc > 24 / 1
% NEG -> kc < -24/1 
% vincolo trovato quindi si crea un controllore di tipo 1 in modo che ne
% risulti un erorre costante all uscita e il vincolo mi garantirà di essere
% al di sotto del 4% 


%% controllore con il metodo 1 

C0  = (s/10+1)/(s) ; % biproprio
kc0 = 35;
L0 = minreal(P0*kc0*C0); % strettamente proprio
Wyr0 = minreal(L0/(1+L0)); 


figure(1)
rlocus(L0)

figure(2)
nyquist(L0)

figure(3)
margin(L0)

%occorre migliorare la robustezza non che le prestanzioni  +
% quindi ovremmo aumentare la fase . 
alpha = 0.07; 
omega_t = 18 ; 
tau_ra = 1/(omega_t*sqrt(alpha)); 
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);

kc1 = 35;
L1 = minreal(P0*kc1*C0*Ra); % strettamente proprio
Wyr1 = minreal(L1/(1+L1)); 

figure(4)
margin(L1)

%% METODO 2
% % metodo 2  piu complicato : inserire un polo doppio in 0 per far fronte al
% segnale di ingresso del sistema di tipo 2 cosi mi assicuro sempre un
% erorre nullo a regime . 

C2 = (s/2+1)*(s/4+1)/s^2; 
kc2 = 8; 
L2 = P0*C2*kc2;

Wyr2 = minreal(L2/(1+L2));

% pole(Wyr2)
%   -5.1533 + 8.4243i
%   -5.1533 - 8.4243i
%   -3.5323 + 0.0000i
%   -2.0000 + 0.0000i
%   -2.0000 + 0.0000i
%   -1.1612 + 0.0000i

figure(1)
rlocus(L2)

figure(2)
margin(L2)

figure(3) % per il criterio di nyquist e asintoticamente stabile 
nyquist(L2)
%% 


% simulaizone delle prestazioni con gradino  e rampa  
ts  = 0.1; 
time = 0:ts:50; 
figure(5)
step(Wyr1,Wyr2)
legend
figure(6)
lsim(Wyr1,Wyr2,time,time)
legend

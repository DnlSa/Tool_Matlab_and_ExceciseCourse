close all 
clear all 
clc 

s= tf('s');

T = 1; % valore fittizzio per darlo  in pasto a matlab 
rit = exp(-T*s);
P0 = 1/(s*(0.75-1)); % processo nominale 
P = P0 *rit ; 

pole(P0); 
% 
% figure(1)
% rlocus(P0)




 %%  richieste
% 1) errore a regime per ingresso a rampa , inferiore al 5%
% 2) s% <= 20 % 
% 3) Ta5% migliore possibile
% 4) T da decidere il t max 

%% CONSEIDERAZIONI INIZIALI 
% iniziamo con l analizzare il mio sistema.
% il mio sistema presenta un polo semplice in 0 . 
pole(P0)

% un paio di specifiche sull segnale di riferimento 
% il segnale e un segnale a Rampa con una trasformata 
% pari a R0/s^2 quindi un segnale di tipo 2 . 
% il nostro controllore SE  di tipo 1 non occorre inserire ulteriori poli
% in 0  (in quanto gia ne presenta uno nel processo nominale) però dovremmo
% modellare un vincolo sul guadagno di controllore affinche l errore
% risulti limitato e(s)=y(s)-r(s);

% se invece adotteremo un controllore di tipo 1 che accopiato al gia
% esistente polo presente nel processo nominale  avremo un errore nullo a
% regime 

% NOTA: anche se potremmo adotta controllore che mi assicuri inseguimento
% ad errore nullo  e possibile introdurre un errore limitato quando si
% inserirà un filtro sul segnale (cio pare scontato in quanto il mio sistema 
% inseguira un segnale modificato e non originale) pero in alcuni casi e
% possibile adottarlo limitando l azione filtrante del filtro (con un tau_fr molto 
% piccolo ) , che introducendoci un piccolo errore di inseguimento ci
% potrebbe aiutare a migliorare le specifiche del transitorio del mio
% sistema 
 

% Possiamo proseguire in 2 possibili modi che vedremo di seguito 




%% MODO 1 (TEOREMA DEL VALOR FINALE PER IMPOSTARE UN VINCOLO SUL GUADAGNO DI CONTROLLORE )
kp = dcgain(P0); % guadagno statico del processo (INF)

% imposteremo un vincolo sul guadagno del controllore affinche in uscita 
% avremo un errore limitato inferiore al 5% . per fare cio dobbiamo
% adottare il TEOREMA DEL LIMITE DEL VALOR FINALE  
% 
% Wer(s) = 1/(1+PCH)
% kp = guadagno statico del processo nominale 
% kc = guadagno statico del controllore (DOVE VIGE IL VINCOLO )
%  lim(s->0) s*Wer(s)*r(s)  = s Wer(s)*(R0/s^2)   = |R0/1+kp*kc|< 5%R0
% |1/(1+kp*kc)|< 0.05 -> |1+kp*kc|> 1/0.05 -> 
% Contempliamo 2 casi possibili 
% Caso 1) GUADAGNO POSITIVO  1+kp*kc > 20 ->  
% kc > (20-1)/(kp) -> kc > 19/inf -> kc > 0 
% Caso 2) GUADAGNO NEGATIVO  1+kp*kc < -20 ->  kc < -21/inf -> kc < 0 

% VINCOLI 
% POS ->  kc > 0
% NEG ->  kc < 0 

% dopo aver impostato questo vincolo si inizia a fare al sintesi del
% controllore 


%% MODO 2 (SFRUTTANDO IL TEOREMA DEL VALOR FINALE CHE CONVERGE A 0 )
% consiste nel impostare un controllore di tipo 1 che accoppiato con il
% processo nominale (QUANDO DICHIAREREMO LA FUNZIONE D'ANELLO) in modo che
% i rifeirmenti rampa siano seguiti con errore nullo a regime 

C0  = 1/s;
kc0 = -1  ; 

L0  = P0 *C0*kc0;
% figure(1)
% rlocus(L0)

% vediamo di sistemare il luogo delle radici 

C1  = (s/25+1)/(s/500+1);  % semplice controllore analitico che mi curva facilmente il luogo delel radici NEL SEMIPIANO SX
% ho adottato l attrattività dei degli zeri su i poli in quanto erano
% assenti  questi riescono facilmente a curvare i 2 poli in 0 . ci basterà 
% qundi andare su rlocus vedere la frequenza che piu ci piace raggiungere
% (quella sull asse reale in quanto smorzerebbe completamente le oscillazioni del mio sistema nel transitorio)
% dal luogo delle radici dobbiamo raggiungere un omega di taglio di
% 53.4 rad/s o superiori( vedasi il percorso dei poli sull asse reale uno andra verso sinistra  
% l'altro converge allo zero)

kc1 = -600; 
L1  = minreal(P0*C1 *C0*kc1);
Wyr1 = minreal((P0*C1 *C0*kc1)/(1+L1));

figure(1)
rlocus(L1)
figure(2)
margin(L1)
figure(3)
nyquist(L1)
figure(4)
step(Wyr1)

%% Verifica della stabilità 

% tutti i miei poli sono a parte reale minore di 0 
% pole(Wyr1)
% -382.7962
%   -75.9038
%   -41.3000

% seconda certificazione dell asintotica stabilità del mio sistema 
% tramite criterio di nyquist 
% viene compiuto un giro completo attorno in quanto sono presenti 2 poli in
% 0  quindi 2 mezzi giri . La chiusura verrà fatta convenzionalemente (come adottato nel corso )
% lasciando l infinito a sinistra (deciso dal PERCORSO DI NYQUIST) e
% trattando il poli in 0 come poli buoni 
figure(3) 
nyquist(L1)

%% Ritardo T massimmo ammissibile 
% calcoliamoci il nostro ritardo massino 
% in questo caso ci corre in aiuto margin 
[gm, pm , wc  , wt ] = margin(L1);
% conversione da deg a rad
MF = pm*pi/180; 
Tmax = MF/wt ; % 0.0116 con T inferiori a 0.0116 il nostro sistema non divergerà 
T_1 = 0.01; 
P1 = P0*exp(-T_1*s);
L1_rit  = minreal(P1*C1 *C0*kc1); 

Wyr1_rit = minreal((P1*C1 *C0*kc1)/(1+L1_rit));

figure(1)
step(Wyr1_rit,Wyr1)
legend
grid on 

% come ci aspettiamo  il nostro sistema come si vuole dimostrare
% presenterà un transitorio con uno smorzamento delle armoniche (derivanti 
% dall antitrasformazione nel dominio del tempo del sistema completo) poco
% accentuate.
% MIGLIORIAMO TALI TRANSITORI 


%% CONTROLLORE C3 MIGLIROAMENTO DELLE PRESTAZIONI PER L IMPIANTO COMPLETO 
% vogliamo adesso migliorare il nostro sistema e renderlo piu robusto 
% applichiamo una rete anticipatrice che a discapito di una maggiore
% frequenza di attraversamenteo (che demoltiplicheremo facilmente )
% anticiperemo le fasi(aumentandole)


alpha = 0.05; 
omega_t = 45 ;
tau_ra = 1/(omega_t *sqrt(alpha)); 

Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s); 
kc3 = -50 ; 
L3  = minreal(P0*C1 *C0*kc3*Ra);

Wyr3  = minreal((P0*C1 *C0*kc3*Ra)/(1+L3));

figure(1)
margin(L3)

figure(2)
bode(L3,L1)
title("Diagramma BODE ")
legend('L1-> NO-rete ', 'L2 -> SI rete'); 
grid on 
figure(4)
step(Wyr3 , Wyr1);
legend
grid on 
%% analisi della stabilità 

% pole(Wyr3)
%   -3.8442 + 2.7638i
%   -3.8442 - 2.7638i
%   -0.1105 + 0.1376i
%   -0.1105 - 0.1376i

% il criterio di nyquist rimane verificato per l assenza di modifiche
% IMPORTANTI al sistema (per sicurezza e stato riverificato )
figure(1)
nyquist(L3);


%% ricalcoliamo il ritardo massimo ammissibile 

% Ricalcoliamo adesso il nostro ritardo massimo 

%% Ritardo T massimmo ammissibile (RICALCOLO)
[gm3, pm3 , wc3  , wt3 ] = margin(L3);
% conversione da deg a rad
MF3 = pm3*pi/180; 
Tmax3 = MF3/wt  % 0.0204 abbiamo raddoppiato il ritardo massimo ammissibile  

T_3 = 0.01; 

P3 = P0*exp(-T_3*s);

L3_rit  = minreal(P1*C1 *C0*kc3*Ra); 

Wyr3_rit = minreal((P3*C1*C0*kc3*Ra)/(1+L3_rit));

figure(1)
step(Wyr1_rit,Wyr3_rit)
legend
grid on 

%% Simulazione del segnale Rampa 
ts = 0.1 ; 
time  = 0: ts : 10;
figure(1)
lsim(Wyr3_rit, time , time)
legend
















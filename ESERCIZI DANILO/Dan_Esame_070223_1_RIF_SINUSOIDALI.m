%% REQUIREMENTS

% riferimento gradino errore nullo a regime  -> OK 
% overshoot<= 20%  -> OK 
% Tempo di assestamento minore possibile . 
% Errore per ingressi sinusoidali con omegabar inferiore al 10% 

%% NOTA 
% Si suppone che il mio sistema ha in ingresso un riferimento sinusoidale 


%%
P0 = -(4*s+2)/(s^2-2*s-8); % PROCESSO NOMINALE 
rit = exp(-0.05*s); % RITARDO



% Controllore ASSCURIAMOCI L ERRORE NULLO A REGIME 

C0 = 1/s; 
K = -1;
L0 = K*C0*P0; 
figure(1)
rlocus(L0);
%% Dal nostro primo controllore possiamo osservare il luogo delle radici il quale
% presenta 2 rami divergenti a infinito 
% inserendo alcuni zeri al posto giuato possiamo attrarre senza problemi il
% questi 2 rami 

C1 = (s/10+1);
k1 = -30;
L1 = C1*C0*P0*k1;
Wur = minreal((C0*C1) / (1+L1));
Wyr1 = minreal(L1/(1+L1));


figure(1)
rlocus(L1); 
% il luogo delle radici mi restituisce un buon luogo il qualche sotto 
% opportuno guadagno riesco ad avere un sistema instabile 
% il mio sistema avra un transitorio dettato dal polo piu lento presente 
% per l'appunto in -2 e andante in -0.5 all aumentare del guadango 

figure(2)
margin(L1)

% figure(3)
% bode(Wur)

figure(5)
nyquist(L1)

 
% inseriamo un filtro segnale 
tau_fr = 1/3;
Fr = 1/(s*tau_fr+1);
Wyr1_filter = Wyr1*Fr ;

figure(4)
step(Wyr1_filter,Wyr1)
legend; 
%
% pole(Wyr1)
%  -4.734445074088935 + 9.516092107420786i
%  -4.734445074088935 - 9.516092107420786i
%  -0.531109851822133 + 0.000000000000000i
%

% vediamo la robustezza del nostro RITARDO 
[gm,pm,wc,wt] = margin(L1);
MF = pm*pi/180;
T_max =MF/wt  %0.055780331094772 dobbiamo miglorare 
P= P0*rit;
L2 = C1*C0*P*k1;

Wyr2_rit = minreal(L2/(1+L2));
%pole(Wyr2_rit)

%% riferimento sinusoidale con omega_bar = 1 


Wer = minreal(1/(1+L2));

figure(1)
bode(Wer)
grid on
% i moduli per omega_bar =1 valgono -22.8db

%omega_bar = 22.8db = 20*log10(x) ->  10^(-22.8/20)
% x = 0.072443596007499 circa 7% inferiore a 10%


%% 
% ret  = pade(rit,10);
% L3 = C1*C0*P0*ret*k1;
% Wyr3_rit = minreal(L3/(1+L3));
% pole(Wyr3_rit)
% figure(4)
% step(Wyr1_filter,Wyr1,Wyr3_rit)
% legend; 



clc
clear all
close all

%% Esame 2:
%errore <= 10% a regime
%sovraelongazioni <= 20%
s = tf('s');
gain = 20/12; % 5/3 guadagno 
P = gain*(1-s/2)/(s*(s/12+1));
% descrizione del sistema 
% il sistema si presenta con un guadagno statico di 5/3
% si nota sin da suvito che abbiamo i seguendi zeri a parte reale positiva 
% uno zero in +2
% i poli sono a parte reale negagativa e nulla , cio rende il sistema
% Stabile semplicemente avendo lo spettro composto da un polinomio in -12 e
% uno un 0 . Se dovessimo passare solo ingressi a gradino questo il
% controllore non necessiterebbe di avere un polo in 0 perche il sistema e
%gia id tipo 1 . per ingressi a rampa necessitiamo di un ulteriore polo in
%0 introddotto dal controllore 

figure(1)
margin(P);

figure(2)
nyquist(P);

figure(3)
rlocus(P);

figure(3)
step(P);
%% NOTE
    
% dai grafici su fatti possiamo subito immaginare che abbiamo bisogno di
% velocizzare considerevolmente il sistema e la prima azione che potremmo
% fare e aggiungere una rete anticipatrice 

%% controllore analitico per sistemare anche il secondo polo in 0 
C0 = ((s/0.1+1))/(s*(s/50+1));  % rendiamo il nostro sistema con errore a regime nullo anche per ingressi a rampa
k =0.035;
L0 = k*P*C0; 
Wyr0= minreal(L0/(1+L0));


 figure(1)
 rlocus(L0);

 figure(2)
 nyquist(L0);
 
 figure(3)
 margin(L0);

 figure(4)
 step(Wyr0);
%% calcolo errore 
ts = 0.01;
t = 0:ts:100;

figure(1);
lsim(Wyr0, 10000*t, t);
grid on;


%% cio che vorrei fare adesso e cercare di migliorare le prestazioni del mio sistema
% NON Fa granche sto filtro migliora un po la risposta del sistema
% cerco voglio inserire un filtro in feed forward 

tau_ff = 1/100; % polo veloce per rendere realizzabile il filtro 
Ff=1/35*(s/12+1)/(1+tau_ff*s); 

%Wyr3 = minreal((L0+Ff*P)/(1+L0)); % notazioni uguali 
Wyr3 = Wyr0+minreal((Ff*P)/(1+L0));
figure(4)
step(Wyr3,Wyr0);
legend;





%% inserisco un filtro segnale(e risutlato migliore gia la wyr0)
% tau_fr = 2/3;
% Fr = 1/(1+tau_fr*s);
% Wyr2 = minreal(Wyr1*Fr);
%  figure(1)
%  step(Wyr2,Wyr0);
%  legend('Wyr2', 'Wyr0');


%% da escludere perche mi peggirano le prestazioni 
% %% Rete Anticipatrice 
% alpha = 0.1;
% omega_tau= 1; 
% tau_ra = 1/omega_tau*sqrt(alpha);
% 
% Ra= (1+tau_ra*s)/(1+tau_ra*alpha*s);
% L1 = k*P*Ra*C0; 
% Wyr1= minreal(L1/(1+L1));
% 
% 
% %% Rete Ritardatrice
% alpha = 0.1;
% omega_tau= 2; 
% tau_ra = 1;
% 
% Rd= (1+tau_ra*alpha*s)/(1+tau_ra*s);
% L2 = k*P*Ra*Rd*C0; 
% Wyr2= minreal(L2/(1+L2));
% 
% figure(1)
% rlocus(L2);
% 
% figure(2)
% margin(L2);
% 
% figure(3)
% step(Wyr2,Wyr1, Wyr0);
% legend('Wyr2','Wyr1', 'Wyr0');

%% vediamo di studiare le altre funzioni di sensitività

Wur = minreal(C0/(1+L0));

Wetrue=minreal(1/(1+L0));

figure(1)% conformazione di un filtro passa basso 
subplot(1 ,2 ,1)
bode(Wur); 
legend
grid on;

subplot(1 ,2 ,2)
bode(Wetrue);
legend
grid on;
%% vediamo come agisce il ritardo di fase 

% sduiarlo bene 
rit = exp(-0.1*s);
L_rit = L0*rit;

Wyrit = minreal(L_rit/(1+L_rit));

figure(1)
step(Wyrit, Wyr0);
legend 
grid on 




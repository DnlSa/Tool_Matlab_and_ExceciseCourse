%               (4s+2) 
%P(s) = (0.1*)---------- 
%              s(12s+1)
%
%->Inseguimento asintotico per riferimenti a rampa   
%->S%<20% 

clc
close all
clear all
%% 
s = tf('s')
r = exp(-0.05*s);
k=0.1;
P= k*(4*s+1)/(s*(12*s+1)) ;

%% errore a regime nullo per ingressi rampa 
% lo spettro di A presenta tutti autovalori <=0 quindi il sistema e stabile
% semplicemente per via dle polo in 0 inoltre avendo di gia un polo in 0
% posso dire che ho un sistema di tipo 1 e non avendo nessun zero nel
% semipiano dx avro un sistema a fase minima 

C0 =(s/0.05+1)/s; % con questo controllore il sistema mi diventerà di tipo 2 e potrò onseguire ingressi rampa con errore nullo 
% tale concetto e dimostrabile tramite il limite del valor finale 
K=1;
L0 = K*C0 * P ; 
Wyr= minreal(L0/(1+L0));

figure(1)
rlocus(L0);

figure(2);
nyquist(L0);

figure(3)
step(Wyr);



%% adesso aggiungiamo il nostro ritardo 
% piu posso ralentare il sistema e meno sarà perturbabile dai ritardi 

[gm, pm, wg, omega_t] = margin(L0);
MF = pm *pi/180;
R_max = MF/omega_t ; % ritardo massimo ammissibile 1.043251694278625
P_r = P*r;
L1 = K*C0*P_r;
Wyr1 = minreal(L1/(1+L1));
figure(1)
step(Wyr1);
grid on;
ts = 0.1;
t = 0:ts:100;
figure(2)
lsim(Wyr , t , t);

%% aggiungiamo in filtro segnale per rendere piu completo l esercizio
tau_fr = omega_t/3; 
Fr = 1/(1+tau_fr*s);
Wyr2 = minreal(Fr*Wyr1);

%% aggiungiamo un altro filtro in feedforward 
tau_ff = 1/100 ; % si agiunge un polo veloce al filtro in feedforward per renderlo realizzabile 
Ff =0.1* ((12*s+1)/(1+tau_ff*s));
Wyr3 =Wyr2+minreal((Ff*P_r)/(1+L1));

%% per completezza si esegue la modellazione del ritardo con pade 
ret = pade(r ,10);
L2 = L0*ret;
Wyr4 = Fr*minreal(L2/(1+L2));
figure(3)
step(Wyr, Wyr1 , Wyr2 , Wyr3, Wyr4);
legend;












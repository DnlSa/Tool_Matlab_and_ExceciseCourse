clear all
close all 
clc



s = tf([1 0],[1]);
P = 10*tf(1,[2 1]);

[num,den] = tfdata(P);
roots(den{1});

H = tf(1,[1/30 1]);
% dalle spedifiche a regime su riferimento costante e reiezione asintotica
% del disturbo costante d1

C1 = 1/s; % per errori a regime nulli  il coefficente g = 1 
% mettento un polo in 0 riesco a seguire senza errori il segnale di
% riferimento a regime 
L1 = C1*P*H;

%figure(1)
%margin(L1);

% da margin comprendo subito che devo aumentare il margine di fase e di
% guadagno 
% la omega di taglio e circa 2,27 rad/s un po lentina verifichiamolo
% dano in ingresso il segnale step

% Wyr1= L1/(1+L1);
% figure(2)
% step(Wyr1);

%% cominciamo subito a creare un controllore atto a definire  
% abbiamo detto che dobbiamo 1 velocizzare il sistema e quindi aumentiamo
% il guadagno statico ,  e da bode ci possimo subito vedere che ho marigini
% bassi e cosa posos usare per aumentarli 
% con una rete anticipatrice possiamo sin da subito aumtnare la fase 

alpha  = 0.1 ; %  0<apha<1
omega_tau = 20 ; % dato dal diagramma di bode 
tau = 1/(omega_tau*sqrt(alpha));
RA =  (1+tau*s)/((1+alpha*tau*s));% impostiamo una rete anticipatrice
C2 = C1*RA*(s+1); % mettiamo uno zero in -1 e mi attira i poli facendoli convergere
L2 = P*H*C2; 
Wyr2 = minreal(L2/(1+L2));
[num,den]= tfdata(Wyr2); % si controlla che il sistema a ciclo chiusoi sia asintoticamente stabile 
myRouth(den{1})

figure(3)
margin(L2);
%nyquist(L2);
grid on
figure(4)
rlocus(L2);
figure(2)
step(Wyr2);
grid on 
%% aggiungiamo un filtro all inzio per miglirare i transitori
% si mette solamente a titolo di didattico in quanto in una situazione
% realeva piu che bene il comportamento della Wyr2
tau_fr = 1/5;
Fr = 1/(1+tau_fr*s);
Wyr3 = Wyr2*Fr;
figure(2)
step(Wyr3);




clc
clear all
close all

%% Esame 7
s = tf('s');
P = (s-1)/(s*(s+10));

figure(1)
subplot(2,2,3)
margin(P);
subplot(2,2,1)
rlocus(P);
subplot(2,2,2)
nyquist(P);

%% creaiamo il controllore 

C0= (((s/0.5+1)^2)*(s/10+1))/(s*(s/1+1)*(s/2+1)); % se voglio errore nullo per riferimenti rampa 
k1=-1;

C0_s= ((s/10+1))/((s/1+1)*(s/2+1)); % caso con errori limitatu su riferimenti rampa 
k_s= -2;

tau_fb = 0.5; % filtro passa basso 
Fb = 1/(1+tau_fb*s);

L0= k1*C0*P*Fb;
Wyr= minreal(L0/(1+L0));

L0_s= k_s*C0_s*P*Fb; 
Wyr_s= minreal(L0_s/(1+L0_s));

figure(1)
subplot(2,2,3)
margin(L0_s);
subplot(2,2,1)
rlocus(L0);
subplot(2,2,2)
nyquist(L0);
subplot(2,2,4)
step(Wyr,Wyr_s);
legend;
%% miglioriamo le prestazioni adottando una rete anticipatrice 
alpha = 0.1;
omega_t  = 1;
tau_r = 1/(omega_t*sqrt(alpha));
k=-0.7;
Ra = (1+tau_r*s)/(1+tau_r*alpha*s);
L1 = k*C0*P*Ra*Fb^2;

k_s_1=-2.5;
L1_s = k_s_1*C0_s*P*Ra*Fb;


Wyr1= minreal(L1/(1+L1));
Wyr1_s= minreal(L1_s/(1+L1_s));
figure(1)
subplot(2,2,3)
margin(L1_s);
%bode(L0,L1);
legend;
subplot(2,2,1)
rlocus(L1);
subplot(2,2,2)
nyquist(L1);
subplot(2,2,4)
step(Wyr1,Wyr1_s);


%% MODELLIAMO UN RITARDO 

r = exp(-0.05*s);
rit = pade(r,10);
L2 = k*C0*P*rit*Ra*Fb^2;
Wyr2= minreal(L2/(1+L2));
figure(1)
subplot(2,2,3)
margin(L2);
%bode(L0,L1);
legend;
subplot(2,2,1)
rlocus(L2);
subplot(2,2,2)
nyquist(L2);
subplot(2,2,4)
step(Wyr2);


%% inserisco un filtro in feed forward 


Ff = 2*(s/10+1)/(s/100 +1) ; % filtro in feed forward
Wyr3 = Wyr2 + minreal(Ff*P/(1+L1));


Ff_s = 1*(s/10+1)/(s/100 +1);
Wyr3_s = Wyr1_s + minreal(Ff_s*P/(1+L1_s));
figure(3)

step(Wyr3_s,Wyr1_s,Wyr3,Wyr2);
legend;

%% filtro segnale 
tau_fr = 6/3;
Fr = 1/(1+tau_fr*s);
Wyr4 = Fr*Wyr3;
figure(3)
step(Wyr4);
%step(Wyr4,Wyr3,Wyr2,Wyr1);
legend;





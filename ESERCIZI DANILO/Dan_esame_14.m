clc
clear all 
close all 


%%

% P(s) = 0.1 * ((4s*2)/(s(12s+1))*e^(-0.05*s)
s= tf('s')
P= (1/20)*(2*s+1)/(s*(12*s+1));
r = exp(-0.05*s);

%% aumento la robustezza e garantisco che lerrore a regime sia nullo per riferimenti a rampa
C0 = (s/0.5+1)/(s*(s/100+1));
k = 130;

% miglioriamo il tutto con una rete anticipatrice cosi da alzare le fasi 
alpha = 0.1;
omega_tau = 3.4;
tau_ra = 1/(1+omega_tau*sqrt(alpha));
Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
L0 = P*C0*k*Ra;
L_noRa= P*C0*k;
Wyr0 = minreal(L0/(1+L0));
figure(1)
rlocus(L0);
figure(2)
bode(L0,L_noRa);
legend;

figure(3)
step(Wyr0);

%% una volta soddisfatte le specifiche a regime e transitorio facciamo vediamo l errore in 2 modi possibili 

ret = pade(r , 10); % tramite approssimante di pade
L1 = L0*ret;
Wyr1 = minreal(L1/(1+L1));
figure(1)
rlocus(L1);
figure(2)
margin(L1);
figure(3)
step(Wyr1);

%% alternativa all approssimangte di pade 
[gm, pm , wg , omega_t] = margin(L0);
MF = pm*pi/180; 
R_max = MF/omega_t % circa 0,37
P1 = P*r;
L2 = P1*C0*k*Ra;
Wyr2 = minreal(L2/(1+L2));
figure(2)
margin(L2);
figure(3)
step(Wyr2);
grid on

%% metto un filtro segnale 

tau_fr = 0.8/3; % se 8 e omega di taglio inserisco al numertore 0.8
Fr = 1/(1+tau_fr*s);
Wyr3 = minreal(Fr*Wyr2);
figure(1)
step(Wyr2,Wyr3);
grid on
legend;






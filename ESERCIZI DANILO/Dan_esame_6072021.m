clc
clear all
close all

%P(s) = (s-2)/((s+3)(s+10)) errore a regime <10% per rampa
%con S% e T% più piccoli possibile

s = tf('s');
P= (s-2)/((s+3)*(s+10));

figure(1)
rlocus(P);


%% controllore 

C0  = 1/s;
L0 = C0*P;
Wyr0 = minreal(L0/(1+L0))
figure(1)
rlocus(L0);

%% CONTROLLORE PER I TRANSITORI 
C1 = ((s/2.5+1)*(s/6+1))/((s/10+1)^2);
k=-15;
L1 = k*C0*C1*P;
Wyr1 = minreal(L1/(1+L1))
figure(1)
rlocus(L1);

figure(2)
nyquist(L1);

figure(3)
margin(L1);

figure(4)
step(Wyr1,Wyr0,10);
legend
% %% RETE ANTICIPATRICE (ON VA BENE )
% 
% alpha = 0.1;
% omega_t = 1;
% tau_r = 1/(omega_t*sqrt(alpha));
% Ra = (1+tau_r*s)/(tau_r*alpha*s+1);
% k1=-15;
% L2 = k1*C0*C1*P*Ra;
% 
% Wyr2 = minreal(L2/(1+L2));
% figure(1)
% rlocus(L2);
% 
% figure(2)
% nyquist(L2);
% 
% figure(3)
% bode(L1,L2)
% legend
% 
% 
% figure(4)
% step(Wyr2,Wyr1,Wyr0,10);
% legend



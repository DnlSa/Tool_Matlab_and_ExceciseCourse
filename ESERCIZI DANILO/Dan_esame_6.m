clc
clear all
close all

%% Esame 3
s = tf('s');
P = (s-4)/(s^2+9*s-10); 
myRouth([1 9 -10])

% sistema instabile a fase non minima 
%% inseriamo un controllore pid 
syms kd ki kp
%C0 = (kp*s+ki+kd*s^2)/s;
%L = P*C0
%den(Wyr) = den(L)+num(L) = (s-4)*(kp*s+ki+kd*s^2)+ (s*(s^2+9*s-10));
% kp*s^2 + ki*s + kd*s^3 -4*kp*s -4*ki -4*kd*s^2 + s^3 + 9*s^2 -10*s
tabella = myRouth([kd+1,kp-4*kd+9, ki-4*kp-10, -4*ki ]);
%  kd + 1  -> kd >= -1
%  kp - 4*kd + 9 >=0
%  (4*ki*(kd + 1) - (kp - 4*kd + 9)*(4*kp - ki + 10))/(kp - 4*kd + 9)>=0
%  -4*ki>=0  -> ki <=0 
kd = 0;
ki = 0;
kp =10000000000;
solve(tabella(2), kp);
roots([kd+1,kp-4*kd+9, ki-4*kp-10, -4*ki ])
% il pid non e una buona soluzione in quanto non riesco ad avere delle
% radici buone 
%% per completezza inseriamo il pid reale 
N=200;
C2= (s^2*(kd+kp/N)+s*(kp+ki/N)+ki)/(s*(1+s/N));
k=10;
L2= C2*P*k;
Wyr2= minreal((P*C2*k)/(1+L2));% H e messo in controreazione e non bisogna prenderlo
figure(1)
margin(L2);
figure(2)
nyquist(L2);
figure(4)
rlocus(L2);
figure(3)
step(Wyr2);
pole (Wyr2)


%% Controllore analitico
C0 = ((s/3+1)*(s/2+1))/((s)*(s/100+1));
k=-6;
L0 = C0*P*k;

Wyr0= minreal(L0/(1+L0));
figure(1)
rlocus(L0)
figure(2)
nyquist(L0)
figure(3)
margin(L0);
figure(4)
step(Wyr0);

pole(Wyr0); % le radici del sistema a ciclo chiuso sono tutte nel semipiano dx cio mi dice che il sistema e asintoticamente stabile 


%% FR 
tau_fr = 2/3;
Fr = 1/(1+tau_fr*s);
Wyr2= minreal(Fr*Wyr0);
figure(4)
step(Wyr2)

% %% cerchiamo di sistemare i transitori 
% % NON APPLICABILE
% alpha = 0.5;
% omega_t = 2;
% tau_ra = 1/omega_t*sqrt(alpha);
% Ra = (1+tau_ra*s)/(1+tau_ra*alpha*s);
% L1 = C0*k*P;
% Wyr1= minreal(L1/(1+L1));
% figure(1)
% rlocus(L1)
% figure(2)
% nyquist(L1)
% 
% figure(3)
% margin(L1)
% figure(4)
% step(Wyr1)


close all
clear all 
clc



s = tf('s');
P = 1/((s-3)*(s+5)*(s-1)); % due poli nel semipiano destro 

[num,den]=tfdata(P);
myRouth(den{1})

figure(1)
nyquist(P);

%% prima di tutto vediamo di mettere l errore a regime nullo  
% e con un controllore analitico vediamo come rendere il sistema
% asintoticamente stabile 
k0=200;
C0=1/s;

Cstab= (((s/2+1)^2)*(s/3+1))/((s/1000+1)^3); % controllore che mi a
L0= k0*C0*Cstab*P;
figure(1)
nyquist(L0);
figure(2)
rlocus(L0)
figure(3)
margin(L0);

Wyr= minreal(L0/(1+L0));
figure(4)
step(Wyr);




%% adesso mettiamo una rete anticipiatrice per sistemare

alpha= 0.1;
omega_tau= 15 ;
tau_ra= 1/omega_tau*sqrt(alpha);
Ra= (1+tau_ra*s)/(1+tau_ra*alpha*s);
k1=600;
L1 =k1*C0*Cstab*P*Ra;

figure(3)
margin(L1);

figure(2)
bode(L0,L1);
grid on
legend('L0','L1');
Wyr1= minreal(L1/(1+L1));
figure(4)
step(Wyr1);
%% Rete anticipatrice inutile per 
alpha= 0.1;
omega_tau_rd= 10 ;
tau_rd= 1/(omega_tau_rd*alpha);
Rd= (1+tau_rd*alpha*s)/(1+tau_rd*s);
k1=5000;
L2 =k1*C0*Cstab*P*Ra*Rd;

figure(3)
margin(L2);

figure(2)
bode(L0,L1, L2);
grid on
legend('L0','L1','L2');
Wyr2= minreal(L2/(1+L2));
figure(4)
step(Wyr2);

%% aggiungo un filtrino 
tau_fr=1/5;
Fr= 1/(tau_fr*s+1)
Wyr3 = Wyr2*Fr;
figure(4)
step(Wyr3);





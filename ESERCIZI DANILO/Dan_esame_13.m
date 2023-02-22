clc
clear all
close all

%% Esame 3
s = tf('s');
P = (s+4)/(s^2+9*s-10);
r= exp(-0.01*s); % ritardo di 500 msec
[num den] = tfdata(P);

P_r = P*r;

% notazioni equivalenti 
pole(P);
roots (den{1});
myRouth([1  9 -10]); 

% i sitema e instabile vediamo come si puo sistemare 

%%  inseguimento con errore nullo a regime 

% mi assicura errore nullo a regime 
C0 = (s/10+1)/(s*(s/100+1));
k=200;
L0 =k*P*C0;

Wyr= minreal(L0/(1+L0));

figure(1)
nyquist(L0);

figure(2);
rlocus(L0);

figure(3)
margin(L0)

figure(4)
step(Wyr);
%% mettiamoci un filtro 
tau_fr = 1/10; 
Fr = 1/(1+tau_fr*s);
Wyr1 = minreal(Fr*Wyr);
figure(1)
figure(1);
step(Wyr1, Wyr);
legend;

%% adesso modelliamo il ritardo

%% metodo1 controlliamo fino a che disturbo puo resistere il nostro
% controllore

[gm , pm , wg , omega_t]= margin(L0);
Mf = pm*pi/180; % converto il margine di fase in gradi centesimali (rad->deg)
T_max = Mf/omega_t % 0.056364890420391 ritardo mmassimo tollerabile . sono molto a limite 
L1 = k*C0*P_r;
Wyr_r = Fr*minreal(L1/(1+L1));
figure(1);
step(Wyr_r, Wyr);
legend;
%% metodo 2 con approssimante di pade

ret = pade(r,10);
L2 = L0*ret;
Wyr2 = Fr*minreal(L2/(1+L2));

figure(1);
bode(L2, L0);
legend

figure(2);
rlocus(L2);
grid on;

figure(3);
nyquist(L2);
grid on;

figure(4);
step(Wyr2);
grid on;
%% stampe di confronto 
% tra i 2 metodi di gestione del riatrdo sono esattamente identici 


figure(1)
step(Wyr,Wyr1 ,Wyr_r , Wyr2);
legend

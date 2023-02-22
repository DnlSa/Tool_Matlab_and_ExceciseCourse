clear all 
close all 
clc
%% 
% vediamo roba con disturbi

s = tf([1,0],1);
P0 = 5/(s^2+2*0.6*1*s + 1);
T = 0.1; % 10 secondi 
P = P0*exp(-T*s); % Effetto discretizzazione introduco un ritardo inevitabilmente 
pole(P0)

%% distrubi agenti sul sistema 
d1 = 10; % disturbo d1 (costante )
omega_d2 = 2*pi*50; % pulsazione del disturbo d2 a 50HZ


%% Filtro H in retroazione per eliminare l' azione del distrubo 


%omega_h  =1; % impostandolo a 1 si vedra l azione del disturbo sinusoidale
%in uscita 
omega_h  =2*pi*20; % azione attenuante agente prima del disturbo a 50 Hz
[b,a] = butter(2,omega_h,'s'); %Butterworth digital and analog filter design.
H = tf(b,a); % funzione di trasferimento del controllore H
% figure(1)
% margin(H)
% title("filtro passa basso ")
%

C1 = 0.1/s; % fuznione del controllore
L1 = C1*P*H; % funzione d'anello 
L2= C1*P;
Wyd1 = minreal(P/(1+C1*P*H)); % funzione di trasferimento con d1
Wyd2 = minreal(C1*P*(1-H))/(1+L1);  % funzione di trasferimento uscita con d2 
Wyr = minreal(C1*P/(1+L1));

figure(2)
subplot(2,1,1)
margin(L1);
grid on
subplot(2,1,2)
nyquist(L1);
% grid on
% subplot(3,1,3)
% rlocus(L1);

time = [0:0.2:150]; % tempo di simulazione 
r = 1*ones(1,length(time)); % segnale di ingresso(vettore di 1 ) 
disturbo1 = d1*ones(1,length(time)); % modellazione del disturbo costante 
disturbo2 = 100*sin(omega_d2*time); % ingresso disturbo sinusioidale 

% le funzioni di sensitività ai disturbi servono principalmente a far
% vedere l azione del disturbo che altrimenti non sarebbe visibile su Wyr
figure(3)
subplot(3,1,1)
lsim(Wyd1,disturbo1,time);% fa vedere la reiezione al disturbo costante in d1
legend;
title("sensitivita al disturbo 1 ") 

subplot(3,1,2)
lsim(Wyd2,disturbo2,time);% fa vedere la reiezione al disturbo sinusoidale d2 
legend
title("sensitivita al disturbo 2 ")

subplot(3,1,3)
lsim(Wyr,r,time);% non fa vedere i disturbi che agiscono nel sistema
legend
title("sensitivita ingresso-uscita ")

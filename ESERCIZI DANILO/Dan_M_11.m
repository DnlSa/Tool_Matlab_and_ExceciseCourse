clc;
close all;
clear all;
%% Processo P
s = tf('s');
P = 0.5 *(s*0.3+1)/(0.25*s^2+1)
pole(P)
% Si vuole:
% - errore a regime del 2% per riferimenti a gradino
% - sovraelongazione inferiore al 25%
% - tempo di assestamento inferiore a 1s

%% errore limitato VINCOLO SUL GUADAGNO 
 % vediamo di modellare subito l errore inderiore al 2 % 
%kp = 0.5;
% lim (s->0) s*Wer(s)*r(s)  -> |R0/(1+kc*kp)|<2%*R0
% 1/(1+kc*kp)|<0.02 -> 1+Kc*kp>50  segno girato quando faccio il reciproco
% POS-> kC > (50-1)/kp; -> kc >= 98
% NEG -> kc < (-50-1)/kp ; kc <= -102 ;

%% IMPOSTIAMO UN VINCOLO SU LA FREQUENZA DI TAGLIO 
%  
% %dobbiamo trovarci zita
% epsilon = 5 ; 
% % s^2+2*omega_n*zita*s+omega_n^2 = 0.25 s^2 + 1
% % omega_n^2*(s^2/mega_n^2+2*s*zita/omega_n+1) = 0.25 s^2 + 1
% omega_n= sqrt(1/0.25);
% omega_taglio_des =  log(0.01*epsilon)/(zita*T)
% 
% % NON POSSIAMO DETERMINARE ZITA IN QUNTO IL TERMINE IN S DEL PROCESSO
% % NOMINALE NON C'E E NON ABBIAMO ZITA 
%% iniziamo subito con l impostare un controllore in 0 

% il questo controllore abbiamo posto un polo doppio che puo arrivare fino
% a -50 i piu senza problemi la dinamica del sistema mi viene data dai poli
% nominanti che  e per l appunto quello in 0 potrei fare una cosa piu furba
% per sistemare le performance 
% inserire un polo che cancelli lo zero fisso e reimpostarne uno con piu
% lontano 
[NUM,DEN] = butter(5,0.5,"low",'s');
H = tf(NUM,DEN);

% CONTROLLORI VALIDI MA CON DEI PROBLEMI
%C0  = ((s/10+1)^2)/(s*(s/100+1)); % FUNZIONA BENE COL POLO DOPPIO ANCHE 
%C01 = ((s/20+1)*(s/30+1)^2)/(s*(s/100+1)*(s*0.3+1));

% si comporta in modo ottimale 
zita = 0.4;
omega_n = 1;
C02 = (s^2+2*zita*omega_n*s+omega_n^2)/(s^2*(s/100+1));

k0=98;
% L01 = k0*P*C01;
% L0 = k0*P*C0;
%L0_filtrata = k0*P*C0*H;
L02 = k0*P*C02;
Wyr = minreal(L02/(1+L02));

pole(Wyr)
figure(1)
rlocus(L02);

figure(2)
margin(L02);%    bode(L0,L01 ,L0_filtrata)
% legend
% grid on ;
figure(3)
step(Wyr)

figure(4)
nyquist(L02);

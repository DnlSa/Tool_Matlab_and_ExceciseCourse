%% Esame 4
%errore nullo a rampa
%overshoot < 20%, tempo di assestamento il più piccolo possibile

s = tf('s');
P = (s^2 + 10*s + 5)/(s^2*(s+2));
% Considerazioni 
% 1) il sistema e gia di tipo 2 quindi risponderà con un errore nullo ad
% ingressi rampa 
[num den] = tfdata(P);
pole(P);
roots(num{1});

figure(1)

subplot(2,2,1);
margin(P);

subplot(2,2,2);
nyquist(P);

%fugure(2)
subplot(2,2,3);
rlocus(P);

subplot(2,2,4);
step(P);

%% iniziamo subito a creare un controllor

% il sitema sta gia bene cosi
k=500;
L0 = k*P;
Wyr = minreal(L0/(1+L0));
figure(1)
margin(L0)
figure(2)
step(Wyr);

%%  inseriamo un filtro segnale 

tau_fr= 1/15;
Fr = 1/(1+tau_fr*s);
Wyr1 = minreal(Fr*Wyr);
figure(2)
step(Wyr1);

%% simulazione ingresso a gradino 
ts=10;
t=0:ts:100;
figure(1)
lsim(Wyr1 , 10*t ,t );







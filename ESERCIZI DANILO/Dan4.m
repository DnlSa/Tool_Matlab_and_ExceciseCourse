%% Esercizio 4
%e_inf <= 0.05%
%phi_m >= 50'
%w_t >= 5 rad/s

s = tf('s');
P = zpk([], [-1 -3], 3);

figure(1);
margin(P);
grid on;

figure(2);
rlocus(P);
grid on;

figure(3);
nyquist(P);
grid on;

figure(4);
step(P);
legend;
grid on;
%% RICHIESTE 
%e_inf <= 0.05% -> ERORRE A REGIME MUNORE UGUALE AL 0.05
%phi_m >= 50' -> MARGINE DI FASE SUPERIORE A 50GRADI DEG
%w_t >= 5 rad/s -> IMEGA TAGLIO SUPERIORE A 5 RADIANTI SECONDO
%% si inizia sempre dall specifiche a regime quindi vediamo di modellizzare 
%l'errore a infinito 
% Deve co parire l errore a regime finito quindi dobbiamo necessariamente 
% trovare un valore tale da 
C0 = 1/s; % cosi ho l errore a regime nullo 
L0 =  C0*P;
figure(1);
margin(L0);
grid on;
figure(2)
rlocus(L0);
%% Dal luogo delle radici abbiamo visto che il problema piu grosso e
% adottare un guadagno tale da arrivare a 5 radianti al secondo 
Cz= (s/2+1); % e solamente uno zero che accoppiato al C0 mi da un controllore proprio
C1= C0*Cz;
L1 = C1*P;
figure(1);
nyquist(L1);
figure(2)
rlocus(L1);
figure(3)
margin(L1);

%% APPLICANDO UN ARETE ANTICIPATRICE POSSO AUMENTARE LA FASE 
alpha_ra =   0.01 ;    % 0<alpha<1
omega_tau =  10;          
tau_ra= 1/(omega_tau*sqrt(alpha_ra))
Ra = (1+tau_ra*s)/(1+tau_ra*alpha_ra*s); 
% nella rete anticipatrice prima agisce 1/tau_ra poi 1/alpha*tau_ra
% prima agistelo zero e poi il polo 
K=5; % gain e possibile metterlo dopo che sono riuscito a mettere uno zero attrattivo 
L2 = K*L1*Ra;
figure(1);
margin(L2);
grid on;

 







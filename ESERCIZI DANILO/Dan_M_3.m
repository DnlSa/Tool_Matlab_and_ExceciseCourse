clc;
close all;
clear all;


%% Processo P

s = tf('s');
Kp = 3;
P1=(1/(s));
P2 = (2*s+1)/(2*s^2+0.5*s+1);
P = Kp * P1 * P2;

% Si vuole:
% - errore a regime nullo a riferimenti a gradino <- già soddisfatto dal polo di P nell'origine
% - sovraelongaziona < 25% 
% - tempo di assestamento < 5s
%% vediamo il tempi di assestamento 

%                      1
% P= ----------------------------------------- -> Layout del processo di riferimento 
%     (s^2/omega_n^2 + 2*zita/omega_n*s + 1)
%
%1/omega_nì^2 = 2 -> ricaviamo che omega_n = sqrt(0.5)
% 2*zita/omega_n = 0.5 -> zita = 1/4*(sqrt(0.5))

zita =1/4*(sqrt(0.5)); 
epsilon =5;  
T = 5; % secondi
omega_taglio_des = (-log(0.01*epsilon))/(T*zita)

%omega_taglio_des = 3.389284168399072
%% vediamo di arrivare ad avere una omega_taglio maggiore di 3.38


C0 = (s/1+1)/(s/100+1);
K0 = 2;
L0 = K0*P*C0

Wyr = minreal(L0/(1+L0));

pole(Wyr);
%  -93.680966777225748
%   -4.467022904411608
%   -1.673679378357498
%   -0.428330940004708

figure(1)
rlocus(L0) % con il luogo delle radici sto bene 

figure(2)
margin(L0) % OMEGA_T  circa 6


figure(3) % verifico la stabilita con nyquist (NON COMPIO GIRI ATTORNO A -1 OK)
nyquist(L0) 

figure(4)
step(Wyr) % settling time intorno ai 4 secondi OK 
% S% inferiore al 20% OK
%% facciamo un paio di consideraiozni 

%SE POSIZIONASSIMO IL NOSTRO GUADAGNO NELLA RETRAZIONE ???
% Se si pone un guadagno K nel ramo di retroazione)
% cieo dove vive il filtro H . 
% l effetto che percepisco e del dimezzamento della risposta in uscita . 
% Questo perche il guadagno andrebbe a motiplicare solamente il termine di
% grado 0 del denominatore.
% in maniera intuitiva la misure e 2 volte l uscita.Lerrore quindi aumenta
% in quanto il controllo vede che l uscita (misurata) ha raggiunto 
% un livello 2 volte superiore a quello reale . Di conseguenza l
% attenuazone viene bloccata quando y=r/2
% si noti che per la stabilità non camia nulla in quanrto la fdt della
% catena aperta è la stessa 

%% 
% Il luogo delle radici di L ci fornisce informazioni sull'uscita sui
% singoli poli , ovvero del loro singolo contributo sull'uscita se al loro
% relativo fratto semplice vi fosse 1 al numeratore , ovvero se il suo
% residuo fosse pari a 1 . Tuttavia la presenza degli zeri al numeratore di
% L e quindi di W fa si che i residui vengano modificati, rendendo
% necessario il loco calcolo per determinare con precisione l uscita .
% prendendo dei singoli poli , o coppie di poli complessi coniugati si puo
% verificare l usicta che quuesti producono ad un ingresso a gradino
% unitario rispetto le caratteristiche riportate sul luogo delle radici 


p1 = 1 / (s + 0.434);
% damping: 1.000   overshoot: 0.00%   frequency: 0.434 rad/s
p2 = 1 / ((s + 1.41 + 1.15i) * (s + 1.41 - 1.15i));
% damping: 0.775   overshoot: 2.13%   frequency: 1.82 rad/s
p3 = 1 / ((s + 12.9 + 14.6i) * (s + 12.9 - 14.6i));
% damping: 0.661   overshoot: 6.26%   frequency: 19.4 rad/s


figure(1);
step(p1);
grid on;

figure(2)
step(p2);
grid on;

figure(3)
step(p3);
grid on;

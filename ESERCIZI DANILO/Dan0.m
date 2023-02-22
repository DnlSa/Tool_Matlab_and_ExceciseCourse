close all 
clear all 
clc

%% 
%funzione di trasferimento di un motore semplice
%da soddisfare:
%-banda passante >= 10 rad/s   -> MI TOCCA SOLAMENTE AUMENTARE IL GUADAGNO 
%-sistema asintoticamente stabile  -> 
%-basse sovraelongazioni
%-alto tempo di assestamento al 5%
s=tf([1 0],[1]); % qu definisco s 

P = 1/(s*(2*s+1)); % funzione di impianto 
C1 = 1 ; %specifica a regime già soddisfatta per via del polo in 0 in P


L1=P*C1; % funzione d anello 
Wyr=L1/(1+L1); % funzione si sensitività ingresso uscita (qua ci passo l ingresso )

% figure(1);
% margin(L1); % diagramma di bode  
% 
% figure(2);
% nyquist(L1); % diagramma di nyquist
% 
% figure(3)
% step(Wyr); % immettiamo l ingresso a gradino in entrata per comprendere come si comporta il sistema chiuso 

%% INIZIAMO ADESSO A DEFINIE UN CONTROLLORE 
% l errore a regime e intrinseco all impianto in quanto gia contiene un
% polo in 0 . 

C2 =  40 ; % come da specifica dobbiamo passare  a banda passante superiore a 10 radianti al secondo quindi aumentiamo il guadagno statico 
% se aumento la banda passante il sistema sarà molto piu veloce e quindi
% tende ad oscillare molto dobbiamo smorzare l osclillazione in che modo ?
% (vedasi punto 3 )
% le successive righe sono state tenute per dare al lettore la facoltà di
% comprendere come all aumento del guadagno e quindi all aumetare della
% banda passante il sistema diventa piu veloce ma aumenta l oscillazione
% nel intorno del punto di equilibrio 
L2 = P*C2;
W2yr= L2/(1+L2);
% figure(4);
% margin(L2); % diagramma di bode  
% 
% figure(5)
% step(W2yr,Wyr); % immettiamo l ingresso a gradino in entrata per comprendere come si comporta il sistema chiuso 
% legend('W2yr', 'Wyr');


%% Provviamo a sistemare le sovraelongazioni dato che al momento il sistema oscilla troppo 
% dovremmo inoltre aumentare il margine di fase in quanto troppo basso cosi
% facendo la sovralongazione  diminuirà
% inolte l aumento del margine di fase e guadagno ci danno un undice di
% robustezza del nostro sistema in quanto dale funzione di impianto essendo
% sintetizzata da un impianto spessevolte non lineare le traiettorie
% possono essere soggette a discostamenti . 

alpha = 0.1; 
omega_tau = 10; % omega di taglio utile per trovare tau
tau = 1/(omega_tau*sqrt(alpha));
%tau = 0.25;


RA = (1+tau*s)/(1+tau*alpha*s);
C2 =  70 ; 
C3 = C2*RA;

L3= C3*P;
W3yr =minreal(L3/(1+L3));

figure(8)
rlocus(L3)


figure(6)
margin(L3);
grid on

figure(7)
step(W3yr,Wyr); % immettiamo l ingresso a gradino in entrata per comprendere come si comporta il sistema chiuso 
legend('W3yr', 'Wyr');



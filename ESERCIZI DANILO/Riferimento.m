 clc
clear all
close all
s = tf('s');
%% PREFAZIONE 
%a)
% noi desideriamo una bassa sovraelongazione di solito inferiore al 20% 
% un buon tempo di assestamento il piu piccolo possibile e un errore di
% inseguimento del segnale di errore piu piccolo possibile 
%b)
% ci sono generalmente 2 disturbi che agiscono sul mio sistema : 
% il primo (d1) potrebbe essere un errore costante 
% il secondo  (d2)potrebbe essere una disturbo dovuto alla frequenza di alimentazione del
% mio sistema 2*PI*50 = 50HZ circa 300 rad/sec. 
% il nostro scopo e creare un controllore che attenui se non elimini tali
% disturbi e stabilizzi l impianto nominale .
% questa e la variabile s della trasformata di laplace ci torna utile per
% evitare di adottare la notazione vettoriale per dichiarare le funzioni di 
% trasferiemento 

s = tf('s');

% questo e l impianto 

%P = 10/(s*(2*s + 1)); %notazione con la variabile s 
P = 10*tf(1, [2, 1 ,0]); % notazione senza usare la variabile s
 
% questo e un filtro generalmente usato per la retrazione che elimina un
% eventuale segnale di disturbo d2 che affligge il segnale di uscita del
% mio sistema 
% supponendo che dobbiamo attenuare il disturbo d2 di una 50Hz(la frequenza 
% dell classica 220Volt di casa nostra) creiamo un filtro passa BASSO che inizia ad agire
% con un attenuazione gia da una decade prima dei 300 HZ
% H = 1/(s/30+1) % polo in -30 che genera un contributo di -45°/decade a partire
% gia dalla frequenza 
%H = tf(1, [1/30 1]) 
H = 1/(s/30+1);

figure(1)
bode(H);
grid on

% diagramma dei MODULI -> vediamo che nei diagramma dei moduli a -3db(circa 0)
% il polo in -30 inizia a fare effetto ed ad attenuare tutti i disturbi che
% si trovano dopo . raggiungeremo un attenuazione di -20dB a 300rad/s

% diagramma delle FASI ->  nel diagramma delle fasi il filtro H inizia ad
% attenuare le fasi gia da una decade prima del polo quindi inizia con 
% a fare effetto da 3 arrivera a 30 rad/s che varra -45° e a 300rad/s vale
% -84...° l effetto del polo svanirà dopo i 300rad/sec cioe una decade 
% dopo il polo che sto inserendo 
% (in fondo apprezzaremo meglio l attenuazione al disturbo )

 
%% MARGIN E BODE 
% la prima funzione importantissima e margin 
% ci puo dare delle importanti informazioni che sono 
% margine di guadagno , margine di fare (che rappresentano buoni indici di robustezza)
% omega_critica e omega taglio se vogliamo prenderci tutti questi parametri
% possimo fare cosi: 
%[margine_guadagno , margine_fase , omega_critica, omega_taglio]= margin(P);
% si puo adottare anche per graficare la funzione che ci interessa . 
% se siamo interessati a fare il plot di piu funzioni nello stesso
% diagramma di bode definiremo le seguenti righe 

% figure(1)
% bode(L0 , L1 ,L2)
% grid on ;
% legend; 

figure(1);
margin(P);
grid on;

%% IL LUOGO DELLA RADICI 
% La seconda  funzione questa ci aiuta a comprendere come il sistema varia al variare del guadagno statico 
% per e posto un importante LIMITE: 
% Non puo essere graficata se stiamo studiando un impianto affetto da sfasamento dovuto ad un RITARDO
% di tempo (per poterla usare dovremmo considerare il sistema senza ritardo)
% oppure possimo approssimare il ritardo con pade e ottenendo una funzione razizonale 
% potremmo studiare l'impianto. 

% l'interpretazione di rlocus:
% x -> sono i poli (radici del denominatore)
% o -> sono i zeri (radici del numeratore)
% Il sistema e stabile solo se la parte reale dei poli sono <0;
% il luogo delle radici ci mostra sia i poli che i zeri ma a noi
% interessano solamente i poli . 
% i zeri pero hanno un importante proprietà ed e quella di ATTIRARE i poli 
% al varaire del guadagno 

figure(2);
rlocus(P);
grid on;

%% NYQUIST  il diagramma polare che viene speccchiato e si chiude 
% da questo gradifico possimo dedurre un importante criteri su la stabilità
% del nostro sistema : 
% il sistema e stabile solo se il numero di giri intorno  al punto -1(giacente 
% sull'asse reale)è uguale al numero di poli "CATTIVI" (giacenti sul semipiano DX)
% del sistema che sto considerando (poli cattivi ->  a parte reale >= 0 e un polo cattivo ) 
% i giri in senso orario intorno a -1 contano come un giro 
% IL percorso di nyquist noi lo intendiamo come un percorso che passa sull
% asse immaginario che si lascia il polo 0 a SX  e che la chiusura all
% infinito avviene sempre lasciando l'infinito a SX . 

figure(3);
nyquist(P);
grid on;

%eseguendo tutte le sezioni fin qui possiamo osservare che :
% da rlocus noi possimo osservare com il poli giacciono sul semipiano sx, 
% e quindi la loro parte reale sono tutte <0 . quindi possiamo dire 2 cose fondamentali 
% 1) che il sistema e asintoticamente stabile 
% 2) che il sistema non necessita di fare giri attorno a -1 

% PS: alcuni per convenzione considerano lo 0 come polo cattivo lasciando il
% lo 0 a DX del percorso di nyquisti quindi la chiusura all infinito deve
% avvenire nella parte opposta cioe lasciando sempre l infinito alla nostra destra
% su la percorrenza del grafico . 

%% PRIMA PARTE DEL CONTROLLORE 
% la prima cosa che dobbiamo fare e assicurare che le specifiche a regime 
% vengano rispettate . 
% ERRORI NULLI A REGIME 
% se l ingresso e di tipo 2 allora il sistema d'anello chiuso (Wyr)
% dovrà possedere almeno 2 poli in zero e 
% se di tipo 1 avro bisogno di un solo polo in 0. 
% ERRORI LIMITATI A REGIME (viene inseguito il segnale di riferimento con una certa soglia di erroe 
% solitamente inferiore al 10% o 5% addirittura ) possiamo scalare di 1
% grado e poi quantificheremo l errore con il teorema del valor finale 
% lim (s->0) s Wer(s) *r(s).(poli in zero detti INTEGRATORI)
% Se abbiamo eliminare dei disturbi costanti d1 :
% dobbiamo aggiungere un ulteriore polo in 0 oltre  a quelli che ci
% occorrono per inseguire il segnale di riferimento 

C1 = 1/s;

% L e la funzione di trasferimento ad anello aperto 
% tutti i teoremi adottano questa funzione perche molto piu semplice da
% manipolare e studiare . 
% per studiare la risposta del nostro sistema dobbiamo usare la funzione di
% sensitività complementare di ingresso-uscita detta genericamente (Wyr)
% Wyr = minreal(L0/(1+L0)) ; se usiamo la notazione con la s per lavorare
% ci occorre chiamare la minreal che applica tutte le semplificazioni 

L1 = P*C1*H;
Wyr1 = minreal(P*C1/(1+L1)); % funzione di trasferimento ingresso uscita

figure(1);
margin(L1);%analiziamo sempre la funzione d anello aperto 
grid on;

figure(2);
rlocus(L1); %analiziamo sempre la funzione d anello aperto 
grid on

figure(3);
nyquist(L1); % analiziamo sempre la funzione d anello aperto 
grid on

figure(4);
step(Wyr1); % con la step analizziamo il comportamento del nostro sistema
grid on

% facendo girare tutte le sezioni del codice fino a qui possiamo vedere che
% il disturbo su citato viene filtrato . e l errore a regime e nullo per i
% riferiemti a gradino in quanto un polo in 0 gia e presente nel processo
% nominale. di contro pero vediamo subito che il nostro sistema e fottuto
% vissto che con rloucs vediamo che i i poli si spostano nel semipiano
% sinistro.
% anche nyquist ci dice che il sistema e instabile perche applicando la
% regola della chiusura abbiamo che il cerchio chiudendosi con l infinito a
% sx  gira intorno a -1  una sola volta . a noi non deve girare nessuna
% volta intorono a -1 .

%%  DETERMINARE VINCOLO PER AVERE UN SETLING TIME SPECIFICO 
% Una volta che abbiamo creato il nostro primo controllore per errori a
% regime. possiamo iniziare a determinare un omega di taglio 
% minima che ci assicura il settling time 
% in sostanza definiamo un primo vincolo inviolabile
% T <= -log(0,01*epsilon)/(omega_t *zita) % formula di riferimento 
% P = 10/((2*s^2+ s));
%                      1
% P= ----------------------------------------- -> Layout del processo di riferimento 
%     (s^2/omega_n^2 + 2*zita/omega_n*s + 1)
%
% dataci per il tempo di assestamento
% Ta,epsilon 

 epsilon =5; 
 zita =0.4; 
 T = 2; % secondi
 omega_taglio_des = (-log(0.01*epsilon))/(T*zita); 

%% VINCOLI PER AVERE ERRORI A REGIME LIMITATI  
% di solito ci verra chiesto di avere errori a regime inferiori di una
% determinata soglia tipo il inferiori al 10% del segnale di riferimento 
% possiamo modellare un vincolo atto a rispettare questo erorre 
% per delineare il nostro errore limitato a regime per ingressi rampa 
% considereremo solamente il nostro processo che contiene gia un polo in 0 
%
%P  = 10*(1/(s*(2*s+ 1))) -> il nostro processo 
%P  = kp*((s/zero+1)/(s/polo+1)....) -> layout tipo del processo 
%kp=10 % guadagno statico del mio processo 
%Kc -> margine di guadagno da impostare al mio controllore 
%R -> segnale d ingresso
% e = lim (s->0) ( s * W_er(s) * r(s)) = R/(1+kp*Kc)
%|R/(10*Kc)| <= (10%)*R  ->  |10*Kc| > 1/0.1    Kc > 1/(0.1*10)  se Kc > 1
% R0/(kp*kc)<=0.1*R0;
% kc > 1/(0.1*kp)
%kc > 1; vincolo sul margine di guadagno 

%%  Errore a regime 1.
% riferimenti rampa la trasformata di laplace e r(s)=R0/s^2
% riferimenti gradino (delta dirac) la trasformata di lapalace e r(s)=R0/s

% non abbiamo bisogno di inserire ulteriori poli in quanto tramite il
% limite del valor finale con un sistema di tipo 1 possiamo assicurarci un
% errore 5limitato per riferimenti rampa
%P  = 10*(s/4+1) / ...
%P  = mu_p*(s/zero+1) / ...
%kp=10 guadagno statico del mio processo 
% Kc -> margine di guadagno da impostare al mio controllore 7
%
% e = lim s->0 ( s * W_er(s) * r(s)) = R /(1 + 10 * Kc)
% |R/(1+10*Kc)| <= 0.1*R  ->  |1 + 10*Kc| > 10   
%
%POSITIVO -> 1+10*Kc > 10 -> Kc > 9/10 ; -> margine di guadagno superiore a  0.9
%NEGATIVO -> 1+10*Kc <-10 -> Kc < -11/10;-> margine di guadagno inferirore a -1.1
%
% R0/(kp*kc)<=0.1*R0;
% kc > 1/(0.1*kp)
%kc > 1; vincolo sul margine di guadagno 

%% Errore  REGIME 2  

% secondo esempio se vogliamo un errore a regime del 5%
% rho = 0 se ho erorre limitato a regime 
% R = segnale di ingresso trasformato con Laplace
% kp = 2 guadagno statico del processo nominale

% errore limitato se 
% rho_p +rho_c-q+1 = 0
%lim [s->0] R*(s^(rho_p +rho_c-q+1)* ...../s^(rho_p +rho_c)* .....)

% Per quanto riguarda l'errore: (q-1= 0 -> errore limitato -> denominatore diventa |1 + Kp * Kc|)
% lim [s->0] (s*Wer(s)*(r(s)/s^q) ) = |R/(s^(q-1) + Kp*Kc)| <= 0.05*R  ->   |1 + Kp * Kc| > 20
% -> |1 + 2*Kc| > 20
% se impostiamo un guadagno positivo nel controllore ->  1 + 2*Kc > 20  ->  10*Kc > 19  ->  Kc > 9.5
% se impostiamo un guadagno negativo nel controllore ->  1 + 2*Kc < -20  ->  10*Kc < -21  ->  Kc < -10.5

% NOTA :
% Del perche possiamo impostare un guadagno positivo o negativo 
% il guadagno potrebbe cambiare generalmente perche ci potrebbe interessare
% il fatto che il luogo delle radici puo essere capovolto (LUOGO INVERSO) 

%% SECONDA PARTE DEL CONTROLLORE 
% abbiamo sistemato le performance a regime adesso vogliamo creare un
% controllore che stabilizzi il sistema e che ci assciuri delle performance
% ottime (definite in cima al codice) 
% le performance vanno valutate sempre con la funzione step infine
% inseriremo il nostro segnale esatto e vedremo il compoortamento 

% Realizziamo un controllore ANALITICO che sfrutta prettmente una prorpietà
% fondamentle dei zeri . cioe quella di attrarre i poli che all aumentare
% del guadagno divergono con determinate traiettorie (i zeri sono le calameite per queste 
% traiettorie che vengono curvate a seconda di come viene posizionato uno zero sull asse)

tau_z1 = 1/0.1; % viene messo uno zero in -1 , attenzione questo controllore non e causale 
% cioe ha il grado del numeratore maggiore del grado del denominatore
% quindi inseriremo dei poli veloci(dei poli molto lontani dal asse immaginario
% nel semipiano sx) in modo da esaurire il loro comportamento su le fasi prima che il 
% sistema inizi a funzionare. 
C2 = (1+tau_z1*s);


Kc = 1; % guadagno statico che inizialmente e posto 1 poi verrà modificato
% in base al grafico di locus e ai diagrammi di bode 

L2 = P*Kc*C1*C2*H; % costruzione funzione d'anello aperto 
Wyr2 = minreal(P*Kc*C1*C2/(1+L2));% definiamo la funzione d anello chiuso 

figure(1);
margin(L2);
grid on;

figure(2);
rlocus(L2);
grid on

figure(3);
nyquist(L2);
grid on

figure(4);
step(Wyr2);
grid on

% adesso il sistema ci sembra ancora instabile am se si fa lo zoom in
% prossimità dello 0 in rlocus possiamo osservare che si e delineata una
% piccola area dove con dei piccoli guadagni il sistema diventa stabile. 
% il numero esatto nel guadagno e descritto nella piccola legenda che
% appare quanto inseriamo un punto ci dara il "gain" cioe il
% guadango da inserire nel controllore per arrivare ad avere quello stato .
% ricordiamo che i poli dominanti saranno sempre quelli piu lenti che
% definiscono le performance del sistema . 


%%
Kc = 0.005;
% con questo guadagno che abbiamo visto che adesso il nostro sistema si
% stabilizza . adesso ci occorre migliorare le performance , quindi per
% migliorare la responsività del nostro sistema dobbiamo poter aumentare la
% omega di taglio che definirà un sistema piu veloce a discapito pero di un
% overshoot maggiore . inoltre per per migliorare la robustezza nonche
% limitare anche il nostro overshoot ci occorre migliorare il margine di
% fase che si definisce buono sopra i 45° ottimale e quindi per sovraelongazioni 
% minori del 20% dobbiamo poter arrivare al 60°
% per migliorare le performance come stavamo dicendo su possiamo sfruttare 
% una rete anticipatrice o ritardatrice per anticipare o ritardare le fasi.

w = 1; % omega di taglio desiderata 
alpha = 0.1; % facciamo agire una decade prima 
tau_ra = 1/(sqrt(alpha)*w); % come scegliamo tau_ra -> 3.16
Ra = (1+tau_ra*s)/(1+alpha*tau_ra*s); % rete anticipatrice che se graficata vedremo
% che prima agirà il polo e poi lo zero
L3 = P*Kc*C1*C2*Ra*H; % definiamo la funzione ad anello  perto 
Wyr3 = minreal(P*Kc*C1*C2*Ra/(1+L3));

figure(1);
margin(L3);
grid on

figure(2);
rlocus(L3);
grid on

figure(3);
nyquist(L3);
grid on

figure(4);
step(Wyr3);
grid on

% il nostro controllore funziona . 
% esortiamo sempre a creare un controllore fisicamente realizzabile
% rispettando la causalità deg(den(C)) >= deg(num(C))


%% Rete RITARDATRICE  non si applica quasi mai pero merita di essere inserita 

w = 1; % omega di taglio desiderata 
alpha = 0.1; % facciamo agire una decade prima 
tau_rd = tau_ra;% come scegliamo ->  tau_ra >> omega_t
Rd = (1+alpha*tau_rd*s)/(1+tau_rd*s); % rete ritardatrice che se graficata vedremo
%agisce prima lo zero e poi il polo. 
% usando lo stesso valore di tau_ra otteniamo una cosa esattamente
% speculare 
figure(1);
bode(Ra ,Rd)
legend
grid on;

%% FILTRO SEGNALE D'INGRESSO (FR)
% un altra tecnica consiste nel filtrare il segnale di ingresso .
% attenzione pero perchè se filtriamo il segnale di ingresso il nostro
% sistema se di tipo 2 seguira il segnale filtrato e introdurrà un
% discostamento dal segnale originale con conseguente errore finito 
tau_r = 20/3;
Fr = 1/(1+tau_r*s);
Wyr3_fr = Fr*Wyr3; % applicazione del filtro segnale di riferimento 

figure(4);
step(Wyr3, Wyr3_fr);
legend;
grid on

% ora il  tempo di salita va bene 
%mouse dx su step graph -> characteristics -> settling time

%% FILTRO IN FEED FORWARD 
% alcune volte inserire il filtro in feed forward puo aiutarci 
% a migliorare considerevolmente il nostro sistema a ciclo chiuso 
% il feed forward cerca di apprissimare il sistema il processo d impianto 
% se esso presenta un sistema asintoticamente stabile 
%P = 10/(s*(2*s + 1)); processo nominale 
tau_ff = 1/100;
k_ff=1/200;
Ff= k_ff*(2*s + 1)/(s*tau_ff+1); % si aggingono i poli per rendere il filtro causale 

Wyr3_ff = Wyr3+minreal(Ff*P/(1+L3));
figure(4);
step(Wyr3, Wyr3_fr,Wyr3_ff);
legend;
grid on

% in questo caso non ci aiuta molto visto che al denominatore non abbiamo
% un polinomio decente.

%% FILTRI DI BUTTERWORTH

% passa BASSO
n = 6;
omega0 = 1;
[num, den] = butterworth(n, omega0,'low');%% filtro passa basso 
H0 = tf(num, den);

figure(1);
bode(H0);
title('Filtro Passa Basso')
legend
grid on;

% passa ALTO 
n = 6; % grado 
omega = 1;
[num1, den1] = butterworth(n, omega , 'high');%% filtro passa basso 
H1 = tf(num1, den1);
figure(2);
bode(H1);
title('Filtro Passa Alto ')
legend
grid on;

% passa BANDA  
n = 6; % grado 
omega1 = 0.5;
omega2 = 5;
[num2, den2] = butterworth(n, [omega1,omega2] , 'band');%% filtro passa basso 
H2 = tf(num2, den2);
figure(3);
bode(H2);
title('Filtro Passa Banda')
legend
grid on;

% passa NOTCH
n = 6; % grado 
omega = 314; % impostato in radianti al secondo  
% la 50HZ -> (2*pi)*50 = omega
[num3, den3] = butterworth(n, omega , 'notch');%% filtro passa basso 
H3 = tf(num3, den3);
figure(4);
bode(H3);
title('Filtro Notch attenua la 50Hz')
legend
grid on;

pole(H3)


%% APPROSSIMAZIONE RITARDI NEL SISTEMA 
% supponiamo di avere un ritardo
% ricordiamo che il ritardo agira solamente su le fasi creando uno sfasamento + o meno evidente 

ritardo = exp(-0.05*s);% ritardo di 0.05 secondi
[margine_guadagno , margine_fase , omega_critica, omega_taglio]= margin(L3);
margine_fase_rad = margine_fase*pi/180 ; 
% convertiamo il margine di fase da deg a rad
Ritardo_massimo = margine_fase_rad/omega_taglio; %  1.990932774452943 secondi 
% questo ci dice che finche non arrivo a 2 secondi il mio sistema continua comportarsi bene 
L_rit = (P*ritardo)*Kc*C1*C2*Ra;
Wyr3_rit = minreal((L_rit)/(1+L_rit*H));
figure(4);
step(Wyr3,Wyr3_fr,Wyr3_ff,Wyr3_rit);
legend;
grid on
%% APPRISSIMANTE DI PADE'
ret=pade(ritardo,10) ; % apprissimiamo con pade di grado 10
L_rit_pade = (P*ret)*Kc*C1*C2*Ra*H;
Wyr3_rit_pade = minreal(((P*ret)*Kc*C1*C2*Ra)/(1+L_rit_pade));
figure(4);
step(Wyr3, Wyr3_fr,Wyr3_ff,Wyr3_rit_pade);
legend;
grid on
%%  PREDITTORE DI SMITH

P0 = (s-5)/(s^2+4*s+1); % funzione di impoanto 
r = exp(-1*s); % definiamo ritardo 
%
T = pade(r, 10); % approssimamo con pade 
P1 = P0*T; % definiamo il nostro sistema con ritardo approssimato
% Uso un Predittore di Smith per lavorare sull'impianto senza tenere conto del ritardo
M = P0*(1-T); 
Kc_s = -0.125; % gain 

alpha_s = 0.1;
w_s = 1;
tau_ra_s = 1/(w_s*sqrt(alpha_s));
Ra_s = (1+tau_ra_s*s)/(1+alpha_s*tau_ra_s*s); % rete anticipatrice 

C_s = (Kc_s/s)*Ra_s; % messa nel controllore direttamente per una questione di semplicità
L4 = minreal(C_s*M + C_s*P1); % funzione d anello C_s*M e la parte con il predittore smith
Wyr_smith = minreal(P1*C_s/(1+L4)); % calcolo funzione di anello chiuso 

figure(1);
margin(L4);
grid on;

figure(2);
rlocus(L4);
grid on;

figure(3);
nyquist(L4);
grid on;

figure(4);
step(Wyr_smith);
legend;
grid on;


%% Analisi delle sensistivita ai disturbi e NON  
% funzioni di sensitività complementari 
Wyr  = minreal((P*Kc*C1*C2*Ra)/(1+L3)); % nessun H al numeratore 
Wetrue = minreal((1-(P*Kc*C1*C2*Ra)*(H-1))/(1+L3)); % quando ho dei disturbi nel mio sistema considero questa
Wur = minreal((Kc*C1*C2*Ra)/(1+L3));% numeratore c e solo il controllore finale 
Wer =  minreal(1/(1+L3)); % funzione sensitivita d errore 

% la funzione di sensitività ci dice quando e suscettibile il nostro
% sistema a fronte dei disturbi esogeni 
%L3 = P*Kc*C1*C2*Ra*H;
Wd2y = minreal(H*P*Kc*C1*C2*Ra/(1+L3)); % sensitivita del disturbo d2 con y 
Wd2e = minreal(-H/(1+L3));% sensitività del disturbo d2 con la variabile e 
Wd1y = minreal(P/(1+L3)); % sensitivtà del processo a fronte dei disturbi d1
Wd1e = minreal(-P*H/(1+L3)); % sensitivita di d1 con e

figure(1);
bode(Wd1e, Wd2e, Wd1y, Wd2y);
title("Funzioni di sensitività dei disturbi");
legend;
grid on;

figure(2);
bode(Wyr, Wetrue, Wur, Wer);
legend;
title("Funzioni di sensitività");
grid on;

Ts = 0.01;
t = 0:Ts:100; % definizione di un tempo di simulazione 
d1 = 10*ones(length(t), 1)'; % creazione di un disturno 
d2 = 0.1*sin(2*pi*50*t) + 0.01*randn(length(t),1)';

%vediamo come la risposta ha effetto su d1: dopo 40 secondi viene
%completamente filtrato (un filtro ricordiamo che ha sempre i suoi
%transitori.

figure(3);
subplot(3,1,1)
lsim(Wd1y, d1, t);
title('Sensitivita uscita e disturbo d1')
grid on;
% come la risposta ha effetto su d2 . 
subplot(3,1,2)
lsim(Wd2y, d2, t);
title('Sensitivita uscita e disturbo d2')
grid on;

% infine simuliamo l'ingresso rampa e vediamo come viene inseguito .
subplot(3,1,3)
lsim(Wyr, t, t);
title('Sensitivita ingresso uscita')
grid on;

%% sistemi del secondo ordine 

%                      1
% P= ----------------------------------------- -> Layout del processo di riferimento 
%     (s^2/omega_n^2 + 2*zita/omega_n*s + 1)

% zita  = margine_fase/2 -> coefficente di smorzamento 
% S% = 100*exp((-zita*pi)/(sqrt(1-zita^2)) -> overshoot 
% T <= -log(0,01*epsilon)/(omega_t *zita) -> settling time 
% quando ci vengono date delle funzioni di impianto con dei poli immaginari
% ci conviene creare un controllore di questo genere per sistemare il
% problema . 

omega_n =  2 ; % pulsazione naturale MAGGIORE DI 0 
zita = 0.7; % coefficente di smorzamento  MAGGIORE DI 0 
kg = -0.865; % guadagno statico 
C1 = kg*(s^2+2*zita*omega_n*s+omega_n^2)/(s*(s/500+1)^2);
L1 = minreal(C1*P);
Wyr1= minreal(L1/(1+L1));
pole(Wyr1) % verifico se il closedloop abbia poli strani 

%% PID

 s = tf('s');
P1 = 4*(s-1)/(s^2+3*s+1);

% applichiamo i metodo dei pid 
% 
% 
% 
% formula pid classica ->  (kp+ki/s+kd*s)
% modo equivalente moltiplico tutto per s -> (kp*s+ki+kd*s^2)/s (DA USARE)
% il processo diventa.
%
% 4*(s-1)*(kp*s+ki+kd*s^2)   (4*kp*s^2+4*ki*s+4*kd*s^3)-(4*kp*s+4*ki+4*kd*s^2)
%------------------------- =--------------------------------------------------
%    (s^2+3*s+1)*s            s^3+3*s^2+s
%
% dobbiamo studiare den(Wyr) = num_L+den_L
%
% (4*kp*s^2+4*ki*s+4*kd*s^3)-(4*kp*s+4*ki+4*kd*s^2)+ s^3+3*s^2+s
syms kd ki kp
myRouth([4*kd+1  4*kp-4*kd+3 4*ki-4*kp+1 4*ki ])
% routh ci restituira questi valori 

% 4*kd + 1 >=0 ->  kd >= -1/4
% 4*kp - 4*kd + 3 >=0
% ((4*kp-4*kd+3)*(4*ki-4*kp+1)-4*ki*(4*kd+1))/(4*kp - 4*kd +3)>=0
% 4*ki >=0     ->  ki >= 0

kd = 0.1;
ki = -0.1; 
kp = -0.2;
roots([ 4*kd+1,  4*kp-4*kd+3, 4*ki-4*kp+1, -4*ki])
% le radici che ne derivano sono 2 complesse coniugate e negative .

% introduciamo il pid reale 
N=10;
C2 = (s^2*(kd+kp/N) + s*(kp+ki/N) + ki)/(s*(s/N + 1));
k=0.6;
L2 = k*C2*P1; % non cambia molto 
L2_NF =  k*C2*P1;
Wyr2 = minreal(L2/(1+L2));
Wur2 = minreal(C2/(1+L2));

%% CONTROLLORE PARAMETRICO

P = (s-3)/((s^2+4*s+1)*(s-4)); % PROCESSO INIZIALE
% tramite la fuznione 
kp = dcgain(P) ; % trogo il guadagno 

% inziamo con il far eun approssimazione ai poli dominanti 
% cancelliamo una porzione del denominatore che e asintoticamente stbile 
Cd = (s^2+4*s+1)/((s/500+1)*(s/200+1));

P_new = minreal(P*Cd);
kc=1
% se ci viene chiesto di testare il sistema a ciclo chiuso con un segnale a
% gradino dobbiamo adottare il limite del valor finale . 

% Routh-Hurwitz
syms q b0 b1 a0 a1
% C = Kc*(b0+b1*s)/(a0+a1*s) % forma del controllore 
%L = Kc*(b0+b1*s)*(s-3)/((a0+a1*s)*(s-4)); % funzione a ciclo chiuso 
%denWyr = numL + denL

expand((b0+b1*q)*(q-3))
expand((a0+a1*q)*(q-4))

myRouth([-2*b1+a1, -2*b0+6*b1+a0-4*a1, 6*b0-4*a0])

%a0  -> parametro libero 
%a1 < 4*a0/3
%(a1-a0)/30 < b0 < a0/90
%-a1/30 < b1 < (a0-4*a1+30*b0)/90

a0 = 1;
a1 = -10;
b1 = -5.12;
b0 = 5;

roots([-2*b1+a1, -2*b0+6*b1+a0-4*a1, 6*b0-4*a0]) % verifica delle radici 
C = Kc*(b0+b1*s)/(a0+a1*s); % nuovo controllore 
L = C*P_new; % nuova funzione d'anello


clc
clear all
close all

%% Esame 1 (VARIANTE PID)
%overshoot <20%
%errore <10% a regime (rampa)
s = tf('s');
P1 = 4*(s-1)/(s^2+3*s+1);

% applichiamo i metodo dei pid 
% 
% 
% 
% formula pid classica ->  (kp+ki/s+kd*s)
% modo equivalente moltiplico tutto per s -> (kp*s+ki+kd*s^2)/s (DA USARE)
% il processo diventa.

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
ki = -0.1; % deve essere negativo ma qualcoda non mi quadra 
kp = -0.2;

roots([ 4*kd+1,  4*kp-4*kd+3, 4*ki-4*kp+1, -4*ki])

% le radici che ne derivano sono 2 compresse coniugate e negative 

%% introduciamo il pid reale 
N=10;
k=0.6;
Fb = 1/(s/(2*N)+1); % filtro passa basso 

C2 = (s^2*(kd+kp/N) + s*(kp+ki/N) + ki)/(s*(s/N + 1));
L2 = k*C2*P1*Fb; % non cambia molto 
L2_NF =  k*C2*P1;
Wyr2 = minreal(L2/(1+L2));
Wur2 = minreal(C2/(1+L2));

figure(2)
bode(L2 , L2_NF);
legend;
grid on 

figure(1)
step(Wyr2);

figure(5);
bode(Wur2, Wyr2);
legend;
grid on;
%% introducuiamo il ritardo 
ret = pade(exp(-0.3*s), 3);
L3 = L2*ret;
Wyr3 = minreal(L3/(1+L3));
figure(5);
step(Wyr2, Wyr3);
legend;
grid on;

%% Simulazioni
ts = 0.01;
t = 0:ts:1000;

figure(1);
lsim(Wyr3, t, t);
grid on;


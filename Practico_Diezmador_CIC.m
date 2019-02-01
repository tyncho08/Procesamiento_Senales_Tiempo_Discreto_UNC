%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analisis de un Decimador CIC y  %
% los Filtros Integradores y Comb % 
% que lo componen.                %
%                                 %
% Autor: Ing. Martin Gonella      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

omega=[0.0001:.0001:1]*pi;
z=exp(j*omega);
fs=400e6;     % Frecuencia de muestreo, in Hz

% Respuestas 
R = 4;  % Sobremuestreo 
M = 4; % Decimacion
N = 8;  % Etapas del CIC
st1 = sprintf('Factor de Sobremuestreo Inicial -> RxM = %d',R*M);
st2 = sprintf('Factor de Decimado Filtro CIC   ->   M = %d',M);
st3 = sprintf('Cantidad de Etapas Filtro CIC   ->   N = %d',N);
st4 = sprintf('Factor de Sobremuestreo Final   ->   R = %d',R);
disp('Parametros de Configuracion:')
disp(' ')
disp(st1)
disp(st2)
disp(st3)
disp('--------------------------------------------')
disp(st4)

Ganancia_DC = 1/((R*M)^N);
H1z = 1./(1-z.^(-1)); % Filtro Integrador
H2z = 1-z.^(-M*R);    % Filtro Comb en alta frecuencia
Htotz = (H1z.^N) .* (H2z.^N) * Ganancia_DC; % Respuesta total en 
% alta frecuencia

% N filtros
H1z_N = H1z.^N;
H2z_N = H2z.^N;

% Diagrama de polos y ceros del filtro CIC de orden 1
num = [1 zeros(1,R*M-1) -1];
den = poly([1]);
figure()
zplane(num,den)
stn = sprintf('Diagrama de Polos y Ceros de un Diezmador CIC con N=1, R=%d y M=%d',R,M);
title(stn)

% Graficas
figure()
h=semilogx(omega*fs/2/pi,20*log10(abs(H1z_N)),'b',omega*fs/2/pi,20*log10(abs(H2z_N)),'r',omega*fs/2/pi,20*log10(abs(Htotz)),'g');
set(h,'Linewidth',3);
set(h,'Markersize',16);
set(gca,'XScale','log','YScale','lin','FontWeight','bold','FontSize',14);
set(gca,'Linewidth',2);
xlabel('f [Hz]');
ylabel('|H(j\omega)|');
legend('Filtro Integrador N etapas','Filtro Comb N etapas','Filtro CIC de N etapas','location','southwest')
st = sprintf('Escala logaritmica, N=%d, M=%d y R=%d',N,M,R);
title(st,'interpreter','latex')
axis([10^4 10^9 -3000 1000])
grid on
%break

% Funcion de transferencia (en funcion de "f" de tiempo continuo)
figure()
h=semilogx(omega*fs/2/pi,20*log10(abs(H1z)),'b',omega*fs/2/pi,20*log10(abs(H2z)),'r',omega*fs/2/pi,20*log10(abs(Htotz)),'g');
set(h,'Linewidth',3);
set(h,'Markersize',16);
set(gca,'XScale','log','YScale','lin','FontWeight','bold','FontSize',14);
set(gca,'Linewidth',2);
xlabel('f [Hz]');
ylabel('|H(j\omega)|');
legend('Filtro Integrador','Filtro Comb','Filtro CIC de N etapas','location','southwest')
st = sprintf('Escala logaritmica, N=%d, M=%d y R=%d',N,M,R);
title(st,'interpreter','latex')
grid on

% Fase
figure()
hh=plot(omega*fs/2/pi,angle(H1z),'b',omega*fs/2/pi,angle(H2z),'r',omega*fs/2/pi,angle(Htotz),'g');
set(hh,'Linewidth',1);
set(hh,'Markersize',16);
set(gca,'XScale','lin','YScale','lin','FontWeight','bold','FontSize',14);
xlabel('f [Hz]');
ylabel('angle(H(j\omega))');
legend('Fase Filtro Integrador','Fase Filtro Comb','Fase Filtro CIC de N etapas','location','southwest')
st = sprintf('Fases, N=%d, M=%d y R=%d',N,M,R);
title(st,'interpreter','latex')
grid on

% Escala lineal
figure()
hhh=plot(omega*fs/2/pi,20*log10(abs(H1z)),'b',omega*fs/2/pi,20*log10(abs(H2z)),'r',omega*fs/2/pi,20*log10(abs(Htotz)),'g');
set(hhh,'Linewidth',1);
set(hhh,'Markersize',16);
set(gca,'XScale','lin','YScale','lin','FontWeight','bold','FontSize',14);
xlabel('f [Hz]');
ylabel('|H(j\omega)|');
legend('Filtro Integrador','Filtro Comb','Filtro CIC de N etapas','location','southwest')
st = sprintf('Escala Lineal, N=%d, M=%d y R=%d',N,M,R);
title(st,'interpreter','latex')
axis([0 200000000 -2500 500])
grid on
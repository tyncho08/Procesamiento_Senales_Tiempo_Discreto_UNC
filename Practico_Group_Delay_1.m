%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analisis de los Efectos de la Demora de Grupo                %
% Dada la señal x[n], formada por tres pulsos de banda angosta %
% modulados a distintas frecuencias. Se propone filtrar dicha  %
% señal con un filtro dado con fase no lineal y                %
% observar los resultados obtenidos.                           %
%                                                              %
% Autor: Ing. Martin Gonella                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

w1 = 0.2*pi; % Frecuencia de Oscilación del Pulso1 de Banda Angosta 1
w2 = 0.4*pi; % Frecuencia de Oscilación del Pulso2 de Banda Angosta 2
w3 = 0.8*pi; % Frecuencia de Oscilación del Pulso3 de Banda Angosta 3
n1 = 1:300;  % Indice pulso final
M = 60;      % Cantidad de puntos de los pulsos de BA no modulados
n = 0:M;     % Indice pulso no modulado

wn = 0.54-0.46*cos(2*pi.*n./M); % Pulso de Banda Angosta no modulado

% Pulsos de Banda Angosta Modulados y Pulso Total x[n]
xn_1 = [zeros(1,M) wn.*cos(w1*n-pi/2) zeros(1,3*M)]; 
xn_2 = [zeros(1,2*M) wn.*cos(w2*n+pi/5) zeros(1,2*M)];
xn_3 = [wn.*cos(w3*n) zeros(1,4*M)]; 
xn = xn_1 + xn_2 + xn_3;   % Pulso Total

% Filtro H(z) definido por sus ceros y polos
% Polos
polo1 = 0.98*exp(j*0.8*pi);
polo2 = 0.98*exp(-j*0.8*pi);
polo3 = 1/0.95*exp(-j*(0.15*pi+0.02*pi));
polo4 = 1/0.95*exp(j*(0.15*pi+0.02*pi));
polo5 = 1/0.95*exp(-j*(0.15*pi+0.02*pi*2));
polo6 = 1/0.95*exp(j*(0.15*pi+0.02*pi*2));
polo7 = 1/0.95*exp(-j*(0.15*pi+0.02*pi*3));
polo8 = 1/0.95*exp(j*(0.15*pi+0.02*pi*3));
polo9 = 1/0.95*exp(-j*(0.15*pi+0.02*pi*4));
polo10 = 1/0.95*exp(j*(0.15*pi+0.02*pi*4));
% Ceros
cero1 = 0.8*exp(j*0.4*pi);
cero2 = 0.8*exp(-j*0.4*pi);
cero3 = 0.95*exp(j*(0.15*pi+0.02*pi));
cero4 = 0.95*exp(-j*(0.15*pi+0.02*pi));
cero5 = 0.95*exp(j*(0.15*pi+0.02*pi*2));
cero6 = 0.95*exp(-j*(0.15*pi+0.02*pi*2));
cero7 = 0.95*exp(j*(0.15*pi+0.02*pi*3));
cero8 = 0.95*exp(-j*(0.15*pi+0.02*pi*3));
cero9 = 0.95*exp(j*(0.15*pi+0.02*pi*4));
cero10 = 0.95*exp(-j*(0.15*pi+0.02*pi*4));

% Numerador
num = poly([polo1,polo2,polo3,polo4,polo5,polo6,polo7,polo8,...
    polo9,polo10,polo3,polo4,polo5,polo6,polo7,polo8,...
    polo9,polo10]);
% Denominador
den = poly([cero1,cero2,cero3,cero4,cero5,cero6,cero7,cero8,cero9,...
    cero10,cero3,cero4,cero5,cero6,cero7,cero8,cero9,...
    cero10]);

% Graficas con fvtool()
a = fvtool(xn,1);
legend(a,'Entrada x[n]')
b = fvtool(num,den);
legend(b,'Filtro H(z)')
c = fvtool(filter(num,den,xn));
legend(c,'Salida y[n]')
d = fvtool(xn,1,num,den,filter(num,den,xn));
legend(d,'Entrada x[n]','Filtro H(z)','Salida y[n]')

% Grafica de la entrada y la salida del filtro H(z)
figure()
subplot 211
plot(xn)
legend('Entrada x[n]')
xlabel('n')
ylabel('x[n]')
title('Efectos de la Demora de Grupo')
grid on
axis([1 300 -1 1])
subplot 212
plot(filter(num,den,xn))
legend('Salida y[n]')
xlabel('n')
ylabel('y[n]')
axis([1 300 -15 15])
grid on

% Diagrama de polos y ceros de H(z)
figure()
zplane(num,den)
title('Diagrama de Polos y Ceros de H(z)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conclusiones: %
%%%%%%%%%%%%%%%%%
% La demora de grupo imprime un retardo diferente a cada
% subgrupo de frecuencias. En este caso, queda en evidencia
% debido a que se trata de 3 pulsos de banda angosta modulados, 
% en distintas frecuencias, por ende las demoras de cada pulso 
% a la salida, difieren entre si. 
% 
% Sumado al efecto de la demora de grupo, tenemos
% la respuesta en magnitud propia del sistema, que puede atenuar o
% amplificar o mantener cada banda de frecuencias.
% 
% Finalmente, es importante tener un sistema de fase cero porque
% la señal a la salida no tendra demoras o retardos. Sin embargo, 
% se puede tolerar una fase lineal donde todas las frecuencias
% posean el mismo retardo. Una fase no lineal, produce los efectos
% nocivos vistos en este script.

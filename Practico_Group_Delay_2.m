%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Salida de un sistema, para una entrada formada      %
% por un pulso de banda angosta modulado y un sistema %
% con respuesta en fase cero, lineal y no lineal      %
% a partir de una Fase Cero, Lineal y No Lineal       %
%                                                     %
% Autor: Ing. Martin Gonella                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc
format compact

w0 = pi; % Frecuencia donde centramos s[n]
H = 1; % Magnitud de H(z)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo Fase Cero, beta(w)=0 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tp = 0; % Retardo de Fase
tg = 0; % Demora de Grupo
n = 1:500;

xn = cos((w0/100).*n).*cos(w0.*n); % Entrada
yn = H.*cos((w0/100).*(n-tg)).*cos(w0.*(n-tp)); % Salida
Energia_xn = sum(abs(xn))
disp('--------------------------------------------------')
Energia_yn_fase_cero = sum(abs(yn))
if Energia_xn == Energia_yn_fase_cero
    disp('x[n] e y[n] tienen la misma energia.')
    disp('--------------------------------------------------')
elseif Energia_xn > Energia_yn_fase_cero
    disp('Hubo perdida de energia por distorsion de fase.')
    disp('--------------------------------------------------')
end

figure()
subplot 311
stem(xn)
hold all
stem(yn)
legend('x[n]','y[n]')
title('Filtro Pasa Todo con Fase Cero')
xlabel('n')
ylabel('x[n], y[n]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo Fase Lineal, beta(w)=-w*30 (Fase lineal => tg=tp)
tp = 30; % Retardo de Fase
tg = 30; % Demora de Grupo

xn = cos((w0/100).*n).*cos(w0.*n); % Entrada
yn = H.*cos((w0/100).*(n-tg)).*cos(w0.*(n-tp)); % Salida
Energia_yn_fase_lineal = sum(abs(yn))
if Energia_xn == Energia_yn_fase_lineal
    disp('x[n] e y[n] tienen la misma energia.')
    disp('--------------------------------------------------')
elseif Energia_xn > Energia_yn_fase_lineal
    disp('Hubo perdida de energia por distorsion de fase.')
    disp('--------------------------------------------------')
end

subplot 312
stem(xn)
hold all
stem(yn)
legend('x[n]','y[n]')
title('Filtro Pasa Todo con Fase Lineal')
xlabel('n')
ylabel('x[n], y[n]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo Fase No Lineal, beta(w)=-w^2*30 (Fase no lineal => tg!=tp)
tp = w0*30; % Retardo de Fase
tg = 2*w0*30; % Demora de Grupo

xn = cos((w0/100).*n).*cos(w0.*n); % Entrada
yn = H.*cos((w0/100).*(n-tg)).*cos(w0.*(n-tp)); % Salida
Energia_yn_fase_no_lineal = sum(abs(yn))
if Energia_xn == Energia_yn_fase_no_lineal
    disp('x[n] e y[n] tienen la misma energia.')
    disp('--------------------------------------------------')
elseif Energia_xn > Energia_yn_fase_no_lineal
    disp('Hubo perdida de energia por distorsion de fase.')
    disp('--------------------------------------------------')
end

subplot 313
stem(xn)
hold all
stem(yn)
legend('x[n]','y[n]')
title('Filtro Pasa Todo con Fase No Lineal')
xlabel('n')
ylabel('x[n], y[n]')

%%%%%%%%%%%%%%%%%
% Conclusiones: %
%%%%%%%%%%%%%%%%%

% Cuando el sistema posee fase cero y magnitud 1, la salida es
% igual a la entrada, sin ningun retardo o defasaje entre ambas.
% 
% Cuando el sistema posee fase lineal y magnitud 1, la salida
% es igual a la entrada, salvo por un retardo o demora de la 
% salida con respecto a la entrada, pero manteniendo la misma 
% magnitud (la portadora y la envolvente poseen el mismo retardo).
% 
% Finalmente, cuando la fase es no lineal, la salida se encuentra
% distorsionada tanto en fase como en magnitud, ya que al tratarse 
% de una entrada del tipo pulso de banda angosta modulado,
% la señal envolvente (correspondiente al pulso no modulado) se
% encuentra retrasada por el retardo de grupo, en cambio la portadora
% de modulacion posee otro retardo, correspondiente al retardo 
% de fase, produciendo distorsion en fase y magnitud.
% 
% De lo ultimo se extrae la importancia de tener un sistema con 
% fase cero o a lo sumo con fase lineal.






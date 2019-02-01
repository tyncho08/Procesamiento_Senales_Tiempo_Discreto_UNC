%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A partir de un filtro considerado de distorsion H(z),         %
% se crea un filtro compensador Hc(z), utilizando lo            %
% aprendido de filtros de fase minima y filtros pasa todo.      %
% Ademas podemos observar mediante fvtool(), las propiedades de %                %
% los sistemas de Fase Minima:                                  %
% (1) Retardo de Energia Minimo                                 %
% (2) Fase Minima                                               %
% (3) Demora de Grupo Minima                                    %
% (4) Mayor Tap Inicial                                         %
%                                                               %
% Autor: Ing. Martin Gonella                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

omega = [0.0001:.0001:1]*pi;
z = exp(j*omega);
fs = 400e6;     % Frecuencia de muestreo, en Hz

% Polos y Ceros Filtro Distorsionador, Hdist(z)
num_dist = poly([0.8*exp(j*0.3*pi) 0.8*exp(-j*0.3*pi) 1.2*exp(j*0.7*pi) 1.2*exp(-j*0.7*pi)]);
den_dist = 1;

% Polos y Ceros Filtro de Fase Minima, Hmin(z)
num_min = 1.44.*poly([0.8*exp(j*0.3*pi) 0.8*exp(-j*0.3*pi) 1/conj(1.2*exp(j*0.7*pi)) 1/conj(1.2*exp(-j*0.7*pi))]);
den_min = 1;

% Polos y Ceros Filtro Pasa Todo, Hap(z)
num_ap = poly([1.2*exp(-j*0.7*pi), 1.2*exp(j*0.7*pi)]);
den_ap = poly([1/conj(1.2*exp(j*0.7*pi)), 1/conj(1.2*exp(-j*0.7*pi))]);

% Polos y Ceros Filtro Compensador, Hcomp(z) = 1/Hmin(z)
num_compensador = 1;
den_compensador = num_min;

% Polos y Ceros Filtro Total, Htot(z) = Hdist(z).Hcomp(z)
num_tot = poly([roots(num_dist)' roots(num_compensador)']);
den_tot = poly([roots(den_dist)' roots(den_compensador)']);

% Respuesta en frecuencia total
G_jw = [(z.^(-1)-(5/6)*exp(-j*0.7*pi)).*(z.^(-1)-(5/6)*exp(j*0.7*pi))]./...
    [(1-(5/6)*exp(j*0.7*pi)*z.^(-1)).*(1-(5/6)*exp(-j*0.7*pi)*z.^(-1))];

% Graficas de magnitud y fase de G(exp(jw))
figure()
subplot 211
h=semilogx(omega*fs/2/pi,20*log10(abs(G_jw)),'r');
set(h,'Linewidth',3);
set(h,'Markersize',16);
set(gca,'XScale','log','YScale','lin','FontWeight','bold','FontSize',14);
set(gca,'Linewidth',2);
xlabel('f [Hz]','interpreter','latex');
ylabel('$|G(e^{j\Omega})|$ [dB]','interpreter','latex');
title('Magnitud de la Respuesta Total, $G(e^{j\Omega})$','interpreter','latex')
axis([2*10^6 fs/2 -30 15])
subplot 212
h=semilogx(omega,unwrap(angle(G_jw)),'r');
set(h,'Linewidth',3);
set(h,'Markersize',16);
set(gca,'XScale','lin','YScale','lin','FontWeight','bold','FontSize',14);
set(gca,'Linewidth',2);
xlabel('$\Omega$','interpreter','latex');
ylabel('$angle(G(e^{j\Omega}))$ [dB]','interpreter','latex');
title('Fase de la Respuesta Total, $G(e^{j\Omega})$','interpreter','latex')
axis([omega(1) omega(end) -7 1])

% Diagrama de polos y ceros
figure()
subplot 231
zplane(num_dist,den_dist)
axis([-1.1 1.1 -1.1 1.1])
title('Filtro Distorsionador, H_{dist}(z)')
subplot 232
zplane(1.44.*num_min,den_min)
axis([-1.1 1.1 -1.1 1.1])
title('Filtro de Fase Minima, H_{min}(z)')
subplot 233
zplane(num_ap,den_ap)
axis([-1.1 1.1 -1.1 1.1])
title('Filtro Pasa Todo, H_{ap}(z)')
subplot 234
zplane(num_compensador,den_compensador)
axis([-1.1 1.1 -1.1 1.1])
title('Filtro Compensador, H_{comp}(z)')
subplot 235
zplane(num_tot,den_tot)
title('Respuesta Total Distorsionador+Compensador, H_{tot}(z)')
axis([-1.1 1.1 -1.1 1.1])

% Graficas usando fvtool()
h=fvtool(num_dist,den_dist,num_min,den_min,num_ap,den_ap,num_tot,den_tot,...
    num_compensador,den_compensador);
legend(h,'H_{dist}(z)','H_{min}(z)','H_{ap}(z)','H_{tot}(z)',...
    'H_{comp}(z)')

%%%%%%%%%%%%%%%%%
% Conclusiones: %
%%%%%%%%%%%%%%%%%

% Los polos y ceros internos al circulo unidad de H(z), 
% permanecen en Hmin(z), por otra parte, los ceros externos
% al circulo unidad, aparecen en Hmin(z) de manera inversa conjugada
% Ademas, Hap(z) presenta los ceros externos de H(z) y los polos
% que cancelan los ceros inversos conjugados de Hmin(z).
% 
% Finalmente, el filtro compensador, es la inversa de Hmin(z),
% el cual es un sistema de fase minima invertible, con inversa
% de fase minina. La respuesta en magnitud total es la unidad
% y la fase total corresponde a la fase del filtro pasa todo 
% utilizado. Hap(z) no puede ser de fase minima!
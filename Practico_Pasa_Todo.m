%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analizamos un sistema pasa todo %
% de primer orden.                %
%                                 %
% Autor: Ing. Martin Gonella      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

omega = [0.0001:.0001:1]*pi;
z = exp(j*omega);
fs = 400e6;     % Frecuencia de muestreo, en Hz

cero = 1/0.9;
polo = 0.9;
num = poly([cero]);
den = poly([polo]);

% Diagrama de polos y ceros z=0.9
figure()
zplane(num,den)
title('Diagrama de polos y ceros de H_{ap}(z) de primer orden, polo en z=0.9')

% Respuesta en frecuencia para z=0.9
Hz = [(z.^(-1)-(0.9))]./[(1-(0.9)*z.^(-1))];

% Graficas de magnitud y fase de H(exp(jw))
figure()
subplot 211
h=semilogx(omega*fs/2/pi,20*log10(abs(Hz)),'r');
set(h,'Linewidth',3);
set(h,'Markersize',16);
set(gca,'XScale','log','YScale','lin','FontWeight','bold','FontSize',14);
set(gca,'Linewidth',2);
xlabel('f [Hz]','interpreter','latex');
ylabel('$|H(e^{j\Omega})|$ [dB]','interpreter','latex');
title('Magnitud de la Respuesta Total, $H(e^{j\Omega})$, polo en $z=0.9$','interpreter','latex')
axis([2*10^6 fs/2 -30 15])
grid on
subplot 212
hh=plot(omega*fs/2/pi,angle(Hz),'b');
set(hh,'Linewidth',3);
set(hh,'Markersize',16);
set(gca,'XScale','lin','YScale','lin','FontWeight','bold','FontSize',14);
xlabel('f [Hz]','interpreter','latex');
ylabel('$\angle(H(j\omega))$','interpreter','latex');
title('Fase de la Respuesta Total, $H(e^{j\Omega})$, polo en $z=0.9$','interpreter','latex')
grid on

% Retardo de fase y Demora de Grupo, con polo en z=0.9
gd = grpdelay(num,den,512);
gd(1) = [];       % Avoid NaNs
[h,w] = freqz(num,den,512); h(1) = []; w(1) = [];
pd = -unwrap(angle(h))./w;
figure()
plot(w,gd,w,pd,':')
axis([0 pi min(gd) max(gd)]);
xlabel('Frecuencia (rad/sec)'); grid;
legend('Demora de Grupo','Retardo de Fase');
title('Demora de Grupo y Retardo de Fase, con polo en z=0.9')

%%%%%%%%%%%%%%%%%%%%%%
% Repito para z=-0.9 %
%%%%%%%%%%%%%%%%%%%%%%

cero = -1/0.9;
polo = -0.9;
num = poly([cero]);
den = poly([polo]);

% Diagrama de polos y ceros z=-0.9
figure()
zplane(num,den)
title('Diagrama de polos y ceros de H_{ap}(z) de primer orden, polo en z=-0.9')

% Respuesta en frecuencia para z=0.9
Hz = [(z.^(-1)+(0.9))]./[(1+(0.9)*z.^(-1))];

% Graficas de magnitud y fase de H(exp(jw))
figure()
subplot 211
h=semilogx(omega*fs/2/pi,20*log10(abs(Hz)),'r');
set(h,'Linewidth',3);
set(h,'Markersize',16);
set(gca,'XScale','log','YScale','lin','FontWeight','bold','FontSize',14);
set(gca,'Linewidth',2);
xlabel('f [Hz]','interpreter','latex');
ylabel('$|H(e^{j\Omega})|$ [dB]','interpreter','latex');
title('Magnitud de la Respuesta Total, $H(e^{j\Omega})$, polo en $z=-0.9$','interpreter','latex')
axis([2*10^6 fs/2 -30 15])
grid on
subplot 212
hh=plot(omega*fs/2/pi,angle(Hz),'b');
set(hh,'Linewidth',3);
set(hh,'Markersize',16);
set(gca,'XScale','lin','YScale','lin','FontWeight','bold','FontSize',14);
xlabel('f [Hz]','interpreter','latex');
ylabel('$\angle(H(j\omega))$','interpreter','latex');
title('Fase de la Respuesta Total, $H(e^{j\Omega})$, polo en $z=-0.9$','interpreter','latex')
grid on

% Retardo de fase y Demora de Grupo, con polo en z=-0.9
gd = grpdelay(num,den,512);
gd(1) = [];       % Avoid NaNs
[h,w] = freqz(num,den,512); h(1) = []; w(1) = [];
pd = -unwrap(angle(h))./w;
figure()
plot(w,gd,w,pd,':')
axis([0 pi min(gd) max(gd)]);
xlabel('Frecuencia (rad/sec)'); grid;
legend('Demora de Grupo','Retardo de Fase');
title('Demora de Grupo y Retardo de Fase, con polo en z=-0.9')

%%%%%%%%%%%%%%%%%
% Conclusiones: %
%%%%%%%%%%%%%%%%%

% La demora de grupo de un sistema pasa todo es siempre positiva, 
% debido a la negatividad de la fase de un sistema pasa todo
% para 0<w<pi.
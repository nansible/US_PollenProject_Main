function [wA_bar, wB_bar, sigA, sigB, A, B, dwA_bar, dwB_bar, dsigA, dsigB, dA , dB, eps, sigu, ubar, dt] = CBL_windstats(ustar, wstar, L, z_i, z0, C0, z)
%% ubar


ex = (1-15*z/L)^0.25;    
psi = -2*log((1+ex)/2) - log((1+ex^2)/2) + 2*atan(ex) - pi/2; 
ubar = ustar/.4*(log(z/z0) + psi);
   
%% sigu, dsigu

sigu = 0.6 * wstar;
%dsigu = 0;

%% sigw_neutral, dsigw_neutral
sigw_neutral = ustar*(1.7-z/z_i)^(1/2);
dsigw_neutral = -ustar/(2*z_i*(17/10 - z/z_i)^(1/2));

%% sigw_CBL, dsigw_CBL
sigw_CBL = wstar * 1.7^.5*(z/z_i)^(1/3)*(1-0.9*z/z_i)^(2/3);
dsigw_CBL = (10^(1/2)*17^(1/2)*wstar*(1 - (9*z)/(10*z_i))^(2/3))/...
    (30*z_i*(z/z_i)^(2/3)) - (3*10^(1/2)*17^(1/2)*wstar*(z/z_i)^(1/3))/...
    (50*z_i*(1 - (9*z)/(10*z_i))^(1/3));

%% sigw, dsigw
sigw = (((1 - exp(z/L))*wstar^3*sigw_CBL^2 + 5*exp(z/L)*ustar^3*sigw_neutral^2)/...
    ((1 - exp(z/L))*wstar^3 + 5*exp(z/L)*ustar^3))^.5;
dsigw = (2*(5*ustar^3*exp(z/L)*sigw_neutral^2 - wstar^3*sigw_CBL^2*...
    (exp(z/L) - 1))*((5*ustar^3*exp(z/L)*sigw_neutral^2)/L - ...
    (wstar^3*exp(z/L)*sigw_CBL^2)/L - 2*wstar^3*dsigw_CBL*sigw_CBL*(exp(z/L)...
    - 1) + 10*ustar^3*exp(z/L)*dsigw_neutral*sigw_neutral))/(5*exp(z/L)*ustar^3 +...
    (1 - exp(z/L))*wstar^3)^2 - (2*(5*ustar^3*exp(z/L)*sigw_neutral^2 - ...
    wstar^3*sigw_CBL^2*(exp(z/L) - 1))^2*((5*exp(z/L)*ustar^3)/L -...
    (wstar^3*exp(z/L))/L))/(5*exp(z/L)*ustar^3 + (1 - exp(z/L))*wstar^3)^3;



%% eps
eps = 0.4*wstar^3/z_i + ustar^3 * (1 - z/z_i) * (1 - 15*z/L)^-.25/(.4*z);

%% tau_v, tau_w, dt
tau_w = 2 * sigw^2/ (C0  * eps);
tau_u = 2 * sigu^2/ (C0  * eps);
dt = 0.01 * min(tau_u, tau_w);

%% w3, dw3
w3 = 1.2*(z/z_i)*(1 - (z/z_i))^(3/2)*wstar;
dw3 = (6*wstar*(1 - z/z_i)^(3/2))/(5*z_i) - (9*wstar*z*(1 - z/z_i)^(1/2))/(5*z_i^2);


%% S, dS
S = w3/sigw^3;
dS = dw3/sigw^3 - (3*dsigw*w3)/sigw^4;

%% m, dm
m = 2/3*S^(1/3);
dm = (2*dS)/(9*S^(2/3));

%% r, dr/dz
r = (1 + m^2)^3*S^2/((3 + m^2)^2*m^2);
dr = (6*dm*S^2*(m^2 + 1)^2)/(m*(m^2 + 3)^2) - (4*dm*S^2*(m^2 + 1)^3)/...
    (m*(m^2 + 3)^3) - (2*dm*S^2*(m^2 + 1)^3)/(m^3*(m^2 + 3)^2) +...
    (2*dS*S*(m^2 + 1)^3)/(m^2*(m^2 + 3)^2);

%% A, dA/dz
A = .5*(1-(r/(4+r))^.5);
dA = -(dr/(r + 4) - (dr*r)/(r + 4)^2)/(4*(r/(r + 4))^(1/2));


%% B, dB/dz
B = 1-A;
dB = -dA;


%% sigB, dsigB/dz
sigB = sigw*(A/(B*(1+m^2)))^.5;
dsigB = dsigw*(A/(B*(m^2 + 1)))^(1/2) - (sigw*((dB*A)/(B^2*(m^2 + 1)) - dA/(B*(m^2 + 1)) + (2*dm*A*m)/(B*(m^2 + 1)^2)))/(2*(A/(B*(m^2 + 1)))^(1/2));

%% sigA, dsigA/dz
sigA = sigw*(B/(A*(1+m^2)))^.5;
dsigA = dsigw*(B/(A*(m^2 + 1)))^(1/2) - (sigw*((dA*B)/(A^2*(m^2 + 1)) - dB/(A*(m^2 + 1)) + (2*dm*B*m)/(A*(m^2 + 1)^2)))/(2*(B/(A*(m^2 + 1)))^(1/2));

%% wB_bar, dwB_bar/dz
wB_bar = m*sigB;
dwB_bar = dsigB*m + dm*sigB;

%% wA_bar, dwA_bar/dz
wA_bar = m*sigA;
dwA_bar = dsigA*m + dm*sigA;


end

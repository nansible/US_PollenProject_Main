function [sigu, sigw, dsigu2, dsigw2, uw, duw, tau, ubar, dt]...
    = ASL_windstats(z,L,ustar,z0,v_s)


        
        psi = 4.7*z/L;
        ubar = ustar/.4*(log(z/z0) + psi);
        sigu = 2.4*ustar;                                               %eq. A8, calculated in param.m because it remains constant above zw for z >= zw, L < 0
        sigw = 1.25*ustar;                                              %eq. A9 for z >= zw, L < 0
        dsigu2 = 0;                                                     %derivative of sigu^2 wrt z
        dsigw2 = 0;                 %derivative of sigw^2 wrt z
        uw = -ustar^2;                                                  %eq. A3 for z >= h
        duw = 0;                                                        %derivative of uw wrt z
        T_L = (0.5*z/sigw)*(1+5*z/L);                          %eq. A5 for z >= h
        tau = T_L/(1+(1.5*v_s/sigw)^2)^0.5;                            %eq. 7
        
   
        


% if Ubar < 0.01
%     Ubar = 0;
%     tau = 0.01;
% end

dt = min(0.01*tau,1/(ubar + 3*sigu));

end






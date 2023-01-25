function [au, bu, aw, bw, P_A_exp, P_B_exp,P_E,threshcountA, threshcountB] = test_CBL_coeffs(wp, up, wA_bar, wB_bar, sigA, sigB, A, B, dwA_bar, dwB_bar, dsigA, dsigB, dA , dB, C0, eps, sigu, v_s,threshcountA, threshcountB)


%% P_A, P_B
% P_A = exp(-(wp - wA_bar)^2/(2*sigA^2))/((2*pi)^.5 * sigA);
% P_B = exp(-(wp + wB_bar)^2/(2*sigB^2))/((2*pi)^.5 * sigB);


P_A_exp = ((wp - wA_bar)/(sqrt(2)*sigA))^2;
P_B_exp = ((wp + wB_bar)/(sqrt(2)*sigB))^2;
thresh = 5;
if P_A_exp > thresh
    P_A_exp = thresh;
    threshcountA = threshcountA + 1;
else 
    threshcountA = 0;    
end
if P_B_exp > thresh
    P_B_exp = thresh;
    threshcountB = threshcountB + 1;
else 
    threshcountB = 0;    
end



P_A = exp(-P_A_exp)/((2*pi)^.5 * sigA);
P_B = exp(-P_B_exp)/((2*pi)^.5 * sigB);

%% P_E


P_E = A * P_A + B * P_B;

%% Q
Q = A*(wp - wA_bar)/sigA^2 * P_A + B*(wp + wB_bar)/sigB^2 * P_B;

%% phi_CBL
phi = -.5 * (A * dwA_bar + (wA_bar - v_s)*dA) * erf((wp - wA_bar)/(sqrt(2) * sigA)) + sigA * (A * dsigA * (wp*(wp - v_s)/sigA^2 + 1) + A * (wp - v_s)/sigA^2 * (sigA * dwA_bar - wA_bar * dsigA) + sigA * dA) * P_A ...
      +.5 * (B * dwB_bar + (wB_bar + v_s)*dB) * erf((wp + wB_bar)/(sqrt(2) * sigB)) + sigB * (B * dsigB * (wp*(wp - v_s)/sigB^2 + 1) + B * (wp - v_s)/sigB^2 * (-sigB * dwB_bar + wB_bar * dsigB) + sigB * dB) * P_B; 

      
%% au, bu
au = -up * C0*eps/(2 * sigu^2);
bu = (C0*eps)^.5;
            
%% aw, bw
aw =  -C0*eps/(2 * P_E) * Q + phi/P_E;
bw = bu;

end
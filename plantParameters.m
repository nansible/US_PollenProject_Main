function [h0, v_s] = plantParameters

Dp = 30*10^-6; %m
h0 = 2; %m
v_s = 9.81*Dp^2*988/(18*1.78*10^-5); %particle settling velocity m/s

end
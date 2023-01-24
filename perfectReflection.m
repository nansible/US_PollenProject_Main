function [x,z, up, wp] = perfectReflection(x, z, wp, up, zmax, v_s, ubar)
% perfect reflection algorithm
% computes x location of mixed layer encounter
% computes time remaining in time step after collision
% reverses up and wp
% computes new location using remaining time



dt_remaining = (z - zmax)/(wp-v_s);
x_i = x - (up + ubar) * dt_remaining;

wp = -wp;
up = -up;

dx = (up + ubar)*dt_remaining;
dz = (wp - v_s)*dt_remaining;

x = x_i + dx;
z = zmax + dz;
end

function [np, zmin,zmax, xmin, xmax, deltstart, C0, threshold, depositions] = modelingParameters(z_i, z0)
%% MODEL RUN PARAMETERS

% np, number of particles released at h0
% zmin, domain lowest height. zmax, domain highest height is defined as z_i, the top of the CBL
threshold = 99;
C0 = 3;
np = 100;           
% initialize array to store location of particle
%depositions. Use NaN, not zero, to be able to distinguish between deposited particles and those which left the domain
depositions = NaN(1,np);  
zmin = z0*1.001;         
%zmin = min(max(z0, 0.001*z_i),h0);         
zmax = z_i*.99;                    
xmin = -100;        % domain min x dir
xmax = 50000;       % domain max x dir
Q_LS = 1;           % spores/second release rate
deltstart = 1/Q_LS; % time gap in seconds between each spore released
end

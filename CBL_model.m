function  outputData = CBL_model(ustar, wstar, L, z_i, z0)
[h0, v_s] = plantParameters;

[np, zmin,zmax, xmin, xmax, deltstart, C0, threshold,...
    depositions] = modelingParameters(z_i, z0);

% If plotting concentration:
%
numParticlePaths = min(np, 500);
X = cell(1,numParticlePaths);
Z = cell(1,numParticlePaths);
% TEMP
%{
    WP = cell(1,numParticlePaths);
    PE = cell(1,numParticlePaths);
    PBexp = cell(1,numParticlePaths);
    t = tiledlayout(5,1);
%}

zgridCellSize = (zmax - zmin)/500;             % meters
xgridCellSize = (xmax - xmin)/5000;
[xgrid, zgrid, xgridConstant, zgridConstant, pgrid] = makeGrid(xmin, xmax,zmin, zmax, xgridCellSize,zgridCellSize);

%}


tic
for p = 1:np                %release particles in loop
    %% Initialize particle state
    % Initialize z to release height, x to zero, and stagger release time of
    % each particle by 'deltstart'. Mark particle as "in-domain".
    % Get initial wind statistics.
    % Initialize particle fluctuations.
    z = h0;
    x = 0;
    t = p*deltstart - deltstart;
    in_domain = 1;
    
    % get initial wind statistics
    [wA_bar, wB_bar, sigA, sigB, A, B, ~, ~, ~, ~, ~ , ~, ~, sigu,...
        ubar, dt] = CBL_windstats(ustar, wstar, L, z_i, z0, C0, h0);    
    
    % initialize particle velocities based on velocity pdfs
    wp = random(CBL_verticalPDF(wA_bar, wB_bar, sigA, sigB, A, B));
    up = sigu*randn;
    

    %% Update particle state
    while in_domain
        % If plotting concentration:
        %
            i = floor(x/xgridCellSize - xgridConstant);
            j = floor(z/zgridCellSize - zgridConstant);
            pgrid(i,j) = pgrid(i,j) + dt;        
        %}
        


        
        % find x,z position increment
        dx = (up + ubar)*dt;
        dz = (wp - v_s)*dt;
        
        % increment time and position x,z
        t = t + dt;
        x = x + dx;
        z = z + dz;
        
        % if plotting concentration:
        %
            if p < numParticlePaths % save the paths of first n particles
                X{p}(end+1) = x;
                Z{p}(end+1) = z;
                % TEMP
                %{
                WP{p}(end+1) = wp;
                %}
            end
        %}

        % if particle goes above PBL layer, reflect velocity and
        % compute position ("perfect reflection")
        if z >= zmax
            [x,z, up, wp] = perfectReflection(x, z, wp, up, zmax, v_s, ubar);
        end
        

        % If particle leaves x bounds, mark it as "not in domain", which
        % starts the next particle.
        % Else if it drops below bottom of grid, increment depgrid and 
        % mark it as "not in domain".
        % Otherwise compute next particle velocity.
        if x <= xmin || x >= xmax
            in_domain = 0;
            
        elseif z <= zmin
            depositions(p) = x;
            in_domain = 0;
            
        else
            
            % update wind statistics
            [wA_bar, wB_bar, sigA, sigB, A, B, dwA_bar, dwB_bar, dsigA,...
                dsigB, dA , dB, eps, sigu, ubar, dt]...
                = CBL_windstats(ustar, wstar, L, z_i, z0, C0, z);
            
            % TEMP - commented out!
            %
            % get langevin coefficients
            [au, bu, aw, bw] = CBL_coeffs(wp, up, wA_bar, wB_bar, sigA,...
               sigB, A, B, dwA_bar, dwB_bar, dsigA, dsigB, dA , dB,...
               C0, eps, sigu, v_s);
            %}

            % TEMP
            %{
            [au, bu, aw, bw, P_A, P_B,P_E] = test_CBL_coeffs(wp, up, wA_bar, wB_bar, sigA, sigB, A, B, dwA_bar, dwB_bar, dsigA, dsigB, dA , dB, C0, eps, sigu, v_s);
            PE{p}(end+1) = P_E;
            PBexp{p}(end+1) = P_B;
            %}


            % find u,w velocity increments (langevin equation)
            dup = au*dt + bu*randn*sqrt(dt);
            dwp = aw*dt + bw*randn*sqrt(dt);
            
            % increment u,w velocities
            up = up + dup;
            wp = wp + dwp;
            
        end
    end
    if toc > 600
        np = p;
        break
    end
    % TEMP
    %{
        nexttile(1)
        plot(X{p},Z{p})
        xlabel('x (m)')
        ylabel('Z (m)')
        hold on
        nexttile(2)
        plot(X{p},WP{p})
        xlabel('x (m)')
        ylabel('wp (m/s)')
        hold on
        nexttile(3)
        plot(X{p}(1:end-1),PBexp{p})
        xlabel('x (m)')
        ylabel('pb exp < 5 thresh')
        hold on
        nexttile(4)
        plot(X{p}(1:end-1),PE{p})
        xlabel('x (m)')
        ylabel('PE')
        hold on        
    %}
end


%% compute deposition cdf
% Remove the NaNs from depositions array and sort in order of least
% distance to greatest distance. The number of particles deposited is the
% length of this array. The "cdf" of deposited particles downwind 
% increases by 1 for each deposition. Divide by total # particles released
% and mult by 100 for percent.

depositions = sort(rmmissing(depositions));
num_deposited = length(depositions);
depcdf = [1:1:num_deposited]/np*100;

%% find rcrits
% If number of particles deposited meets threshold (99%), we can
% calculate an rcrit at that location. Calculate index at which depcdf
% meets threshold.
% Else not enough particles were deposited and that index is set to the
% end of the array. Rcrit is set as maximum distance of the domain.
% Rcritdep is distance at which 99% of particles are deposited within the domain.
% Finally, compute total percentage of particles that were deposited before
% either rcrit or rcritdep.

percdep = num_deposited/np*100;
pbeyond50km = 100-percdep;
pbeyond500m = sum(depositions>500)/np*100 + pbeyond50km;
pbeyond1km = sum(depositions>1000)/np*100 + pbeyond50km;
pbeyond5km = sum(depositions>5000)/np*100 + pbeyond50km;
pbeyond10km = sum(depositions>10000)/np*100 + pbeyond50km;
pbeyond15km = sum(depositions>15000)/np*100 + pbeyond50km;
pbeyond20km = sum(depositions>20000)/np*100 + pbeyond50km;
pbeyond25km = sum(depositions>25000)/np*100 + pbeyond50km;
pbeyond30km = sum(depositions>30000)/np*100 + pbeyond50km;
pbeyond35km = sum(depositions>35000)/np*100 + pbeyond50km;
pbeyond40km = sum(depositions>40000)/np*100 + pbeyond50km;
pbeyond45km = sum(depositions>45000)/np*100 + pbeyond50km;


if percdep >= threshold
    threshIndex = find(depcdf - threshold >= 0,1);
    r_crit = depositions(threshIndex);
    r_critdep = r_crit;
else
    r_crit = xmax;
    if num_deposited > 0
        threshIndex = find(depcdf/max(depcdf)*100 - threshold >= 0,1);
        r_critdep = depositions(threshIndex);
    else
        r_critdep = xmax;
    end
end


%% compile data for output

outputData = {[r_crit,r_critdep,percdep,np,...
    pbeyond500m,pbeyond1km,pbeyond5km,pbeyond10km,pbeyond15km,pbeyond20km,...
    pbeyond25km,pbeyond30km,pbeyond35km,pbeyond40km,pbeyond45km,pbeyond50km ...
    v_s,h0,xmin, xmax,zmin, zmax,threshold,toc,string(datetime)]};



% If plotting concentration only
%
outputData = {outputData{1,1},[0,zgrid;xgrid',pgrid],[depositions',depcdf'],X,Z};


%}




end
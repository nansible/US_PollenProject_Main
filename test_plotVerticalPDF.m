clear all
close all
GEOID = 49011;
times = datetime(2016,7,1,12,0,0);
InputFolder = '../MeanCountyTimeSeries_2016/mean_';
[timestring,inputvars] = getWeatherCasesBetweenDates(GEOID, InputFolder, times, times);

L = 1./inputvars(1);
ustar = inputvars(3);
wstar = inputvars(5);
z_i = inputvars(2);
z0 = inputvars(6);
[h0, v_s] = plantParameters;

[np, zmin,zmax, xmin, xmax, deltstart, C0, threshold,...
    depositions] = modelingParameters(z_i, z0);

z = z0:.5:5;
wp = [-5:.01:5];
up = 1;

for ind1 = 1:length(z)
    for ind2 = 1:length(wp)
    [wA_bar, wB_bar, sigA, sigB, A, B, dwA_bar, dwB_bar, dsigA,...
        dsigB, dA , dB, eps, sigu, ubar, dt]...
        = CBL_windstats(ustar, wstar, L, z_i, z0, C0, z(ind1));

    [au, bu, aw(ind1,ind2), bw, P_A_exp(ind1,ind2), P_B_exp(ind1,ind2),...
        P_E(ind1,ind2),phi(ind1,ind2),P_A(ind1,ind2),P_B(ind1,ind2)]...
        = test_CBL_coeffs(wp(ind2), up, wA_bar, wB_bar, sigA,...
        sigB, A, B, dwA_bar, dwB_bar, dsigA, dsigB, dA ,...
        dB, C0, eps, sigu, v_s);
    end
end

%%

figure
for ind3 = 1:5%length(z)
    plot(wp,P_E(ind3,:))
    hold on
    sum(P_E(ind3,:))/length(wp)*(wp(end)-wp(1))
end




%%

figure
pcolor(wp,z,P_A)
colorbar

figure
pcolor(wp,z,P_B)
colorbar

figure
pcolor(wp,z,P_E)
colorbar

figure
pcolor(wp,z,aw)
colorbar








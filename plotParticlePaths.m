%function plotParticlePaths(OutputFolder,timestamp,GEOID,p)
% X is cell array of positions
%for ii = 1:length(X)
OutputFolder = 'plotMeanCases/mean_';
timestamp = [datetime(2016,7,1,12,0,0)];
GEOID = 49027;

filenameX = [OutputFolder,'plots/XPaths_',datestr(timestamp, 'yyyy_mm_dd_hh'),'_',num2str(GEOID),'.csv'];
filenameZ = [OutputFolder,'plots/ZPaths_',datestr(timestamp, 'yyyy_mm_dd_hh'),'_',num2str(GEOID),'.csv'];

fidX = fopen(filenameX,'r');
fidZ = fopen(filenameZ,'r');
n = 1;

while ~feof(fidX)% && n < p
    X = sscanf(fgetl(fidX),"%f,");
    Z = sscanf(fgetl(fidZ),"%f,");
    plot(X,Z)
    hold on
    n = n+1;
end
fclose(fidX);
fclose(fidZ);
%end

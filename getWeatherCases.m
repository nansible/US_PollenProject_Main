function [countyData] = getWeatherCases(GEOID,InputFolder)
% filename of metcro2d time series data at a location, contains variables: 
    % LOCALTIME,UTCTIME,MOLI, PBL, USTAR, WSTAR, WSPD10, ZRUF 
    % one hour increments



filename = [InputFolder,num2str(GEOID),'.csv']; 
format = '%{dd-MMM-yyyy HH:mm:ss}D %s %f %f %f %f %f %f';

fileID = fopen(filename,'r');
countyData = textscan(fileID,format,'HeaderLines',7,'DateLocale','en_US','Delimiter',',');
fclose(fileID);
end
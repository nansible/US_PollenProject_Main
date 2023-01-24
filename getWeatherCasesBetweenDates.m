function [timestring,inputvars] = getWeatherCasesBetweenDates(GEOID, InputFolder, tlower, tupper)
% outputs table of weather cases for data between tlower and tupper. 

[countyData] = getWeatherCases(GEOID,InputFolder);


logicalArray = logical(sum(isbetween(countyData{1,1},tlower,tupper),2));

    

timestring = [string(countyData{1,1}(logicalArray)),... % LOCALTIME
    countyData{1,2}(logicalArray)];             % UTCTIME

inputvars = [countyData{1,3}(logicalArray),...  % MOLI
    countyData{1,4}(logicalArray),...           % PBL
    countyData{1,5}(logicalArray),...           % USTAR
    countyData{1,6}(logicalArray),...           % WSPD10
    countyData{1,7}(logicalArray),...           % WSTAR
    countyData{1,8}(logicalArray)];             % ZRUF

end
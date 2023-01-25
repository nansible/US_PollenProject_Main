function [countyResultsFile, timestring, inputvars, GEOID,outputFormat] = chooseCasesToRun(countiesToRun,InputFolder,OutputFolder)
% Branch - find Scope of Rogue Vels Problem


% the first monthly average case - July NOON
times = datetime(2016,7,1,12,0,0);

%for analysis 2
%times = datetime(2016,7,20,00,0,0):hours(1):datetime(2016,11,20,00,0,0); 


% use for analysis 1 monthly averages
%times = [datetime(2016,7,1,00,0,0),datetime(2016,7,1,12,0,0),...
%    datetime(2016,8,1,00,0,0),datetime(2016,8,1,12,0,0),...
%    datetime(2016,9,1,00,0,0),datetime(2016,9,1,12,0,0),...
%    datetime(2016,10,1,00,0,0),datetime(2016,10,1,12,0,0),...
%    datetime(2016,11,1,00,0,0),datetime(2016,11,1,12,0,0)];

% use for analysis 1 just one date, one hour
% times = [datetime(2016,7,20,00,0,0),datetime(2016,7,20,12,0,0),...
%     datetime(2016,8,20,00,0,0),datetime(2016,8,20,12,0,0),...
%     datetime(2016,9,22,00,0,0),datetime(2016,9,22,12,0,0),...
%     datetime(2016,10,20,00,0,0),datetime(2016,10,20,12,0,0),...
%     datetime(2016,11,20,00,0,0),datetime(2016,11,20,12,0,0)];

%%
GEOIDs = countiesToRun.GEOID(:);

countyResultsFile = [];
timestring = [];
inputvars = [];
GEOID = [];
for countyIndex = 1:height(countiesToRun)
    [timesNotDone1,countyResultsFile1,outputFormat] = setUpResultsFile(GEOIDs(countyIndex),times,OutputFolder);
    if isempty(timesNotDone1)
        timestring1 = [];
        inputvars1 = [];
        GEOID1 = [];
    else
        [timestring1,inputvars1] = getWeatherCasesBetweenDates(GEOIDs(countyIndex), InputFolder, timesNotDone1, timesNotDone1);
        GEOID1 = repmat(GEOIDs(countyIndex),length(timesNotDone1),1);
    end
    countyResultsFile = [countyResultsFile;countyResultsFile1];
    timestring = [timestring;timestring1];
    inputvars = [inputvars;inputvars1];
    GEOID = [GEOID;GEOID1];
end


end
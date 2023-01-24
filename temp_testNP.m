clear all

% modify chooseCounties to select all counties in CONUS
countiesToRun = chooseCounties; 
GEOID = countiesToRun.GEOID;


OutputFolder =  'LSModelOutput_mean/Computed_';

times = [datetime(2016,7,1,00,0,0),datetime(2016,7,1,12,0,0),...
    datetime(2016,8,1,00,0,0),datetime(2016,8,1,12,0,0),...
    datetime(2016,9,1,00,0,0),datetime(2016,9,1,12,0,0),...
    datetime(2016,10,1,00,0,0),datetime(2016,10,1,12,0,0),...
    datetime(2016,11,1,00,0,0),datetime(2016,11,1,12,0,0)];

timename = {'7_0000','7_1200',...
    '8_0000','8_1200',...
    '9_0000','9_1200',...
    '10_0000','10_1200',...
    '11_0000','11_1200'};

tic
for j = 1:length(GEOID)
    datafile = [OutputFolder,'mean_',num2str(GEOID(j)),'.csv'];
    if isfile(datafile)
        computedCases = sortComputedCasesByDate(datafile);
        for i = 1:length(times) 
            logicalArray = isbetween(computedCases.LOCALTIME,times(i),times(i));
            Output{i}(j,:) = computedCases(logicalArray,:);             
        end  
    end
    if ~mod(j,100)
        fprintf('Index = %d, GEOID: %d, Time Elapsed: %f \n',j, GEOID(j), toc)
    end
end



%%
close all
NParray = [];
for i = 1:1:length(times)
%    plot(Output{i}.RCRITDEP,Output{i}.WSTAR,'.')   
%    hold on
    NParray = [NParray; Output{i}.NP];
end

histogram(NParray)




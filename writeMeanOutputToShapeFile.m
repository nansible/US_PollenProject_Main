

filename = '../CountyMapsAndCode_2016/cb_2021_us_county_20m/cb_2021_us_county_20m.shp';
shapeCounties = shaperead(filename);
GEOID = str2num(cell2mat({shapeCounties.GEOID}'));
OutputFolder =  '../plotRogueVels_Jan25_2023/';


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

% 
% %%
% for j = 1:length(shapeGEOID)
%     datafile = [OutputFolder,'mean_',num2str(shapeGEOID(j)),'.csv'];
%     if isfile(datafile)
%         computedCases = sortComputedCasesByDate(datafile);
%         for i = 1:length(times) 
%             logicalArray = isbetween(computedCases.LOCALTIME,times(i),times(i));
%             Output{i}(j,:) = computedCases(logicalArray,:);             
%         end  
%     end
%     if ~mod(j,100)
%         fprintf('Index = %d, GEOID: %d, Time Elapsed: %f \n',j, shapeGEOID(j), toc)
%     end
% end

%%
for i = 2:2%length(times)
    for j = 1:length(GEOID)
        datafile = [OutputFolder,'mean_',num2str(GEOID(j)),'.csv'];
        if isfile(datafile)
            computedCases = sortComputedCasesByDate(datafile);
            logicalArray = isbetween(computedCases.LOCALTIME,times(i),times(i));
            Output = computedCases(logicalArray,:);
            for k = 4:length(Output.Properties.VariableNames)
                shapeCounties(j).(Output.Properties.VariableNames{k}) = Output{1,k};
            end
        else
            for k = 4:length(Output.Properties.VariableNames)
                shapeCounties(j).(Output.Properties.VariableNames{k}) = 0;
            end
        end
    end
    shapewrite(shapeCounties,['CountyMapsAndCode_2016/testRogueVels',timename{i},'.shp']);
end

%}

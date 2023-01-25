% Branch - find Scope of Rogue Vels Problem

clear all

%% Where to save output?
%InputFolder =  'CountyTimeSeries_2016/';
%OutputFolder =  'LSModelOutput/plotting';
InputFolder = 'MeanCountyTimeSeries_2016/mean_';
%OutputFolder =  'LSModelOutput_mean_fixed/mean_';
OutputFolder = 'plotMeanCases/mean_';
%% Choose which counties to run
% modify to run all cases > 100 acres of hemp
countiesToRun = chooseCounties;


%% For each county:
[countyResultsFile, timestring, inputvars, GEOID,outputFormat] = chooseCasesToRun(countiesToRun,InputFolder,OutputFolder);

%%
tic
for c = 1:length(GEOID)
    outputData = runLS(inputvars(c,:));
    
    countyfileID = fopen(countyResultsFile(c),'a');
    fprintf(countyfileID,outputFormat,GEOID(c),timestring(c,:), inputvars(c,:), outputData{1,1});
    fclose(countyfileID);
    
    % If plotting concentration only
    %
        %writematrix(outputData{1,2},[OutputFolder,'plots/Concentration_',datestr(timestring(c,1), 'yyyy_mm_dd_hh'),'_',num2str(GEOID(c)),'.csv']);
        %writematrix(outputData{1,3},[OutputFolder,'plots/Deposition_',datestr(timestring(c,1), 'yyyy_mm_dd_hh'),'_',num2str(GEOID(c)),'.csv']);
        %writecell(outputData{1,4}',[OutputFolder,'plots/XPaths_',datestr(timestring(c,1), 'yyyy_mm_dd_hh'),'_',num2str(GEOID(c)),'.csv']);
        %writecell(outputData{1,5}',[OutputFolder,'plots/ZPaths_',datestr(timestring(c,1), 'yyyy_mm_dd_hh'),'_',num2str(GEOID(c)),'.csv']);
        
        % actually plot particle paths during run and save the figures
        %
            X = outputData{1,4};
            Z = outputData{1,5};
            figure
            for thisPath = 1:length(X)
                plot(X{thisPath},Z{thisPath})
                hold on
            end
            xlabel('X (m), downwind')
            ylabel('Z (m)')
            set(findall(gcf,'-property','FontSize'),'FontSize',16)
            title({'Particle Paths ';...
            ['GEOID = ', num2str(GEOID(c)),', ',datestr(timestring(c,1), 'mmmm yyyy, HHMM')]})
            saveas(gcf,[OutputFolder,'plots/pathsPlotted_',datestr(timestring(c,1), 'yyyy_mm_dd_hh'),'_',num2str(GEOID(c)),'.fig'])
            close all
        %}
            
    %}



end


toc




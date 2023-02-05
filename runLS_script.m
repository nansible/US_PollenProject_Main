% temporary change log 
% 1_22_23 
% parfor to for
% uncommented all "if plotting concentration only" sections in this
% script, ASL function, and CBL function
% running specific county in chooseCounties
% uncommented "a very bad case to plot" line in chooseCasesToRun and
% commented out monthly averages times
% changed output folder to something else
% AM I ON A BRANCH? - debugRogueVELS BRANCH!!!

clear all

%% Where to save output?
%InputFolder =  'CountyTimeSeries_2016/';
%OutputFolder =  'LSModelOutput/plotting';
InputFolder = '../MeanCountyTimeSeries_2016/mean_';
%OutputFolder =  'LSModelOutput_mean_fixed/mean_';
OutputFolder = '../plotRogueVels_Feb5_2023/mean_';
%% Choose which counties to run
% modify to run all cases > 100 acres of hemp
countiesToRun = chooseCounties;


%% For each county:
% modify to run times for Analysis 2, all times btw July 20 to Nov 20
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
            %saveas(gcf,[OutputFolder,'plots/pathsPlotted_',datestr(timestring(c,1), 'yyyy_mm_dd_hh'),'_',num2str(GEOID(c)),'.jpg'])

        %}
            
    %}



end


toc




function [times,filename,outputFormat] = setUpResultsFile(GEOID,times,OutputFolder)
%% Set up rcrit storage in csv file
% Open or create a Computed_GEOID.csv file and check if we have already run
% any of the cases. Remove those ones from the 'cases' list. 

filename = string([OutputFolder,num2str(GEOID),'.csv']);

if isfile(filename)
    times = findNotDoneCases(times, filename);
    
else
    fileID = fopen(filename,'a');
    fprintf(fileID,['GEOID,LOCALTIME,UTCTIME,MOLI,PBL,USTAR,WSPD10,WSTAR,ZRUF,',...   
        'RCRIT,RCRITDEP,PERCDEP,NP,',...
        'PBEYOND500M,PBEYOND1KM,PBEYOND5KM,PBEYOND10KM,PBEYOND15KM,PBEYOND20KM,',...
        'PBEYOND25KM,PBEYOND30KM,PBEYOND35KM,PBEYOND40KM,PBEYOND45KM,PBEYOND50KM,', ...
        'VS,H0,XMIN,XMAX,ZMIN,ZMAX,THRESHOLD,RUNTIME,RUNDATE\n']);     
    fclose(fileID);
end

outputFormat = ['%d,%s,%s,%f,%f,%f,%f,%f,%f,',...
    '%f,%f,%f,%f,%f,%f,',...
    '%f,%f,%f,%f,%f,%f,'...
    '%f,%f,%f,%f,',...
    '%f,%f,%f,%f,%f,%f,%f,%f,%s\n'];
filename = repmat(filename,length(times),1);

end
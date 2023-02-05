function sortedComputedCases = sortComputedCasesByDate(filename)
% filename is name of .csv input file from metcro2d
% sort all rows by date and overwrite original file

format = ['%d %{dd-MMM-yyyy HH:mm:ss}D %s %f %f %f %f %f %f ',... 
    '%f %f %f %f %f ',...
    '%f %f %f %f %f %f ',...
    '%f %f %f %f %f %f ',...
    '%f %f %f %f %f %f %f %f %s\n'];
ds = tabularTextDatastore(filename,'TextscanFormats',format);                                  
ds.ReadSize = 'file';
if hasdata(ds)
    computedCases = read(ds);
    [~,ia] = unique(computedCases.LOCALTIME);
    sortedComputedCases = computedCases(ia,:);
    writetable(sortedComputedCases,filename)
else
    % file exists but it is completely empty
    sortedComputedCases = table;
    sortedComputedCases.LOCALTIME = datetime([],[],[]);
    fileID = fopen(filename,'a');
    fprintf(fileID,['GEOID,LOCALTIME,UTCTIME,MOLI,PBL,USTAR,WSPD10,WSTAR,ZRUF,',...   
        'RCRIT,RCRITDEP,PERCDEP,NP,VS,H0,',...                                                
        'XMIN,XMAX,ZMIN,ZMAX,THRESHOLD,RUNTIME,RUNDATE\n']);                                      
    fclose(fileID);
end
reset(ds)

  
end
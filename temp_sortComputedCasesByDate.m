function sortedComputedCases = temp_sortComputedCasesByDate(filename)
% USED THIS ONCE ON 12/19/22 TO FIX PBEYOND COLUMNS (summing each with
% PBEYOND50KM). NEVER USE AGAIN!
% filename is name of .csv input file from metcro2d
% sort all rows by date and overwrite original file


format = ['%d %{dd-MMM-yyyy HH:mm:ss}D %s %f %f %f %f %f %f ',... 
    '%f %f %f %f %f %f ',...
    '%f %f %f %f %f %f ',...
    '%f %f %f %f ',... 
    '%f %f %f %f %f %f %f %f %s\n'];
ds = tabularTextDatastore(filename,'TextscanFormats',format);                                  
ds.ReadSize = 'file';
if hasdata(ds)
    computedCases = read(ds);
    [~,ia] = unique(computedCases.LOCALTIME);
    sortedComputedCases = computedCases(ia,:);
    sortedComputedCases.PBEYOND500M = sortedComputedCases.PBEYOND500M + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND1KM = sortedComputedCases.PBEYOND1KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND5KM = sortedComputedCases.PBEYOND5KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND10KM = sortedComputedCases.PBEYOND10KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND15KM = sortedComputedCases.PBEYOND15KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND20KM = sortedComputedCases.PBEYOND20KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND25KM = sortedComputedCases.PBEYOND25KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND30KM = sortedComputedCases.PBEYOND30KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND35KM = sortedComputedCases.PBEYOND35KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND40KM = sortedComputedCases.PBEYOND40KM + sortedComputedCases.PBEYOND50KM;
    sortedComputedCases.PBEYOND45KM = sortedComputedCases.PBEYOND45KM + sortedComputedCases.PBEYOND50KM;
    
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
function countiesToRun = chooseCounties
% Branch - find Scope of Rogue Vels Problem

%% Choose all counties in CONUS
%
ds = tabularTextDatastore('CONUSCounties_List.csv');
ds.ReadSize = 'file';
countiesToRun = read(ds);

% find list of counties 
%
countiesList = [4011, 4015, 6051,8003,8013,8027,8037,8043,8045,8049,8057,8059,8069,8071];
countiesToRun = countiesToRun(ismember(countiesToRun.GEOID,countiesList),:);
%}

% find specific county (montgomery county VA - 51121)
%{
countiesToRun = countiesToRun(countiesToRun.GEOID == 49027,:); 
reset(ds)
%}

% find 2022 counties with > 100 acres of hemp
%{
countiesToRun = countiesToRun(countiesToRun.HEMPACRESOct2022 > 100,:); 
reset(ds)
%}


% find 2022 counties with < 100 acres of hemp AND > 80 acres of hemp
%{
countiesToRun = countiesToRun(countiesToRun.HEMPACRESOct2022 < 100 & countiesToRun.HEMPACRESOct2022 > 80,:); 
reset(ds)
%}

end

function countiesToRun = chooseCounties
% Branch - find Scope of Rogue Vels Problem

%% Choose all counties in CONUS
%
ds = tabularTextDatastore('CONUSCounties_List.csv');
ds.ReadSize = 'file';
countiesToRun = read(ds);


% find specific county (montgomery county VA - 51121)
%
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

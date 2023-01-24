timename = {'7_0000','7_1200',...
    '8_0000','8_1200',...
    '9_0000','9_1200',...
    '10_0000','10_1200',...
    '11_0000','11_1200'};
filename = ['CountyMapsAndCode_2016/MEANMONTHS_counties_2016_CONUS_',timename{2},'.shp'];
shapeCounties = shaperead(filename);
GEOID = str2num(cell2mat({shapeCounties.GEOID}'));
OutputFolder =  'LSModelOutput_mean/Computed_';


times = [datetime(2016,7,1,00,0,0),datetime(2016,7,1,12,0,0),...
    datetime(2016,8,1,00,0,0),datetime(2016,8,1,12,0,0),...
    datetime(2016,9,1,00,0,0),datetime(2016,9,1,12,0,0),...
    datetime(2016,10,1,00,0,0),datetime(2016,10,1,12,0,0),...
    datetime(2016,11,1,00,0,0),datetime(2016,11,1,12,0,0)];

%% cdf
xpos =[0, .5, 1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
deps = [ones(1,height(shapeCounties))*100; shapeCounties.PBEYOND500M; shapeCounties.PBEYOND1KM; shapeCounties.PBEYOND5KM; shapeCounties.PBEYOND10KM; shapeCounties.PBEYOND15KM; shapeCounties.PBEYOND20KM; shapeCounties.PBEYOND25KM; shapeCounties.PBEYOND30KM; shapeCounties.PBEYOND35KM; shapeCounties.PBEYOND40KM; shapeCounties.PBEYOND45KM; shapeCounties.PBEYOND50KM];

figure
for i = 1:height(shapeCounties)
    plot(xpos,deps(:,i))
    hold on
end

%% pdf
centers = (xpos(2:end) - xpos(1:end-1))/2;
deppdf = deps(1:end-1,:) - deps(2:end,:);
figure
for i = 1:height(shapeCounties)
    plot(centers(2:end)',deppdf(2:end,i))
    hold on
end
 
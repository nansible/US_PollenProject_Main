function [xgrid, zgrid, xgridConstant, zgridConstant, pgrid] = makeGrid(xmin, xmax,zmin, zmax, xgridCellSize,zgridCellSize)

xgrid = xmin:xgridCellSize:xmax;      % meters
zgrid = zmin:zgridCellSize:zmax;       % meters


xgridConstant = xgrid(1)/xgridCellSize-1;
zgridConstant = zgrid(1)/zgridCellSize-1;

pgrid = zeros(length(xgrid),length(zgrid));
end
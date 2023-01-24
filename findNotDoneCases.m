function times = findNotDoneCases(times, filename)


sortedComputedCases = sortComputedCasesByDate(filename);

%if height(sortedComputedCases) > 0
    [~,ia] = setdiff(times,sortedComputedCases.LOCALTIME);
    times = times(ia);
%end


end
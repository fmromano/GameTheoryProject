function compPrefMatrix = compPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)

    compPrefMatrix = []
    if nargin>=1 & nargin < 3
        error('Need exactly 3 arguments (Or no arguments for default values)')
    end
    if nargin == 0
        % The nth row is the nth computers list of number of cores of each type that are available.
        % The number of rows should be the number of computers.
        % The number of columns should be the number of types of cores.
        coreAvailabilityMatrix = [
                        8, 7, 6; ...
                        1, 23, 3;  ... 
                        14,  8, 2; ...
                        23, 12, 18,; ...
                        5, 25,  13,; ...
                      ]

        % The nth row is the nth job's list of speed ratios for the each core type.
        % The number of rows should be the number of jobs.
        % The number of columns should be the number of types of cores.
        speedMatrix = [
                        30, 41, 22; ... 
                        12, 13, 3;  ... 
                        1,  28, 42; ... 
                        20, 22, 1,; ... 
                        25, 2,  16,; ...
                      ]

        % The nth element is the max number of cores that can be used by job n.
        % The number of columns should be the number of jobs.
        maxNumCoresMatrix = [8,20,10,4,1,50]
    end

    totalNumComps = size(coreAvailabilityMatrix,1)
    totalNumJobs = size(maxNumCoresMatrix,2)

    compPrefMatrix = zeros(totalNumComps,totalNumJobs)

    [maxNumCoresSorted, jobsWithMostCores] = sort(maxNumCoresMatrix,'descend')
    for x = 1:totalNumComps
        compPrefMatrix(x,:) = jobsWithMostCores
    end

    % Reformat compPrefMatrix to be input to collegeAdmissionsGame
    for x = 1:totalNumComps
        [notUsed, compPrefFormatted] = sort(compPrefMatrix(x,:))
        compPrefMatrix(x,:) = compPrefFormatted
    end

end


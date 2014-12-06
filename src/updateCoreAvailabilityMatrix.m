function [coreAvailabilityMatrix,matchedJob,matchedComp] = updateCoreAvailabilityMatrix(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix,matchingMatrix)

    if nargin>=1 & nargin < 4
    coreAvailabilityMatrix = []
    error('Need exactly 3 arguments (Or no arguments for default values)')
    end
    if nargin == 0
    % The nth row is the nth computers list of number of cores of each type that are available.
    % The number of rows should be the number of computers.
    % The number of columns should be the number of types of cores.
    coreAvailabilityMatrix = [
    8, 7, 6; ...
    1, 23, 3; ...
    14, 8, 2; ...
    23, 12, 18,; ...
    5, 25, 13,; ...
    ]
    % The nth row is the nth job's list of speed ratios for the each core type.
    % The number of rows should be the number of jobs.
    % The number of columns should be the number of types of cores.
    speedMatrix = [
    30, 41, 22; ...
    12, 13, 3; ...
    1, 28, 42; ...
    20, 22, 1,; ...
    25, 2, 16,; ...
    ]
    % The nth element is the max number of cores that can be used by job n.
    % The number of columns should be the number of jobs.
    maxNumCoresMatrix = [8,20,10,1,50]

    % The only nonzero element of the nth row is the job number that has been assigned to the nth computer.
    matchingMatrix = [
     0,0,0,4,0; ...
     0,0,0,0,5; ...
     0,0,3,0,0; ...
     1,0,0,0,0; ...
     0,2,0,0,0; ...
     ]

    end  

    totalNumComps = size(matchingMatrix,1)

    matchedJobs = sum(matchingMatrix,2)
    % Check to be sure there is at least one matching
    if sum(matchedJobs,1) ==0
        error('There is no one matched!')
    end

    % TODO FIXME: Be sure that when calling CollegeAdmissionsGame, 
    % if a computer doesn't have any cores left, then to set its quota to 0.

    % Of the jobs that were matched, which uses the most cores?
    reducedMaxNumCoresMatrix = zeros(1,size(matchedJobs,1))
    for x = 1:totalNumComps
        if matchedJobs(x) > 0
            reducedMaxNumCoresMatrix(x) = maxNumCoresMatrix(matchedJobs(x))
        end
    end
    [maxNumCores, jobMostCores] = max(reducedMaxNumCoresMatrix)
    matchedJob = matchedJobs(jobMostCores)

    % Which computer is matchedJob assigned to?
    compOfJobMostCores = find(matchedJobs==matchedJob)
    % How many cores does that computer actually have available?
    totalCoresAvailable = sum(coreAvailabilityMatrix(compOfJobMostCores,:))

    % How many cores is matchedJob actually able to use?
    if totalCoresAvailable<maxNumCores
        numCoresUsed = totalCoresAvailable
    else
        numCoresUsed = maxNumCores
    end

    [coreSpeedsSorted,coreSpeedsSortedIndices] = sort(speedMatrix(matchedJob,:),'descend')
    for x = 1:numCoresUsed
        while coreAvailabilityMatrix(compOfJobMostCores,coreSpeedsSortedIndices(x))>0
            coreAvailabilityMatrix(compOfJobMostCores,coreSpeedsSortedIndices(x)) = coreAvailabilityMatrix(compOfJobMostCores,coreSpeedsSortedIndices(x)) - 1;
            numCoresUsed = numCoresUsed - 1;
            if numCoresUsed == 0
                break
            end
        end
        if numCoresUsed == 0
            break
        end
    end

    matchedComp = compOfJobMostCores;
            

end

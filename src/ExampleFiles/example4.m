%example 4

coreAvailabilityMatrix = [
                        8, 7, 6; ...
                        1, 23, 3;  ...
                        14,  8, 2; ...
                        23, 12, 18,; ...
                      ];

speedMatrix = [
                        30, 41, 22; ...
                        12, 13, 3;  ...
                        1,  28, 42; ...
                        20, 22, 1,; ...
                        25, 2,  16,; ...
                        4, 4, 3;...
                        50, 20, 10;...
                        28, 29, 50;...
                        ];
                    
maxNumCoresMatrix = [8,20,10,1,50,3,15,17];

% Check dimensions
    if size(maxNumCoresMatrix,2) ~= size(speedMatrix,1)
        error('A matrix has the wrong number of jobs')
    elseif size(coreAvailabilityMatrix,2) ~= size(speedMatrix,2)
        error('A matrix has the wrong number of core types')
    end

    % Common variables
    numComps = size(coreAvailabilityMatrix,1)
    numJobs = size(maxNumCoresMatrix,2)

    % Matrix to store final matchings
    finalMatchingMatrix = zeros(numComps,numJobs);

% While there are still cores available and jobs to be matched
while sum(sum(coreAvailabilityMatrix))>0 & sum(maxNumCoresMatrix)>0
    jobPrefs = jobPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)
    compPrefs = compPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)
    quotaArray = ones(1,size(compPrefs,1))

    % If a computer doesn't have any cores left, set its quota to zero
    for x = 1:numComps
        if sum(coreAvailabilityMatrix(x,:))==0
            quotaArray(x) = 0
        end
    end

    % Perform matching
    [matchingMatrix, leftoverJobs, leftoverComps, leftoverQuota] = collegeAdmissionsGame(jobPrefs,compPrefs,quotaArray);

    % Find the most significant matching (the one with the job with most cores)
    % and update the coreAvailabilityMatrix
    [coreAvailabilityMatrix,matchedJob,matchedComp] = updateCoreAvailabilityMatrix(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix,matchingMatrix);

    % When a job has been assigned to a computer, set its maxNumCores to zero to signify this
    % This way, when doing the matching, it will be preferred the least compared with all other jobs
    maxNumCoresMatrix(matchedJob) = 0;

    % Record Final matchings
    finalMatchingMatrix(matchedComp,matchedJob) = matchedJob;
end

finalMatchingMatrix

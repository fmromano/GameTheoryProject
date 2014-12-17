function [resultMatrix] = deferredAcceptance2(coreAvailabilityMatrix,...
    speedMatrix, maxNumCoresMatrix)




if nargin == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create inputs to algorithm
    % The nth row is the nth computer's list of number of cores of each type that are available.
    % The number of rows should be the number of computers.
    % The number of columns should be the number of types of cores.
    coreAvailabilityMatrix = [
        8,      7,      6,     ;...
        1,      23,     3,     ;...
        14,     8,      2,     ;...
        23,     12,     18,    ;...
        5,      25,     13,    ;...
    ];
    % The nth row is the nth job's list of speed ratios for the each core type.
    % The number of rows should be the number of jobs.
    % The number of columns should be the number of types of cores.
    speedMatrix = [
        30,     41,     22,    ;...
        12,     13,     3,     ;...
        1,      28,     42,    ;...
        20,     22,     6,     ;...
        25,     2,      66,    ;...
        40,     41,     62,    ;...
        42,     13,     6,     ;...
        4,      38,     62,    ;...
        40,     32,     2,     ;...
        45,     3,      26,    ;...
        40,     31,     22,    ;...
        52,     33,     2,     ;...
        5,      38,     42,    ;...
        50,     32,     1,     ;...
        55,     2,      16,    ;...
    ];

% The nth element is the max number of cores that can be used by job n.
    % The number of columns should be the number of jobs.
maxNumCoresMatrix = [8,20,10,4,1,3,27,14,50,8,40,13,4,18,30];%,58,32,33,41,14,21]
elseif nargin<=1 && nargin > 4
    error('Need exactly 3 arguments (Or no arguments for default values)')
end %if nargin == 0 or ~= 3

% coreAvailabilityMatrix = [
%                         8, 7, 6; ...
%                         1, 23, 3;  ...
%                         14,  8, 2; ...
%                         23, 12, 18,; ...
%                       ];
% 
% speedMatrix = [
%                         30, 41, 22; ...
%                         12, 13, 3;  ...
%                         1,  28, 42; ...
%                         20, 22, 1,; ...
%                         25, 2,  16,; ...
%                         4, 4, 3;...
%                         50, 20, 10;...
%                         28, 29, 50;...
%                         ];
%                     
% maxNumCoresMatrix = [8,20,10,1,50,3,15,17];

% Check dimensions
    if size(maxNumCoresMatrix,2) ~= size(speedMatrix,1)
        error('A matrix has the wrong number of jobs')
    elseif size(coreAvailabilityMatrix,2) ~= size(speedMatrix,2)
        error('A matrix has the wrong number of core types')
    end

    % Common variables
    numComps = size(coreAvailabilityMatrix,1);
    numJobs = size(maxNumCoresMatrix,2);
    tempMatchingMatrix = zeros(numComps,numJobs);

    % Matrix to store final matchings
    finalMatchingMatrix = zeros(numComps,numJobs);

% While there are still cores available and jobs to be matched
while sum(sum(coreAvailabilityMatrix))>0 && sum(maxNumCoresMatrix)>0
    jobPrefs = jobPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix);
    compPrefs = compPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix);
    quotaArray = ones(1,size(compPrefs,1));

    % If a computer doesn't have any cores left, set its quota to zero
    for x = 1:numComps
        if sum(coreAvailabilityMatrix(x,:))==0
            quotaArray(x) = 0;
        end
    end

    % Perform matching
    [matchingMatrix, leftoverJobs, leftoverComps, leftoverQuota] = ...
        collegeAdmissionsGame(jobPrefs,compPrefs,quotaArray);
    
    if numJobs == nnz(matchingMatrix)
        tempMatchingMatrix = tempMatchingMatrix + matchingMatrix;
        resultMatrix = matchingMatrix;
        break %done
    end

%     % Find the most significant matching (the one with the job with most cores)
%     % and update the coreAvailabilityMatrix
%     [coreAvailabilityMatrix,matchedJob,matchedComp] = ...
%         updateCoreAvailabilityMatrix(coreAvailabilityMatrix,speedMatrix,...
%                                      maxNumCoresMatrix,matchingMatrix);
% 
%     % When a job has been assigned to a computer, set its maxNumCores to zero to signify this
%     % This way, when doing the matching, it will be preferred the least compared with all other jobs
%     maxNumCoresMatrix(matchedJob) = 0;
% 
%     % TODO: Record Final matchings
%     finalMatchingMatrix(matchedComp,matchedJob) = matchedJob;
    
    for iLoop = 1:numComps
        currentMatch = nonzeros(matchingMatrix(iLoop,:));
        
        if currentMatch ~= 0
            coreAvailabilityMatrix = ...
                updateCoreAvailabilityMatrixAlt(coreAvailabilityMatrix, ...
                speedMatrix, maxNumCoresMatrix, matchingMatrix(iLoop,:), iLoop);
        end
        
    end
    
    %Update results matrix and delete jobs that have been taken
    listOfJobs = nonzeros(matchingMatrix);
    for jLoop = 1:nnz(matchingMatrix)
        maxNumCoresMatrix(listOfJobs(jLoop)) = 0;
    end
    numJobs = numJobs - nnz(listOfJobs);
    
    tempMatchingMatrix = tempMatchingMatrix + matchingMatrix;
    
end

resultMatrix = tempMatchingMatrix;

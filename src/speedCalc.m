function [timeScores] = speedCalc(resultMatrix, ...
    coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)
%For a given setup, calculate how fast it will take to complete this set of
%jobs.
if nargin>=1 & nargin < 4
    coreAvailabilityMatrix = []
    error('Need exactly 3 arguments (Or no arguments for default values)')
end
if nargin == 0
    resultMatrix = [1     0     0     0     0;...
                    0     0     3     4     0;...
                    0     0     0     0     0;...
                    0     0     0     0     5;...
                    0     2     0     0     0];
    
    % The nth row is the nth computers list of number of cores of each type that are available.
    % The number of rows should be the number of computers.
    % The number of columns should be the number of types of cores.
    coreAvailabilityMatrix = [
    8, 7, 6; ...
    1, 23, 3; ...
    14, 8, 2; ...
    23, 12, 18,; ...
    5, 25, 13,; ...
    ];
    % The nth row is the nth job's list of speed ratios for the each core type.
    % The number of rows should be the number of jobs.
    % The number of columns should be the number of types of cores.
    speedMatrix = [
    30, 41, 22; ...
    12, 13, 3; ...
    1, 28, 42; ...
    20, 22, 1,; ...
    25, 2, 16,; ...
    ];
    % The nth element is the max number of cores that can be used by job n.
    % The number of columns should be the number of jobs.
    maxNumCoresMatrix = [8,20,10,1,50];
    
end

totalNumComps = size(coreAvailabilityMatrix,1);
totalNumJobs = nnz(resultMatrix);
[~,selectedJobs] = find(resultMatrix ~= 0);
totalNumCoreTypes = size(speedMatrix,2);
timeScores = zeros(2,totalNumJobs);
timeScores(1,:) = selectedJobs;

%Need to convert result matrix into what jobs have taken which resources,
%then calculate their speed ratios similar to how the speeds were used for
%the job preference matrices.

% For each job, calculate the total speed
for compNum = 1:totalNumComps
    tmpCoreAvailabilityMatrix = coreAvailabilityMatrix;
    processingPower = zeros(1,totalNumComps);
    totalJobsPerComp = nnz(resultMatrix(compNum,:));
    [~,jobList] = find(resultMatrix(compNum,:));
    
    for jobNum = 1:totalJobsPerComp
        coresAddedSoFar = 0;
        % Calculate relative speed at completing job
        [sortedCoreSpeeds,coreTypeRanking] = sort(speedMatrix(jobList(jobNum),:),'descend') ;
        for coreNum = 1:totalNumCoreTypes
            % Find the best core for this job
            nextBestCoreType = coreTypeRanking(coreNum);
            % Use all the cores of this type that the computer has available.
            while tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)>0
                % For each core used, add its processing power to the total
                processingPower(compNum) = processingPower(compNum) + speedMatrix(jobList(jobNum),nextBestCoreType);
                coresAddedSoFar = coresAddedSoFar + 1;
                % The core is no longer available so mark it as such.
                tmpCoreAvailabilityMatrix(compNum,nextBestCoreType) = tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)-1;
                % Stop if job has reached max number of cores
                if coresAddedSoFar == maxNumCoresMatrix(jobList(jobNum))
                    break
                end
            end
            % Stop if job has reached max number of cores
            if coresAddedSoFar == maxNumCoresMatrix(jobList(jobNum))
                break
            end
        end
        
        timeScores(2,jobList(jobNum)) = processingPower(compNum);
        processingPower(compNum) = 0;
    end

end




end %function
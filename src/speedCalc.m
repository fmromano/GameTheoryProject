function [timeScores] = speedCalc(resultMatrix, ...
    coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)
%For a given setup, calculate how fast it will take to complete this set of
%jobs.  Useful if compared to multiple test cases.  Besides that, this
%number may seem like gibberish.  The scores are derived the same way job
%preferences were created.

%To do:  1.  Create a cores used by job X matrix. This setup is currently 
%computed based on the original number of cores.
if nargin>=1 && nargin < 4
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
    23, 12, 10,; ...
    5, 0, 13,; ...
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
selectedJobs = unique(resultMatrix);
if selectedJobs(1) == 0
    selectedJobs = selectedJobs(2:end);
end
totalNumCoreTypes = size(speedMatrix,2);
timeScores = zeros(2,totalNumJobs);
timeScores(1,:) = selectedJobs;
threadsLeft = timeScores;
threadsLeft(2,:) = 1;

%Need to convert result matrix into what jobs have taken which resources,
%then calculate their speed ratios similar to how the speeds were used for
%the job preference matrices.

% For each job, calculate the total speed
for compNum = 1:totalNumComps
    tmpCoreAvailabilityMatrix = coreAvailabilityMatrix;
    processingPower = zeros(1,totalNumComps);
    totalJobsPerComp = nnz(resultMatrix(compNum,:));
    jobList = nonzeros(resultMatrix(compNum,:));
    
    
    
    if totalJobsPerComp == 0
        %do nothing
    else
        for jobNum = 1:totalJobsPerComp
            coresAddedSoFar = 0;
            % Calculate relative speed at completing job
            [~,coreTypeRanking] = ...
                sort(speedMatrix(jobList(jobNum),:),'descend') ;
            
            jobIndex = find(jobList(jobNum) == timeScores(1,:));
            
            for coreNum = 1:totalNumCoreTypes
                % Find the best core for this job
                nextBestCoreType = coreTypeRanking(coreNum);
                % Use all the cores of this type that the computer has available.
                while tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)>0
                    % For each core used, add its processing power to the total
                    processingPower(compNum) = processingPower(compNum) + ...
                        speedMatrix(jobList(jobNum),nextBestCoreType);
                    coresAddedSoFar = coresAddedSoFar + 1;
                    % The core is no longer available so mark it as such.
                    tmpCoreAvailabilityMatrix(compNum,nextBestCoreType) = ...
                        tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)-1;
                    % Stop if job has reached max number of cores
                    if coresAddedSoFar == maxNumCoresMatrix(jobList(jobNum))
                        threadsLeft(2,jobIndex) = 0;
                        break
                    end
                end
%                 % Stop if job has reached max number of cores
%                 if coresAddedSoFar == maxNumCoresMatrix(jobList(jobNum))
%                     threadsLeft(2,jobIndex) = 0;
%                     break
%                 end
%               
                if threadsLeft(2,jobIndex) ~= 0
                threadsLeft(2,jobIndex) = maxNumCoresMatrix(jobList(jobNum)) - ...
                    coresAddedSoFar;
                end
            end
            
            timeScores(2,jobIndex) = processingPower(compNum);
            processingPower(compNum) = 0;
        end
    end

end

timeScores
threadsLeft

end %function
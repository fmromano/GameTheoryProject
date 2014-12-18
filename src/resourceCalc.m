function [resourceScores,percentCoresUsed] = ...
    resourceCalc(resultMatrix, coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)
%The purpose of this function is to see how efficiently the resources are
%distributed.

%resourceScores:  This is based on the speed matrix and the core types
%used.  If a job is able to use the best cores, it will run the most
%efficiently.

%percentCoresUsed:  see how many cores are used (one thread per core)


if nargin == 0  
    %This setup is completely arbitrary and may not be stable.
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
    23, 8, 10,; ...
    5, 0, 10,; ...
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
elseif nargin<=2 && nargin > 4
    error('Need exactly 3 arguments (Or no arguments for default values)')
end

%% Find the Percent of Cores Used First (1 == 100% <= all used)
updatedCoreAvailabilityMatrix = coreAvailabilityMatrix;
for iLoop = 1:length(coreAvailabilityMatrix(:,1))
        currentMatch = nonzeros(resultMatrix(iLoop,:));
        
        if ~isempty(currentMatch)
            updatedCoreAvailabilityMatrix = ...
                updateCoreAvailabilityMatrixAlt(updatedCoreAvailabilityMatrix, ...
                speedMatrix, maxNumCoresMatrix, resultMatrix(iLoop,:), iLoop);
        end
end

if sum(sum(updatedCoreAvailabilityMatrix)) == 0
    percentCoresUsed = 1;
else
%     percentCoresPerComp = zeros(1,length(coreAvailabilityMatrix));
% 
%     for jLoop = 1:length(percentCoresPerComp)
%         coresUsed = sum(coreAvailabilityMatrix(jLoop,:)) - ...
%                     sum(updatedCoreAvailabilityMatrix(jLoop,:));
% 
%         totalCores = sum(coreAvailabilityMatrix(jLoop,:));
%                             
%         percentCoresPerComp(jLoop) = coresUsed./totalCores;
% 
%     end
%     
%     percentCoresUsed = mean(percentCoresPerComp);
        coresUsed = sum(sum(coreAvailabilityMatrix)) - ...
            sum(sum(updatedCoreAvailabilityMatrix));
        
        totalCores = sum(sum(coreAvailabilityMatrix));
        
        percentCoresUsed = coresUsed./totalCores;
end

%% Find resources used


totalNumComps = size(coreAvailabilityMatrix,1);
totalNumSelectedJobs = nnz(resultMatrix);
totalNumJobs = size(resultMatrix,2);
selectedJobs = unique(resultMatrix);
if selectedJobs(1) == 0
    selectedJobs = selectedJobs(2:end);
end
totalNumCoreTypes = size(speedMatrix,2);
rawTimeScores = zeros(2,totalNumJobs);
rawTimeScores(1,:) = 1:totalNumJobs;
coresUsedPerJob = zeros(totalNumCoreTypes+1,totalNumJobs);

%Need to convert result matrix into what jobs have taken which resources,
%then calculate their speed ratios similar to how the speeds were used for
%the job preference matrices.
tmpCoreAvailabilityMatrix = coreAvailabilityMatrix;
% For each job, calculate which cores were used
for compNum = 1:totalNumComps

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
            
            jobIndex = find(jobList(jobNum) == rawTimeScores(1,:));
            threadsLeft = maxNumCoresMatrix(jobIndex);

            for coreNum = 1:totalNumCoreTypes
                % Find the best core for this job
                nextBestCoreType = coreTypeRanking(coreNum);

                % Use all the cores of this type that the computer has available.
                while tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)>0
                    if coresAddedSoFar == maxNumCoresMatrix(jobList(jobNum))
                        %threadsLeft(2,jobIndex) = 0;
                        break
                    end

                    coresAddedSoFar = coresAddedSoFar + 1;

                    coresUsedPerJob(nextBestCoreType,jobIndex) = ...
                            coresUsedPerJob(nextBestCoreType,jobIndex) + 1;

                    threadsLeft = threadsLeft - 1;

                    tmpCoreAvailabilityMatrix(compNum,nextBestCoreType) = ...
                        tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)-1;

                end %end while tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)>0


            end  %for corenum
            coresUsedPerJob(totalNumCoreTypes+1, jobIndex) = threadsLeft; %leftovers
         end %for jobnum

    end  %if totalnumberofjobs
end  %for compnum

coresUsedPerJob = coresUsedPerJob';
percentOptimal = zeros(1,totalNumCoreTypes+1);
resourceScores = zeros(1,totalNumJobs);
speedMatrix = [speedMatrix'; zeros(1,length(maxNumCoresMatrix))]';

for rLoop = 1:totalNumJobs
    maxSpeed = max(speedMatrix(rLoop,:));
    percentOptimal = zeros(1,totalNumCoreTypes+1);
    for sLoop = 1:(totalNumCoreTypes+1)        
        percentOptimal(sLoop) = (speedMatrix(rLoop,sLoop).*...
                                 coresUsedPerJob(rLoop,sLoop))./maxSpeed;
        
    end
    resourceScores(rLoop) = sum(percentOptimal)./maxNumCoresMatrix(rLoop);
end

%Rank the jobs based on the cores... maybe

end %of function
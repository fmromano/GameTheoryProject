function [coreAvailabilityMatrix] = updateCoreAvailabilityMatrixAlt(coreAvailabilityMatrix,...
    speedMatrix,maxNumCoresMatrix,resultVector,currentComp)

totalNumComps = length(currentComp);
totalNumJobs = nnz(resultVector);
selectedJobs = unique(resultVector);
if selectedJobs(1) == 0
    selectedJobs = selectedJobs(2:end);
end
totalNumCoreTypes = size(speedMatrix,2);
rawTimeScores = zeros(2,totalNumJobs);
rawTimeScores(1,:) = selectedJobs;
threadsLeft = rawTimeScores;
threadsLeft(2,:) = 1;

% For each job, calculate the total speed
compNum = currentComp;
    tmpCoreAvailabilityMatrix = coreAvailabilityMatrix;
    processingPower = zeros(1,totalNumComps);
    totalJobsPerComp = nnz(resultVector);
    jobList = nonzeros(resultVector);
    
    if totalJobsPerComp == 0
        %do nothing
    else
        for jobNum = 1:totalJobsPerComp
            coresAddedSoFar = 0;
            % Calculate relative speed at completing job
            [~,coreTypeRanking] = ...
                sort(speedMatrix(jobList(jobNum),:),'descend') ;
            
            jobIndex = find(jobList(jobNum) == rawTimeScores(1,:));
            
            for coreNum = 1:totalNumCoreTypes
                % Find the best core for this job
                nextBestCoreType = coreTypeRanking(coreNum);
                % Use all the cores of this type that the computer has available.
                while tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)>0
                    % For each core used, add its processing power to the total
                    processingPower = processingPower + ...
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
            
            %rawTimeScores(2,jobIndex) = processingPower;
            %processingPower(compNum) = 0;
            
            coreAvailabilityMatrix = tmpCoreAvailabilityMatrix;
        end
    end


end
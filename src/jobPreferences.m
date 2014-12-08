function jobPrefMatrix = jobPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)

    jobPrefMatrix = [];
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
        maxNumCoresMatrix = [8,20,10,1,50]
    end

    %TODO: Check validity of array dimensions

    totalNumComps = size(coreAvailabilityMatrix,1)
    totalNumJobs = size(speedMatrix,1)
    totalNumCoreTypes = size(speedMatrix,2)

    % Initialize Returned Preference Matrix
    % Each row is a job's ranking of the computers by preference.
    % 1 means most preferred.
    jobPrefMatrix = zeros(totalNumJobs,totalNumComps);

    % For each job, 
    for jobNum = 1:totalNumJobs
        tmpCoreAvailabilityMatrix = coreAvailabilityMatrix;
        processingPower = zeros(1,totalNumComps);
        % For each computer
        for compNum = 1:totalNumComps
            coresAddedSoFar = 0;
            % Calculate relative speed at completing job
            [sortedCoreSpeeds,coreTypeRanking] = sort(speedMatrix(jobNum,:),'descend') ;
            for coreNum = 1:totalNumCoreTypes
                % Find the best core for this job
                nextBestCoreType = coreTypeRanking(coreNum);
                % Use all the cores of this type that the computer has available.
                while tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)>0
                    % For each core used, add its processing power to the total
                    processingPower(compNum) = processingPower(compNum) + speedMatrix(jobNum,nextBestCoreType);
                    coresAddedSoFar = coresAddedSoFar + 1;
                    % The core is no longer available so mark it as such.
                    tmpCoreAvailabilityMatrix(compNum,nextBestCoreType) = tmpCoreAvailabilityMatrix(compNum,nextBestCoreType)-1;
                    % Stop if job has reached max number of cores
                    if coresAddedSoFar == maxNumCoresMatrix(jobNum)
                        break
                    end
                end
                % Stop if job has reached max number of cores
                if coresAddedSoFar == maxNumCoresMatrix(jobNum)
                    break
                end
            end
        end
        % Create current job's preference list
        [processingPowerSorted, jobPref] = sort(processingPower, 'descend');
        jobPrefMatrix(jobNum,:) = jobPref;
    end

    % Reformat jobPrefMatrix to be input to collegeAdmissionsGame
    for x = 1:totalNumJobs
        [notUsed, jobPrefFormatted] = sort(jobPrefMatrix(x,:));
        jobPrefMatrix(x,:) = jobPrefFormatted;
    end

end



function [averageTimeScores,percentJobsAssigned] = ...
    comparisonFunction(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix)
%Comparison between methods 


%% Run The different algorithms

%Apply for first preference
[resultMatrixSM] = simpleMatching(coreAvailabilityMatrix, ...
    speedMatrix, maxNumCoresMatrix);
[rawTimeScoresSM,percentThreadsUsedSM,adjustedTimeScoresSM] = ...
    speedCalc(resultMatrixSM, coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix);

%Deferred Acceptance with quotas = TotalNumberOfJobs/TotalNumberOfComputers
[resultMatrixDA1] = deferredAcceptance(coreAvailabilityMatrix, ...
    speedMatrix, maxNumCoresMatrix);
[rawTimeScoresDA1,percentThreadsUsedDA1,adjustedTimeScoresDA1] = ...
    speedCalc(resultMatrixDA1, coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix);

%Deferred Acceptance where matchings are based on the number of cores
%available
[resultMatrixDA2] = deferredAcceptance2(coreAvailabilityMatrix, ...
    speedMatrix, maxNumCoresMatrix);
[rawTimeScoresDA2,percentThreadsUsedDA2,adjustedTimeScoresDA2] = ...
    speedCalc(resultMatrixDA2, coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix);

%Deferred Acceptance where each round is looking for a best match
[resultMatrixPA] = proposedAlgorithm(coreAvailabilityMatrix, ...
    speedMatrix, maxNumCoresMatrix);
[rawTimeScoresPA,percentThreadsUsedPA,adjustedTimeScoresPA] = ...
    speedCalc(resultMatrixPA, coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix);

%% Compile the results
allPercents = [percentThreadsUsedSM;percentThreadsUsedDA1;percentThreadsUsedDA2;percentThreadsUsedPA];
allRawScores = [rawTimeScoresSM(2,:);rawTimeScoresDA1(2,:);rawTimeScoresDA2(2,:);rawTimeScoresPA(2,:)];
allScores = [adjustedTimeScoresSM;adjustedTimeScoresDA1;adjustedTimeScoresDA2;adjustedTimeScoresPA];

percentJobsAssigned = zeros(4,1);
totalJobs = length(maxNumCoresMatrix);

for iLoop = 1:length(percentJobsAssigned)
    percentJobsAssigned(iLoop) = nnz(allPercents(iLoop,:))/totalJobs;
end

averageTimeScores = zeros(4,1);

for jLoop = 1:length(averageTimeScores)
    averageTimeScores(jLoop) = mean(nonzeros(allScores(jLoop,:)));
    
end

end %of function

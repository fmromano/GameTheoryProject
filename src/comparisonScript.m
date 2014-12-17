%comparison script
%used to run the comparison function multiple times
clc
clear all
close all
format compact

numberOfRuns = 50;
averageTimeScores = zeros(4,1);
percentJobsAssigned = averageTimeScores;
averagePercentThreadsAssigned = averageTimeScores;

%Random Runs
    coreAvailabilityMatrix = ceil(25.*rand(14,3));
    speedMatrix = ceil(100.*rand(14,3));
    maxNumCoresMatrix = ceil(50.*rand(1,14));
    
    [averageTimeScores,percentJobsAssigned, averagePercentThreadsAssigned] = ...
    comparisonFunction(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);


for runLoop = 2:numberOfRuns
    %Random Runs
    coreAvailabilityMatrix = ceil(25.*rand(14,3));
    speedMatrix = ceil(100.*rand(14,3));
    maxNumCoresMatrix = ceil(20.*rand(1,14));

    [averageTimeScoresTemp,percentJobsAssignedTemp,averagePercentThreadsAssignedTemp] = ...
    comparisonFunction(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);

    for iLoop = 1:length(averageTimeScores)
        averageTimeScores(iLoop) = mean([averageTimeScores(iLoop) averageTimeScoresTemp(iLoop)]);
        percentJobsAssigned(iLoop) = mean([percentJobsAssigned(iLoop) ...
            percentJobsAssignedTemp(iLoop)]); 
        averagePercentThreadsAssigned(iLoop) = mean([averagePercentThreadsAssigned(iLoop)...
            averagePercentThreadsAssignedTemp(iLoop)]);
    end
    
    disp(runLoop)
end

averageTimeScores
percentJobsAssigned
averagePercentThreadsAssigned
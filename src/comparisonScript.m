%comparison script
%used to run the comparison function multiple times
clc
clear all
close all
format compact

% %Run 1
% numberOfRuns = 500;
% numComp = 20;
% numJob = 50;
% numCoreType = 5;
% maxCoresPerType = 25;
% maxThreads = 50;
% speedRatio = 100;

% %Run 2
% numberOfRuns = 100;
% numComp = 50;
% numJob = 100;
% numCoreType = 10;
% maxCoresPerType = 50;
% maxThreads = 200;
% speedRatio = 200;

% %Run 3
% numberOfRuns = 100;
% numComp = 20;
% numJob = 100;
% numCoreType = 5;
% maxCoresPerType = 50;
% maxThreads = 50;
% speedRatio = 200;

%Run 4
numberOfRuns = 500;
numComp = 10;
numJob = 50;
numCoreType = 5;
maxCoresPerType = 25;
maxThreads = 50;
speedRatio = 200;

%Random Runs
coreAvailabilityMatrix = ceil(maxCoresPerType*rand(ceil(numComp.*rand(1)),ceil(numCoreType.*rand(1))));
speedMatrix = ceil(speedRatio.*rand(ceil(numJob.*rand(1)),length(coreAvailabilityMatrix(1,:))));
maxNumCoresMatrix = ceil(maxThreads.*rand(1,length(speedMatrix(:,1))));
    
    [aveTimeScr,perJobAsgn,avePerThdsAsgn,aveCorePer,aveResScr] = ...
    comparisonFunction(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);


for runLoop = 2:numberOfRuns
    %Random Runs
    coreAvailabilityMatrix = ceil(maxCoresPerType*rand(ceil(numComp.*rand(1)),ceil(numCoreType.*rand(1))));
    speedMatrix = ceil(speedRatio.*rand(ceil(numJob.*rand(1)),length(coreAvailabilityMatrix(1,:))));
    maxNumCoresMatrix = ceil(maxThreads.*rand(1,length(speedMatrix(:,1))));

    [aveTimeScrTmp,perJobAsgnTmp,avePerThdsAsgnTmp,aveCorePerTmp,aveResScrTmp] = ...
    comparisonFunction(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);

    for iLoop = 1:length(aveTimeScr)
        aveTimeScr(iLoop) = mean([aveTimeScr(iLoop) aveTimeScrTmp(iLoop)]);
        perJobAsgn(iLoop) = mean([perJobAsgn(iLoop) ...
            perJobAsgnTmp(iLoop)]); 
        avePerThdsAsgn(iLoop) = mean([avePerThdsAsgn(iLoop)...
            avePerThdsAsgnTmp(iLoop)]);
        aveCorePer(iLoop) = mean([aveCorePer(iLoop)...
            aveCorePerTmp(iLoop)]);
        aveResScr(iLoop) = mean([aveResScr(iLoop)...
            aveResScrTmp(iLoop)]);
    end
    
    disp(runLoop)
end

aveTimeScr
perJobAsgn
avePerThdsAsgn
aveCorePer
aveResScr
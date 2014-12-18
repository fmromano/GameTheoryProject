%comparison script
%used to run the comparison function multiple times
clc
clear all
close all
format compact

numberOfRuns = 200;
aveTimeScr = zeros(4,1);
perJobAsgn = aveTimeScr;
avePerThdsAsgn = aveTimeScr;

%Random Runs
coreAvailabilityMatrix = ceil(25.*rand(ceil(20.*rand(1)),ceil(5.*rand(1))));
speedMatrix = ceil(100.*rand(ceil(50.*rand(1)),length(coreAvailabilityMatrix(1,:))));
maxNumCoresMatrix = ceil(50.*rand(1,length(speedMatrix(:,1))));
    
    [aveTimeScr,perJobAsgn,avePerThdsAsgn,aveCorePer,aveResScr] = ...
    comparisonFunction(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);


for runLoop = 2:numberOfRuns
    %Random Runs
coreAvailabilityMatrix = ceil(25.*rand(ceil(20.*rand(1)),ceil(5.*rand(1))));
speedMatrix = ceil(100.*rand(ceil(50.*rand(1)),length(coreAvailabilityMatrix(1,:))));
maxNumCoresMatrix = ceil(50.*rand(1,length(speedMatrix(:,1))));


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
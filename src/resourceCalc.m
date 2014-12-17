function [resourceScores,percentCoresUsed,percentThreadsUsed] = ...
    resourceCalc(resultMatrix, coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)
%The purpose of this function is to see how efficiently the resources are
%distributed.

%resourceScores:  scores based on the optimality of the cores chosen
%(optimality is based on speedMatrix)

%percentCoresUsed:  see how many cores are used (one thread per core)

%percentThreadsUsed:  see how many threads were utilized (don't have to use
%all of them to complete a job)

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

updatedCoreAvailabilityMatrix = coreAvailabilityMatrix;
for iLoop = 1:5
        currentMatch = nonzeros(resultMatrix(iLoop,:));
        
        if currentMatch ~= 0
            updatedCoreAvailabilityMatrix = ...
                updateCoreAvailabilityMatrixAlt(updatedCoreAvailabilityMatrix, ...
                speedMatrix, maxNumCoresMatrix, resultMatrix(iLoop,:), iLoop);
        end
end

if sum(sum(updatedCoreAvailabilityMatrix)) == 0
    percentCoresUsed = 1;
else
    
    
end


end %of function
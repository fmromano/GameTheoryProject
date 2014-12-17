function [resultMatrix] = deferredAcceptance(coreAvailabilityMatrix,...
    speedMatrix, maxNumCoresMatrix)
%Deferred Acceptance 1

if nargin<=1 && nargin > 4
    error('Need exactly 3 arguments (Or no arguments for default values)')
end

if nargin == 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create inputs to algorithm
    % The nth row is the nth computer's list of number of cores of each type that are available.
    % The number of rows should be the number of computers.
    % The number of columns should be the number of types of cores.
    coreAvailabilityMatrix = [
        8,      7,      6,     ;...
        1,      23,     3,     ;...
        14,     8,      2,     ;...
        23,     12,     18,    ;...
        5,      25,     13,    ;...
    ];
    % The nth row is the nth job's list of speed ratios for the each core type.
    % The number of rows should be the number of jobs.
    % The number of columns should be the number of types of cores.
    speedMatrix = [
        30,     41,     22,    ;...
        12,     13,     3,     ;...
        1,      28,     42,    ;...
        20,     22,     6,     ;...
        25,     2,      66,    ;...
        40,     41,     62,    ;...
        42,     13,     6,     ;...
        4,      38,     62,    ;...
        40,     32,     2,     ;...
        45,     3,      26,    ;...
        40,     31,     22,    ;...
        52,     33,     2,     ;...
        5,      38,     42,    ;...
        50,     32,     1,     ;...
        55,     2,      16,    ;...
    ];

% The nth element is the max number of cores that can be used by job n.
    % The number of columns should be the number of jobs.
maxNumCoresMatrix = [8,20,10,4,1,3,27,14,50,8,40,13,4,18,30];%,58,32,33,41,14,21]
end %if nargin == 0

jobPrefs = jobPreferences(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);
compPrefs = compPreferences(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);
numJobs = length(maxNumCoresMatrix);
numComps = length(coreAvailabilityMatrix(:,1));
maxJobsPerComp = ceil(numJobs/numComps);
quotaArray = ones(1,numComps);
quotaArray(:) = maxJobsPerComp;


resultMatrix = collegeAdmissionsGame(jobPrefs,compPrefs,quotaArray);

end %end of function

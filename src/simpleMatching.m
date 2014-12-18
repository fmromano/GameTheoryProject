function [resultMatrix] = simpleMatching(coreAvailabilityMatrix, ...
    speedMatrix, maxNumCoresMatrix)
%Simple Match function
%All jobs will be matched based on preferences only.

%Initialize computer preferences and job preferences.

%Output the matches, leftovers, and efficiency (will be used to see how
%well this method works).

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

%Matchings jobs and computers based on job preference only.  This is a
%waiting list setup.  Matched based on first preferences.
jobPrefs = jobPreferences(coreAvailabilityMatrix,speedMatrix,maxNumCoresMatrix);
jobList = 1:length(jobPrefs(:,1));
[preferredComputer,jobNumber] = sort(jobPrefs(:,1));
[chosenComputers,numJobs] = count_unique(preferredComputer);

resultMatrix = zeros(size(jobPrefs))';
for iLoop = 1:length(chosenComputers)
    for jLoop = 1:numJobs(iLoop)
        resultMatrix(chosenComputers(iLoop),jobNumber(jLoop)) = jobNumber(jLoop);
    end
    
    jobNumber = jobNumber((numJobs(iLoop)+1):end);
    if isempty(jobNumber)
        break
    end
end

%Output the matches, leftovers, and efficiency (will be used to see how
%well this method works).
resultMatrix;
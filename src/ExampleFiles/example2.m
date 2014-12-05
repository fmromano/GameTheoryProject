% Example - 
% The ith element of the output is the man who will be matched to the ith
% woman. 

% Functions are in the directory above
addpath('../');

jobPrefs = jobPreferences()
compPrefs = compPreferences()

%men_pref = [4 1 2 3; 2 3 1 4; 2 4 3 1; 3 1 4 2; 3 4 1 2];
%women_pref = [4 1 3 2 5; 1 3 2 4 5; 1 2 3 4 5; 4 1 3 2 5];

resultMatrix = collegeAdmissionsGame(jobPrefs,compPrefs,[1 1 1 1]);

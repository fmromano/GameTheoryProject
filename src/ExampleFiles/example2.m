% Example - 
% The ith element of the output is the man who will be matched to the ith
% woman. 

% Functions are in the directory above
addpath('../');

jobPrefs = jobPreferences()
compPrefs = compPreferences()
quotaArray = ones(1,size(jobPrefs,1))

resultMatrix = collegeAdmissionsGame(jobPrefs,compPrefs,quotaArray);

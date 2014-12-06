% Example - 

% Functions are in the directory above
addpath('../');

jobPrefs = jobPreferences()
compPrefs = compPreferences()
quotaArray = ones(1,size(jobPrefs,1))

resultMatrix = collegeAdmissionsGame(jobPrefs,compPrefs,quotaArray);

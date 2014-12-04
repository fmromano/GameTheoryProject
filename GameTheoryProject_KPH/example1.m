% Example - 
% The ith element of the output is the man who will be matched to the ith
% woman. 



N = 4;                      % Number of men/women

men_pref = zeros(N,N);      % Preference order for the men
women_pref = zeros(N,N);    % Preference order for the women


men_pref = [4 1 2 3; 2 3 1 4; 2 4 3 1; 3 1 4 2];
women_pref = [4 1 3 2; 1 3 2 4; 1 2 3 4; 4 1 3 2];

%resultMatrix = collegeAdmissionsGame(men_pref,women_pref,[1 1 1 1]);

%resultMatrix2 = collegeAdmissionsGame(men_pref,women_pref,[1 2 1 1]);

resultMatrix3 = collegeAdmissionsGame(men_pref,women_pref,[1 1 1 0]);

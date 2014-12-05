function [responseMatrix, leftoverAppl, leftoverInst, leftoverQuota] = ...
             collegeAdmissionsGame(applicantPref, institutionPref, quotaArrayLengths)
                                          
%Help documentation here
%Assuming applicants apply first
%Matrix setup assumption:
%A = [1st 2nd 3rd ...]
%B = [1st 2nd 3rd ...]
%And so on for both the applicants and institutions.

%To do:
% 1. Test this more.  I have only tried this with easy examples.

%Testing to see what is present...
if nargin < 1
    applicantPref = [3 2 3 1;3 1 3 1;3 2 1 1];
    institutionPref = [3 2 1; 3 2 1;3 2 1];
    quotaArrayLengths = [1 1 2];
end
if nargin == 1, error('Please specify other preference matrix and quota vector.'); end
% Still thinking on this one...
% if numel(applicantPref) ~= numel(institutionPref)
%     disp('Preference matrices are mismatched.  Quitting...')
%     return
% end

%Set vectors and matrices
numAppl = length(applicantPref(:,1));
numInst = length(institutionPref(:,1));
applyMat = zeros(numInst,numAppl);
tentAcceptMat = zeros(numInst,numAppl);
responseMatrix = applyMat;
applFree = ones(numAppl,1);
instFree = ones(numInst,1);

%Main stop parameter for the while loop
allMatched = 0;

%Continue matching until either all applicants or institutions are taken.
while allMatched == 0
    
    %Have the applicants propose to the institutions.
    for iLoop = 1:numAppl
        if applFree(iLoop) == 1
            nextChoice = find(applicantPref(iLoop,:) > 0, 1);
            applyMat(applicantPref(iLoop,nextChoice),iLoop) = iLoop;
            applicantPref(iLoop,nextChoice) = 0;
        end
    end

    %Have the institutions accept tentatively, check their quotas, and
    %reject the ones beyond the quota.
    for iLoop = 1:numInst
        quota = quotaArrayLengths(iLoop);
        if quota > nnz(applyMat(iLoop,:))
            tentAcceptMat(iLoop,:) = applyMat(iLoop,:);
        elseif quota == nnz(applyMat(iLoop,:))
            tentAcceptMat(iLoop,:) = applyMat(iLoop,:);
            instFree(iLoop) = 0;
        end %end if below or at the quota
        
        if quota < nnz(applyMat(iLoop,:))
            tempList = applyMat(iLoop,:);
            instPref = institutionPref(iLoop,:);
            
            %Find out how each preference ranks compared to the others
            ranked = zeros(length(tempList));
            for jLoop = 1:numInst
                ranked(jLoop,:) = instPref == tempList(jLoop); 
            end
            
            ranked = sum(ranked,1)';
            indices = find(ranked);
            keptAppl = instPref(indices(1:quota));
            
            tempZeroedList = zeros(size(tempList));
            for kLoop = 1:quota
                index = find(keptAppl(kLoop)==tempList);
                tempZeroedList(index) = tempList(index);
            end
            
            %Put the kept applicants back into the applyMat
            applyMat(iLoop,:) = tempZeroedList;
            instFree(iLoop) = 0;
        end %end if above quota
        
        %See which applicants are currently taken...
        for lLoop = 1:numAppl
            testAppl = sum(sum(applyMat == lLoop));
            if testAppl > 0
                applFree(lLoop) = 0;
            elseif testAppl == 0
                applFree(lLoop) = 1;
            end            
        end %for lLoop = 1:numAppl
    end %for iLoop = 1:numInst
    
    
    %Assemble the response matrix
    responseMatrix = applyMat;
    
    %Determine whether everyone is tentatively matched or not
    if sum(instFree) == 0 || sum(applFree) == 0
        allMatched = 1;
    end
end %while allMatched == 0

responseMatrix

fullIndices = find(instFree == 0);
quotaArrayLengths(fullIndices) = 0;

leftoverInst = [];
leftoverQuota = [];
if sum(instFree) > 0
    leftoverInst = find(instFree == 1);
    for mLoop = 1:length(leftoverInst)
        leftoverQuota(mLoop) = quotaArrayLengths(leftoverInst(mLoop));
    end
end

leftoverAppl = [];
if sum(applFree) > 0
    leftoverAppl = find(applFree == 1);
end

leftoverInst
leftoverQuota
leftoverAppl

end %end of the function
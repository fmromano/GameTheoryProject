function [responseMatrix] = collegeAdmissionsGame(applicantPref, ...
                                  institutionPref, quotaArrayLengths)
                                          
%Help documentation here
%Assuming applicants apply first
%Assumption:
%A = 1st 2nd 3rd ...
%B = 1st 2nd 3rd ...
%And so on for both the applicants and institutions.

numAppl = length(applicantPref(:,1));
numInst = length(institutionPref(1,:));
applyMat = zeros(numAppl,numInst);
tentAcceptMat = zeros(numAppl,numInst);
responseMatrix = applyMat;
applFree = ones(numAppl,1);
instFree = ones(numInst,1);

allMatched = 0;

%Continue matching until all members are paired.
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
        end
        
        if quota < nnz(applyMat(iLoop,:))
            tempList = applyMat(iLoop,:);
            instPref = institutionPref(iLoop,:);
            
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
            applyMat(iLoop,:) = tempZeroedList;
            instFree(iLoop) = 0;
        end
    end
    
    
    %Assemble the response matrix
    responseMatrix = applyMat;
    
    %Determine whether everyone is tentatively matched or not
    if sum(instFree) == 0 || sum(applFree) == 0
        allMatched = 1;
    end
end %while allMatched == 0

disp(responseMatrix);

end %function
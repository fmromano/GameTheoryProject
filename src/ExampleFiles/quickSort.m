%Quicksort function


%Matchings jobs and computers based on job preference only.  This is a
%waiting list setup.
jobPrefs = jobPreferences(coreAvailabilityMatrix, speedMatrix, maxNumCoresMatrix)


%Output the matches, leftovers, and efficiency (will be used to see how
%well this method works).
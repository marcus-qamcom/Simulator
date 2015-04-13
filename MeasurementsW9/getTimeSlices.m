function TIME_SLICES = getTimeSlices(TEST_SPEC, firstVeh, lastVeh)

  [T_LAST D_LAST RSSI_tmp LAT_tmp LONG_tmp SEQ_tmp lab_tmp] = ...
    getLink(TEST_SPEC, lastVeh, lastVeh);  % Get pos/time for first truck

  [T_FIRST D_FIRST RSSI_tmp LAT_tmp LONG_tmp SEQ_tmp lab_tmp] = ...
    getLink(TEST_SPEC, firstVeh, firstVeh);  % Get pos/time for first truck

  TIME_SLICES = getTimeSlicesT(TEST_SPEC, T_FIRST, D_FIRST, T_LAST, D_LAST);

end

function TIME_SLICES = getTimeSlicesT(TEST_SPEC, T_FIRST, D_FIRST, T_LAST, D_LAST)
% GETTIMESLICES returns timestamps when platoon is within valid sections for the test
%
% Todo: Should I use data from both antennas to get more exact result, or perhaps data for last-to-last?

  testcase_no = TEST_SPEC.testcase_no;
  AP = TEST_SPEC.AP;
  
  % Get configuration data for the test
  testconf = getTestConfiguration(testcase_no, AP);

  if testcase_no == '8'
    % No slices for this test, just use start and stop time. No distance possible since in tunnel
  
    % Test start time in unix time format
    tu_start=timeHuman2timeUnix(testconf.starttime);
    TIME_SLICES(1,1) = 0;
    % Test stop time in unix time format
    tu_stop=timeHuman2timeUnix(testconf.stoptime);
    TIME_SLICES(1,2) = tu_stop-tu_start;
  else 
    for i=1:size(testconf.locfilter, 1)
      d1 = testconf.locfilter(i,1);
      d2 = testconf.locfilter(i,2);
      if (d1>d2)
        % Search on way back towards reference point
        base1 = find(D_FIRST(:,1)==max(D_FIRST(:,1)),1);
        base2 = find(D_LAST(:,1)==max(D_LAST(:,1)),1);
        idx2 = find(D_LAST(base2:end,1)<=d1,1)+base2; % Last truck
        idx1 = find(D_FIRST(base1:end,1)<=d2,1)+base1; % First truck
      else
        idx1 = find(D_FIRST(:,1)>=d2,1); % First truck
        idx2 = find(D_LAST(:,1)>=d1,1); % Last truck
      end
      TIME_SLICES(i,1) = T_LAST(idx2);
      TIME_SLICES(i,2) = T_FIRST(idx1);
    end % for i
  end % if-else
  
  %TIME_SLICES = sort(TIME_SLICES,1); % Sort slices on start time

end

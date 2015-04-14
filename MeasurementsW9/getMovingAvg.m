function getMovingAvg(tc, ap, fs)
% This script calculates moving average packet error rate

% Specify which test to use
% Convert to struct for historical reasons
TEST_SPEC = struct('testcase_no', tc, 'AP', ap, 'framesize', fs);

% Specify which test to use

file_data = sprintf(['SimData_tc%sAP%sfs%d_data.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
file_per = sprintf(['SimData_tc%sAP%sfs%d_per.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
file_mavg = sprintf(['SimData_tc%sAP%sfs%d_mavg_per.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);

ant_per_veh = 2; % TODO Save this data as well from allTests script

% This script assumes saved data
load(file_data);

min_time = TX_T_ALL{1}(1)
max_time = TX_T_ALL{1}(size(TX_T_ALL{1},2))


window_size = 5;  % 10 sekunder moving average
start_time = min_time + (window_size/2);
end_time = max_time - (window_size/2);
time_step = 0.1;
dim_size = 8; % 8 nodes (4 veh, 2 antenna)

empty_PER=0;
empty_tx=0;
all_PER = 0;

% Calculate moving average
MAVG_PER = zeros(dim_size, dim_size, (end_time-start_time)*(1/time_step));
idx = 1;
for ts=start_time:time_step:end_time
%for ts=start_time:time_step:(start_time+0.1)
  % Get data for current time step
  from_time = ts-(window_size/2);
  to_time = ts+(window_size/2);


  % Calculate PER for current time step
  for i=1:dim_size % RX_veh
  %for i=1:1 % RX_veh
    for j=1:dim_size % TX_veh
    %for j=3:3 % TX_veh
    % Added int32 in order to work in matlab as well (not only Octave)
      if idivide(int32(i),ant_per_veh,'ceil') ~= idivide(int32(j),ant_per_veh,'ceil')
        tx_first = find(TX_T_ALL{j}(:)>=from_time,1);
        tx_last = find(TX_T_ALL{j}(:)>to_time,1)-1;
        rx_first = find(RX_T_ALL{i,j}(:)>=from_time,1);
        rx_last = find(RX_T_ALL{i,j}(:)>to_time,1)-1;
  
        TX_SEQ_tmp = TX_SEQ_ALL{j}(tx_first:tx_last);
        RX_SEQ_tmp = RX_SEQ_ALL{i,j}(rx_first:rx_last);

        %str = sprintf(['i=%d j=%d from_time: %0.2f to_time: %0.2f ts: %0.2f\n', ...
        %              '  tx_first(t): %d (%0.2f) tx_last(t): %d (%0.2f) numtx: %d\n', ...
        %              '  rx_first(t): %d (%0.2f) rx_last(t): %d (%0.2f) numrx: %d'], ...
        %              i, j, from_time, to_time, ts, ...
        %              tx_first, TX_T_ALL{j}(tx_first), tx_last, TX_T_ALL{j}(tx_last), size(TX_SEQ_tmp,2), ...
        %              rx_first, RX_T_ALL{i,j}(rx_first), rx_last, RX_T_ALL{i,j}(rx_last), size(RX_SEQ_tmp,2));
        %disp(str)
        
        % Need to add guard for empty arguments. (ML)
        if (~isempty(tx_first) && ~isempty(tx_last) && ~isempty(rx_first) && ~isempty(rx_last))
            if (rx_last>rx_first) && (tx_last>tx_first) 
              MAVG_PER(i,j, idx) = getPER(RX_SEQ_tmp, TX_SEQ_tmp);
            else
              empty_PER = empty_PER+1;
              MAVG_PER(i,j, idx) = 100;
            end
            all_PER = all_PER+1;
            if tx_first>=tx_last
              empty_tx = empty_tx + 1;
            end
        end
      end
    end
  end
  idx = idx+1;    
end

str = sprintf('Number of slots with 100%% PER: %d out of %d, Empty TX: %d', empty_PER, all_PER, empty_tx);
disp(str)

save(file_mavg, 'MAVG_PER', 'empty_PER', 'all_PER', 'min_time', 'max_time', 'time_step');


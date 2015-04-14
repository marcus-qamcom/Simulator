function getAllTests(tc, ap, fs)
% This function creates a number of matlab variables from for RX and TX node from raw data files
% and saves to two .mat files.
% tc = test case (string)
% ap = antenna position (string)
% fs = frame size (number)

% Specify which test to use
% Convert to struct for historical reasons
TEST_SPEC = struct('testcase_no', tc, 'AP', ap, 'framesize', fs);

% Specify which test to use

file_data = sprintf(['SimData_tc%sAP%sfs%d_data.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
file_per = sprintf(['SimData_tc%sAP%sfs%d_per.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
disp(file_data)
disp(file_per)

% First to last vehicle in platoon
PLATOON = cellstr(['DEF84'; 'Plton'; 'DRF18'; 'Pluto']);
PLATOON_ANT = cellstr(['DEF84L'; 'DEF84R'; 'PltonL'; 'PltonR'; 'DRF18L'; 'DRF18R'; 'PlutoL'; 'PlutoR']);
platoon_size = size(PLATOON,1);
ant_per_veh = 2;
platoon_ant_size = platoon_size * ant_per_veh;


% Get timestamps for when platoon is within valid road sections.
% Data for the first and last truck (either antenna) is used for this.
% Changed " to ' for use in Matlab
TIME_SLICES = getTimeSlices(TEST_SPEC, 'DEF84L', 'PlutoL'); % DEF84L is first, Pluto is last vehicle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All combinations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dim_size = platoon_size*ant_per_veh;  % 

% TX Data
TX_T_ALL    =cell(dim_size, 1);
TX_D_ALL    =cell(dim_size, 1);
TX_RSSI_ALL =cell(dim_size, 1);
TX_LAT_ALL  =cell(dim_size, 1);
TX_LONG_ALL =cell(dim_size, 1);
TX_SEQ_ALL  =cell(dim_size, 1);
TX_V_ALL    =cell(dim_size, 1);

for i=1:dim_size
        str = sprintf('TX i=%d \n', i);
        disp(str)

        % Get data for one RX-DX link
        [T_tmp, D_tmp, RSSI_tmp, LAT_tmp, LONG_tmp, SEQ_tmp, lab, V_tmp] = ...
          getLink(TEST_SPEC, char(PLATOON_ANT(i)), char(PLATOON_ANT(i)) );

        % Filter data
        [T_tmp, D_tmp, RSSI_tmp, LAT_tmp, LONG_tmp, SEQ_tmp, V_tmp] = ...
          filterTimeSlices(TIME_SLICES, T_tmp, D_tmp, RSSI_tmp, LAT_tmp, LONG_tmp, SEQ_tmp, V_tmp);
        T_tmp = adjustT(TIME_SLICES, T_tmp);
        
        TX_T_ALL{i}     = T_tmp;
        TX_D_ALL{i}     = D_tmp; 
        TX_RSSI_ALL{i}  = RSSI_tmp;
        TX_LAT_ALL{i}   = LAT_tmp;
        TX_LONG_ALL{i}  = LONG_tmp;
        TX_SEQ_ALL{i}   = SEQ_tmp;
        TX_V_ALL{i}     = V_tmp;
end

% Extract turnvector for first vehicle
[TX_DRIVING_STRAIGHT_LEAD, TX_DRIVING_LEFT_LEAD, TX_DRIVING_RIGHT_LEAD] = getTurnVector(TX_T_ALL{1}, TX_V_ALL{i}, TX_LAT_ALL{1}, TX_LONG_ALL{1});

disp(['TX T array size:'])
disp(cellfun('length',TX_T_ALL))

% RX Data

RX_T_ALL    =cell(dim_size,dim_size);
RX_D_ALL    =cell(dim_size,dim_size);
RX_RSSI_ALL =cell(dim_size,dim_size);
RX_LAT_ALL  =cell(dim_size,dim_size);
RX_LONG_ALL =cell(dim_size,dim_size);
RX_SEQ_ALL  =cell(dim_size,dim_size);
RX_V_ALL    =cell(dim_size,dim_size);

for i=1:dim_size % RX veh
  for j=1:dim_size % TX veh
      % Added int32 for support in matlab (not only Octave
      if idivide(int32(i),ant_per_veh,'ceil') ~= idivide(int32(j),ant_per_veh,'ceil')
        % Calculate numbers for all combinations of antennas where sender and receiver is not on the same vehicle

        % Get data for one RX-DX link
        [T_tmp D_tmp RSSI_tmp LAT_tmp LONG_tmp SEQ_tmp lab, V_tmp] = ...
          getLink(TEST_SPEC, char(PLATOON_ANT(i)), char(PLATOON_ANT(j)) );
 
        % Filter data
        [T_tmp D_tmp RSSI_tmp LAT_tmp LONG_tmp SEQ_tmp, V_tmp] = ...
          filterTimeSlices(TIME_SLICES, T_tmp, D_tmp, RSSI_tmp, LAT_tmp, LONG_tmp, SEQ_tmp, V_tmp);
        T_tmp = adjustT(TIME_SLICES, T_tmp);

        str = sprintf('RX i=%d j=%d To(RX): %s From(TX): %s RX T size=%d\n', i, j, char(PLATOON_ANT(i)), char(PLATOON_ANT(j)),size(T_tmp,2) );
        disp(str)

        RX_T_ALL{i,j}       = T_tmp;
        RX_D_ALL{i,j}       = D_tmp; 
        RX_RSSI_ALL{i,j}    = RSSI_tmp;
        RX_LAT_ALL{i,j}     = LAT_tmp;
        RX_LONG_ALL{i,j}    = LONG_tmp;
        RX_SEQ_ALL{i,j}     = SEQ_tmp;
        RX_V_ALL{i,j}       = V_tmp;

      end
  end
end
disp(['RX T array size:'])
disp(cellfun('length',RX_T_ALL))

save(file_data,'RX_T_ALL', 'RX_D_ALL', 'RX_RSSI_ALL', 'RX_LAT_ALL', 'RX_LONG_ALL', 'RX_SEQ_ALL', 'RX_V_ALL', ...
                               'TX_T_ALL', 'TX_D_ALL', 'TX_RSSI_ALL', 'TX_LAT_ALL', 'TX_LONG_ALL', 'TX_SEQ_ALL', 'TX_V_ALL','TX_DRIVING_STRAIGHT_LEAD', 'TX_DRIVING_LEFT_LEAD', 'TX_DRIVING_RIGHT_LEAD');

% Calculate PER for all antenna combinations
%ALL_PER = cell(dim_size,dim_size);
ALL_PER = zeros(dim_size, dim_size);
for i=1:dim_size % RX_veh
  for j=1:dim_size % TX_veh
      % Added int32 for support in matlab (not only Octave)
      if idivide(int32(i),ant_per_veh,'ceil') ~= idivide(int32(j),ant_per_veh,'ceil')
         ALL_PER(i,j) = getPER(RX_SEQ_ALL{i,j}, TX_SEQ_ALL{j});
      end
  end
end
disp(ALL_PER)

save(file_per, 'ALL_PER');

function [T D RSSI LAT LONG RX_SEQ lab V] = getLink(TEST_SPEC,veh,friendlyname) 
% Load a communication link specified by:
%  testcase_no - Test case number
%  AP - Antenna position number
%  veh - Name of packet reciving (RX) vehicle
%  friendlyname - Name of packet sending (TX) vehicle
%  frame size - filter packets and use only packets with this frame size

%testcase_no = TEST_SPEC(1);
%AP = TEST_SPEC(2);
%frame_size = TEST_SPEC(3);
testcase_no = TEST_SPEC.testcase_no;
AP = TEST_SPEC.AP;
frame_size = TEST_SPEC.framesize;

% Frame sizes in logs are slightly different for the sending vehicle
if frame_size==124
    fs_own=108;
end
if frame_size==524
    fs_own=508;
end
if frame_size==600
    fs_own=600;
end



% Get configuration data for the test
testconf = getTestConfiguration(testcase_no, AP);

% Print some info
%disp(['Loading test: ' testconf.testname ', AP: ' testconf.AP ', Starttime:' testconf.starttime ' , Stoptime: ' testconf.stoptime])

% Test start time in unix time format
tu_start=timeHuman2timeUnix(testconf.starttime);
% Test stop time in unix time format
tu_stop=timeHuman2timeUnix(testconf.stoptime);

DATA_RX = getRawData(testcase_no, AP, veh);

% Get the data we want from the log file
if strcmp(veh,friendlyname)
  % Data for a sending vehicle
  [T RSSI LAT LONG RX_SEQ V] = filterData(tu_start, tu_stop, DATA_RX, friendlyname, fs_own);
else
  % Data for a receiving vehicle
  [T RSSI LAT LONG RX_SEQ V] = filterData(tu_start, tu_stop, DATA_RX, friendlyname, frame_size);
end

if testcase_no ~= '8'
  D = calcGCDistV(LAT, LONG, testconf.refloc(1), testconf.refloc(2)); % RX vehicle
else
  dsize = size(LAT, 2)
  D = zeros(dsize);
end
  
% Remove raw data to save memory
% TODO - unneceessary in a function?
clear DATA_RX

% Construction of label for this comm link
lab = getLabel(AP, veh, friendlyname);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Local functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DATA = getRawData(testcase_no, AP, veh)
% GETRAWDATA loads log files from W9 experiments based on
% testcase_no - Testcase number
% AP - antenna position number
% veh - vehicle name

  % Create path to .mat file containing test data
  if isequal(testcase_no,'1') || isequal(testcase_no,'1b') || isequal(testcase_no,'2')
    my_path=['Day1/' veh '/Test' num2str(testcase_no) 'AP' num2str(AP) veh '.mat'];
  else
    my_path=['Day2/' veh '/Test' num2str(testcase_no) 'AP' num2str(AP) veh '.mat'];
  end
  disp(my_path)

  % Load data and rename the array from a test name string such as 'Test6AP8DRF18L' to just 'data'
  DATA_M = load(my_path);
  my_cmd=['Test' num2str(testcase_no) 'AP' num2str(AP) veh];
  DATA = DATA_M.(my_cmd);
  clear DATA_M
end


function [T RSSI LAT LONG SEQ V] = filterData(t1, t2, DATA, fname, flength)
% FILTERDATA filters data on
%  time - only packets between t1 and t2 is returned
%  receiver vehicle - only data received by fname is returned
%  packet length - only data with packet size flength is returned

  N=max(size(DATA));

  % Filter on time, receiver and packet length
  tt=1;

  for t=1:N
    if DATA(t).postime > t1 && DATA(t).postime < t2
      fname2=DATA(t).friendlyname;
      if fname2 == fname
        flength2=DATA(t).framelength;
        if flength2 == flength; % 108 124 524 600
          time=DATA(t).postime;        % Timestamp
          T(tt)=time-t1;              % Adjust time so 0 is at start of experiment
          RSSI(tt)=DATA(t).rssi;       % RSSI expressed in dBm
          LAT(tt)=DATA(t).latitude;    % Position at packet reception
          LONG(tt)=DATA(t).longitude;  %       -"-
          SEQ(tt)=DATA(t).seqno;       % Sequence number
          V(tt)=DATA(t).speed/3.6;     % Speed of vehicle in m/s 
          tt=tt+1;
        end
      end
    end
  end   
  if tt==1
    disp(['Not found: ' fname ' ' num2str(flength) ])
    T(1)=0;
    RSSI(1)=-90;
    LAT(1)=DATA(1).latitude;
    LONG(1)=DATA(1).longitude;
    SEQ(1)=DATA(1).seqno;
    V(1)=DATA(1).speed;
    return;
  end
end


function lab = getLabel(AP, veh, friendlyname)
% GETLABEL constructs a label for the testcase

% Label sender
% ------- Volvo left -----------
if isequal(friendlyname, 'DEF84L') || isequal(friendlyname, 'DRF18L')
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '2'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '3'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3L'];
    case '6'
        lab_send = [friendlyname(1:5) ' 1L'];
    case '7'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '9'
        lab_send = [friendlyname(1:5) ' 1L'];
    end
end

% ------- Volvo right -----------
if isequal(friendlyname, 'DEF84R') || isequal(friendlyname, 'DRF18R') 
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' 1R-high'];
    case '2'
        lab_send = [friendlyname(1:5) ' 1R-low'];
    case '3'
        lab_send = [friendlyname(1:5) ' 1R-low'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3R'];
    case '6'
        lab_send = [friendlyname(1:5) ' 1R-low'];
    case '7'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '9'
        lab_send = [friendlyname(1:5) ' 1R-high'];
    end
end

% ------- Scania left -----------
if isequal(friendlyname, 'PltonL') || isequal(friendlyname, 'PlutoL') 
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' VL'];
    case '2'
        lab_send = [friendlyname(1:5) ' VL'];
    case '3'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3L'];
    case '6'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '7'
        lab_send = [friendlyname(1:5) ' 2L'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4L'];
    case '9'
        lab_send = [friendlyname(1:5) ' 2L'];
    end
end

% ------- Scania right -----------
if isequal(friendlyname, 'PltonR') || isequal(friendlyname, 'PlutoR')
    switch AP(1)
    case '1'
        lab_send = [friendlyname(1:5) ' VR'];
    case '2'
        lab_send = [friendlyname(1:5) ' VR'];
    case '3'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '4'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '5'
        lab_send = [friendlyname(1:5) ' 3R'];
    case '6'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '7'
        lab_send = [friendlyname(1:5) ' 2R'];
    case '8'
        lab_send = [friendlyname(1:5) ' 4R'];
    case '9'
        lab_send = [friendlyname(1:5) ' 2R'];
    end
end


% Label receiver
% ------- Volvo left -----------
if isequal(veh, 'DEF84L') || isequal(veh, 'DRF18L')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' 1L'];
    case '2'
        lab_rec = [veh(1:5) ' 1L'];
    case '3'
        lab_rec = [veh(1:5) ' 1L'];
    case '4'
        lab_rec = [veh(1:5) ' 2L'];
    case '5'
        lab_rec = [veh(1:5) ' 3L'];
    case '6'
        lab_rec = [veh(1:5) ' 1L'];
    case '7'
        lab_rec = [veh(1:5) ' 4L'];
    case '8'
        lab_rec = [veh(1:5) ' 4L'];
    case '9'
        lab_rec = [veh(1:5) ' 1L'];
    end
end

% ------- Volvo right -----------
if isequal(veh, 'DEF84R') || isequal(veh, 'DRF18R')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' 1R-high'];
    case '2'
        lab_rec = [veh(1:5) ' 1R-low'];
    case '3'
        lab_rec = [veh(1:5) ' 1R-low'];
    case '4'
        lab_rec = [veh(1:5) ' 2R'];
    case '5'
        lab_rec = [veh(1:5) ' 3R'];
    case '6'
        lab_rec = [veh(1:5) ' 1R-low'];
    case '7'
        lab_rec = [veh(1:5) ' 4R'];
    case '8'
        lab_rec = [veh(1:5) ' 4R'];
    case '9'
        lab_rec = [veh(1:5) ' 1R-high'];
    end
end

% ------- Scania left -----------
if isequal(veh, 'PltonL') || isequal(veh, 'PlutoL')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' VL'];
    case '2'
        lab_rec = [veh(1:5) ' VL'];
    case '3'
        lab_rec = [veh(1:5) ' 2L'];
    case '4'
        lab_rec = [veh(1:5) ' 2L'];
    case '5'
        lab_rec = [veh(1:5) ' 3L'];
    case '6'
        lab_rec = [veh(1:5) ' 4L'];
    case '7'
        lab_rec = [veh(1:5) ' 2L'];
    case '8'
        lab_rec = [veh(1:5) ' 4L'];
    case '9'
        lab_rec = [veh(1:5) ' 2L'];
    end
end

% ------- Scania right -----------
if isequal(veh, 'PltonR') || isequal(veh, 'PlutoR')
    switch AP(1)
    case '1'
        lab_rec = [veh(1:5) ' VR'];
    case '2'
        lab_rec = [veh(1:5) ' VR'];
    case '3'
        lab_rec = [veh(1:5) ' 2R'];
    case '4'
        lab_rec = [veh(1:5) ' 2R'];
    case '5'
        lab_rec = [veh(1:5) ' 3R'];
    case '6'
        lab_rec = [veh(1:5) ' 4R'];
    case '7'
        lab_rec = [veh(1:5) ' 2R'];
    case '8'
        lab_rec = [veh(1:5) ' 4R'];
    case '9'
        lab_rec = [veh(1:5) ' 2R'];
    end
end

% Put together the pieces...
lab = ['AP' AP ': ' lab_send '->' lab_rec];

end % getLabel

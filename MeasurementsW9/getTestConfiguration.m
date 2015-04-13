function testconf = getTestConfiguration(testcase_no, AP)

% Note:
% The testconf array contains start and stop times for valid data in the tests, ie 
% when the vehices were all on the road in a platooning formation.
% The measurement files also contains some data before and after when the vehicles
% started, turned around etc.
%
% testname - Name of testcase
% AP - Antenna position
% starttime - Start time of test (earlier log entries discarded)
% stoptime - Stop time for test (later log entries discarded)
% refloc - Reference location for testcase, distance to reference used
%          in other calculations
% locfilter - Start/stop distance pairs for filtering sections of test
%             to use. Format: [startdist, enddist] where
%                   startdist - distance where this section begins
%                   enddist   - distance where this section ends
%             If locfilter is used only log entries within start-end
%             pairs will be used for further calculations. If startdis
%             is larger than enddist the log will be searched
%             backwards (it is assumed to be the return trip back
%             towards the starting point).

testconf = {};

% Test 1
if isequal(testcase_no,'1') && isequal(AP,'1')
  testconf.testname = 'Test 1'; % Time verified by ploting in google earth
  testconf.AP = 'AP1';
  testconf.starttime = '2014-02-26 10:21:57.500'; %Time in test protocol = 2014-02-26 10:22:43.000
  testconf.stoptime =  '2014-02-26 10:26:02.600'; %Time in testprotocol = 2014-02-26 10:26:00.000
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1') && isequal(AP,'2')
  testconf.testname = 'Test 1';  % Time verified by ploting in google earth
  testconf.AP = 'AP2';
  testconf.starttime = '2014-02-26 10:34:48.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 10:38:05.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1') && isequal(AP,'4')
  testconf.testname = 'Test 1';  % Time verified by ploting in google earth
  testconf.AP = 'AP4';
  testconf.starttime = '2014-02-26 10:46:25.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 10:49:44.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1') && isequal(AP,'5')
  testconf.testname = 'Test 1'; % Time verified by ploting in google earth
  testconf.AP = 'AP5';
  testconf.starttime = '2014-02-26 11:02:04.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 11:05:17.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1') && isequal(AP,'8')
  testconf.testname = 'Test 1'; % Time verified by ploting in google earth
  testconf.AP = 'AP8';
  testconf.starttime = '2014-02-26 11:11:00.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 11:14:17.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'1a')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP1a';
  testconf.starttime = '2014-02-26 12:42:29.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 12:44:30.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'1b')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP1b';
  testconf.starttime = '2014-02-26 12:49:40.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 12:53:50.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'2a')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP2a';
  testconf.starttime = '2014-02-26 13:02:28.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 13:04:35.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'2b')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth 
  testconf.AP = 'AP2b';
  testconf.starttime = '2014-02-26 13:08:10.000'; % Time in test protocol: 2014-02-26 13:08:04.000
  testconf.stoptime =  '2014-02-26 13:12:20.000'; % Time in test protocol: 2014-02-26 13:12:30.000
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'4a')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP4a';
  testconf.starttime = '2014-02-26 13:17:40.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 13:19:40.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'4b')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP4b';
  testconf.starttime = '2014-02-26 13:26:50.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 13:31:10.000'; % Time in test protocol: 2014-02-26 13:31:40.000
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'5a')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP5a';
  testconf.starttime = '2014-02-26 13:37:10.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 13:39:10.000'; % Time in test protocol: 2014-02-26 13:39:17.000
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'5b')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP5b';
  testconf.starttime = '2014-02-26 13:43:08.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 13:47:20.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'8a')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP8a';
  testconf.starttime = '2014-02-26 13:51:38.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 13:53:47.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'1b') && isequal(AP,'8b')
  testconf.testname = 'Test 1b'; % Time verified by ploting in google earth
  testconf.AP = 'AP8b';
  testconf.starttime = '2014-02-26 13:57:25.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 14:01:40.000';
  testconf.testsaved = 0;
end

if isequal(testcase_no,'2') && isequal(AP,'8_10m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP8_10m';
  testconf.starttime = '2014-02-26 15:20:17.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 15:27:34.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'8_20m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP8_20m';
  testconf.starttime = '2014-02-26 15:29:37.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 15:36:43.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'8_30m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP8_30m';
  testconf.starttime = '2014-02-26 15:29:37.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 15:36:43.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'1_10m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP1_10m';
  testconf.starttime = '2014-02-26 15:49:12.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 15:57:00.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'1_20m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP1_20m';
  testconf.starttime = '2014-02-26 15:58:57.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 16:06:03.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'1_30m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP1_30m';
  testconf.starttime = '2014-02-26 16:07:56.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 16:15:48.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'4_10m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP4_10m';
  testconf.starttime = '2014-02-26 16:22:40.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 16:29:46.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'4_20m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP4_20m';
  testconf.starttime = '2014-02-26 16:32:03.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 16:39:08.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'4_30m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP4_30m';
  testconf.starttime = '2014-02-26 16:41:01.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 16:48:07.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'5_10m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP5_10m';
  testconf.starttime = '2014-02-26 16:56:18.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 17:03:24.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'5_20m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP5_20m';
  testconf.starttime = '2014-02-26 17:05:20.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 17:12:27.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'2') && isequal(AP,'5_30m')
  testconf.testname = 'Test 2'; % Time verified by ploting in google earth
  testconf.AP = 'AP5_30m';
  testconf.starttime = '2014-02-26 17:14:28.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-26 17:21:34.000';
  testconf.testsaved = 0;
end


% Day 2
if isequal(testcase_no,'6') && isequal(AP,'1')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP1';
  testconf.starttime = '2014-02-27 08:18:40.000'; %Time in test protocoll: 2014-02-27 08:20:45.000
  testconf.stoptime =  '2014-02-27 08:31:10.000'; %Time in test protocoll: 2014-02-27 08:30:00.000
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'2')
  testconf.testname = 'Test 6';  % Time verified in google earth
  testconf.AP = 'AP2';
  testconf.starttime = '2014-02-27 08:34:45.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 08:46:40.000';
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'4')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP4';
  testconf.starttime = '2014-02-27 08:50:10.000'; 
  testconf.stoptime =  '2014-02-27 09:02:30.000'; 
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'5')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP5';
  testconf.starttime = '2014-02-27 09:06:20.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 09:18:10.000';
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'8')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP8';
  testconf.starttime = '2014-02-27 09:21:30.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 09:33:50.000';
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'7')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP7';
  testconf.starttime = '2014-02-27 09:37:00.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 09:49:07.000'; %Time in test protocoll: 2014-02-27 09:49:00.000
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'6')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP6';
  testconf.starttime = '2014-02-27 09:52:55.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 10:04:50.000';
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'4_Diversity')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP4_Diversity';
  testconf.starttime = '2014-02-27 11:13:20.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 11:25:50.000';
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'9_Diversity')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP9_Diversity';
  testconf.starttime = '2014-02-27 11:29:40.000'; 
  testconf.stoptime =  '2014-02-27 11:41:45.000'; 
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'3_Diversity')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP3_Diversity';
  testconf.starttime = '2014-02-27 11:44:40.000'; % Time in test protocol: 2014-02-27 11:44:45.000
  testconf.stoptime =  '2014-02-27 11:57:35.000';
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'8_Diversity')
  testconf.testname = 'Test 6'; % Time verified in google earth, slightly late start.
  testconf.AP = 'AP8_Diversity';
  testconf.starttime = '2014-02-27 12:00:45.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 12:12:05.000'; 
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'6') && isequal(AP,'5_Diversity')
  testconf.testname = 'Test 6'; % Time verified in google earth
  testconf.AP = 'AP5_Diversity';
  testconf.starttime = '2014-02-27 12:15:00.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 12:26:40.000'; 
  testconf.testsaved = 0;
  testconf.refloc = [590846416, 175958966]; % Lat, Long
  testconf.locfilter = [2200 6100; 5500 800];
end
if isequal(testcase_no,'7') && isequal(AP,'4')
  testconf.testname = 'Test 7'; 
  testconf.AP = 'AP4';
  testconf.starttime = '2014-02-27 14:16:00.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 14:20:00.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'7') && isequal(AP,'9')
  testconf.testname = 'Test 7'; 
  testconf.AP = 'AP9';
  testconf.starttime = '2014-02-27 14:25:00.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 14:27:10.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'7') && isequal(AP,'3')
  testconf.testname = 'Test 7'; 
  testconf.AP = 'AP3';
  testconf.starttime = '2014-02-27 14:30:30.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 14:32:45.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'7') && isequal(AP,'5')
  testconf.testname = 'Test 7'; 
  testconf.AP = 'AP5';
  testconf.starttime = '2014-02-27 14:37:05.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 14:41:20.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'7') && isequal(AP,'8')
  testconf.testname = 'Test 7'; 
  testconf.AP = 'AP8';
  testconf.starttime = '2014-02-27 14:45:45.000'; %'yyyy-mm-dd HH:MM:SS.FFF'
  testconf.stoptime =  '2014-02-27 14:49:00.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'8') && isequal(AP,'8')
  testconf.testname = 'Test 8'; % Time verified in google earth
  testconf.AP = 'AP8';
  % testconf.starttime = '2014-02-27 14:50:30.000'; Platoon not formed until 14:52:30
  testconf.starttime = '2014-02-27 14:52:30.000';
  % testconf.stoptime =  '2014-02-27 14:53:45.000';
  testconf.stoptime =  '2014-02-27 14:53:45.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'8') && isequal(AP,'5')
  testconf.testname = 'Test 8'; % Time verified in google earth
  testconf.AP = 'AP5';
  testconf.starttime = '2014-02-27 14:56:40.000';
  testconf.stoptime =  '2014-02-27 15:00:00.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'8') && isequal(AP,'4')
  testconf.testname = 'Test 8'; % Time verified in google earth
  testconf.AP = 'AP4';
  testconf.starttime = '2014-02-27 15:02:30.000';
  testconf.stoptime =  '2014-02-27 15:06:00.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'8') && isequal(AP,'3')
  testconf.testname = 'Test 8'; % Time verified in google earth
  testconf.AP = 'AP3';
  testconf.starttime = '2014-02-27 15:09:00.000';
  testconf.stoptime =  '2014-02-27 15:12:50.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'8') && isequal(AP,'9')
  testconf.testname = 'Test 8'; % Time verified in google earth
  testconf.AP = 'AP9';
  testconf.starttime = '2014-02-27 15:15:20.000';
  testconf.stoptime =  '2014-02-27 15:20:20.000';
  testconf.testsaved = 0;
end
if isequal(testcase_no,'8') && isequal(AP,'1')
  testconf.testname = 'Test 8'; % Time verified in google earth
  testconf.AP = 'AP1';
  testconf.starttime = '2014-02-27 15:23:10.000';
  testconf.stoptime =  '2014-02-27 15:30:00.000';
  testconf.testsaved = 0;
end

end % function get_test_configuration

function runTrafficSimRealmeas(tc, ap, fs, hop, tx, perm)
% Runs DataAge simulation and saves plots and description file with simulation parameters and results.
% tc - Testcase number 
% ap - Antenna position
% fs - Frame size
% hop - multihop algorithm
% tx - send algorithm
% perm - Packer error rate (PER) model
%
% Alternatives for hop, tx, and perm are documented in code below

% Convert some parameters to a struct for historical reasons...
TEST_SPEC = struct('testcase_no', tc, 'AP', ap, 'framesize', fs);

% Construct file names for pre-generated data for the specified test case. 
% This data is generated from 'MeasurementsW9'. Must exist in 'Meas_properties' directories.
file_data = sprintf(['Meas_properties/SimData_tc%sAP%sfs%d_data.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
file_per = sprintf(['Meas_properties/SimData_tc%sAP%sfs%d_per.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
file_mavg = sprintf(['Meas_properties/SimData_tc%sAP%sfs%d_mavg_per.mat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize);
disp(file_data)
disp(file_per)
disp(file_mavg)
% Construct file names for output data files. 'plots' and 'desc' directories must exist.
file_plot_age = sprintf(['plots/SimPlot_tc%sAP%sfs%dhop%dtx%dper%d_age'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize, hop, tx, perm);
file_plot_hist = sprintf(['plots/SimPlot_tc%sAP%sfs%dhop%dtx%dper%d_hist'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize, hop, tx, perm);
file_plot_energy = sprintf(['plots/SimPlot_tc%sAP%sfs%dhop%dtx%dper%d_energy'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize, hop, tx, perm);
file_desc = sprintf(['desc/SimPlot_tc%sAP%sfs%dhop%dtx%dper%d.dat'], TEST_SPEC.testcase_no, TEST_SPEC.AP, TEST_SPEC.framesize, hop, tx, perm);

% Load pre-calculated PER data
load(file_per);
load(file_mavg);
load(file_data);
% Initialize statistics collection struct.
STATS = struct('resends', 0, 'resend_received', 0, 'resend_useful', 0);

% File name for PER, only used for some PER models.
ch_file = '';

%% Time
sim_time=max_time-min_time-11; % Total simulation time in seconds.
                               % TODO: -11 pga averaging i 'MeasurementsW9'-koden. Borde fixas i average-scriptet eftersom
                               %       detta hårdkodade värde påverkas av hur lång average-tid man använder.

sim_time_step=0.01;            % Time step in seconds
T=0:sim_time_step:sim_time;    % time vector
timeout = 0; %1000;            % max allowed age of data

% intial settings
distance=10;                % Distance between vehicles [m] (change to time?)
speed=10;                   % inital speed [m/s]
Hz=10;                      % Message update frequency in Hz: 
PER_model=perm;             % 1 = perfect
                            % 2 = simple per
                            % 3 = tabluar per
                            % 4 = Moving average tabular PER (FW)

age_limit = 0.2;
algo=hop; % Algorithm: 
          % 0 = no algorithm
          % 1 = single hop. Repeat each msg once
          % 2 = single hop. Repeat msg from nodes ahead
          % 3 = single hop. Repeat msg from nodes ahead. Half power.
          % 4 = Ask for repeated message if data age above some limit ver A.
          % 5 = Ask for repeated message if data age above some limit ver B. Half power.
          % 6 = ETSI Contention-based forwarding for GeoBroadcast
          % 7 = Reachability-matrix algorithm
          % 8 = Reachability-matrix + ETSI Contention-based              ## NOT IMPLEMENTED YET
          % 9 = "An optimal 1D vehicular accident warning system"        ## NOT IMPLEMENTED YET

% For vehicles with more than one node:
Tx_algo=tx; % 1 => Transmits with first node
            % 2 => Transmit with random node
            % 3 => Transmit with every second node, simply uses half data rate
            % 4 => Transmit with all nodes (Not allowed acc to std.)
            % 5 => Transmit on left hand side when "turning" left vise verca for right, if going straigh, alternate between left and right hand side antennas.          
           

%% Platoon/vehicles
N_veh=4;   % No of vehicles. MAXVALUE =7 (limited by ColorVec)
% A platoon = row of vehicles, no take over possible
% A vehicle is represented by a spatial point
% platoon=zeros(N_veh,1); 
N_node=2; % No of nodes per vehicle
ch_ind=1;

%% PER model...
if PER_model == 1 || PER_model == 2
    for n=1:N_veh
        platoon(n)=vehicle(n, distance, 3, Hz, N_veh, N_node, timeout, ch_ind, Tx_algo);
        ch_ind=ch_ind+N_node;
    end
    ch=0;
    ch_file='';
end


% Initialize platoon
% TODO: Hard coded to 4 vehicles 8 nodes, should use N_veh and N_node
if PER_model == 3 || PER_model == 4
    platoon(1)=vehicle(1, distance, 3, Hz, N_veh, 2, timeout, ch_ind, Tx_algo);
    ch_ind=ch_ind+2;
    platoon(2)=vehicle(2, distance, 3, Hz, N_veh, 2, timeout, ch_ind, Tx_algo);
    ch_ind=ch_ind+2;
    platoon(3)=vehicle(3, distance, 3, Hz, N_veh, 2, timeout, ch_ind, Tx_algo);
    ch_ind=ch_ind+2;
    platoon(4)=vehicle(4, distance, 3, Hz, N_veh, 2, timeout, ch_ind, Tx_algo);
    ch_ind=ch_ind+2;
end
    
if PER_model == 3    
    % Read channel data
    ch_file='8nodes_4veh.txt';
    %ch_file='8nodes_4veh_left_side_blind.txt'; 
    ch = dlmread(['Channel_properties/' ch_file ], '\t', 1, 0);
end

if PER_model == 4
   % Rename moving average variable to be consistent to the existing variants
   ch = MAVG_PER;
   clear MAVG_PER;
end

%% Simulation
% h1=figure;
% hold on
% xlabel('Distance')
% ylabel('Time')
t=0;
for ts=1:length(T)
    platoon = communication_update(platoon, t, Hz, Tx_algo,TX_DRIVING_RIGHT_LEAD, TX_DRIVING_LEFT_LEAD);
    %radar_update(platoon) % ego vehicle radar, not implemented
    [platoon STATS] = position_update(platoon,t, sim_time_step, PER_model,algo,ch,age_limit,T(ts), time_step, STATS);
    res_speed(ts,:)=[platoon(:).speed_x];
    res_coord(ts,:)=[platoon(:).coordinate_x];
    for p=1:N_veh
        res_timestamp(ts,:,p)=platoon(p).data_age;
    end
    
%    graph_update(h1, platoon,t)
    t=t+sim_time_step; % increase time [sec.]
   
    
end
%hold off
max_age = zeros(N_veh, N_veh);
for ts=1:length(T)
    for v=1:N_veh
        for a=1:size(res_timestamp,2)
            age = T(ts)-res_timestamp(ts,a,v);
            if (v~=a) && (age > max_age(v,a)) % Changed from ! to ~ in order to work in matlab.
               max_age(v,a) = age;
            end
        end
    end
end


%% send count, congestion control
for p=1:N_veh
    sc(p)=platoon(p).send_energy;
end
sc=sc/sim_time;


cdf_val=makeAgePlot(N_veh,T,res_timestamp,timeout,age_limit, file_plot_age, file_plot_hist);

% Create description/results file for this simulation
sim_description(N_veh,platoon,T,distance, speed, Hz,PER_model,age_limit,algo, Tx_algo, ch_file,sc,cdf_val, file_desc,max_age, STATS);


%% Plot send count, congestion control
figure
stem(sc)
hold on
xlabel('Node [-]')
ylabel('Messages/s [Hz]')
title(['Tx energy per node per second. (Total: ' sprintf('%g',round(sum(sc)*100)/100) ')'])
hold off
print (file_plot_energy, '-deps')
print (file_plot_energy, '-dpng')

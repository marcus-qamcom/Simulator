function [platoon STATS] = position_update(platoon, t, t_step, PER_model, algo, ch, age_limit, ts, time_step, STATS)
% platoon = position_update(platoon, t, t_step, PER_model, algo, ch, age_limit, ts, time_step)
%
% Control leading vehicle. +
% Collect information about vehicles in front. Following vehicles +
% Data age: Timestamp. All vehicles +
% Multi-hop algorithms
%
% platoon   = vehicle platoon
% t         = absolute time [s]
% t_step    = time step [s]
% PER_model = PER model
% algo      = multi-hop algorithm
% ch        = wireless channel
% age_limit = data age limit for algo 4
% ts        = timestamp (i.e. current time)
% timestep  = timestep in ch data


N=length(platoon);


%% LEADING VEHICLE
% leading vehicle follows some external directions
% - read file could be used to specify route
% - random route could be used as well
% - If data age is going to be investigated - comment this.
if t>=1 %after 1 sec. decrease speed to 10m/s
  %  platoon(1).set_speed_x =10;
end

if t>=3 %after 3 sec. increase speed to 30m/s
  %  platoon(1).set_speed_x =30;
end

%if t>=0.5 %after 7 sec. decrease speed to 0m/s
  %  platoon(1).set_speed_x =0;
%end

% Structures for "Reachability-matrix algo"
% NOTE: Originally called listen-vector, hence the variable names. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  - Dim-1 1-N contains listen-matrix for vehicle 'n'
%  - Dim-2 1-M each "row" contains listen data from vehicle 'm' as seen by vehicle 'n'
%  - Dim-3 1-L each item is listen data from vehicle 'l' as known by vehicle 'm'
% Note that this data is persistent, i.e. survives between invocations of this function

persistent LISTEN_AGE 
if (length(LISTEN_AGE) == 0)
    LISTEN_AGE = zeros(N, N, N);
end
persistent listenAgeLimit
if (length(listenAgeLimit)==0)
    listenAgeLimit = 0.2;        % Age limit for listen data. TODO: Should be argument
end
% Structure for ETSI Contention-based but also used for reachability-matrix
ECB_DIST = zeros(N, N); % distance from sender for all receiving nodes

% Structures for other resend algorithms
RECEIVED = zeros(N, N);
RECEIVED_FWD = zeros(N,N);
FORWARD = zeros(N,N);

%% Collect information about vehicles in front. Following vehicles
for p_rx=2:N % for each receiveing node
   % Node checks if any node before has reported its position, set speed etc.:
    for p_tx=1:p_rx-1
        if channel_ok(platoon, p_tx, p_rx, PER_model,1, ch,0,ts, time_step)
            platoon(p_rx).other_nodes_speed_x(p_tx,1)=1;
            platoon(p_rx).other_nodes_speed_x(p_tx,2)=platoon(p_tx).speed_x;
            platoon(p_rx).other_nodes_speed_x(p_tx,3)=t;
            platoon(p_rx).other_nodes_speed_x(p_tx,4)=platoon(p_tx).coordinate_x;
            %disp(['msg to from ' num2str(p) ' ' num2str(p2) ' ' num2str(platoon(p).other_nodes_speed_x(p2,2))])
        end
    end
end



%% Data age: Timestamp. All vehicles
for p_rx=1:N % for each receiving node
  % Time stamp: Node checks if any other node has reported its position, set speed etc.:
    for p_tx=1:N
        if p_tx ~= p_rx
            if channel_ok(platoon, p_tx, p_rx, PER_model,1,ch,0, ts, time_step)
                platoon(p_rx).data_age(p_tx)=t;
                RECEIVED(p_rx,p_tx) = 1;
                                
                % repetition of messages
                   
                if algo==1 % single hop   
                    % repeat received message once
                    platoon(p_rx).send_energy=platoon(p_rx).send_energy+1; % p_rx sends
                    FORWARD(p_rx,p_tx) = 1;
                    for p_rx_2nd=1:N % loop receiving nodes, except:
                        if p_rx_2nd ~= p_tx % sending node not interested
                            if p_rx_2nd ~= p_rx % neither my node is interested
                                                                
                                if channel_ok(platoon, p_rx, p_rx_2nd, PER_model,1,ch,1, ts, time_step) % from repeating node to other node 
                                   RECEIVED_FWD(p_rx_2nd,p_tx) = RECEIVED_FWD(p_rx_2nd,p_tx) + 1;
                                   if RECEIVED(p_rx_2nd,p_tx) == 0
                                     % Only update age if this node has not also received this packet from the sender directly
                                     platoon(p_rx_2nd).data_age(p_tx)=t-platoon(p_rx).veh_rep_freq;
                                     %disp([ num2str(p_rx_2nd) ' ' num2str(p_tx) ' ' num2str(t)])
                                   end
                                end
                            end
                        end
                    end
                end
                  
                
                if algo==2 % single hop 2: repeate messages from vehicles in front
                    % repeat received message once
                    if p_rx>p_tx %rec node is after transmitting node 
                        platoon(p_rx).send_energy=platoon(p_rx).send_energy+1;
                        FORWARD(p_rx,p_tx) = 1;
                        for p_rx_2nd=1:N % send to all nodes, except:
                            if p_rx_2nd ~= p_tx % sending node not interested
                                if p_rx_2nd ~= p_rx % neither my node is interested
                                    if channel_ok(platoon, p_rx, p_rx_2nd, PER_model,1,ch,1, ts, time_step) % from my node to other node 
                                      RECEIVED_FWD(p_rx_2nd,p_tx) = RECEIVED_FWD(p_rx_2nd,p_tx) + 1;
                                      if RECEIVED(p_rx_2nd,p_tx) == 0
                                        % Only update age if this node has not also received this packet from the sender directly
                                       platoon(p_rx_2nd).data_age(p_tx)=t-platoon(p_rx).veh_rep_freq;
                                      end
                                    end
                                end
                            end
                        end     
                    end
                end
                    
                    
                if algo==3 % single hop 3: repeate messages from vehicles in front but with half power
                    % repeat received message once
                    if p_rx>p_tx %my_node is after transmitting node 
                        platoon(p_rx).send_energy=platoon(p_rx).send_energy+1/2;
                        FORWARD(p_rx,p_tx) = 1;
                        for p_rx_2nd=1:N % send to all nodes, except:
                            if p_rx_2nd ~= p_tx % sending node not interested
                                if p_rx_2nd ~= p_rx % neither my node is interested
                                    if channel_ok(platoon, p_rx, p_rx_2nd, PER_model,2,ch,1, ts, time_step) % from my node to other node 
                                      RECEIVED_FWD(p_rx_2nd,p_tx) = RECEIVED_FWD(p_rx_2nd,p_tx) + 1;
                                      if RECEIVED(p_rx_2nd,p_tx) == 0
                                        % Only update age if this node has not also received this packet from the sender directly
                                        platoon(p_rx_2nd).data_age(p_tx)=t-platoon(p_rx).veh_rep_freq;
                                      end
                                    end
                                end
                            end
                        end     
                    end
                end
       
                if (algo==6) || (algo==7) || (algo==8) % ETSI contention-based & Reachability-matrix
                   % Record which nodes receive the message. Forwarding is calculated in a loop below
                   % ECB_DIST(p_rx, p_tx) = abs(p_rx-p_tx);
                   ECB_DIST(p_rx, p_tx) = abs(platoon(p_rx).coordinate_x-platoon(p_tx).coordinate_x);

                   % Update listen age for this receiver from this sender
                   LISTEN_AGE(p_rx, p_rx, p_tx) = ts;
                   % Update listen age for this receiver with data from the current sender
                   for i=1:N
                       if i ~= p_tx
                         if ts-LISTEN_AGE(p_tx, p_tx, i) <= listenAgeLimit
                           LISTEN_AGE(p_rx, p_tx, i) = ts;
                         else
                           LISTEN_AGE(p_rx, p_tx, i) = 0;
                         end
                       end
                   end

                end
                if algo==9 % "An optimal 1D vehicular accident warning system"
                   % Update lists for regular messages
                   % Send oracle message (frequency?)
                end
                
            else
                % Two reasons causes code end up here:
                % 1) channel was not ok
                % 2) no message was sent
                
                % Check if data age above some treshold:
                if algo==4 
                    
                    if t-platoon(p_rx).data_age(p_tx)>age_limit
                        if p_rx==7 % we plot only node 7...
                            disp([num2str(p_tx) ' to ' num2str(p_rx) ' age ' num2str(t-platoon(p_rx).data_age(p_tx)) ' T ' num2str(t) ])
                        end
                        % now receiving node should send a message to all nodes
                        % requiring p_tx to resend
                        platoon(p_rx).send_energy=platoon(p_rx).send_energy+1; % p_rx sends a request for info about p_tx
                        t2=t+0.01; % add 10 ms
                        %disp(['T: ' num2str(t2) ' Request from ' num2str(p_rx) ' send.'])
                        t2=t2+0.01; % add 10 ms
                        for p_rx_2nd=1:N % all except p_rx listen.
                            if p_rx_2nd ~= p_rx
                                if channel_ok(platoon, p_rx, p_rx_2nd, PER_model,1,ch,1, ts, time_step) 
                                    %disp(['     Reception by: ' num2str(p_rx_2nd)])
                                                            
                                    platoon(p_rx_2nd).send_energy=platoon(p_rx_2nd).send_energy+1; % nodes p_rx call for help repeat information about p_tx              
                                    for p_rx_3rd=1:N 
                                        if p_rx_3rd ~= p_rx_2nd 
                                            if channel_ok(platoon, p_rx_2nd, p_rx_3rd, PER_model,1,ch,1, ts, time_step) % from repeating node to other node 
                                                %disp(['         ' num2str(p_rx_3rd) ' received message from ' num2str(p_rx_2nd)])
                                                % Now p_rx_2nd sends
                                                % message to p_rx_3rd
                                                % containing information 
                                                % about p_tx
                        
                                                if platoon(p_rx_2nd).data_age(p_tx) > platoon(p_rx_3rd).data_age(p_tx)
                                                    %disp(['         data age ' num2str(t-platoon(p_rx_3rd).data_age(p_tx)) ' changed to ' num2str(t2-platoon(p_rx_2nd).data_age(p_tx))])
                                                    platoon(p_rx_3rd).data_age(p_tx) = platoon(p_rx_2nd).data_age(p_tx);
                                                end
                                            end
                                        end
                                    end
                        
                                    
                                end
                            end 
                        end
                    end
                end
                                
                
                
                if algo==5 
                    
                    if t-platoon(p_rx).data_age(p_tx)>age_limit
                        if p_rx==7 % we plot only node 7...
                            disp([num2str(p_tx) ' to ' num2str(p_rx) ' age ' num2str(t-platoon(p_rx).data_age(p_tx)) ' T ' num2str(t) ])
                        end
                        % now receiving node should send a message to all nodes
                        % requiring p_tx to resend
                        platoon(p_rx).send_energy=platoon(p_rx).send_energy+0.5; % p_rx sends a request for info about p_tx
                        t2=t+0.01; % add 10 ms
                        disp(['T: ' num2str(t2) ' Request from ' num2str(p_rx) ' send.'])
                        t2=t2+0.01; % add 10 ms
                        for p_rx_2nd=1:N % all except p_rx listen.
                            if p_rx_2nd ~= p_rx
                                if channel_ok(platoon, p_rx, p_rx_2nd, PER_model,2,ch,1, ts, time_step) 
                                    disp(['     Reception by: ' num2str(p_rx_2nd)])
                                                            
                                    platoon(p_rx_2nd).send_energy=platoon(p_rx_2nd).send_energy+0.5; % nodes p_rx call for help repeat information about p_tx              
                                    for p_rx_3rd=1:N 
                                        if p_rx_3rd ~= p_rx_2nd 
                                            if channel_ok(platoon, p_rx_2nd, p_rx_3rd, PER_model,2,ch,1, ts, time_step) % from repeating node to other node 
                                                disp(['         ' num2str(p_rx_3rd) ' received message from ' num2str(p_rx_2nd)])
                                                % Now p_rx_2nd sends
                                                % message to p_rx_3rd
                                                % containing information 
                                                % about p_tx
                        
                                                if platoon(p_rx_2nd).data_age(p_tx) > platoon(p_rx_3rd).data_age(p_tx)
                                                    disp(['         data age ' num2str(t-platoon(p_rx_3rd).data_age(p_tx)) ' changed to ' num2str(t2-platoon(p_rx_2nd).data_age(p_tx))])
                                                    platoon(p_rx_3rd).data_age(p_tx) = platoon(p_rx_2nd).data_age(p_tx);
                                                end
                                            end
                                        end
                                    end
                        
                                    
                                end
                            end 
                        end
                    end
                end
                
                
                
            end
        end
    end
end


% Update stats for forwarding algorithms - general version for algorithms 1-5
if algo<6
  for rx=1:N
    for tx=1:N
      if rx ~= tx 
         if FORWARD(rx,tx) == 1
            STATS.resends = STATS.resends+1;
         end
         if (RECEIVED_FWD(rx,tx) > 0)
            STATS.resend_received = STATS.resend_received+RECEIVED_FWD(rx,tx);
         end
         if (RECEIVED_FWD(rx,tx) > 0) && (RECEIVED(rx,tx) == 0)
            STATS.resend_useful = STATS.resend_useful+1;
         end
      end
    end
  end
end


% ETSI Contention-based forwarding and stats
if algo==6 
  for p_tx=1:N
    buf_time = zeros(N);
    [d_max, fw_node] = max(ECB_DIST(:,p_tx)); % Distance and node number for resend, i.e. longest away from sender

    %disp(['Checking resend for node: ' num2str(p_tx)])
    %disp(ECB_DIST)
    while d_max>0
      STATS.resends = STATS.resends+1;
      % Define 100m as maximum distance for an 802.11p message. Enl. google är 300ft (92m) "in the high end of the range seen in practice".
      t_send = platoon(p_tx).veh_rep_freq-(d_max/100)*(platoon(p_tx).veh_rep_freq);
      ECB_DIST(fw_node,p_tx) = 0; % This vehicle forwards message, so it is no longer among listeners for this package
      %disp(['ETSI CB original tx: ' num2str(p_tx) ' forwarded by: ' num2str(fw_node) ' with dist: ' num2str(d_max) ' t_send: ' num2str(t_send)])
      
      % repeat received message once
      platoon(fw_node).send_energy=platoon(fw_node).send_energy+1; % vehicle with longest distance from previous tranmitter sends
      for p_rx_2nd=1:N % loop receiving nodes, except:
        if (p_rx_2nd ~= p_tx) && (p_rx_2nd ~= fw_node) % sending node and my node not interesting
          if channel_ok(platoon, fw_node, p_rx_2nd, PER_model,1,ch,1, ts, time_step) % from repeating node to other node 
            STATS.resend_received = STATS.resend_received+1;
            if  ECB_DIST(p_rx_2nd,p_tx)>0
              % This node had already received the packet, but now also knows it does not have to forward
              ECB_DIST(p_rx_2nd, p_tx) = -1;
            elseif ECB_DIST(p_rx_2nd,p_tx) == 0
              % This node had not received the packet before, so update data age
              STATS.resend_useful = STATS.resend_useful+1;
              platoon(p_rx_2nd).data_age(p_tx)=t-t_send; 
              ECB_DIST(p_rx_2nd, p_tx) = -1;
              % Todo: Should this node also be a candidate for a second forwarding of the packet? Check standard again
           end
           %disp(['  - Resend reached by: ' num2str(p_rx_2nd) ' from: ' num2str(fw_node) ' at time: ' num2str(t)])
          end
        end
      end

    [d_max, idx_max] = max(ECB_DIST(:,p_tx));
    %disp(ECB_DIST)                       
    end % while d_max>0
  end % for p_tx
end % if algo = 6

% Reachability-matrix algo forwarding and stats (NOTE: algo 8 NOT IMPLEMENTED YET)
if (algo==7) || (algo==8)  
  for p_tx=1:N

    % Calculate listen-vector waiting times
    REACH = zeros(1,N);
    for rx=1:N
        if ECB_DIST(rx,p_tx)>0
           % Node rx did receive a packet from p_tx, so calculate if rx should resend
           reach=0;
           for i=1:N
               if (i ~= p_tx) && (i ~= rx)
                 if ts-LISTEN_AGE(rx, i, rx) <= listenAgeLimit
                    % Vehicle i hears vehicle rx...
                    if ts-LISTEN_AGE(rx, i, p_tx) > listenAgeLimit
                       % ...but not vehicle p_tx. Therefore, it could benefit from a resend from rx
                       reach = reach +1;
                       %disp(['Node: ' num2str(rx) ' reaches ' num2str(i)])
                    end
                 end
               end
           end % for i
           REACH(rx) = reach;
        end
    end % for rx
    [w_max, fw_node] = max(REACH);

    %disp(['Checking resend for node: ' num2str(p_tx)])
    %disp(LISTEN_AGE(fw_node,:,:))
    %if(w_max>0)
    %  disp(['Checking resend for node: ' num2str(p_tx) ' at ' num2str(ts)])
    %  disp(REACH)
    %  disp(w_max)
    %  disp(fw_node)
    %  disp(['Listen age fw rx'])
    %  tmp = LISTEN_AGE(fw_node,1,:);
    %  disp(tmp)
    %  tmp = LISTEN_AGE(fw_node,2,:);
    %  disp(tmp)
    %  tmp = LISTEN_AGE(fw_node,3,:);
    %  disp(tmp)
    %  tmp = LISTEN_AGE(fw_node,4,:);
    %  disp(tmp)
    %  disp(['ECB dist'])
    %  tmp = ECB_DIST(:,p_tx);
    %  disp(tmp)
    %  disp(['------------'])
   %end

    while w_max>0
      %disp(['Resend from node: ' num2str(fw_node) '. Original sender: ' num2str(p_tx)])

      % Make sure this node does not resend again.
      REACH(fw_node)=0;

      STATS.resends = STATS.resends+1;
      % Wait time inversely proportional to reach number (w_max). Max wait time is equal to message frequency.
      % TODO: Maybe max wait time should be shorter...
      t_send = platoon(p_tx).veh_rep_freq*(1/w_max);

      % repeat received message once
      platoon(fw_node).send_energy=platoon(fw_node).send_energy+1; % vehicle with longest distance from previous tranmitter sends
      for p_rx_2nd=1:N % loop receiving nodes, except:
        if (p_rx_2nd ~= p_tx) && (p_rx_2nd ~= fw_node) % sending node and my node not interesting
          if channel_ok(platoon, fw_node, p_rx_2nd, PER_model,1,ch,1, ts, time_step) % from repeating node to other node
            %disp(['Resend received by node: ' num2str(p_rx_2nd) '. Original sender: ' num2str(p_tx)])
            STATS.resend_received = STATS.resend_received+1;
            if  ECB_DIST(p_rx_2nd,p_tx)>0
              % This node had already received the original packet

              % Recalculate its wait time given that the resender has now covered some more nodes,
              % unless this node has already resent (i.e. its wait time is zero)
              if(REACH(p_rx_2nd)>0)
                  reach=0;
                  for i=1:N
                     if (i ~= p_tx) && (i ~= p_rx_2nd)
                        if ts-LISTEN_AGE(p_rx_2nd, i, p_rx_2nd) <= listenAgeLimit
                           % Vehicle i hears vehicle rx...
                           if ts-LISTEN_AGE(p_rx_2nd, i, p_tx) > listenAgeLimit
                               % ...but not vehicle p_tx. Therefore, it could benefit from a resend from rx
                               if ~(ts-LISTEN_AGE(p_rx_2nd, i, fw_node) <= listenAgeLimit)
                                    % ...unless the resender also is known to cover this node
                                    % Note: It is possible that there has been several resenders and this is not the first resend
                                    % this node hears. It should really filter for all resenders, but currently only takes the last
                                    % heard resend into account, which may result in some unneccessary resends. For only 4 nodes
                                    % this is not a problem since sender+resender+receiver only leaves one more node so there can
                                    % not be more than two resends so noone can be left with non-zero wait time after a second resend.
                                   %disp(['Node: ' num2str(p_rx_2nd) ' reaches ' num2str(i)])
                                   reach = reach +1;
                               end
                           end
                        end
                     end
                  end % for i
                  REACH(p_rx_2nd) = reach;
                  %disp(['New reach: ' num2str(reach) ' in node ' num2str(p_rx_2nd)])
              end

            elseif ECB_DIST(p_rx_2nd,p_tx) == 0
              % This node had not received the packet before, so update data age
              STATS.resend_useful = STATS.resend_useful+1;
              platoon(p_rx_2nd).data_age(p_tx)=t-t_send;
              % Update its knowledge of the original sender
              for i=1:N
                  if ts-LISTEN_AGE(p_tx, p_tx, i) <= listenAgeLimit
                      LISTEN_AGE(p_rx_2nd, p_tx, i) = ts;
                  else
                    LISTEN_AGE(p_rx_2nd, p_tx, i) = 0;
                  end
              end
              
              % Mark that the node has now received the packet
              ECB_DIST(p_rx_2nd, p_tx) = -1;
              % Todo: Should this node also be a candidate for a second forwarding of the packet? Check standard again
            else
              % This node has received an update but not the original packet. For now, do nothing about it (needed for more than one resend)
            end
           %disp(['  - Resend reached by: ' num2str(p_rx_2nd) ' from: ' num2str(fw_node) ' at time: ' num2str(t)])
          else
             % Resend not received by this node
             %disp(['Resend not received for node: ' num2str(p_rx_2nd) '. Original sender: ' num2str(p_tx)])
          end
        end
      end

      [w_max, fw_node] = max(REACH);
    end % while d_max>0
  end % for p_tx
end % if algo = 7


for p_rx=1:N 
    % control loop
    platoon(p_rx) = control_loop(platoon(p_rx),p_rx,t_step,1);
end


% position update, all vehicles
for p_rx=1:N 
    platoon(p_rx).coordinate_x =platoon(p_rx).coordinate_x + platoon(p_rx).speed_x*t_step;
end    
end

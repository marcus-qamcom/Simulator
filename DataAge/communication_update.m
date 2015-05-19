function platoon = communication_update(platoon, t, Hz, Tx_algo, D_right, D_left, tx_time_all)
% platoon = communication_update(platoon, t, Hz, Tx_algo)
%
% Sets flag when a vehicle has send it's status information.
%
% platoon = vehicle platoon
% t       = absolute time [s]
% Hz      = Message update freqency [Hz]
% Tx_algo = Tx algorithm


% For vehicles with more than one node:
%  Tx_algo = 1 => Transmits with first node
           % 2 => Transmit with random node
           % 3 => Transmit with every second node, simply use s half data
           % rate
           % 4 => Transmit with all nodes (allowed acc to std.?)
           % 5 => Tx algorithm... to be implemented...

N=length(platoon);

for n=1:N
    platoon(n).send_flag(:)=0; % no messages send
end


if Tx_algo == 1
    for n=1:N
        diff_t=t-platoon(n).t_last_msg;
        if diff_t>1/Hz
            platoon(n).t_last_msg=t;
            % inform that info is send out to platoon:
            platoon(n).send_flag(1)=1; % msg send
            platoon(n).send_energy=platoon(n).send_energy+1;
        end
    end
end


if Tx_algo == 2 % Transmit with random node
    for n=1:N
        n_node=floor(rand*platoon(n).N_node+1);
        diff_t=t-platoon(n).t_last_msg;
        if diff_t>platoon(n).veh_rep_freq
            platoon(n).t_last_msg=t;
            % inform that info is send out to platoon:
            platoon(n).send_flag(n_node)=1; % msg send
            platoon(n).send_energy=platoon(n).send_energy+1;
        end
    end
end


if Tx_algo == 3 % Transmit with every second node
tol = 0.002; % Tolerance between each send event.   
    for n=1:N
        diff_t=t-platoon(n).t_last_msg;
        if(diff_t>(platoon(n).veh_rep_freq-tol)) % Changed the if statement to get correct update rate. if diff_t>=platoon(n).veh_rep_freq
            last_node=platoon(n).send_node;
            if last_node+1<=platoon(n).N_node
                n_node=last_node+1;
            else
                n_node=1;
            end
            
            platoon(n).t_last_msg=t;
            
            % inform that info is send out to platoon:
            platoon(n).send_flag(n_node)=1; % msg send
            platoon(n).send_node=n_node;
            platoon(n).send_energy=platoon(n).send_energy+1;
            
        end
    end
end


if Tx_algo == 4 % Transmit with all nodes (allowed acc to std.?)
    
    for n=1:N
        diff_t=t-platoon(n).t_last_msg;
        if diff_t>platoon(n).veh_rep_freq
            for n_node=1:platoon(n).N_node
                
                % inform that info is send out to platoon:
                platoon(n).send_flag(n_node)=1; % msg send
                platoon(n).send_energy=platoon(n).send_energy+1;
            end
            
            platoon(n).t_last_msg=t;
        end
    end
end


if (Tx_algo == 5) % Transmit on left when turning left and right when turning right, if driving straight, alternate between left and right hand side antennas.
tol = 0.002; % Tolerance between each send event. 
    for n=1:N
        diff_t=t-platoon(n).t_last_msg;
        if(diff_t>(platoon(n).veh_rep_freq-tol)) % Changed the if statement to get correct update rate. 
            % if turning left, choose left antenna
            % ceil(t*10) is the index of the turningvector
            % FREDRIK Can You see a nicer way of doing this?
            % TODO: Check how many times in left, right and straight.
            %  
            tmp_idx = find(tx_time_all{1}(:)>=t & tx_time_all{1}(:)<t+0.05);
            if ~isempty(tmp_idx)
                idx = tmp_idx(1);
                if ismember(idx, D_left) % Does n_node == 1 represents transmission on the left hand side?
                    n_node = 1;
                % if turning right, choose right antenna
                elseif ismember(idx, D_right)
                    n_node = 2;
                % If driving straight apply same algo as "3"
                else
                    last_node=platoon(n).send_node;
                    if last_node+1<=platoon(n).N_node
                        n_node=last_node+1;
                    else
                        n_node=1;
                    end
                end
                platoon(n).t_last_msg=t;

                % inform that info is send out to platoon:
                platoon(n).send_flag(n_node)=1; % msg send
                platoon(n).send_node=n_node;
                platoon(n).send_energy=platoon(n).send_energy+1;
            end
        end
    end
end
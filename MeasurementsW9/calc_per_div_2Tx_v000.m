function [vper per] = calc_per_div_2Tx_v000(RX_SEQ_LL,RX_SEQ_RL,RX_SEQ_LR,RX_SEQ_RR, TX_SEQ_L,TX_SEQ_R,TT_L,TT_R)
% This is how input arguments are derived:
%[TT_1 RSSI_1 LAT_1 LONG_1 RX_SEQ_1  lab_1]=load_comm_link(testconf,t_no,AP,  veh_rec1,  veh_send,   fs       );
%[TT_2 RSSI_2 LAT_2 LONG_2 RX_SEQ_2  lab_2]=load_comm_link(testconf,t_no,AP,  veh_rec2,  veh_send,   fs       );
%[TT_3 RSSI_3 LAT_3 LONG_3 TX_SEQ lab_3]=load_comm_link(testconf,t_no,AP,  veh_send,  veh_send,  fs_own   );

%% Analysis starts here

NL=length(TT_L);
NR=length(TT_R);

vper =ones(NL,1);
% Round time vectors to one decimal:
TT_Lb=round((TT_L*10))/10;
TT_Rb=round((TT_R*10))/10;





for tL=1:NL
    if find(RX_SEQ_LL == TX_SEQ_L(tL)) %ok
        vper(tL)=0;
    else
        if find(RX_SEQ_RL == TX_SEQ_L(tL)) %ok
            vper(tL)=0;
        else
            
            tR=find(TT_Rb==TT_Lb(tL));
            if length(tR)>1
                tR=tR(1);
            end
            if length(tR)>0
                
                if find(RX_SEQ_LR == TX_SEQ_R(tR)) %ok
                    vper(tL)=0;
                else
                    if find(RX_SEQ_RR == TX_SEQ_R(tR)) %ok
                        vper(tL)=0;
                    else
                    % sorry not found
                    end
                end
            else
                vper(tL)=0;
               % disp('time not found')
            end    
        end
    end
end

per=sum(vper)/NL*100;
function [vper per] = calc_per_div_v000(RX_SEQ_1,RX_SEQ_2,TX_SEQ)
% This is how input arguments are derived:
%[TT_1 RSSI_1 LAT_1 LONG_1 RX_SEQ_1  lab_1]=load_comm_link(testconf,t_no,AP,  veh_rec1,  veh_send,   fs       );
%[TT_2 RSSI_2 LAT_2 LONG_2 RX_SEQ_2  lab_2]=load_comm_link(testconf,t_no,AP,  veh_rec2,  veh_send,   fs       );
%[TT_3 RSSI_3 LAT_3 LONG_3 TX_SEQ lab_3]=load_comm_link(testconf,t_no,AP,  veh_send,  veh_send,  fs_own   );

%% Analysis starts here

% sort, just in case
RX_SEQ_1=sort(RX_SEQ_1);
RX_SEQ_2=sort(RX_SEQ_2);
TX_SEQ=sort(TX_SEQ);

vper =ones(size(TX_SEQ));
vper1=zeros(size(TX_SEQ));
vper2=zeros(size(TX_SEQ));

M=length(TX_SEQ);
N1=length(RX_SEQ_1);
N2=length(RX_SEQ_2);

% First check if packet is received by first antenna
for n1=1:N1
    if TX_SEQ(1)<=RX_SEQ_1(n1)
        break
    end
    
end

for m=1:M
    if n1>N1
        vper1(m)=1;
    else
        if TX_SEQ(m)==RX_SEQ_1(n1)
            n1=n1+1;
        else
            vper1(m)=1;
        end 
    end
end

% Second, check if packet is received by second antenna
for n2=1:N2
    if TX_SEQ(1)<=RX_SEQ_2(n2)
        break
    end
    
end

for m=1:M
    if n2>N2
        vper2(m)=1;
    else
        if TX_SEQ(m)==RX_SEQ_2(n2)
            n2=n2+1;
        else
            vper2(m)=1;
        end 
    end
end

% Combine vper1 and vper2
for m=1:M
    if vper1(m)==0 || vper2(m)==0
        vper(m)=0;
    end
end

per=sum(vper)/M*100;
per1=sum(vper1)/M*100;
per2=sum(vper2)/M*100;
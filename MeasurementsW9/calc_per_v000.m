function [vper per] = calc_per_v000(RX_SEQ,TX_SEQ)
% This is how input arguments are derived:
%[TT_1 RSSI_1 LAT_1 LONG_1 RX_SEQ  lab_1]=load_comm_link(testconf,t_no,AP,  veh_rec,  veh_send,   fs       );
%[TT_2 RSSI_2 LAT_2 LONG_2 TX_SEQ lab_2]=load_comm_link(testconf,t_no,AP,  veh_send,  veh_send,  fs_own   );

%% Analysis starts here

% sort, just in case
RX_SEQ=sort(RX_SEQ);
TX_SEQ=sort(TX_SEQ);

vper=zeros(size(TX_SEQ));

M=length(TX_SEQ);
N=length(RX_SEQ);

% Om TX-loggen startar på ett högre värde än RX så stegar vi fram RX
% så att sekvensnumret är minst lika stort som första TX
for n=1:N
    if TX_SEQ(1)<=RX_SEQ(n)
        break
    end
    
end

% Gå genom hela TX-sekvensen och sätt en etta i vper-vektorn på varje
% sekvensnummer där inget motsvarande paket finns i RX
for m=1:M
    if n>N
        vper(m)=1;
    else
        if TX_SEQ(m)==RX_SEQ(n)
            n=n+1;
        else
            vper(m)=1;
        end 
    end
end

% Beräkna totala packet error rate som antalet mottagna paket genom
% antalet sända paket. Resultat i %.
per=sum(vper)/M*100;


function [ts] = timestamp_test_6(TT_1L, TT_2L, TT_3L, TT_4L, TT_1R, TT_2R, TT_3R, DD, d, first,search_from_end)

% Timestamps from distance/position 

ts=zeros(1,7); %(time_index, veh. L/R)

if 1 ~= search_from_end
    
    % A node reaches <d> meters:
    tmp=find(DD(:,1)>=d,1);
    if first ==1 
        tmp=TT_1L(tmp); %time
    else % last node
        tmp=TT_4L(tmp); %time
    end

    ts(1,1)=find(TT_1L>=tmp,1);
    ts(1,2)=find(TT_1R>=tmp,1);
    ts(1,3)=find(TT_2L>=tmp,1);
    ts(1,4)=find(TT_2R>=tmp,1);
    ts(1,5)=find(TT_3L>=tmp,1);
    ts(1,6)=find(TT_3R>=tmp,1);
    ts(1,7)=find(TT_4L>=tmp,1);

else % search_from_end
    % First find index of turning point:
    tmp2=find(DD(:,1)==max(DD(:,1)),1);
    % A node reaches <d> meters on the way back:
    tmp=find(DD(tmp2:end,1)<=d,1)+tmp2;
    
    if first ==1 
        tmp=TT_1L(tmp); %time
    else % last node
        
        tmp=TT_4L(tmp); %time
    end

    ts(1,1)=find(TT_1L>=tmp,1);
    ts(1,2)=find(TT_1R>=tmp,1);
    ts(1,3)=find(TT_2L>=tmp,1);
    ts(1,4)=find(TT_2R>=tmp,1);
    ts(1,5)=find(TT_3L>=tmp,1);
    ts(1,6)=find(TT_3R>=tmp,1);
    ts(1,7)=find(TT_4L>=tmp,1);
    
end

%disp(['T:' num2str(TT_1L(ts(1,1))) ' ' num2str(TT_1R(ts(1,2))) ' ' num2str(TT_2L(ts(1,3))) ' ' num2str(TT_2R(ts(1,4))) ' ' num2str(TT_3L(ts(1,5))) ' ' num2str(TT_3R(ts(1,6))) ' ' num2str(TT_4L(ts(1,7)))  ])
end
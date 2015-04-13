function T = adjustT(TIME_SLICES, T_in)
% ADJUSTT adjusts the time vector so that it starts at
% zero and there are no gaps
  
  adj = 0;
  for j=1:size(TIME_SLICES,1)
    for i=1:size(T_in, 2)
      if(T_in(i) >= TIME_SLICES(j,1)) && (T_in(i) <= TIME_SLICES(j,2))
        T(i) = T_in(i)-TIME_SLICES(j,1)+adj;
      end
    end
    adj = adj + (TIME_SLICES(j,2)-TIME_SLICES(j,1))+0.1; % Start of current slice adjusted to be behind previous slices
  end
end

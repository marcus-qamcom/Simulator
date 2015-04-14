function [T D RSSI LAT LONG SEQ V] = filterTimeSlices(TIME_SLICES, T_in, D_in, RSSI_in, LAT_in, LONG_in, SEQ_in, V_in)
% FILTERTIMESLICES filters data on
%  distance - only data enclosed by distances defined in
%             testconf.locfilter (i.e. distance from reference location
%             testconf.refloc) is returned

  idx=1;
  for i=1:size(T_in, 2)
    for j=1:size(TIME_SLICES,1)
        %disp(TIME_SLICES(j,1));
        %disp(T_in(i));
        %disp(size(T_in));
        if (T_in(i) >= TIME_SLICES(j,1)) && (T_in(i) <= TIME_SLICES(j,2))
           T(idx)       = T_in(i);
           D(idx,:)     = D_in(i,:);
           RSSI(idx)    = RSSI_in(i);
           LAT(idx)     = LAT_in(i);
           LONG(idx)    = LONG_in(i);
           SEQ(idx)     = SEQ_in(i);
           V(idx)       = V_in(i);
           idx = idx+1;
        end
    end
  end
end % filterTimeSlices

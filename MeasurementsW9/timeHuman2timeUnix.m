function timeUnix = timeHuman2timeUnix( timeHuman )
% matlab_time = todatenum(cdfepoch(timeHuman));   % FW: cdfepoch is not available in octave. Substituted with expression below which seems to give the same answer.
matlab_time = datenum(timeHuman, 'yyyy-mm-dd HH:MM:SS.FFF');
time_reference = datenum('1970-01-01', 'yyyy-mm-dd');
timeUnix = 8.64e4 * (matlab_time - time_reference); %8.64e4 number of seconds in 24 hours
%timeUnix = 8.64e4 * (matlab_time - datenum('1970', 'yyyy')); %8.64e4 number of seconds in 24 hours
end


% Clear everything
clear all 
close all
clc
graphics_toolkit("gnuplot");

% TC6 tests, PER model 4 (real meas moving avg)

TC = [6];
%TC = [8];
AP = [5];
%AP = [5 8];
FRAME_SIZE = [524, 600];

MULTIHOP = [7];
TX_ALG = [3];

% Loop through testcases, antenna positions, frame sizes, and multihop algorithms.
% Result files will be created for each simulation. The file names are constructed
% using these parameters.
for i=1:size(TC,2)
  for j=1:size(AP,2)
    for k=1:size(FRAME_SIZE,2)
      for m=1:size(MULTIHOP,2)
        for n=1:size(TX_ALG,2)
          disp(['TC: ' num2str(TC(i)) ' AP: ' num2str(AP(j)) ' FS ' num2str(FRAME_SIZE(k))])
          runTrafficSimRealmeas(num2str(TC(i)), num2str(AP(j)), FRAME_SIZE(k), MULTIHOP(m), TX_ALG(n), 4);
          close all
        end
      end
    end
  end
end

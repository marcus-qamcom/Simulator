% Clear everything
clear all 
close all
clc

% TC6 tests

TC = [6];
AP = [2, 5, 8];
FRAME_SIZE = [124, 524, 600];

for i=1:size(TC,2)
 for j=1:size(AP,2)
   for k=1:size(FRAME_SIZE,2)
     disp(['TC: ' num2str(TC(i)) ' AP: ' num2str(AP(j)) ' FS ' num2str(FRAME_SIZE(k))])
     getAllTests(num2str(TC(i)), num2str(AP(j)), FRAME_SIZE(k));
     getMovingAvg(num2str(TC(i)), num2str(AP(j)), FRAME_SIZE(k));
   end
 end
end


% TC8 tests
% 
% TC = [8];
% AP = [5, 8];
% FRAME_SIZE = [124, 524, 600];
% %TC = [8];
% %AP = [5];
% %FRAME_SIZE = [124];
% 
% for i=1:size(TC,2)
%   for j=1:size(AP,2)
%     for k=1:size(FRAME_SIZE,2)
%       disp(['TC: ' num2str(TC(i)) ' AP: ' num2str(AP(j)) ' FS ' num2str(FRAME_SIZE(k))])
%       getAllTests(num2str(TC(i)), num2str(AP(j)), FRAME_SIZE(k));
%       getMovingAvg(num2str(TC(i)), num2str(AP(j)), FRAME_SIZE(k));
%     end
%   end
% end

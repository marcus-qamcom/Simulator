function [straightIndex, leftIndex, rightIndex] = getTurnVector(t, V, lat, long )
% input and output parameters: 
% t is the elapsed time since start of test
% V is the speed of the vehicle
% lat is latitude of vehicle
% long is the longitude of the vehicle
% turnVector indicates whether the first truck is driving left, right or
% straight ahead.
idxs=t(1:end-1);

[E,N] = deg2utm((lat*0.0000001)', (long*0.0000001)'); 

% Det Degermanska trolleriet... och det är lätt!!!
E = E-mean(E);
N = N-mean(N);
V = V/3.6;

% filter to get good acceleration (Kalman stuff)
% init state
x = [E(1),N(1),(E(2)-E(1))/1,(N(2)-N(1))/1]';
P = diag([5,5,5,5].^2);
% state transition
% T = 0.1;

% modeling errors

q = 0.5; % tidigare 0.5

% measurement error
R = diag([5,5,5].^2);

X = [];

for i=2:length(idxs)
    
    T=t(i)-t(i-1);
    Q = q^2*kron([T/3,T/2;T/2,T],eye(2));
    F = kron([1,T;0,1],eye(2));
    % predicted state
    xp = F*x;
    Pp = F*P*F' + Q;   
    % predicted velocity (from state)
    vp = sqrt(xp(3)^2+xp(4)^2);
   
    % meausrement
    z  = [E(i),N(i),V(i)]';
    % predicted measurement
    zp = [x(1),x(2),vp]';
   
    % residual
    y  = z - zp;
   
    % measurement Jacobian
    H  = [1,0,0,0;0,1,0,0;0,0,xp(3)/vp,xp(4)/vp];
   
    % residual covariance
    S  = H*Pp*H' + R;
   
    % Kalman gain
    K  = Pp*H'*inv(S);
    
    % update
    x  = xp + K*y;
    P  = (eye(4)-K*H)*Pp;
    
    X = [X,x];
    
end

vx = X(3,:);
vy = X(4,:);

% Classify direction and plot
turn = gradient(atan2(vy,vx));
%unwrap the pi's
turn(turn>0.9*pi)=turn(turn>0.9*pi)-pi;
turn(turn<-0.9*pi)=turn(turn<-0.9*pi)+pi;
%%
turn_indicator = zeros(size(turn));
turn_indicator(turn>0.00058) = 1; %Tidigare 0.0004
turn_indicator(turn<-0.00058) = -1;

%% Plot figure describing the turning behavior of the platoon, and create a 
%  turning vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot for checking feasability.
% figure(1);
% hold on;
% cla;
% title('Turning indicator');
% xlabel('Distance [m]')
% ylabel('Distance [m]')
% turnlogg=zeros(1,length(idxs));
for i=1:length(idxs)-1
    
    if turn_indicator(i)==1
%         plot(X(1,i),X(2,i),'r.');
        turnlogg(i)=1;
    elseif turn_indicator(i)==-1
%         plot(X(1,i),X(2,i),'b.');
        turnlogg(i)=0.9;
    else
%         plot(X(1,i),X(2,i),'g.');
        turnlogg(i)=0;
    end
    
end

[straightIndex, leftIndex, rightIndex] = getTurnIndex(turnlogg);
end

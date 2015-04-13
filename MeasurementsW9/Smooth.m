function [Y2] = Smooth(Y, points)
% Y: real vector
% points: number of points to smooth

if (floor(points)==points) && points>0
    if mod(points,2) == 0 % even will always be transformed to uneven
        points=points+1;
    end
    pp=(points+1)/2;
    
    N=length(Y);
    F=linspace(1,N,N);
    Y2=zeros(N,1);
    
    % ----  smooth amplitude  ----
    % start up data
    for f=1:(points-1)/2
        length(Y(1:f+(points-1)/2));
        sum(Y(1:f+(points-1)/2));
        Y2(f)=sum(Y(1:f+(points-1)/2))/length(Y(1:f+(points-1)/2));
    end
    % middle region
    for f=((points-1)/2+1):(N-(points-1)/2-1)
        Y2(f)=mean(Y((f-pp+1):(f+pp)));
    end
%     for f=((points-1)/2+1):(N-(points-1)/2-1)
%         Y2(f)=Y2(f-1) + Y(f+pp)/points - Y(f-pp+1)/points;
%     end
%     
    % Ending data up data
    for f=(N-(points-1)/2):N
        Y2(f)=sum(Y(f-(points-1)/2:N))/length(Y(f-(points-1)/2:N));
    end
    %plot(F,Y,'r',F,Y2,'b')
   %keyboard
end    
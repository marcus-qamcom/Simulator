function d = calcDistV(lat1V,long1V,lat2,long2,pos_neg)
% Calculate the great circle distance between a vector and a point.
%   
N=length(lat1V);


if pos_neg==1
    d=zeros(N,1);
    
    
    for n=1:N
        d(n)=calcDist(lat1V(n),long1V(n),lat2,long2)*1000;
    end
    
    
else
    if pos_neg==-1
    d=zeros(N,1);
    
    
    R = 6371000; %Radius of earth in meters
    long2=long2*0.0000001;
    lat2=lat2*0.0000001;
    for n=1:N
    
        
        lat=lat1V(n)*0.0000001;
        lon=long1V(n)*0.0000001;
       
        d_lon = sind(lon - long2) * cosd(lat) * R;
        d_lat = -sind(lat - lat2) * R; %' cosd(lat) * R
        %d(n, 1) = d_lat;
        %d(n, 2) = d_lon;
        d(n)=sign(d_lat)*(d_lat^2 + d_lon^2)^0.5;
    end


    else %pos_neg==-2
        d=zeros(N,2);           
        R = 6371000; %Radius of earth in meters
        long2=long2*0.0000001;
        lat2=lat2*0.0000001;
        for n=1:N
            
            lat=lat1V(n)*0.0000001;
            lon=long1V(n)*0.0000001;
       
            d_lon = sind(lon - long2) * cosd(lat) * R;
            d_lat = -sind(lat - lat2) * R; %' cosd(lat) * R
            d(n, 1) = d_lat;
            d(n, 2) = d_lon;
            %d(n)=sign(d_lat)*(d_lat^2 + d_lon^2)^0.5;
        end
    end

end
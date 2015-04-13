function d = calcGCDistV(LAT,LONG,lat_ref,long_ref)
% Calculate the great circle distance between a vector and a point.
%   
  
  N=length(LAT);

  d=zeros(N,2);
  R = 6371000; %Radius of earth in meters
  long_ref=long_ref*0.0000001;
  lat_ref=lat_ref*0.0000001;
  for n=1:N
    lat=LAT(n)*0.0000001;
    long=LONG(n)*0.0000001;

    d_long = sind(long - long_ref) * cosd(lat) * R;
    d_lat  = -sind(lat - lat_ref) * R; %' cosd(lat) * R
    d(n, 1) = d_lat;
    d(n, 2) = d_long;
  end
end

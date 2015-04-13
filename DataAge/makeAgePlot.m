function cdf_val = makeAgePlot(N_veh,T,res_timestamp,timeout,age_limit, file_plot_age, file_plot_hist)
% cdf_val = sub_plot(N_veh,T,res_timestamp,timeout,age_limit)
%
% Plot function
%
% N_veh         = Number of vehicle in Platoon
% T             = Time vector
% res_timestamp = data age timestamps
% timeout       = ...
% age_limit     = Age limit in plots.


%% General plot settings
ColorVec={'r' 'g' 'b' 'c' 'm' 'y' 'k'};
p_act=N_veh; % We select the last node as viewpoint of our plots
C={}; % legend
cc=0;
for p=1:N_veh
    if p_act ~= p
        cc=cc+1;
        C{cc}=[' ' num2str(p) ' to ' num2str(p_act) ' '];
    end
end

C{cc+1}= ' Age limit ';

%% plot timestamp, res_timestamp(ts,p,p_act);
for ts=2:length(T)
    for p=1:N_veh
        if p_act ~= p
            if res_timestamp(ts,p,p_act)~= timeout
                tmp_timestamp(ts,p)=T(ts)-res_timestamp(ts,p,p_act);
            else 
                tmp_timestamp(ts,p)=ones(size(res_timestamp(ts,p,p_act)))*5;
            end
            tmp_timestamp2(ts,p)=T(ts)-res_timestamp(ts,p,p_act);
        end
    end
end

figure
hold on
for p=1:N_veh
    if p_act ~= p
        plot(T,tmp_timestamp(:,p),ColorVec{p})
    end
end
plot(T,ones(length(tmp_timestamp),1)*age_limit,'r--')
legend(C,'Location','NorthEast')
xlabel('T [sec.]')
ylabel('Data age [s]')
title(['Communication to veh. no.: ' num2str(p_act) ])
axis([0 max(T) 0 1])
hold off

print (file_plot_age, '-deps')
print (file_plot_age, '-dpng')

%% CDF:s
tmp_timestamp2(tmp_timestamp2>=1.1) = 1.1; % replace in time stamp >1.1 sec with infinite (here 1.1 sec.)

cdf=sort(tmp_timestamp2);

figure
hold on
for p=1:N_veh
    if p_act ~= p
        plot(cdf(:,p),linspace(0,1,length(tmp_timestamp2)),ColorVec{p})  
        if length( find(cdf(:,p) > age_limit, 1))>0
            cdf_val(p)=find(cdf(:,p) > age_limit, 1)/length(T);
        else
           cdf_val(p)=100;
        end
    end
end

plot([age_limit age_limit],[0 1],'r--')
xlabel('Data age [s]')
ylabel('Probability [-]')
xlim([0 1]) 
ylim([0 1]) 
legend(C,'Location','SouthEast')
hold off

file_plot_age2 = strcat(file_plot_age, "_c");

print (file_plot_age2, '-deps')
print (file_plot_age2, '-dpng')

%hFig = figure(1);
%set(hFig, 'Position', [100 100 500 600])


%% Histogram
figure
%hist(flipdim(tmp_timestamp2,2))
hist(tmp_timestamp2)
hold on
h=findobj(gca,'Type','patch');
for p=1:N_veh
    if p_act ~= p
        set(h(p),'FaceColor',ColorVec{N_veh-p},'EdgeColor','k')
        %set(h(p),'FaceColor',ColorVec{p},'EdgeColor','k')
    end
end

xlabel('Data age [s]')
ylabel('Frequency [-]')
xlim([0 1]) 
ylim('auto') 
legend(C)
hold off

print (file_plot_hist, '-deps')
print (file_plot_hist, '-dpng')
 

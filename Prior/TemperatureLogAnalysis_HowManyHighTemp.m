
close all
clear all
%Path='/Users/kathrynhornburg/Downloads/Temp_Log_Files_During_18.gaj.42';
Path='/Volumes/workstation_data/data/temperature_logging/stejskal/Combined_Temperature_Logging';
log_files=dir(Path);

%These are the days you want to keep in the set. 
Scan_Day={'2019-02-14'
    '2019-02-18'
    '2019-02-21'
    '2019-07-31'
    '2019-08-20'
    '2019-08-21'
    '2019-08-26'
    '2019-08-27'
    '2019-08-30'
    '2019-09-02'
    '2020-08-03'
    '2020-08-04'
    '2020-08-06'
    '2020-08-14'
    '2020-10-20'
    '2020-10-26'
    '2020-11-30'
    '2021-11-01'};

A=~cellfun(@isempty,regexpi({log_files.name},'9T'));
out_logs={log_files(A').name};

OUT=table;
Temp_Reform=table;

for n=1:sum(A)
    Temp = readtable(strcat(Path,'/',out_logs{n}));
    Temp(1,:)=[]; %The first row in it is always bogus
    offset_out=size(Temp_Reform,1);

        for m=1:size(Temp)
            % when possible would probably be good to convert the whole sheet
            somedate=datetime(Temp.Datetime(m));
        
             %idx_2=sum(idx)'>0;
        
            Temp_Reform.Date{m+offset_out}=datestr(somedate,29);
        
            try
                Temp_Reform.Time{m+offset_out}=datestr(somedate,13);
            catch
                Temp_Reform.Time{m+offset_out}={'00:00:00'};
            end
        end
       if size(Temp,2)==3
            Temp_Reform.T1((1:size(Temp,1))+offset_out)=table2array(Temp(:,2));
            Temp_Reform.T2((1:size(Temp,1))+offset_out)=table2array(Temp(:,3));
        else %newer data has more sensor inputs these are the two temperature sensors that compare with the inital data. 
            Temp_Reform.T1((1:size(Temp,1))+offset_out)=table2array(Temp(:,2));
            Temp_Reform.T2((1:size(Temp,1))+offset_out)=table2array(Temp(:,8));
        end

        

    end

%     if sum(sum(idx))>1
% 
%         idx_2=sum(idx)'>0;
% 
%         offset_out=size(OUT,1);
% 
%         if size(Temp,2)==3
%             OUT.T1((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,2));
%             OUT.T2((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,3));
%         else %newer data has more sensor inputs these are the two temperature sensors that compare with the inital data. 
%             OUT.T1((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,2));
%             OUT.T2((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,8));
%         end
%         OUT.Date((1:sum(idx_2))+offset_out)=Temp_Reform.Date(idx_2);
%         OUT.Time((1:sum(idx_2))+offset_out)=Temp_Reform.Time(idx_2);
%     end
%     clear idx idx_2
% end
% 
% OUT.High_T1=OUT.T1>mean(OUT.T1)+std(OUT.T1);
% OUT.High_T2=OUT.T2>mean(OUT.T2)+std(OUT.T2);
% 
% disp(sprintf('%1.2f%% of All Sampling Times Temperature Sensor 1 was High (mean+SD= %1.2f C) and %1.2f%% of All Sampling Times Temperature Sensor 2 was High(mean+SD=%1.2f C)',[100*sum(OUT.High_T1==1)/size(OUT,1),mean(OUT.T1)+std(OUT.T1),100*sum(OUT.High_T2==1)/size(OUT,1),mean(OUT.T2)+std(OUT.T2)]))
% disp(sprintf('%2.2f%% of Pulled Dates Temperature Sensor 1 was High (>mean+SD) and %2.2f%% of Pulled Dates Temperature Sensor 2 was High(>mean+SD)',100*[size(unique(OUT.Date(OUT.T1>mean(OUT.T1)+std(OUT.T1))),1),size(unique(OUT.Date(OUT.T2>mean(OUT.T2)+std(OUT.T2))),1)]./numel(unique(OUT.Date))));
% 
% writetable(OUT, 'Temperature_Log_9T_output_CombinedOutlier_MeanResponseDates.csv');

%Overview Temperature Logging Analysis
clear all
close all

%% "Outlier" Days from the 18.gaj.42
% Scan_Day={'2019-02-14'
%     '2019-02-18'
%     '2019-02-21'
%     '2019-07-31'
%     '2019-08-20'
%     '2019-08-21'
%     '2019-08-26'
%     '2019-08-27'
%     '2019-08-30'
%     '2019-09-02'
%     '2020-08-03'
%     '2020-08-04'
%     '2020-08-06'
%     '2020-08-14'
%     '2020-10-20'
%     '2020-10-26'
%     '2020-11-30'
%     '2021-11-01'};

%% All 18gaj42 Scan Days
%Scan_Day=readtable('/Users/Shared/workstation/code/analysis/TemperatureLogging/Scan_Dates_18gaj42_Cleaned.csv','Format','%s');

%% The scan Days that represent the major hole in 18gaj42 data
%Scan_Day=readtable('/Users/Shared/workstation/code/analysis/TemperatureLogging/Scan_Dates_InBetween_Cleaned.csv','Format','%s');

%% Selected "Outlier" Days from the 18.gaj.42 and Corresponding strain/sex/age pair
% Scan_Day={'2020-09-18'
%     '2019-08-07'
%     '2019-08-13'
%     '2019-08-16'
%     '2019-08-21'
%     '2019-07-31'
%     '2021-05-06'
%     '2019-07-24'
%     '2020-08-03'
%     '2020-08-04'
%     '2020-08-06'
%     '2020-08-14'
%     '2020-10-20'
%     '2020-10-26'};
% 
% Scan_Day=sort(Scan_Day);

%% 205xFAD days pulling
%Scan_Day=readtable('/Users/Shared/workstation/code/analysis/TemperatureLogging/Scan_Dates_205XFAD_Cleaned.csv','Format','%s');

%% Preliminary Setup Information
Name='Compare_Pairs_O_M_BXD51';
Data_Path='/Volumes/workstation_data/data/temperature_logging/stejskal/Combined_Temperature_Logging';
Save_Path='/Volumes/dusom_civm-kjh60/All_Staff/18.gaj.42';
Scan_Day={'2020-10-26'; '2019-07-24'; '2021-05-06'};
Scan_Day=sort(Scan_Day);

%% Pull Full Temperature Log Data

 %[Temp_Reform] = Pulling_All_TemperatureLogs(Data_Path);
 %writetable(Temp_Reform,'/Users/Shared/workstation/code/analysis/TemperatureLogging/Temperature_Log_9T_output_ALL_Agilent_QTenki.csv');

%% Else if already got all the log files together and saved
Temp_Reform=readtable('/Users/Shared/workstation/code/analysis/TemperatureLogging/Temperature_Log_9T_output_ALL_Agilent_QTenki.csv','Format','%s %s %s %s %f %f');
Temp_Reform.DateTime=datetime(Temp_Reform.DateTime); %makes sure the datetime is loaded as a proper datetime... easier to do this than get it out of the table on load

%% Pull Only Date We Care About 
[OUT,Status] = Restructure_OnlyDaysInterested(Temp_Reform,Scan_Day);

Plot_TemperatureLog(OUT,Save_Path,Name);
 
%Do Analysis to determine set number of days which have 1 SD and 2SD above
%the mean set (with mean and standard deviation coming  from the whole  set
%of temperature data)

[OUT,result_1SD] = sensorSDBound(Temp_Reform,OUT,Status,1);
[OUT,result_2SD] = sensorSDBound(Temp_Reform,OUT,Status,2);
[OUT,result_30] = sensorHardTempBound(Temp_Reform,OUT,Status,30);

writetable(OUT, strcat(Save_Path,'/Temperature_Log_9T_output_',Name,'_QTenki.csv'));

save(strcat(Save_Path,'/Temperature_Result_1SD_',Name,'_QTenki.mat'),'result_1SD');
save(strcat(Save_Path,'/Temperature_Result_2SD_',Name,'_QTenki.mat'),'result_2SD');
save(strcat(Save_Path,'/Temperature_Result_30C_',Name,'_QTenki.mat'),'result_30');



close all
clear all

log_files=dir('/Users/kathrynhornburg/Downloads/Temp_Log_Files_During_18.gaj.42');

Scan_Day={'14-Feb-2019'
    '18-Feb-2019'
    '21-Feb-2019'
    '31-Jul-2019'
    '20-Aug-2019'
    '21-Aug-2019'
    '26-Aug-2019'
    '27-Aug-2019'
    '30-Aug-2019'
    '02-Sep-2019'
    '03-Aug-2020'
    '04-Aug-2020'
    '06-Aug-2020'
    '14-Aug-2020'
    '20-Oct-2020'
    '26-Oct-2020'
    '30-Nov-2020'
    '01-Nov-2021'};

A=~cellfun(@isempty,regexpi({log_files.name},'9T'));
out_logs={log_files(A').name};

OUT=table;

for n=1:sum(A)
    Temp_Reform=table;
    Temp = readtable(strcat('/Users/kathrynhornburg/Downloads/Temp_Log_Files_During_18.gaj.42/',out_logs{n}));

    Temp(1,:)=[]; %The first row in it is always bogus

    for m=1:size(Temp)

        Temp_Date=strsplit(datestr(datetime(table2array(Temp(m,1)))),' ');

        Temp_Reform.Date{m}=Temp_Date{1,1};

        try
            Temp_Reform.Time{m}=Temp_Date{1,2};
        catch
            Temp_Reform.Time{m}={'00:00:00'};
        end

        idx(:,m)=strcmp(Scan_Day,Temp_Date{1,1});

    end

    if sum(sum(idx))>1

        idx_2=sum(idx)'>0;

        offset_out=size(OUT,1);

        if size(Temp,2)==3
            OUT.T1((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,2));
            OUT.T2((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,3));
        else %newer data has more sensor inputs these are the two temperature sensors that compare with the inital data. 
            OUT.T1((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,2));
            OUT.T2((1:sum(idx_2))+offset_out)=table2array(Temp(idx_2,8));
        end
        OUT.Date((1:sum(idx_2))+offset_out)=Temp_Reform.Date(idx_2);
        OUT.Time((1:sum(idx_2))+offset_out)=Temp_Reform.Time(idx_2);

    end

    clear idx idx_2
end

writetable(OUT, 'Temperature_Log_9T_output_CombinedOutlier_MeanResponseDates.csv');

for m=1:size(OUT,1)
    MORE_DATA(m,:)=strsplit(OUT.Time{m},':');
end

[name_dataset,idx_dateset,~]=unique(OUT.Date,'stable');

idx_dateset=[idx_dateset' numel(OUT.Date)];

idx_0=round((str2double(MORE_DATA(:,1))+round((str2double(MORE_DATA(:,2))+round(str2double(MORE_DATA(:,3)))/60)/60))/6)*6==0;
idx_6=round((str2double(MORE_DATA(:,1))+round((str2double(MORE_DATA(:,2))+round(str2double(MORE_DATA(:,3)))/60)/60))/6)*6==6;
idx_12=round((str2double(MORE_DATA(:,1))+round((str2double(MORE_DATA(:,2))+round(str2double(MORE_DATA(:,3)))/60)/60))/6)*6==12;
idx_18=round((str2double(MORE_DATA(:,1))+round((str2double(MORE_DATA(:,2))+round(str2double(MORE_DATA(:,3)))/60)/60))/6)*6==18;
idx_24=round((str2double(MORE_DATA(:,1))+round((str2double(MORE_DATA(:,2))+round(str2double(MORE_DATA(:,3)))/60)/60))/6)*6==24;


find(diff(idx_6)==-1);
find(diff(idx_12)==-1);
find(diff(idx_18)==-1);


tic_loc=[510
870
1230
1950
2376
2736
3107
3467
4187
4548
4908
5627
5987
6347
7067
7427
7787
8507
8867
9227
9947
10307
10667
11386
11746
12106
12826
13186
13546
14266
14626
14986
15706
16067
16427
17147
17507
17867
18587
18947
19307];

tic_name={"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"
"6AM"
"12PM"
"6PM"};

figure;
hold on
plot(OUT.T1,'.')


line([1 numel(OUT.Date)]',[30 30]','Color','r')
for n=1:15
    line([idx_dateset(n) idx_dateset(n)],[28 32],'Color','r')
    if n<=14
        text(idx_dateset(n),30.5,name_dataset{n}, 'FontSize',4)
    end
end

xlabel('Time of Day')
ylabel('Temperature \circ C')
title('Temperature Monitor:E11686')
xticks(tic_loc)
xticklabels(tic_name)

grid on
box on
axis tight

print -dpng 'Temperature Monitor_E11686_18gaj42_OutlierPoints.png'

figure;
hold on
plot(OUT.T2,'.')

line([1 numel(OUT.Date)]',[30 30]','Color','r')
for n=1:15
    line([idx_dateset(n) idx_dateset(n)],[28 32],'Color','r')
    if n<=14
        text(idx_dateset(n),30.5,name_dataset{n}, 'FontSize',4)
    end
end


xlabel('Time of Day')
ylabel('Temperature \circ C')
title('Temperature Monitor:E11709')
xticks(tic_loc)
xticklabels(tic_name)

grid on
box on
axis tight

print -dpng 'Temperature Monitor_E11709_18gaj42_OutlierPoints.png'
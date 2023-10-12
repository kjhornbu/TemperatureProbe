function [Temp_Reform] = Pulling_All_TemperatureLogs(Path)

log_files=dir(Path);

A=~cellfun(@isempty,regexpi({log_files.name},'9T'));
out_logs={log_files(A').name};

Temp_Reform=table;
Sensors={'E11709_00', 'E11686_00'}; %  The colon becomes an _ when imported. 

cnt=1;
offset_in_in=0;

    for n=1:sum(A)
        Temp = readtable(strcat(Path,'/',out_logs{n}));

        disp(strcat('Loading...',Path,'/',out_logs{n})); %Tell  us which sheet actively working on

        Temp(cellfun(@isnan,table2cell(Temp(:,2))),:)=[]; %remove bogus data in the sheet
        offset_out=size(Temp_Reform,1);

        % when possible would probably be good to convert the whole sheet
        try
            reset_dayname=datetime(Temp.Datetime);

                Temp_Reform.Date((1:size(Temp,1))+offset_out)=cellstr(datestr(reset_dayname(:),29));
                
                
                try
                    Temp_Reform.Time((1:size(Temp,1))+offset_out)=cellstr(datestr(reset_dayname(:),13));
                catch
                    Temp_Reform.Time((1:size(Temp,1))+offset_out)='00:00:00';
                end

                Temp_Reform.DateTime((1:size(Temp,1))+offset_out)=reset_dayname;

                Temp_Reform.File((1:size(Temp,1))+offset_out)=repmat(cellstr(strcat(Path,'/',out_logs{n})),size(Temp,1),1);

        catch %if we don't have a full DateTime and only have a time figure out the number of 24 hour iterations we have and rewrite the DateTime
            day=strsplit(out_logs{n},{'9T','_'});
            
            day_rolloveridx=find(diff(Temp.Time-Temp.Time(1))<duration(00,00,00)==1); %the little clock that tells you how many 24 hour cycles have passed.
            count=numel(day_rolloveridx);

            while count>0 %count down to determine the actual day lengths (the part day the log starts and the almost always 60*24+/-1 day intervals afterwards)
                try
                    length_day(count,1)=day_rolloveridx(count)-day_rolloveridx(count-1);
                catch
                    length_day(count,1)=day_rolloveridx(count);
                end
                count=count-1;
            end
            offset_in=0;
            Temp_Reform.File((1:size(Temp,1))+offset_out)=repmat(cellstr(strcat(Path,'/',out_logs{n})),size(Temp,1),1);
            for m=1:numel(day_rolloveridx)
                
                %actually incrementing thte day
                reset_dayname=datetime(strcat('20',day{2}(1:2),'-',day{2}(3:4),'-',day{2}(5:6)))+(Temp.Time((1:length_day(m))+offset_in)+(m-1)*duration(24,00,00));
                Temp_Reform.Date(((1:length_day(m))+offset_in)+offset_out)=cellstr(datestr(reset_dayname(:),29));
                
                try
                    Temp_Reform.Time(((1:length_day(m))+offset_in)+offset_out)=cellstr(datestr(reset_dayname(:),13));
                catch
                    Temp_Reform.Time(((1:length_day(m))+offset_in)+offset_out)='00:00:00';
                end

                Temp_Reform.DateTime(((1:length_day(m))+offset_in)+offset_out)=reset_dayname;

                %rolling over internal dataset offset index
                offset_in=day_rolloveridx(m);
            end
        end

        for m=1:2
            sensor_idx=strcmp(Temp.Properties.VariableNames,Sensors(1,m));
            Temp_Reform.(Sensors{1,m})((1:size(Temp,1))+offset_out)=table2array(Temp(:,sensor_idx));
        end
    end
end

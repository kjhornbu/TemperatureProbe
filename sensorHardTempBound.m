function [OUT,result] = sensorHardTempBound(Temp_Reform,OUT,Status,Temp)
sensor_idx=~(strcmp(Temp_Reform.Properties.VariableNames,{'DateTime'})|strcmp(Temp_Reform.Properties.VariableNames,{'Date'})|strcmp(Temp_Reform.Properties.VariableNames,{'Time'})|strcmp(Temp_Reform.Properties.VariableNames,{'File'}));
sensor_name=Temp_Reform.Properties.VariableNames(sensor_idx);

    for m=1:numel(sensor_name)
        OUT.(strcat(sensor_name{1,m},'greaterthan',num2str(Temp),'C_Temp'))=OUT.(sensor_name{1,m})>30;
        
        result.(strcat(sensor_name{1,m},'greaterthan',num2str(Temp),'C_Temp_Dates'))=unique(OUT.Date(OUT.(strcat(sensor_name{1,m},'greaterthan',num2str(Temp),'C_Temp'))),'Stable');
        result.(strcat(sensor_name{1,m},'greaterthan',num2str(Temp),'C_Temp_NumberOfDays'))=numel(unique(OUT.Date(OUT.(strcat(sensor_name{1,m},'greaterthan',num2str(Temp),'C_Temp'))),'Stable'));
        result.(strcat(sensor_name{1,m},'greaterthan',num2str(Temp),'C_Temp_TotalFoundScanDays'))=sum(Status);
    end

end
function [OUT,result] = sensorSDBound(Temp_Reform,OUT,Status,SD)
%Finding mean and standard deviation of data along with several important
%parameters

sensor_idx=~(strcmp(Temp_Reform.Properties.VariableNames,{'DateTime'})|strcmp(Temp_Reform.Properties.VariableNames,{'Date'})|strcmp(Temp_Reform.Properties.VariableNames,{'Time'})|strcmp(Temp_Reform.Properties.VariableNames,{'File'}));
sensor_name=Temp_Reform.Properties.VariableNames(sensor_idx);

SensorBound=table;
    for m=1:numel(sensor_name)
        
        SensorBound.(strcat(sensor_name{1,m},num2str(SD),'SD'))=mean(Temp_Reform.(sensor_name{1,m}),'omitnan')+SD*std(Temp_Reform.(sensor_name{1,m}),'omitnan');
        
        OUT.(strcat(sensor_name{1,m},num2str(SD),'SD_OverMeanTemp'))=OUT.(sensor_name{1,m})>SensorBound.(strcat(sensor_name{1,m},num2str(SD),'SD'));
        
        result.(strcat(sensor_name{1,m},num2str(SD),'SD_OverMeanTemp_Dates'))=unique(OUT.Date(OUT.(strcat(sensor_name{1,m},num2str(SD),'SD_OverMeanTemp'))),'Stable');
        result.(strcat(sensor_name{1,m},num2str(SD),'SD_OverMeanTemp_NumberOfDays'))=numel(unique(OUT.Date(OUT.(strcat(sensor_name{1,m},num2str(SD),'SD_OverMeanTemp'))),'Stable'));
        result.(strcat(sensor_name{1,m},num2str(SD),'SD_OverMeanTemp_TotalFoundScanDays'))=sum(Status);
        result.(strcat(sensor_name{1,m},'_MEAN_AllData'))=mean(Temp_Reform.(sensor_name{1,m}),'omitnan');
        result.(strcat(sensor_name{1,m},'_STDDEV_AllData'))=std(Temp_Reform.(sensor_name{1,m}),'omitnan');
        result.(strcat(sensor_name{1,m},'_MEAN_SelectData'))=mean(OUT.(sensor_name{1,m}),'omitnan');
        result.(strcat(sensor_name{1,m},'_STDDEV_SelectData'))=std(OUT.(sensor_name{1,m}),'omitnan');
    end

end
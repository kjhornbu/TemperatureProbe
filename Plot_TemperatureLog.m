function [] = Plot_TemperatureLog(Temp_Reform,Path,Name)

sensor_idx=~(strcmp(Temp_Reform.Properties.VariableNames,{'DateTime'})|strcmp(Temp_Reform.Properties.VariableNames,{'Date'})|strcmp(Temp_Reform.Properties.VariableNames,{'Time'})|strcmp(Temp_Reform.Properties.VariableNames,{'File'}));
sensor_name=Temp_Reform.Properties.VariableNames(sensor_idx);
BeginMonth=dateshift(Temp_Reform.DateTime(1),'start','month');
EndMonth=dateshift(Temp_Reform.DateTime(end),'end','month');

Month_PlotLabel=dateshift(Temp_Reform.DateTime,'start','month');

BeginDay=dateshift(Temp_Reform.DateTime,'start','day');
EndDay=dateshift(Temp_Reform.DateTime,'end','day');

BeginDay=unique(BeginDay);
EndDay=unique(EndDay);

for n=1:numel(sensor_name)
    figure;
    hold on
    plot(Temp_Reform.DateTime,Temp_Reform.(sensor_name{1,n}),'.')

    line([BeginMonth EndMonth]',[mean(Temp_Reform.(sensor_name{1,n}),'omitnan')+std(Temp_Reform.(sensor_name{1,n}),'omitnan') mean(Temp_Reform.(sensor_name{1,n}),'omitnan')+std(Temp_Reform.(sensor_name{1,n}),'omitnan')]','Color','g')

    line([BeginMonth EndMonth]',[mean(Temp_Reform.(sensor_name{1,n}),'omitnan')+2*std(Temp_Reform.(sensor_name{1,n}),'omitnan')  mean(Temp_Reform.(sensor_name{1,n}),'omitnan')+2*std(Temp_Reform.(sensor_name{1,n}),'omitnan')]','Color','y')
    
    line([BeginMonth EndMonth]',[30 30]','Color','r')

    
%     for m=1:numel(BeginDay)
%         line([BeginDay(m) BeginDay(m)],[28 32],'Color','r')
%         line([EndDay(m) EndDay(m)],[28 32],'Color','r')
%         %text(BeginDay(m),32,datestr(BeginDay(m),7))
%     end

    xlabel('Day')
    ylabel('Temperature \circ C')
    title('Temperature Monitor:',sensor_name{1,n})
    legend({'Temperature Data','Mean+SD of Selected Data','Mean+2SD of Selected Data','30\circC'},'Location','best');

    xlim([BeginMonth EndMonth])

    set(gca,'XTick',unique(Month_PlotLabel))

    grid on
    print('-dpng','-r1600',strcat(Path,'/Temperature Monitor_',sensor_name{1,n},'DataPoints_',Name,'.png'))
end 
end
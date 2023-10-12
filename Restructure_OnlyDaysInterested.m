function [OUT,Status] = Restructure_OnlyDaysInterested(Temp_Reform,Scan_Day)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Scan_Name=unique(Scan_Day,'Stable');

OUT=table;
offset=0;
for m=1:numel(Scan_Name)
    idx_keep=strcmp(Temp_Reform.Date,Scan_Day{m,1});
    Status(m,1)=logical(sum(idx_keep));
    OUT((1:sum(idx_keep))+offset,:)=Temp_Reform(idx_keep,:);

    offset=size(OUT,1);
end

end
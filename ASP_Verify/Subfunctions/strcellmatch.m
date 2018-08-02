function indFind = strcellmatch(strCell,str)
%l = length(strCell);
l = size(strCell,1);
%strFind = [];
indFind = [];
for i = 1:l,
    ind = strmatch(str,strCell(i,:),'exact');
     if ~isempty(ind),
        indFind = [indFind;i];
    end
end
function [D,tBlankOn,tMoveOn,tBlipOn,tBlipOff,tMoveOff,tPause] = sortASP(D)

%% Calculate timepoints
s = find(D{1}.paraTrial(4,:) ~=0,1);
tBlankOn = D{s}.tBlankStart-D{s}.tFixation;
tMoveOn = D{s}.tMoveStart - D{s}.tFixation;
tBlipOn = D{s}.tBlipStart-D{s}.tFixation;
tBlipOff = D{s}.tBlipStop-D{s}.tFixation;
tMoveOff = D{s}.tMoveStop - D{s}.tFixation;
tPause = D{s}.tPauseStart - D{s}.tFixation;


%% Automatic detection of saccades during blank- and blip-phase
answer1 = questdlg('Sort trials automatically?','Auto-Sort','Yes','No','No');
switch answer1
    
    case 'Yes'
        
        prompt = {'Max saccade length in blank period:','Max saccade length in blip period:'};
        dlg_title = 'Maximal Deviations';
        num_lines = 1;
        defaultans = {'50','5'};
        answer2 = num2cell(str2double(inputdlg(prompt,dlg_title,num_lines,defaultans)));
        [blankSacLimit,blipSacLimit] = deal(answer2{:});
        D{1}.sorting = zeros(4,length(D));
        
        for n = 1:length(D)
            if sum(D{n}.eyeXv((tBlankOn:tMoveOn)+D{1}.delay) ~= D{n}.eyeXvws((tBlankOn:tMoveOn)+D{1}.delay)) >= blankSacLimit
                D{1}.sorting(2,n) = 1;
                D{n}.goodBlank = 0;
            end
            if sum(D{n}.eyeXv(tBlipOn:tBlipOff+200) ~= D{n}.eyeXvws(tBlipOn:tBlipOff+200)) >= blipSacLimit
                D{1}.sorting(3,n) = 1;
                D{n}.goodBlip = 0;
            end
            if sum(D{1}.sorting(:,n)) ~= 0
                D{1}.sorting(1,n) = 1;
            end
        end
        
    case 'No'
end

%% Calculation of anticipatory pursuit velocity
answer1 = questdlg('Calculate anticipatory pursuit?','Estimate ASP','Yes','No','Yes');
switch answer1
    
    case 'Yes'
        for n = 1:length(D)
            D = findASP(D,n,tBlankOn,tMoveOn);
        end
    case 'No'
        
end
end
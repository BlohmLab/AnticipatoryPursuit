function C = dataCombine

origPath = 'D:\Master\Program\ASPAnalyze';
savePath = 'D:\Master\Data\03_Combined';
loadPath = 'D:\Master\Data\02_Loaded';

%load file into data
choice = questdlg('Which data file do you want to use?','New or existing','Create new file','Use existing file','Use existing file');
switch choice
    case 'Create new file'
        prompt = {'Output Name'};
        dlg_title = 'Input';
        num_lines = 1;
        defaultans = {''}; %# of sequences per direction
        inputcluster = inputdlg(prompt,dlg_title,num_lines,defaultans);
        outFilename = [inputcluster{1} '_Comb.mat'];
        newFile = 1;
        
    case 'Use existing file'
        cd(savePath);
        [oFilename,oPathname] = uigetfile({'*_Comb.mat'},'Choose existing Comb-file to load....');
        cd(oPathname);
        load([oPathname oFilename]);
        outFilename = oFilename;
        newFile = 0;
end

ongoing = 1;
while ongoing == 1
    
    cd(loadPath);
    [iFilename,iPathname] = uigetfile({'D.mat'},'Choose D.mat file to integrate....');
    cd(iPathname);
    load([iPathname iFilename]);
    
    if newFile == 1
        C.numBlocks = 1;
        C.paraTrials = ones(8,D{1}.numTrials)*NaN;
        C.tEvents = ones(8,D{1}.numTrials)*NaN;
        C.eyeX = ones(3001,D{1}.numTrials)*NaN;
        C.eyeXv = ones(3001,D{1}.numTrials)*NaN;
        C.eyeXvws = ones(3001,D{1}.numTrials)*NaN;
        C.eyeXa = ones(3001,D{1}.numTrials)*NaN;
        C.target_x = ones(175,D{1}.numTrials)*NaN;
        C.target_v = ones(175,D{1}.numTrials)*NaN;
        C.target_a = ones(175,D{1}.numTrials)*NaN;
        C.tTarget = ones(175,D{1}.numTrials)*NaN;
        C.detOn = ones(1,D{1}.numTrials)*NaN;
        C.SPon = ones(1,D{1}.numTrials)*NaN;
        C.ASPlot = ones(1,D{1}.numTrials)*NaN;
        C.realVOn = ones(1,D{1}.numTrials)*NaN;
        C.estVOn = ones(1,D{1}.numTrials)*NaN;
        C.numSacc = ones(1,D{1}.numTrials)*NaN;
        C.v_target(C.numBlocks) = D{1}.v_target;
        C.v_blip(C.numBlocks) = D{1}.v_blip;
        startPoint = 0;
    else
        C.numBlocks = C.numBlocks + 1;
        startPoint = length(C.paraTrials);
    end
    
    C.subjectID = D{1}.subjectID;
    C.paraTrials(1:4,(1:D{1}.numTrials)+startPoint) = D{1}.paraTrial;
    C.paraTrials(5,(1:D{1}.numTrials)+startPoint) = D{1}.blockNumber;
    C.paraTrials(6,(1:D{1}.numTrials)+startPoint) = D{1}.numProfile;
    
    
    for i = 1:D{1}.numTrials
        C.paraTrials(7,i+startPoint) = D{i}.goodBlank;
        C.paraTrials(8,i+startPoint) = D{i}.goodBlip;
        C.paraTrials(9,i+startPoint) = D{i}.exclude;
        C.tEvents(1,i+startPoint) = 0;
        C.tEvents(2,i+startPoint) = D{i}.tBlankStart - D{i}.tFixation;
        C.tEvents(3,i+startPoint) = D{i}.tMoveStart - D{i}.tFixation;
        if D{1}.paraTrial(4,i) ~= 0
            C.tEvents(4,i+startPoint) = D{i}.tBlipStart - D{i}.tFixation;
            C.tEvents(5,i+startPoint) = D{i}.tBlipStop - D{i}.tFixation;
        end
        C.tEvents(6,i+startPoint) = D{i}.tMoveStop - D{i}.tFixation;
        C.tEvents(7,i+startPoint) = D{i}.tPauseStart - D{i}.tFixation;
        C.tEvents(8,i+startPoint) = D{i}.tTrialEnd - D{i}.tFixation;
        C.eyeX(1:length(D{i}.eyeX),i+startPoint) = D{i}.eyeX';
        C.eyeXv(1:length(D{i}.eyeX),i+startPoint) = D{i}.eyeXv';
        C.eyeXvws(1:length(D{i}.eyeX),i+startPoint) = D{i}.eyeXvws';
        C.eyeXa(1:length(D{i}.eyeX),i+startPoint) = D{i}.eyeXa';
        C.target_x(1:length(D{i}.target_x),i+startPoint) = D{i}.target_x';
        C.target_v(1:length(D{i}.target_v),i+startPoint) = D{i}.target_v';
        C.target_a(1:length(D{i}.target_a),i+startPoint) = D{i}.target_a';
        C.tTarget(1:length(D{i}.tTarget),i+startPoint) = D{i}.tTarget';
        C.detOn(i+startPoint) = D{i}.detOn;
        C.SPon(i+startPoint) = D{i}.SPon;
        C.ASPlot(1:length(D{i}.ASPlot),i+startPoint) = D{i}.ASPlot;
        C.realVOn(i+startPoint) = D{i}.realVOn;
        C.estVOn(i+startPoint) = D{i}.estVOn;
        C.numSacc(i+startPoint) = D{i}.numSacc;
    end
    
    cd(savePath);
    save(outFilename,'C');
    
    choice = questdlg('Do you want to include more files?','Continue?','Include another file','Save and quit','Include another file');
    switch choice
        case 'Include another file'
            newFile = 0;
            loadPath = iPathname;
        case 'Save and quit'
            ongoing = 0;
            cd(origPath);
    end
end


end
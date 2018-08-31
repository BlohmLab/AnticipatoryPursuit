function C = dataCombine

origPath = 'D:\Felix\Program\ASP_Analyze';
savePath = 'D:\Felix\Data\03_Combined';
loadPath = 'D:\Felix\Data\02_Loaded';

%% load or create file
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

%% fill combine_file with data from loaded file
ongoing = 1;
while ongoing == 1
    
    cd(loadPath);
    [iFilename,iPathname] = uigetfile({'D.mat'},'Choose D.mat file to integrate....');
    cd(iPathname);
    load([iPathname iFilename]);
    
    if newFile == 1
        C.subjectID = NaN;
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
%         C.maxVOn = ones(1,D{1}.numTrials)*NaN;
        C.estVOn = ones(1,D{1}.numTrials)*NaN;
        C.numSacc = ones(1,D{1}.numTrials)*NaN;
        C.v_target(C.numBlocks) = D{1}.v_target;
        C.v_blip(C.numBlocks) = D{1}.v_blip;
        startPoint = 0;
    else
        C.numBlocks = C.numBlocks + 1;
        startPoint = length(C.paraTrials);
    end
    
    % Declare which type of stimulation was used during the block
    answer = questdlg('Which stimulation type was used?','Stimulation','An','Cat','Ctr','Ctr');
    switch answer
        case 'An'
            stimType = 1;
        case 'Cat'
            stimType = 2;
        case 'Ctr'
            stimType = 3;
    end
    
    C.paraTrials(1:4,(1:D{1}.numTrials)+startPoint) = D{1}.paraTrial;
    C.paraTrials(5,(1:D{1}.numTrials)+startPoint) = D{1}.blockNumber;
    C.paraTrials(6,(1:D{1}.numTrials)+startPoint) = D{1}.numProfile;
    
    %% Single trial data
    for i = 1:D{1}.numTrials
        C.paraTrials(7,i+startPoint) = D{i}.goodBlank;
        C.paraTrials(8,i+startPoint) = D{i}.goodBlip;
        C.paraTrials(9,i+startPoint) = D{i}.exclude;
        C.paraTrials(10,i+startPoint) = D{1}.subjectID; %Subject ID
        C.paraTrials(11,i+startPoint) = stimType; %Stimulation type: 1 - Anodal / 2 - Cathodal / 3 - None                
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
        timecut = length(D{i}.eyeX);
        if timecut >= 3002, timecut = 3001; end % Avoids problems through single, overly long trial
        C.eyeX(1:timecut,i+startPoint) = D{i}.eyeX(1:timecut)';
        C.eyeXv(1:timecut,i+startPoint) = D{i}.eyeXv(1:timecut)';
        C.eyeXvws(1:timecut,i+startPoint) = D{i}.eyeXvws(1:timecut)';
        C.eyeXa(1:timecut,i+startPoint) = D{i}.eyeXa(1:timecut)';
        C.target_x(1:length(D{i}.target_x),i+startPoint) = D{i}.target_x';
        C.target_v(1:length(D{i}.target_v),i+startPoint) = D{i}.target_v';
        C.target_a(1:length(D{i}.target_a),i+startPoint) = D{i}.target_a';
        C.tTarget(1:length(D{i}.tTarget),i+startPoint) = D{i}.tTarget';
        C.detOn(i+startPoint) = D{i}.detOn;
        C.SPon(i+startPoint) = D{i}.SPon;
        C.ASPlot(1:length(D{i}.ASPlot),i+startPoint) = D{i}.ASPlot;
        C.realVOn(i+startPoint) = D{i}.realVOn;
%         C.maxVOn(i+startPoint) = D{i}.maxVOn;
        C.estVOn(i+startPoint) = D{i}.estVOn;
        C.numSacc(i+startPoint) = D{i}.numSacc;
    end
    
    cd(savePath);
    save(outFilename,'C');
    
    
    %% Load further files or save and quit
    choice = questdlg('Do you want to include more files?','Continue?','Include another file','Save and quit','Include another file');
    switch choice
        case 'Include another file'
            newFile = 0;
            loadPath = iPathname;
            
        case 'Save and quit'
            %SubjectID
            if range(C.paraTrials(10,:))==0
                C.subjectID = C.paraTrials(10,1);
            else
                C.subjectID = 99; % Mixed subjects
            end
            
            % Define all trial positions
            smallDr = [1;1]; % small NiDr counter - resets every block
            bigDr = [1;1];   %   big NiDr counter - resets every session
            for t = 1:length(C.paraTrials(1,:))
                if t == 1 || C.paraTrials(10,t)~=C.paraTrials(10,t-1)  || C.paraTrials(11,t)~=C.paraTrials(11,t-1) % New session
                    smallDr = [1;1];% reset small trial counter - new with every block
                    bigDr = [1;1]; % reset big trial counter - new with every session
                    C.prevTrial(t,1) = 0; C.prevTrial(t,2) = 0; % First trial = 1|1
                elseif C.paraTrials(5,t)-C.paraTrials(5,t-1) ~= 0 % New block
                    smallDr = [1;1]; % reset counter
                    C.prevTrial(t,1) = 0; C.prevTrial(t,2) = 0; % First trial = 1|1
                else
                    C.prevTrial(t,1) = C.paraTrials(1,t-1); % Set previous Dr
                    C.prevTrial(t,2) = C.paraTrials(2,t-1); % Set previous PiS
                end
                    C.trialPiDr(t,1) = smallDr(C.paraTrials(1,t));
                    C.trialPiDr(t,2) = bigDr(C.paraTrials(1,t));
                    smallDr(C.paraTrials(1,t)) = smallDr(C.paraTrials(1,t))+1; % increase small counter
                    bigDr(C.paraTrials(1,t)) = bigDr(C.paraTrials(1,t))+1; % increase big counter
            end
            
            
            % Save and quit
            cd(savePath);
            save(outFilename,'C');
            ongoing = 0;
            cd(origPath);
    end
end
end
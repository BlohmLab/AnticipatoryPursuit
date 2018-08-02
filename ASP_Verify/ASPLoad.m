%% Load and combine .mat and .edf file into single file
function [D,pathname1,firstload,loadPath] = ASPLoad(loadPath)

try
    origPath = 'D:\Master\Program\ASPVerify';
    savePath = 'D:\Master\Data\02_Loaded';
    cd(loadPath);
    [filename1,pathname1] = uigetfile({'*.mat'},'Choose XP record file you want to load....'); %load in mat-file = Trial parameters
    cd(pathname1);
    loadPath = pathname1;
    load([pathname1 filename1]);
    firstload = 0;
    
    %%  -   Check if loading a raw or pre-loaded data file
    if exist ('D','var') == 0
        firstload = 1;
        [filename2,pathname2] = uigetfile({'*.edf'},'Choose Eyelink edf file you want to load....'); %load in edf-file = EyeLink
        %      [filename3,pathname3,filterIndex] = uigetfile({'record-*.csv'},'Choose EEG record file you want to load....'); %load in EEG file (.csv)
        %      if filterIndex == 1
        %          D{1}.eegData = csvread([pathname3 '\' filename3], 2);
        %          D{1}.eegData(1,22) = 512;
        %          D{1}.eegFilename = filename3;
        %      end
        cd(origPath);
        try
            [X.sampledata,X.eventdata,X.mestimes,X.messages,X.preamble,X.samplerate,X.numtrials,X.button,X.input]=el2matInputEvent([pathname2 filename2],'fixation','trialEnd');%change eyelink- to mat-file
        catch
            warning(['Error processing file: ' filename2]);
            D=[];
            cd(origPath);
            clear all;
            return
        end
        %%  -   Get eyelink messages and offset times
        s = {'fixation','blankStart','moveStart','blipStart','blipStop','moveStop','pauseStart','trialEnd'};
        [tFixation, mesFixation]=getELmes(X, s{1});
        [tBlankStart, mesBlankStart]=getELmes(X, s{2});
        [tMoveStart, mesMoveStart]=getELmes(X, s{3});
        [tBlipStart, mesBlipStart]=getELmes(X, s{4});
        [tBlipStop, mesBlipStop]=getELmes(X, s{5});
        [tMoveStop, mesMoveStop]=getELmes(X, s{6});
        [tPauseStart, mesPauseStart]=getELmes(X, s{7});
        [tTrialEnd, mesTrialEnd]=getELmes(X, s{8});
        
        cd(origPath);
        
        %%  -   Construct collective file 'D'
        
        % Parameters from  .mat-file
        D{1}.dFilename = [filename2(1:end-4) 'D.mat']; % General filename
        D{1}.xpFilename = filename1;	% Mat filename
        D{1}.edfFilename = filename2;	% Edf filename
        D{1}.subjectID = subjectID;
        D{1}.blockNumber = blockNumber;
        D{1}.numProfile = numProfile;
        D{1}.numTrials = numTrials;
        D{1}.numBlips = numBlips;
        D{1}.distToScreen =  distToScreen;
        D{1}.wideScreen = wideScreen;
        D{1}.heightScreen = heightScreen;
        D{1}.scrWidth = windowRect(3);
        D{1}.scrHeight = windowRect(4);
        D{1}.centerWidth = centerWidth;
        D{1}.centerHeight = centerHeight;
        D{1}.windowRect = windowRect; % ??? redundant ???
        D{1}.ppcmx = ppcmx;
        D{1}.ppcmy = ppcmy;
        D{1}.ppdr = sqrt(D{1}.ppcmx*D{1}.ppcmx+D{1}.ppcmy*D{1}.ppcmy);
        D{1}.frameRate = frameRate;
        D{1}.diamDot = diamDot;
        D{1}.radCross = radCross;
        D{1}.flipInterval =  flipInterval;
        D{1}.nDr = nDr;
        D{1}.v_target = v;
        D{1}.v_blip = v2;
        D{1}.durFix = durFixs; %ms
        D{1}.durBlank = durBlank;
        D{1}.durMove = durMove; %ms
        D{1}.durBlip = durBlip; %ms
        D{1}.durStop = durStop; %ms
        D{1}.durPause = durPause; %ms
        D{1}.paraTrial = paraTrial; %parameters of all Trials
        D{1}.paraSeq = paraSeq;
        D{1}.blipCount = blipCount;
        D{1}.nFrames = nFrames;
        if ~isempty(delay)
            D{1}.delay = delay;
        end
        
        % Parameters from Eyelink file
        D{1}.EFIX = 8;
        D{1}.ESACC=6;
        D{1}.EBLINK=4;
        D{1}.MESSAGEEVENT = 24;
        D{1}.BUTTONEVENT = 25;
        D{1}.INPUTEVENT = 28;
        D{1}.message = s ;
        D{1}.cutoff = 50; % cut-off frequency for filter
        D{1}.sfr1 = 1000; % sampling frequency
        D{1}.win = 0.005; % time window (1/2 width) for differentiation
        
        [iBlank, iBlip] = deal(1);
        
        for iTrial = 1: D{1}.numTrials
            % parameter from .mat-file
            D{iTrial}.tScreen = vbl(iTrial,:); % 6 columns
            D{iTrial}.target_x = squeeze(target(iTrial,1,:)); % target movement data
            D{iTrial}.target_v = squeeze(target(iTrial,2,:));
            D{iTrial}.target_a = squeeze(target(iTrial,3,:));
            
            % eyelink data
            D{iTrial}.tFixation = tFixation(iTrial);
            if paraTrial(3,iTrial) == 1
                D{iTrial}.tBlankStart = tBlankStart(iBlank);
                iBlank = iBlank+1;
            else
                D{iTrial}.tBlankStart = NaN;
            end
            D{iTrial}.tMoveStart = tMoveStart(iTrial);
            if paraTrial(4,iTrial) ~= 0
                D{iTrial}.tBlipStart = tBlipStart(iBlip);
                D{iTrial}.tBlipStop = tBlipStop(iBlip);
                iBlip = iBlip+1;
            else
                D{iTrial}.tBlipStart = NaN;
                D{iTrial}.tBlipStop = NaN;
            end
            D{iTrial}.tMoveStop = tMoveStop(iTrial);
            D{iTrial}.tPauseStart = tPauseStart(iTrial);
            D{iTrial}.tTrialEnd = tTrialEnd(iTrial);
            
            indBegin = find(X.sampledata(1,:) >= tFixation(iTrial),1);
            
            if iTrial == D{1}.numTrials
                D{iTrial}.eyeX = rad2deg(atan((X.sampledata(2,indBegin:end)-D{1}.centerWidth)/D{1}.distToScreen/D{1}.ppcmx));% x-position eye (degree)
                D{iTrial}.eyeY = rad2deg(atan((X.sampledata(3,indBegin:end)-D{1}.centerHeight)/D{1}.distToScreen/D{1}.ppcmy)); % y-position eye (degree)
            else
                indEnd = find(X.sampledata(1,:) >= tFixation(iTrial+1),1)-1;
                D{iTrial}.eyeX = rad2deg(atan((X.sampledata(2,indBegin:indEnd)-D{1}.centerWidth)/D{1}.distToScreen/D{1}.ppcmx));% x-position eye (degree)
                D{iTrial}.eyeY = rad2deg(atan((X.sampledata(3,indBegin:indEnd)-D{1}.centerHeight)/D{1}.distToScreen/D{1}.ppcmy)); % y-position eye (degree)
            end
            
            D{iTrial}.t = (0:length(D{iTrial}.eyeX)-1)/D{1}.sfr1*1000;% construct timepoints in miliseconds
            
            %for eventdata
            indEvt = (X.eventdata(1,:) >= tFixation(iTrial))& (X.eventdata(1,:)<tFixation(iTrial)+D{iTrial}.t(end));
            if ~isempty(indEvt)
                D{iTrial}.eventdata = X.eventdata(:,indEvt);
            end
            
            % set up other parameters
            D{iTrial}.goodBlank = 1;
            D{iTrial}.goodBlip = 1;
            D{iTrial}.exclude = 0;
            D{iTrial}.antic = 0;
            D{iTrial}.TF = (D{iTrial}.tTrialEnd-D{iTrial}.tFixation)/D{1}.nFrames(iTrial);
            D{iTrial}.tTarget = [1:D{1}.nFrames(iTrial)]*D{iTrial}.TF;
            
        end
        
        %%  -   Filter signals & differentiate
        for iTrial = 1:numTrials
            
            D{iTrial}.eyeX = autoregfiltinpart(D{1}.sfr1,D{1}.cutoff,D{iTrial}.eyeX);
            D{iTrial}.eyeY = autoregfiltinpart(D{1}.sfr1,D{1}.cutoff,D{iTrial}.eyeY);
            
            D{iTrial}.eyeXv = aiDiff(1/D{1}.sfr1,D{1}.win,D{iTrial}.eyeX);
            D{iTrial}.eyeYv = aiDiff(1/D{1}.sfr1,D{1}.win,D{iTrial}.eyeY);
            D{iTrial}.eyeVv = sqrt(D{iTrial}.eyeXv.^2 + D{iTrial}.eyeYv.^2);
            
            D{iTrial}.eyeXa = aiDiff(1/D{1}.sfr1,D{1}.win,D{iTrial}.eyeXv);
            D{iTrial}.eyeYa = aiDiff(1/D{1}.sfr1,D{1}.win,D{iTrial}.eyeYv);
            D{iTrial}.eyeVa = sqrt(D{iTrial}.eyeXa.^2 + D{iTrial}.eyeYa.^2);
            
        end
        
        %%  -   Calculate saccade-free velocity traces for X, Y, Total(V)
        for iTrial = 1:numTrials
            [D{iTrial}.numSacc, D{iTrial}.sacc, D{iTrial}.eyeXvws, D{iTrial}.eyeYvws, D{iTrial}.eyeVvws] = detectSaccades2(D,iTrial);
        end
        cd(savePath);
        save([filename2(1:end-4) 'D.mat'],'D');
        cd(origPath);
    else
        cd(origPath);
    end
catch
    cd(origPath);
    clear all;
end
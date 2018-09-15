function [E] = ASP_Extract(C,filename1,origPath)

%% Creates data file E with all relevant parameters for each experiment
E = [];
E.name = filename1(1:end-4);
E.subjectID = C.subjectID;
E.numBlocks = C.numBlocks;
E.numTrials = length(C.paraTrials(1,:));
E.v_target = C.v_target;
E.vmax_blip = C.v_blip;
E.tEvents = [0;765;1049;1399;1599;1965;2416;2916];

%% Name the file
prompt = {'Name for extracted file?'};
dlg_title = 'Namet';
num_lines = 1;
defaultans = {''}; %# of sequences per direction
inputcluster = inputdlg(prompt,dlg_title,num_lines,defaultans);
ename = ['Sub' num2str(E.subjectID) '_' inputcluster{1}];
ename2 = [ename '_Corrected'];

%% Basic task parameters
%  Extract from paraTrials
E.spec.trialDr = C.paraTrials(1,:)'; % Direction the target moved to | 1: Leftwards | 2: Rightwards
E.spec.trialPiS = C.paraTrials(2,:)'; % Number in (direction) sequence
E.spec.trialBlip = C.paraTrials(4,:)'; % -1: De/In-Blip | 0: Zero-Blip | 1: In/De-Blip
E.spec.blockNr = C.paraTrials(5,:)'; % Number of block the trial is in
E.spec.goodBlank = C.paraTrials(7,:)'; % No (relevant) saccade in 'blank' period
E.spec.goodBlip = C.paraTrials(8,:)'; % No (relevant) saccade in 'blip'-period + 100 ms afterwards
E.spec.exclude = zeros(E.numTrials,1)'; % Has the trial to be excluded completely?

% If previously evaluated, exclude the marked trials. 
% Otherwise exclude all trials where both blank and blip phase includes saccades
if length(C.paraTrials(:,1)) == 11
    E.spec.exclude = C.paraTrials(9,:)';
else
    for t = 1:E.numTrials
        if E.spec.goodBlank(t) == 0 && E.spec.goodBlip(t) == 0 % Exclude trials where neither is good
            E.spec.exclude(t) = 1;
        end
    end
end

E.spec.prevTrial = C.prevTrial; % Data from previous trial ~> 1: Which Dr | 2: Which PiS? ~> sets expectation
E.spec.trialPiDr = C.trialPiDr; % How much trials did already go in same dr? | 1: This block | 2: Overall

% Define hexablocks for each trial and in total
E.spec.HB = ones(E.numTrials,1)*NaN;
for hb = 1:3
    E.spec.HB(E.spec.blockNr >= 6*hb-5 & E.spec.blockNr <= 6*hb,1) = hb;
end

% Define stimulation and subject for group level analysis
E.spec.stimType = C.paraTrials(11,:)'; % Which type of stimulation was used? | 1: Anodal | 2: Cathodal | 3: None
E.spec.subject = C.paraTrials(10,:)';

% Define 'apTrials': All trials which are NOT the first in a new block
apTrials =ones(E.numTrials/2,1);
for a = 1:E.numBlocks/2
    apTrials(28*a-27) = 0;
end

% Define if single-session or multi-session analysis
if range(E.spec.subject(:,1)) == 0 && range(E.spec.stimType(:,1)) == 0
    multiSession = 0;
else
    multiSession = 1;
end
% multiSession = 0;
corrected = 0;

%% Percentages
E.P_evASP = [];% Calculate percentage of trials with estimated ASP
E.P_exclude = []; % Calculate percentage of trials with had to be discarded
for e = 1:(E.numBlocks*56/1008)
    E.P_exclude(e,1) = sum(E.spec.exclude(1008*e-1007:1008*e));
    E.P_exclude(e,2) = E.P_exclude(e,1)/1008*100;
end

%% Single-Trial results
E.rv_ASP = C.realVOn';% deg/s | real velocity of anticipatory smooth pursuit at 400 ms post-blank
E.ev_ASP = C.estVOn';% deg/s  | estimated velocity of ASP at 400 ms, based on linear fit
E.on_ASP = C.detOn';%  ms     | estimated onset of ASP, based on linear fitASP velocity & detected onset
E.saccades(1:E.numTrials,1) = C.numSacc; % number of saccades in the blank & move part of each trial
%E.durSacc % duration of (all?) catch-up saccades

%% Define categories
E.total = struct;
E.pre = struct;
E.stim = struct;
E.post = struct;

%% Calculate mean & SD of velocities and trial counts for single-session files
E.total.AV_rv_ASP = ones(6,4,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.total.SD_rv_ASP = ones(6,4,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
E.total.AV_ev_ASP = ones(6,4,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.total.SD_ev_ASP = ones(6,4,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
E.total.AV_on_ASP = ones(6,4,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.total.SD_on_ASP = ones(6,4,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
E.total.AV_sa_ASP = ones(6,4,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.total.SD_sa_ASP = ones(6,4,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
c_ev_good = ones(6,4,2)*NaN; % Number of all trials with estimated ASP | pPiS x hexablock x pDR
c_ev_total = ones(6,4,2)*NaN;% Number of all trials | pPiS x hexablock x pDR
c_on_good = ones(6,4,2)*NaN; % Number of all trials with estimated ASP | pPiS x hexablock x pDR
c_on_total = ones(6,4,2)*NaN;% Number of all trials | pPiS x hexablock x pDR

for d = 1:2 % Two directions
    E.total.AV_rv_ASP(1,1,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    E.total.SD_rv_ASP(1,1,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    E.total.AV_ev_ASP(1,1,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    E.total.SD_ev_ASP(1,1,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    E.total.AV_on_ASP(1,1,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    E.total.SD_on_ASP(1,1,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    E.total.AV_sa_ASP(1,1,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d));
    E.total.SD_sa_ASP(1,1,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d));
    c_ev_good(1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d)));
    c_ev_total(1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    c_on_good(1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d)));
    c_on_total(1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    for k = 1:5
        E.total.AV_rv_ASP(k+1,1,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        E.total.SD_rv_ASP(k+1,1,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        E.total.AV_ev_ASP(k+1,1,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        E.total.SD_ev_ASP(k+1,1,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        E.total.AV_on_ASP(k+1,1,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        E.total.SD_on_ASP(k+1,1,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        E.total.AV_sa_ASP(k+1,1,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialPiS==k));
        E.total.SD_sa_ASP(k+1,1,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialPiS==k));
        c_ev_good(k+1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k)));
        c_ev_total(k+1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        c_on_good(k+1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k)));
        c_on_total(k+1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
    end
    for hexa = 1:3 % Three hexablocks
        % Average values & standard deviation
        E.total.AV_rv_ASP(1,hexa+1,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_rv_ASP(1,hexa+1,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.AV_ev_ASP(1,hexa+1,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_ev_ASP(1,hexa+1,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.AV_on_ASP(1,hexa+1,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_on_ASP(1,hexa+1,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.AV_sa_ASP(1,hexa+1,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==hexa));
        E.total.SD_sa_ASP(1,hexa+1,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==hexa));
        % Trial counter
        c_ev_good(1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa)));
        c_ev_total(1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        c_on_good(1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa)));
        c_on_total(1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        for k = 1:5 % Six conditions
            E.total.AV_rv_ASP(k+1,hexa+1,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_rv_ASP(k+1,hexa+1,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.AV_ev_ASP(k+1,hexa+1,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_ev_ASP(k+1,hexa+1,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.AV_on_ASP(k+1,hexa+1,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_on_ASP(k+1,hexa+1,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.AV_sa_ASP(k+1,hexa+1,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialPiS==k & E.spec.HB==hexa));
            E.total.SD_sa_ASP(k+1,hexa+1,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialPiS==k & E.spec.HB==hexa));
            % Trial counter
            c_ev_good(k+1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa)));
            c_ev_total(k+1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            c_on_good(k+1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa)));
            c_on_total(k+1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
        end
        rel_ev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa); % Find estimated ASP matching all criteria
        E.total.N_ev_ASP(1,hexa,d) = sum(~isnan(rel_ev_ASP))/length(rel_ev_ASP);
        for k = 1:5
            rel_ev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa & E.spec.prevTrial(:,2)==k); % One additional criterium: pPiS
            E.total.N_ev_ASP(k+1,hexa,d) = sum(~isnan(rel_ev_ASP))/length(rel_ev_ASP);
        end
    end
end

E.P_evASP = c_ev_good(:,:,:)./c_ev_total(:,:,:)*100;
E.P_onASP = c_on_good(:,:,:)./c_on_total(:,:,:)*100;

%% Calculate mean & SD of velocities for multi-session files
if multiSession == 1
    AV_rv_ASP = ones(6,2,2,3)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x Dr
    SD_rv_ASP = ones(6,2,2,3)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x Dr
    AV_ev_ASP = ones(6,2,2,3)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x Dr
    SD_ev_ASP = ones(6,2,2,3);% deg/s | SD of real ASP velocity | pPiS x hexablock x Dr
    AV_on_ASP = ones(6,2,2,3)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x Dr
    SD_on_ASP = ones(6,2,2,3);% deg/s | SD of real ASP velocity | pPiS x hexablock x Dr
    AV_sa_ASP = ones(6,2,2,3)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x Dr
    SD_sa_ASP = ones(6,2,2,3);% deg/s | SD of real ASP velocity | pPiS x hexablock x Dr
    
    for HB = 1:3
        for d = 1:2 % Two directions
            for stim = 1:2 % Stimulation types
                AV_rv_ASP(1,stim,d,HB) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                SD_rv_ASP(1,stim,d,HB) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                AV_ev_ASP(1,stim,d,HB) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                SD_ev_ASP(1,stim,d,HB) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                AV_on_ASP(1,stim,d,HB) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                SD_on_ASP(1,stim,d,HB) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                AV_sa_ASP(1,stim,d,HB) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB & E.spec.stimType==stim));
                SD_sa_ASP(1,stim,d,HB) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB & E.spec.stimType==stim));
                for k = 1:5 % Six conditions
                    AV_rv_ASP(k+1,stim,d,HB) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_rv_ASP(k+1,stim,d,HB) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    AV_ev_ASP(k+1,stim,d,HB) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_ev_ASP(k+1,stim,d,HB) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    AV_on_ASP(k+1,stim,d,HB) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_on_ASP(k+1,stim,d,HB) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    AV_sa_ASP(k+1,stim,d,HB) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialPiS==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_sa_ASP(k+1,stim,d,HB) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialPiS==k & E.spec.HB==HB & E.spec.stimType==stim));
                end
            end
        end
    end
    
% Copy averages into three files, one for each hexablock
E.pre.AV_RV = AV_rv_ASP(:,:,:,1); E.pre.SD_RV = SD_rv_ASP(:,:,:,1); E.pre.AV_EV = AV_ev_ASP(:,:,:,1); E.pre.SD_EV = SD_ev_ASP(:,:,:,1); E.pre.AV_ON = AV_on_ASP(:,:,:,1); E.pre.SD_ON = SD_on_ASP(:,:,:,1); E.pre.AV_SA = AV_sa_ASP(:,:,:,1); E.pre.SD_SA = SD_sa_ASP(:,:,:,1);
E.stim.AV_RV = AV_rv_ASP(:,:,:,2); E.stim.SD_RV = SD_rv_ASP(:,:,:,2); E.stim.AV_EV = AV_ev_ASP(:,:,:,2); E.stim.SD_EV = SD_ev_ASP(:,:,:,2); E.stim.AV_ON = AV_on_ASP(:,:,:,2); E.stim.SD_ON = SD_on_ASP(:,:,:,2); E.stim.AV_SA = AV_sa_ASP(:,:,:,2); E.stim.SD_SA = SD_sa_ASP(:,:,:,2);
E.post.AV_RV = AV_rv_ASP(:,:,:,3); E.post.SD_RV = SD_rv_ASP(:,:,:,3); E.post.AV_EV = AV_ev_ASP(:,:,:,3); E.post.SD_EV = SD_ev_ASP(:,:,:,3); E.post.AV_ON = AV_on_ASP(:,:,:,3); E.post.SD_ON = SD_on_ASP(:,:,:,3); E.post.AV_SA = AV_sa_ASP(:,:,:,3); E.post.SD_SA = SD_sa_ASP(:,:,:,3);
end

%% Calculate mean & SD of entire trial (-150 pre-blank ~> 250 ms post-stop) for single session
E.AV.s_avtl_trial = ones(1600,5,6,2)*NaN; % Average timeline of rv_ASP | timepoints | hexablock (1:all | 5:diff) | PiS | Dr
E.AV.s_sdtl_trial = ones(1600,5,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:1599
    for Dr = 1:2
        % Average of direction
        E.AV.s_avtl_trial(i+1,1,1,Dr)= nanmean(C.eyeXv(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialDr==Dr));
        E.AV.s_sdtl_trial(i+1,1,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialDr==Dr));
        for hb = 1:3
            % Specific for hexablock
            E.AV.s_avtl_trial(i+1,hb+1,1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialDr==Dr));
            E.AV.s_sdtl_trial(i+1,hb+1,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialDr==Dr));
            for PiS = 1:5
                % Specific for PiS x hexablock
                E.AV.s_avtl_trial(i+1,hb+1,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
                E.AV.s_sdtl_trial(i+1,hb+1,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
            end
        end
        % Specific for PiS
        for PiS = 1:5
            E.AV.s_avtl_trial(i+1,1,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
            E.AV.s_sdtl_trial(i+1,1,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
        end
    end
end
E.AV.s_avtl_trial(:,5,:,:)= E.AV.s_avtl_trial(:,3,:,:) - E.AV.s_avtl_trial(:,2,:,:); % Calculate difference of velocities per condition | (Stim - NoStim)

%% Calculate mean & SD of entire trial (-150 pre-blank ~> 250 ms post-stop) for multi-session
E.AV.m_avtl_trial = ones(1600,3,6,2,3)*NaN; % Average timeline of rv_ASP | timepoints | stim (1:an | 2:cat) | PiS | Dr | HB
E.AV.m_sdtl_trial = ones(1600,3,6,2,3)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:1599
    for HB = 1:3
        for Dr = 1:2
            for stim = 1:2
                % Specific for hexablock
                E.AV.m_avtl_trial(i+1,stim,1,Dr,HB)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.trialDr==Dr));
                E.AV.m_sdtl_trial(i+1,stim,1,Dr,HB)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.trialDr==Dr));
                for PiS = 1:5
                    % Specific for pPiS x hexablock
                    E.AV.m_avtl_trial(i+1,stim,PiS+1,Dr,HB)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.trialPiS==PiS & E.spec.stimType==stim & E.spec.trialDr==Dr));
                    E.AV.m_sdtl_trial(i+1,stim,PiS+1,Dr,HB)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.trialPiS==PiS & E.spec.stimType==stim & E.spec.trialDr==Dr));
                end
            end
        end
    end
end
E.AV.m_avtl_trial(:,3,:,:,:)= E.AV.m_avtl_trial(:,2,:,:,:) - E.AV.m_avtl_trial(:,1,:,:,:); % Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Calculate mean & SD of blank reaction period for single session
E.AV.s_avtl_blank = ones(600,5,6,2)*NaN; % Average timeline of rv_ASP | timepoints | hexablock (1:all | 5:diff) | pPiS | pDr
E.AV.s_sdtl_blank = ones(600,5,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:599
    for pDr = 1:2
        % Average of previous direction
        E.AV.s_avtl_blank(i+1,1,1,pDr)= nanmean(C.eyeXv(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr));
        E.AV.s_sdtl_blank(i+1,1,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr));
        for hb = 1:3
            % Specific for hexablock
            E.AV.s_avtl_blank(i+1,hb+1,1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,1)==pDr));
            E.AV.s_sdtl_blank(i+1,hb+1,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,1)==pDr));
            for pPiS = 1:5
                % Specific for pPiS x hexablock
                E.AV.s_avtl_blank(i+1,hb+1,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
                E.AV.s_sdtl_blank(i+1,hb+1,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
            end
        end
        % Specific for pPiS
        for pPiS = 1:5
        E.AV.s_avtl_blank(i+1,1,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
        E.AV.s_sdtl_blank(i+1,1,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
        end
    end
end
E.AV.s_avtl_blank(:,5,:,:)= E.AV.s_avtl_blank(:,3,:,:) - E.AV.s_avtl_blank(:,2,:,:); % Calculate difference of velocities per condition | (Stim - NoStim)

%% Calculate average traces of blank period for multi-session
E.AV.m_avtl_blank = ones(600,3,6,2,2)*NaN; % Average timeline of rv_ASP | timepoints | stim (1:an | 2:cat) | pPiS | pDr
E.AV.m_sdtl_blank = ones(600,3,6,2,2)*NaN; % Standard deviation timeline of rv_ASP
E.HB1_stable_blank = ones(600,3,6,4,2)*NaN;

for i = 0:599
    for HB = 1:3
        for pDr = 1:2
            for stim = 1:2
                % Specific for hexablock
                E.AV.m_avtl_blank(i+1,stim,1,pDr,HB)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                E.AV.m_sdtl_blank(i+1,stim,1,pDr,HB)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                E.HB1_stable_blank(i+1,stim,1,4,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==1 & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                for doubleblock = 1:3
                    E.HB1_stable_blank(i+1,stim,1,doubleblock,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & round(E.spec.blockNr/2)==doubleblock  & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                end
                for pPiS = 1:5
                    % Specific for pPiS x hexablock
                    E.AV.m_avtl_blank(i+1,stim,pPiS+1,pDr,HB)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                    E.AV.m_sdtl_blank(i+1,stim,pPiS+1,pDr,HB)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                    E.HB1_stable_blank(i+1,stim,pPiS+1,4,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==1 & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                    for doubleblock = 1:3
                        E.HB1_stable_blank(i+1,stim,pPiS+1,doubleblock,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & round(E.spec.blockNr/2)==doubleblock & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                    end
                end
            end
        end
    end
end
E.HB1_stable_blank(:,3,:,:,:) = E.HB1_stable_blank(:,2,:,:,:)-E.HB1_stable_blank(:,1,:,:,:);% Calculate difference of velocities per condition | (Cathodal - Anodal)
E.AV.m_avtl_blank(:,3,:,:,:)= E.AV.m_avtl_blank(:,2,:,:,:) - E.AV.m_avtl_blank(:,1,:,:,:); % Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Calculate average trace of blip reaction period for single session
E.AV.s_avtl_blip = ones(400,4,5,2)*NaN; % Complete v_mean of each time point of the blip period | timepoints / hexablocks (1:all) / conditions / direction
E.AV.s_sdtl_blip = ones(400,4,4,2)*NaN; % STD of v_mean of each time point of the blip period

for i = 1:400
    for d = 1:2
        E.AV.s_avtl_blip(i,1,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d));
        E.AV.s_sdtl_blip(i,1,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d));
        for hexa = 1:3
            E.AV.s_avtl_blip(i,hexa+1,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==hexa));
            E.AV.s_sdtl_blip(i,hexa+1,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==hexa));
        end
        for b = 1:3
           E.AV.s_avtl_blip(i,1,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2));
           E.AV.s_sdtl_blip(i,1,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2));
           for hexa = 1:3
               E.AV.s_avtl_blip(i,hexa+1,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==hexa));
               E.AV.s_sdtl_blip(i,hexa+1,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==hexa));
           end
        end
    end
end
E.AV.s_avtl_blip(:,:,5,:)= E.AV.s_avtl_blip(:,:,4,:) - E.AV.s_avtl_blip(:,:,2,:); % Calculate difference of velocities per condition | (In/De - De/In)

%% Calculate mean & SD of blip reaction period for multi-session
E.AV.m_avtl_blip = ones(400,3,5,2,3)*NaN; % Complete v_mean of each time point of the blip period | timepoints / stim / blip condition (1:all & 5:diff) / direction / hexablock
E.AV.m_sdtl_blip = ones(400,3,4,2,3)*NaN; % STD of v_mean of each time point of the blip period
E.HB1_stable_blip = ones(400,3,4,4,3)*NaN;

for i = 1:400
    for HB = 1:3
        for d = 1:2
            for stim = 1:2
                E.AV.m_avtl_blip(i,stim,1,d,HB) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB & E.spec.stimType==stim));
                E.AV.m_sdtl_blip(i,stim,1,d,HB) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB & E.spec.stimType==stim));
                E.HB1_stable_blip(i,stim,1,4,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==1 & E.spec.stimType==stim));
                for doubleblock = 1:3
                    E.HB1_stable_blip(i,stim,1,doubleblock,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & round(E.spec.blockNr/2)==doubleblock & E.spec.stimType==stim));
                end
                for b = 1:3
                    E.AV.m_avtl_blip(i,stim,b+1,d,HB) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==HB & E.spec.stimType==stim));
                    E.AV.m_sdtl_blip(i,stim,b+1,d,HB) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==HB & E.spec.stimType==stim));
                    E.HB1_stable_blip(i,stim,b+1,4,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==1 & E.spec.stimType==stim));
                    for doubleblock = 1:3
                        E.HB1_stable_blip(i,stim,b+1,doubleblock,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & round(E.spec.blockNr/2)==doubleblock & E.spec.stimType==stim));
                    end
                end
            end
        end
    end
end
E.AV.m_avtl_blip(:,:,5,:,:)= E.AV.m_avtl_blip(:,:,4,:,:) - E.AV.m_avtl_blip(:,:,2,:,:); % Calculate difference of velocities per condition | (Anodal - Cathodal)
E.AV.m_avtl_blip(:,3,:,:,:)= E.AV.m_avtl_blip(:,2,:,:,:) - E.AV.m_avtl_blip(:,1,:,:,:); % Calculate difference of velocities per condition | (Anodal - Cathodal)
E.HB1_stable_blip(:,3,:,:,:) = E.HB1_stable_blip(:,2,:,:,:)-E.HB1_stable_blip(:,1,:,:,:);% Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Find peaks, zerocrossings
E.blippeaks = ones(2,4,2)*NaN; locs = ones(2,4,2)*NaN;
zerocross = ones(3,4,2)*NaN;

for d = 1:2
    for h = 1:4
        % All trials
        [maxpks, maxlocs] = findpeaks(E.AV.s_avtl_blip(:,h,5,d)); % All max-peaks
        [minpks, minlocs] = findpeaks(-E.AV.s_avtl_blip(:,h,5,d)); % All min-peaks
        minpks = -1*minpks; % invert
        
        [E.blippeaks(d,h,d),p1] = min(minpks);
        [E.blippeaks(3-d,h,d),p2] = max(maxpks);
        locs(d,h,d) = minlocs(p1);
        locs(3-d,h,d) = maxlocs(p2);
        
        if min(abs(E.AV.s_avtl_blip(1:locs(1,h,d),h,5,d))) <= 0.1
            zerocross(1,h,d) = find(abs(E.AV.s_avtl_blip(1:locs(1,h,d),h,5,d)) <= 0.1,1,'last');
        else
            zerocross(1,h,d) = NaN;
        end
        zerocross(2,h,d) = round(mean(find(abs(E.AV.s_avtl_blip(locs(1,h,d):locs(2,h,d),h,5,d)) <= 0.1))) +locs(1,h,d) -1;
        if min(abs(E.AV.s_avtl_blip(locs(2,h,d):end,h,5,d))) <= 0.1
            zerocross(3,h,d) = find(abs(E.AV.s_avtl_blip(locs(2,h,d):end,h,5,d)) <= 0.1,1,'first') +locs(2,h,d) -1;
        else
            zerocross(3,h,d) = NaN;
        end
    end
end

E.bliptimes = ones(5,4,2)*NaN; % Time points of events | Events (2 - Peak 1 / 4 - Peak 2) | 1+hexablocks | dr) 
for d = 1:2
    for h = 1:4
        for i = 1:3
            E.bliptimes(2*i-1,h,d) = zerocross(i,h,d);
        end
        for i = 1:2
            E.bliptimes(2*i,h,d) = locs(i,h,d);
        end
    end
end

%% Calculate for Blip: Velocity at Peaks, single trial blip difference and single trial basic level (blip sum)
E.bliptimes = E.bliptimes + E.tEvents(4); % Convert from relative (after blip onset) to absolute timepoint

E.v_Blip = ones(E.numTrials,2)*NaN;
v_cBlip = ones(E.numTrials,2)*NaN;
E.BlipSum = ones(E.numTrials,1)*NaN;
E.BlipDiff = ones(E.numTrials,1)*NaN;
if multiSession == 1
    corr_Blip = ones(2,2,2,3)*NaN;
else
    corr_Blip = ones(2,2,3)*NaN;
end

for HB = 1:3
    for dr = 1:2
        for peak = 1:2
            if multiSession == 1
                for stim = 1:2
                    corr_Blip(peak,stim,dr,HB) = E.AV.m_avtl_blip(E.bliptimes(2*peak,1,dr)-E.tEvents(4),stim,1,dr,HB);
                end
            else
                corr_Blip(peak,dr,HB) = E.AV.s_avtl_blip(E.bliptimes(2*peak,1,dr)-E.tEvents(4),HB+1,1,dr);
            end
        end
    end
end
for i = 1:E.numTrials
    for peak = 1:2
        E.v_Blip(i,peak) = C.eyeXvws(E.bliptimes(2*peak,1,E.spec.trialDr(i)),i);
        if multiSession == 1
            v_cBlip(i,peak) = E.v_Blip(i,peak) - corr_Blip(peak,E.spec.stimType(i),E.spec.trialDr(i),E.spec.HB(i));
        else
            v_cBlip(i,peak) = E.v_Blip(i,peak) - corr_Blip(peak,E.spec.trialDr(i),E.spec.HB(i));
        end
    end
    E.BlipSum(i) = E.v_Blip(i,1)+E.v_Blip(i,2);        % Sum of velocities from both 'peaks' for measure of baseline
    E.BlipDiff(i) = abs(v_cBlip(i,2)-v_cBlip(i,1));     % Difference of velocity from both 'peaks' for peak-to-peak amplitude
end

%% Calculate mean & SD for BlipDiff & BlipSum
E.total.AV_BDiff = ones(4,4,2)*NaN; % BlipCondition (1:All) | HexaBlock (1:All) | Dr
E.total.SD_BDiff = ones(4,4,2)*NaN;
E.total.AV_BSum = ones(4,4,2)*NaN;
E.total.SD_BSum = ones(4,4,2)*NaN;

for Dr = 1:2
    E.total.AV_BDiff(1,1,Dr) = nanmean(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr));
    E.total.SD_BDiff(1,1,Dr) = nanstd(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr));
    E.total.AV_BSum(1,1,Dr) = nanmean(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr));
    E.total.SD_BSum(1,1,Dr) = nanstd(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr));
    for HB = 1:3
        E.total.AV_BDiff(1,HB+1,Dr) = nanmean(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        E.total.SD_BDiff(1,HB+1,Dr) = nanstd(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        E.total.AV_BSum(1,HB+1,Dr) = nanmean(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        E.total.SD_BSum(1,HB+1,Dr) = nanstd(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        for BC = 1:3
            E.total.AV_BDiff(BC+1,HB+1,Dr) = nanmean(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
            E.total.SD_BDiff(BC+1,HB+1,Dr) = nanstd(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
            E.total.AV_BSum(BC+1,HB+1,Dr) = nanmean(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
            E.total.SD_BSum(BC+1,HB+1,Dr) = nanstd(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
        end
    end
    for BC = 1:3
        E.total.AV_BDiff(BC+1,1,Dr) = nanmean(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
        E.total.SD_BDiff(BC+1,1,Dr) = nanstd(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
        E.total.AV_BSum(BC+1,1,Dr) = nanmean(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
        E.total.SD_BSum(BC+1,1,Dr) = nanstd(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
    end
end

if multiSession == 1
    AV_BDiff = ones(4,2,2,3)*NaN; % BlipCondition (1:All) | Stim(1:All) | Dr | HexaBlock
    SD_BDiff = ones(4,2,2,3)*NaN;
    AV_BSum = ones(4,2,2,3)*NaN;
    SD_BSum = ones(4,2,2,3)*NaN;
    
    for HB = 1:3
        for Dr = 1:2
            for stim = 1:2
                AV_BDiff(1,stim,Dr,HB) = nanmean(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
                SD_BDiff(1,stim,Dr,HB) = nanstd(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
                AV_BSum(1,stim,Dr,HB) = nanmean(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
                SD_BSum(1,stim,Dr,HB) = nanstd(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
                for BC = 1:3
                    AV_BDiff(BC+1,stim,Dr,HB) = nanmean(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                    SD_BDiff(BC+1,stim,Dr,HB) = nanstd(E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                    AV_BSum(BC+1,stim,Dr,HB) = nanmean(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                    SD_BSum(BC+1,stim,Dr,HB) = nanstd(E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                end
            end
        end
    end
E.pre.AV_BDiff = AV_BDiff(1:4,1:2,1:2,1); E.stim.AV_BDiff = AV_BDiff(1:4,1:2,1:2,2); E.post.AV_BDiff = AV_BDiff(1:4,1:2,1:2,3);
E.pre.SD_BDiff = SD_BDiff(1:4,1:2,1:2,1); E.stim.SD_BDiff = SD_BDiff(1:4,1:2,1:2,2); E.post.AV_BDiff = SD_BDiff(1:4,1:2,1:2,3);
E.pre.AV_BSum = AV_BSum(1:4,1:2,1:2,1); E.stim.AV_BSum = AV_BSum(1:4,1:2,1:2,2); E.post.AV_BSum = AV_BSum(1:4,1:2,1:2,3);
E.pre.SD_BSum = SD_BSum(1:4,1:2,1:2,1); E.stim.SD_BSum = SD_BSum(1:4,1:2,1:2,2); E.post.AV_BSum = SD_BSum(1:4,1:2,1:2,3);    
end

%% Calculate slope for steady-phase for single-session
steadySlope = ones(6,4,2)*NaN; % pPiS (1:Average), rest +1 | HB (1:Average), rest+1 | Dr 
steadyOffset = ones(6,4,2)*NaN;% pPiS (1:Average), rest +1 | HB (1:Average), rest+1 | Dr 
slopeTime = 0:70;

for Dr = 1:2
    for PiS = 1:6
        for HB = 1:4
            sSlope = [ones(size(slopeTime));slopeTime]'\E.AV.s_avtl_trial(((460:530)+150),HB,PiS,Dr);
            steadySlope(PiS,HB,Dr) = sSlope(2);
            steadyOffset(PiS,HB,Dr) = sSlope(1);
        end
    end
end

E.total.AV_Slope = steadySlope;
E.total.OFF_Slope = steadyOffset;

%% Calculate slope for steady-phase for multi-session
if multiSession == 1
    steadySlope = ones(6,2,2,3)*NaN; % pPiS (1:Average), rest +1 | Stim (1:Average) | Dr | HB(1:3)
    steadyOffset = ones(6,2,2,3)*NaN;% pPiS (1:Average), rest +1 | Stim (1:Average) | Dr | HB(1:3)
    slopeTime = 0:70;
    
    for HB = 1:3
        for Dr = 1:2
            for PiS = 1:6
                for stim = 1:2
                    sSlope = [ones(size(slopeTime));slopeTime]'\E.AV.m_avtl_trial(((460:530)+150),stim,PiS,Dr,HB);
                    steadySlope(PiS,stim,Dr,HB) = sSlope(2);
                    steadyOffset(PiS,stim,Dr,HB) = sSlope(1);
                end
            end
        end
    end
    
    E.pre.AV_Slope = steadySlope(:,:,:,1);  E.stim.AV_Slope = steadySlope(:,:,:,2);  E.post.AV_Slope = steadySlope(:,:,:,3);
    E.pre.OFF_Slope = steadyOffset(:,:,:,1); E.stim.OFF_Slope = steadyOffset(:,:,:,2); E.post.OFF_Slope = steadyOffset(:,:,:,3);
end

%% Calculate saccade time traces for single session
E.AV.s_sacc_times = ones(1600,5,2,5)*NaN; % Average timeline of rv_ASP | timepoints | BlipCondition (1:All,5:Diff 4-2) | Dr | HB (all/pre/stim/post/diff)

for Dr = 1:2
    relTrials = (E.spec.exclude==0 & E.spec.trialDr==Dr);
    for t = 1:1600
        E.AV.s_sacc_times(t,1,Dr,1) = sum(C.eyeXv(E.tEvents(2)-150+t,relTrials)~=C.eyeXvws(E.tEvents(2)-150+t,relTrials))/sum(relTrials);
    end
    for BC = 1:3
        relTrials = (E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2);
        for t = 1:1600
            E.AV.s_sacc_times(t,BC+1,Dr,1) = sum(C.eyeXv(E.tEvents(2)-150+t,relTrials)~=C.eyeXvws(E.tEvents(2)-150+t,relTrials))/sum(relTrials);
        end
    end
    for HB = 1:3
        relTrials = (E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB);
        for t = 1:1600
            E.AV.s_sacc_times(t,1,Dr,HB+1) = sum(C.eyeXv(E.tEvents(2)-150+t,relTrials)~=C.eyeXvws(E.tEvents(2)-150+t,relTrials))/sum(relTrials);
        end
        for BC = 1:3
            relTrials = (E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2 & E.spec.HB==HB);
            for t = 1:1600
                E.AV.s_sacc_times(t,BC+1,Dr,HB+1) = sum(C.eyeXv(E.tEvents(2)-150+t,relTrials)~=C.eyeXvws(E.tEvents(2)-150+t,relTrials))/sum(relTrials);
            end
        end
    end
end

E.AV.s_sacc_times(:,5,:,:) = E.AV.s_sacc_times(:,4,:,:) - E.AV.s_sacc_times(:,2,:,:);
E.AV.s_sacc_times(:,:,:,5) = E.AV.s_sacc_times(:,:,:,3) - E.AV.s_sacc_times(:,2,:,2);
    
%% Calculate saccade time traces for multi-session
if multiSession == 1
    E.AV.m_sacc_times = ones(1600,5,3,2,3)*NaN; % Average timeline of rv_ASP | timepoints | BlipCondition (1:All,5:Diff 4-2) | stim (1:an,2:cat,3:diff)| Dr | HB (pre/stim/post)
    
    for HB = 1:3
        for Dr = 1:2
            for stim = 1:2
                for BC = 1:3
                    relTrials = (E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2 & E.spec.stimType==stim & E.spec.HB==HB);
                    for t = 1:1600
                        E.AV.m_sacc_times(t,BC+1,stim,Dr,HB) = sum(C.eyeXv(E.tEvents(2)-150+t,relTrials)~=C.eyeXvws(E.tEvents(2)-150+t,relTrials))/sum(relTrials);
                    end
                end
                relTrials = (E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==stim & E.spec.HB==HB);
                for t = 1:1600
                    E.AV.m_sacc_times(t,1,stim,Dr,HB) = sum(C.eyeXv(E.tEvents(2)-150+t,relTrials)~=C.eyeXvws(E.tEvents(2)-150+t,relTrials))/sum(relTrials);
                end
            end
        end
    end
    E.AV.m_sacc_times(:,5,1:2,:,:) = E.AV.m_sacc_times(:,4,1:2,:,:) - E.AV.m_sacc_times(:,2,1:2,:,:);
    E.AV.m_sacc_times(:,:,3,:,:) = E.AV.m_sacc_times(:,:,2,:,:) - E.AV.m_sacc_times(:,:,1,:,:);
    
end
%% Calculate significances and effect sizes
[E] = statistics(C,E,multiSession);

%% Overview of results
E.Overview.Excluded = (sum(E.spec.exclude)/E.numTrials)*100;
E.Overview.detected_ASP = cell(3,4);
E.Overview.detected_ASP(2:3,1) = {'Left','Right'};
E.Overview.detected_ASP(1,2:4) = {'Hex1','Hex2','Hex3'};

%% Save data and figures
% Save E
cd D:\Felix\Data\04_Extracted
mkdir(strcat(ename))
cd(strcat('D:\Felix\Data\04_Extracted\',ename))
save(ename,'E');

% Create & save Average-Traces
cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Average_Traces')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Average_Traces'))
extractFigures(E,multiSession,corrected);

% % Create & save Histograms
% cd(strcat('D:\Felix\Data\04_Extracted\',ename))
% mkdir('Histograms')
% cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Histograms'))
% extractHisto(C,E,multiSession);
% 
% % Create & save Raincloud-Plots
% cd(strcat('D:\Felix\Data\04_Extracted\',ename))
% mkdir('Rainclouds')
% cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Rainclouds'))
% extractRainstick(C,E,multiSession);
% 
% % Create & save Baseline-Plots
% if multiSession == 1
%     cd(strcat('D:\Felix\Data\04_Extracted\',ename))
%     mkdir('Baselines')
%     cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Baselines'))
%     plotBaseline(E);
% end

if multiSession == 1
    answer = questdlg('Calculate Session-corrected results, too?','Correction','Yes','No','Yes');
    switch answer
        case 'Yes'
            %Repeat statistics
            corrected = 1;
            [E2] = correctData(E,v_cBlip);
            [E2] = statistics(C,E2,multiSession);
            
            %Save E2
            cd(strcat('D:\Felix\Data\04_Extracted\',ename))
            save(ename2,'E2');
            
            % Create & save Average-Traces
            cd(strcat('D:\Felix\Data\04_Extracted\',ename))
            mkdir('Correct_Traces')
            cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Correct_Traces'))
            extractFigures(E2,multiSession,corrected);
            
            corrected = 0;
        case 'No'
            
    end
end

cd(origPath)
end

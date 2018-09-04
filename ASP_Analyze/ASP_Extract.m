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

%% Basic task parameters
%  Extract from paraTrials
E.spec.trialDr = C.paraTrials(1,:)'; % Direction the target moved to | 1: Leftwards | 2: Rightwards
E.spec.trialPiS = C.paraTrials(2,:)'; % Number in (direction) sequence
E.spec.trialBlip = C.paraTrials(4,:)'; % -1: De/In-Blip | 0: Zero-Blip | 1: In/De-Blip
E.spec.blockNr = C.paraTrials(5,:)'; % Number of block the trial is in
E.spec.goodBlank = C.paraTrials(7,:)'; % No (relevant) saccade in 'blank' period
E.spec.goodBlip = C.paraTrials(8,:)'; % No (relevant) saccade in 'blip'-period + 100 ms afterwards
E.spec.exclude = zeros(E.numTrials,1); % Has the trial to be excluded completely?

% If previously evaluated, exclude the marked trials. 
% Otherwise exclude all trials where both blank and blip phase includes saccades
if length(C.paraTrials(:,1)) == 9
    E.spec.exclude = C.paraTrials(9,:);
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

%% Calculate mean & SD of velocities and trial counts for single-session files
E.total.AV_rv_ASP = ones(6,3,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.total.SD_rv_ASP = ones(6,3,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
E.total.AV_ev_ASP = ones(6,3,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.total.SD_ev_ASP = ones(6,3,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
X_single_ASP = ones(sum(E.spec.HB(:,1) == 1),3,2)*NaN; % Vector of ASP velocities for ANOVA | trials x hexablock x Dr
c_ev_good = ones(6,3,2)*NaN; % Number of all trials with estimated ASP | pPiS x hexablock x pDR
c_ev_total = ones(6,3,2)*NaN;% Number of all trials | pPiS x hexablock x pDR
c_on_good = ones(6,3,2)*NaN; % Number of all trials with estimated ASP | pPiS x hexablock x pDR
c_on_total = ones(6,3,2)*NaN;% Number of all trials | pPiS x hexablock x pDR

for d = 1:2 % Two directions
    c_ev_good(1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d)));
    c_ev_total(1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    c_on_good(1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d)));
    c_on_total(1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d));
    for k = 1:5
        c_ev_good(k+1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k)));
        c_ev_total(k+1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
        c_on_good(k+1,1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k)));
        c_on_total(k+1,1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k));
    end
    for hexa = 1:3 % Three hexablocks
        sev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa);
        X_single_ASP(1:length(sev_ASP),hexa,d) = sev_ASP;
        % Average values & standard deviation
        E.total.AV_rv_ASP(1,hexa,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_rv_ASP(1,hexa,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.AV_ev_ASP(1,hexa,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_ev_ASP(1,hexa,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.AV_on_ASP(1,hexa,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_on_ASP(1,hexa,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.AV_sa_ASP(1,hexa,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        E.total.SD_sa_ASP(1,hexa,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        % Trial counter
        c_ev_good(1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa)));
        c_ev_total(1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        c_on_good(1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa)));
        c_on_total(1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==hexa));
        for k = 1:5 % Six conditions
            E.total.AV_rv_ASP(k+1,hexa,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_rv_ASP(k+1,hexa,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.AV_ev_ASP(k+1,hexa,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_ev_ASP(k+1,hexa,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.AV_on_ASP(k+1,hexa,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_on_ASP(k+1,hexa,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.AV_sa_ASP(k+1,hexa,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
            E.total.SD_sa_ASP(k+1,hexa,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==hexa));
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
                AV_sa_ASP(1,stim,d,HB) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                SD_sa_ASP(1,stim,d,HB) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB & E.spec.stimType==stim));
                for k = 1:5 % Six conditions
                    AV_rv_ASP(k+1,stim,d,HB) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_rv_ASP(k+1,stim,d,HB) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    AV_ev_ASP(k+1,stim,d,HB) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_ev_ASP(k+1,stim,d,HB) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    AV_on_ASP(k+1,stim,d,HB) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_on_ASP(k+1,stim,d,HB) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    AV_sa_ASP(k+1,stim,d,HB) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                    SD_sa_ASP(k+1,stim,d,HB) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB==HB & E.spec.stimType==stim));
                end
            end
        end
    end
end
% Copy averages into three files, one for each hexablock
E.pre_stim.AV_RV = AV_rv_ASP(:,:,:,1); E.pre_stim.SD_RV = SD_rv_ASP(:,:,:,1); E.pre_stim.AV_EV = AV_ev_ASP(:,:,:,1); E.pre_stim.SD_EV = SD_ev_ASP(:,:,:,1); E.pre_stim.AV_ON = AV_on_ASP(:,:,:,1); E.pre_stim.SD_ON = SD_on_ASP(:,:,:,1); E.pre_stim.AV_SA = AV_sa_ASP(:,:,:,1); E.pre_stim.SD_SA = SD_sa_ASP(:,:,:,1);
E.stim.AV_RV = AV_rv_ASP(:,:,:,2); E.stim.SD_RV = SD_rv_ASP(:,:,:,2); E.stim.AV_EV = AV_ev_ASP(:,:,:,2); E.stim.SD_EV = SD_ev_ASP(:,:,:,2); E.stim.AV_ON = AV_on_ASP(:,:,:,2); E.stim.SD_ON = SD_on_ASP(:,:,:,2); E.stim.AV_SA = AV_sa_ASP(:,:,:,2); E.stim.SD_SA = SD_sa_ASP(:,:,:,2);
E.post_stim.AV_RV = AV_rv_ASP(:,:,:,3); E.post_stim.SD_RV = SD_rv_ASP(:,:,:,3); E.post_stim.AV_EV = AV_ev_ASP(:,:,:,3); E.post_stim.SD_EV = SD_ev_ASP(:,:,:,3); E.post_stim.AV_ON = AV_on_ASP(:,:,:,3); E.post_stim.SD_ON = SD_on_ASP(:,:,:,3); E.post_stim.AV_SA = AV_sa_ASP(:,:,:,3); E.post_stim.SD_SA = SD_sa_ASP(:,:,:,3);

%% Calculate mean & SD of entire trial (-150 pre-blank ~> 250 ms post-stop) for single session
real.s_avtl_trial = ones(1600,5,6,2)*NaN; % Average timeline of rv_ASP | timepoints | hexablock (1:all | 5:diff) | pPiS | pDr
s.sdtl_trial = ones(1600,5,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:1599
    for Dr = 1:2
        % Average of direction
        real.s_avtl_trial(i+1,1,1,Dr)= nanmean(C.eyeXv(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialDr==Dr));
        s.sdtl_trial(i+1,1,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialDr==Dr));
        for hb = 1:3
            % Specific for hexablock
            real.s_avtl_trial(i+1,hb+1,1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialDr==Dr));
            s.sdtl_trial(i+1,hb+1,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialDr==Dr));
            for PiS = 1:5
                % Specific for PiS x hexablock
                real.s_avtl_trial(i+1,hb+1,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
                s.sdtl_trial(i+1,hb+1,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
            end
        end
        % Specific for PiS
        for PiS = 1:5
            real.s_avtl_trial(i+1,1,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
            s.sdtl_trial(i+1,1,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
        end
    end
end
real.s_avtl_trial(:,5,:,:)= real.s_avtl_trial(:,3,:,:) - real.s_avtl_trial(:,2,:,:); % Calculate difference of velocities per condition | (Stim - NoStim)

%% Calculate mean & SD of entire trial (-150 pre-blank ~> 250 ms post-stop) for multi-session
real.m_avtl_trial = ones(1600,3,6,2,3)*NaN; % Average timeline of rv_ASP | timepoints | stim (1:an | 2:cat) | pPiS | pDr | HB
real.m_sdtl_trial = ones(1600,3,6,2,3)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:1599
    for HB = 1:3
        for Dr = 1:2
            for stim = 1:2
                % Specific for hexablock
                real.m_avtl_trial(i+1,stim,1,Dr,HB)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.trialDr==Dr));
                real.m_sdtl_trial(i+1,stim,1,Dr,HB)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.trialDr==Dr));
                for PiS = 1:5
                    % Specific for pPiS x hexablock
                    real.m_avtl_trial(i+1,stim,PiS+1,Dr,HB)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.trialPiS==PiS & E.spec.stimType==stim & E.spec.trialDr==Dr));
                    real.m_sdtl_trial(i+1,stim,PiS+1,Dr,HB)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.trialPiS==PiS & E.spec.stimType==stim & E.spec.trialDr==Dr));
                end
            end
        end
    end
end
real.m_avtl_trial(:,3,:,:,:)= real.m_avtl_trial(:,2,:,:,:) - real.m_avtl_trial(:,1,:,:,:); % Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Calculate mean & SD of blank reaction period for single session
real.s_avtl_blank = ones(600,5,6,2)*NaN; % Average timeline of rv_ASP | timepoints | hexablock (1:all | 5:diff) | pPiS | pDr
real.s_sdtl_blank = ones(600,5,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:599
    for pDr = 1:2
        % Average of previous direction
        real.s_avtl_blank(i+1,1,1,pDr)= nanmean(C.eyeXv(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr));
        real.s_sdtl_blank(i+1,1,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr));
        for hb = 1:3
            % Specific for hexablock
            real.s_avtl_blank(i+1,hb+1,1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,1)==pDr));
            real.s_sdtl_blank(i+1,hb+1,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,1)==pDr));
            for pPiS = 1:5
                % Specific for pPiS x hexablock
                real.s_avtl_blank(i+1,hb+1,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
                real.s_sdtl_blank(i+1,hb+1,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==hb & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
            end
        end
        % Specific for pPiS
        for pPiS = 1:5
        real.s_avtl_blank(i+1,1,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
        real.s_sdtl_blank(i+1,1,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
        end
    end
end
real.s_avtl_blank(:,5,:,:)= real.s_avtl_blank(:,3,:,:) - real.s_avtl_blank(:,2,:,:); % Calculate difference of velocities per condition | (Stim - NoStim)

%% Calculate mean & SD of blank reaction period for multi-session
real.m_avtl_blank = ones(600,3,6,2,2)*NaN; % Average timeline of rv_ASP | timepoints | stim (1:an | 2:cat) | pPiS | pDr
real.m_sdtl_blank = ones(600,3,6,2,2)*NaN; % Standard deviation timeline of rv_ASP
E.HB1_stable_blank = ones(600,3,6,4,2)*NaN;

for i = 0:599
    for HB = 1:3
        for pDr = 1:2
            for stim = 1:2
                % Specific for hexablock
                real.m_avtl_blank(i+1,stim,1,pDr,HB)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                real.m_sdtl_blank(i+1,stim,1,pDr,HB)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                E.HB1_stable_blank(i+1,stim,1,4,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==1 & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                for doubleblock = 1:3
                    E.HB1_stable_blank(i+1,stim,1,doubleblock,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & round(E.spec.blockNr/2)==doubleblock  & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                end
                for pPiS = 1:5
                    % Specific for pPiS x hexablock
                    real.m_avtl_blank(i+1,stim,pPiS+1,pDr,HB)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
                    real.m_sdtl_blank(i+1,stim,pPiS+1,pDr,HB)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB==HB & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==stim & E.spec.prevTrial(:,1)==pDr));
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
real.m_avtl_blank(:,3,:,:,:)= real.m_avtl_blank(:,2,:,:,:) - real.m_avtl_blank(:,1,:,:,:); % Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Calculate mean & SD of blip reaction period for single session
real.s_avtl_blip = ones(400,4,5,2)*NaN; % Complete v_mean of each time point of the blip period | timepoints / hexablocks (1:all) / conditions / direction
real.s_sdtl_blip = ones(400,4,4,2)*NaN; % STD of v_mean of each time point of the blip period

for i = 1:400
    for d = 1:2
        real.s_avtl_blip(i,1,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d));
        real.s_sdtl_blip(i,1,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d));
        for hexa = 1:3
            real.s_avtl_blip(i,hexa+1,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==hexa));
            real.s_sdtl_blip(i,hexa+1,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==hexa));
        end
        for b = 1:3
           real.s_avtl_blip(i,1,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2));
           real.s_sdtl_blip(i,1,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2));
           for hexa = 1:3
               real.s_avtl_blip(i,hexa+1,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==hexa));
               real.s_sdtl_blip(i,hexa+1,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==hexa));
           end
        end
    end
end
real.s_avtl_blip(:,:,5,:)= real.s_avtl_blip(:,:,4,:) - real.s_avtl_blip(:,:,2,:); % Calculate difference of velocities per condition | (In/De - De/In)

%% Calculate mean & SD of blip reaction period for multi-session
real.m_avtl_blip = ones(400,3,5,2,2)*NaN; % Complete v_mean of each time point of the blip period | timepoints / hexablocks (1:all) / conditions / direction
real.m_sdtl_blip = ones(400,3,4,2,2)*NaN; % STD of v_mean of each time point of the blip period
E.HB1_stable_blip = ones(400,3,4,4,2)*NaN;

for i = 1:400
    for HB = 1:3
        for d = 1:2
            for stim = 1:2
                real.m_avtl_blip(i,stim,1,d,HB) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB & E.spec.stimType==stim));
                real.m_sdtl_blip(i,stim,1,d,HB) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB & E.spec.stimType==stim));
                E.HB1_stable_blip(i,stim,1,4,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==1 & E.spec.stimType==stim));
                for doubleblock = 1:3
                    E.HB1_stable_blip(i,stim,1,doubleblock,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & round(E.spec.blockNr/2)==doubleblock & E.spec.stimType==stim));
                end
                for b = 1:3
                    real.m_avtl_blip(i,stim,b+1,d,HB) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==HB & E.spec.stimType==stim));
                    real.m_sdtl_blip(i,stim,b+1,d,HB) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==HB & E.spec.stimType==stim));
                    E.HB1_stable_blip(i,stim,b+1,4,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB==1 & E.spec.stimType==stim));
                    for doubleblock = 1:3
                        E.HB1_stable_blip(i,stim,b+1,doubleblock,d)= nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & round(E.spec.blockNr/2)==doubleblock & E.spec.stimType==stim));
                    end
                end
            end
        end
    end
end
real.m_avtl_blip(:,:,5,:,:)= real.m_avtl_blip(:,:,4,:,:) - real.m_avtl_blip(:,:,2,:,:); % Calculate difference of velocities per condition | (Anodal - Cathodal)
real.m_avtl_blip(:,3,:,:,:)= real.m_avtl_blip(:,2,:,:,:) - real.m_avtl_blip(:,1,:,:,:); % Calculate difference of velocities per condition | (Anodal - Cathodal)
E.HB1_stable_blip(:,3,:,:,:) = E.HB1_stable_blip(:,2,:,:,:)-E.HB1_stable_blip(:,1,:,:,:);% Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Find peaks, zerocrossings
E.blippeaks = ones(2,4,2)*NaN; locs = ones(2,4,2)*NaN;
zerocross = ones(3,4,2)*NaN;

for d = 1:2
    for h = 1:4
        % All trials
        [maxpks, maxlocs] = findpeaks(real.s_avtl_blip(:,h,5,d)); % All max-peaks
        [minpks, minlocs] = findpeaks(-real.s_avtl_blip(:,h,5,d)); % All min-peaks
        minpks = -1*minpks; % invert
        
        [E.blippeaks(d,h,d),p1] = min(minpks);
        [E.blippeaks(3-d,h,d),p2] = max(maxpks);
        locs(d,h,d) = minlocs(p1);
        locs(3-d,h,d) = maxlocs(p2);
        
        if min(abs(real.s_avtl_blip(1:locs(1,h,d),h,5,d))) <= 0.1
            zerocross(1,h,d) = find(abs(real.s_avtl_blip(1:locs(1,h,d),h,5,d)) <= 0.1,1,'last');
        else
            zerocross(1,h,d) = NaN;
        end
        zerocross(2,h,d) = round(mean(find(abs(real.s_avtl_blip(locs(1,h,d):locs(2,h,d),h,5,d)) <= 0.1))) +locs(1,h,d) -1;
        if min(abs(real.s_avtl_blip(locs(2,h,d):end,h,5,d))) <= 0.1
            zerocross(3,h,d) = find(abs(real.s_avtl_blip(locs(2,h,d):end,h,5,d)) <= 0.1,1,'first') +locs(2,h,d) -1;
        else
            zerocross(3,h,d) = NaN;
        end
    end
end

E.bliptimes = ones(5,4,2)*NaN; % E.bliptimes_g = ones(5,4,2)*NaN;
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
E.bliptimes = E.bliptimes + E.tEvents(4); % Convert from relative (after blip onset) to absolute timepoint

% Define velocities at blip peaks for each trial
E.v_Blip = ones(E.numTrials,2);
for i = 1:E.numTrials
    for peak = 1:2
        E.v_Blip(i,peak) = C.eyeXvws(E.bliptimes(2*peak,1,E.spec.trialDr(i)),i);
    end
end
    

%% Correct the 'cathodal vs anodal'-contrast with a baseline
answer2 = questdlg('Use correctional baseline for session contrast?','Baseline','Yes','No','No');
switch answer2
    case 'Yes'
        % Set up variables
        corr.rv_ASP = ones(size(E.rv_ASP))*NaN;
        corr.v_Blip = ones(size(E.v_Blip))*NaN;
        corr.m_avtl_trial = ones(size(real.m_avtl_trial))*NaN;
        corr.m_avtl_blank = ones(size(real.m_avtl_blank))*NaN;
        corr.m_avtl_blip = ones(size(real.m_avtl_blip))*NaN;
        
        % Calculate baselines
        BaseTrial = real.m_avtl_trial(:,3,:,:,1);
        BaseBlank = real.m_avtl_blank(:,3,:,:,1);
        BaseBlip = real.m_avtl_blip(:,3,:,:,1) ;
        
        % Correction for single values
        rvTime = E.tEvents(3)-E.tEvents(2)+50;
        blTime = E.bliptimes([2 4],1,:) - E.tEvents(4);
        for pDr = 1:2
            for pPiS = 1:5
                % Correct unilaterally - anodal only
                corr.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==1) + BaseBlank(rvTime,1,1,pDr,1);
                corr.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==2) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType==2);
                %                     for stim = 1:2
                %                         E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr&E.spec.prevTrial(:,2)==pPiS&E.spec.stimType==stim) = E.rv_ASP(E.spec.exclude==0&E.spec.prevTrial(:,1)==pDr&E.spec.prevTrial(:,2)==pPiS&E.spec.stimType==stim) - BaseBlank(rvTime,1,pDr);
                %                     end
            end
        end
        for Dr = 1:2
            for peak = 1:2
                corr.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==1,peak) = E.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr  & E.spec.stimType==1,peak) + BaseBlip(blTime(peak,Dr),1,1,Dr,1);
                corr.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==2,peak) = E.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr  & E.spec.stimType==2,peak);
            end
        end
        
        % Correction for average traces
        corr.m_avtl_trial(:,1,:,:,:) = real.m_avtl_trial(:,1,:,:,:) + BaseTrial(:,:,1,:,:);
        corr.m_avtl_trial(:,2,:,:,:) = real.m_avtl_trial(:,2,:,:,:);
        corr.m_avtl_trial(:,3,:,:,:) = corr.m_avtl_trial(:,2,:,:,:) - corr.m_avtl_trial(:,1,:,:,:);
        corr.m_avtl_blank(:,1,:,:,:) = real.m_avtl_blank(:,1,:,:,:) + BaseBlank(:,:,1,:,:);
        corr.m_avtl_blank(:,2,:,:,:) = real.m_avtl_blank(:,2,:,:,:);
        corr.m_avtl_blank(:,3,:,:,:) = corr.m_avtl_blank(:,2,:,:,:) - corr.m_avtl_blank(:,1,:,:,:);
        corr.m_avtl_blip(:,1,:,:,:) = real.m_avtl_blip(:,1,:,:,:) + BaseBlip(:,:,1,:,:);
        corr.m_avtl_blip(:,2,:,:,:) = real.m_avtl_blip(:,2,:,:,:);
        corr.m_avtl_blip(:,3,:,:,:) = corr.m_avtl_blip(:,2,:,:,:) - corr.m_avtl_blip(:,1,:,:,:); 
        
    case 'No'
end

%% Calculate significances and effect sizes
% [E] = statistics(C,E,multiSession,X_single_ASP);

%% Overview of results
% E.Averages.s = s;
% E.Averages.m = m;
E.Overview.Excluded = (sum(E.spec.exclude)/E.numTrials)*100;
E.Overview.detected_ASP = cell(3,4);
E.Overview.detected_ASP(2:3,1) = {'Left','Right'};
E.Overview.detected_ASP(1,2:4) = {'Hex1','Hex2','Hex3'};

%% Save data and figures
cd D:\Felix\Data\04_Extracted
mkdir(strcat(ename))
cd(strcat('D:\Felix\Data\04_Extracted\',ename))
save(ename,'E');

% cd(strcat('D:\Felix\Data\04_Extracted\',ename))
% mkdir('Average_Traces')
% cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Average_Traces'))
% extractFigures(E,multiSession,real);

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Correct_Traces')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Correct_Traces'))
correctFigures(E,multiSession,real,corr);

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Histograms')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Histograms'))
extractHisto(C,E,multiSession);

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Rainclouds')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Rainclouds'))
extractRainstick(C,E,multiSession);

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Baselines')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Baselines'))
plotBaseline(E,real);

cd(origPath)
end

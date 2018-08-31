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
E.spec.HB = ones(E.numTrials,3)*NaN;
for hb = 1:3
    E.spec.HB(E.spec.blockNr >= 6*hb-5 & E.spec.blockNr <= 6*hb,3) = hb;
end
E.spec.HB(1:length(E.spec.HB)/2,1)=E.spec.HB(E.spec.trialDr==1,3); % hexablock for trials to the left
E.spec.HB(1:length(E.spec.HB)/2,2)=E.spec.HB(E.spec.trialDr==2,3); % hexablock for trials to the right 


% Define stimulation and subject for group level analysis
E.spec.stimType = ones(length(C.paraTrials),3)*NaN; % Which type of stimulation was used? | 1: Anodal | 2: Cathodal | 3: None
E.spec.stimType(:,3) = C.paraTrials(11,:)'; 
E.spec.stimType(1:length(E.spec.stimType)/2,1)=E.spec.stimType(E.spec.trialDr==1,3); % stimType for trials to the left
E.spec.stimType(1:length(E.spec.stimType)/2,2)=E.spec.stimType(E.spec.trialDr==2,3); % stimType for trials to the right
E.spec.subject = ones(length(C.paraTrials),3)*NaN;
E.spec.subject(:,3) = C.paraTrials(10,:)'; 
E.spec.subject(1:length(E.spec.subject)/2,1)=E.spec.subject(E.spec.trialDr==1,3);
E.spec.subject(1:length(E.spec.subject)/2,2)=E.spec.subject(E.spec.trialDr==2,3);

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
% If multisession, look at An-Cat or Control?
if multiSession == 1
   answer = questdlg('Examine An/Cat difference or control condition?','AnCat or Ctr','An/Cat','Control','An/Cat');
   switch answer
       case 'An/Cat'
           multiHB = 2;
       case 'Control'
           multiHB = 1;
   end
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
E.single.AV_rv_ASP = ones(6,3,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.single.SD_rv_ASP = ones(6,3,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
E.single.AV_ev_ASP = ones(6,3,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x pDr
E.single.SD_ev_ASP = ones(6,3,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x pDr
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
    for hexa = 1:3 % Three hexablocks
        sev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa);
        X_single_ASP(1:length(sev_ASP),hexa,d) = sev_ASP;
        % Average values & standard deviation
        E.single.AV_rv_ASP(1,hexa,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.SD_rv_ASP(1,hexa,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.AV_ev_ASP(1,hexa,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.SD_ev_ASP(1,hexa,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.AV_on_ASP(1,hexa,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.SD_on_ASP(1,hexa,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.AV_sa_ASP(1,hexa,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        E.single.SD_sa_ASP(1,hexa,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        % Trial counter
        c_ev_good(1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa)));
        c_ev_total(1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        c_on_good(1,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa)));
        c_on_total(1,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa));
        for k = 1:5 % Six conditions
            E.single.AV_rv_ASP(k+1,hexa,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.SD_rv_ASP(k+1,hexa,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.AV_ev_ASP(k+1,hexa,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.SD_ev_ASP(k+1,hexa,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.AV_on_ASP(k+1,hexa,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.SD_on_ASP(k+1,hexa,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.AV_sa_ASP(k+1,hexa,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            E.single.SD_sa_ASP(k+1,hexa,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            % Trial counter
            c_ev_good(1+k,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa)));
            c_ev_total(1+k,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
            c_on_good(1+k,hexa+1,d) = sum(~isnan(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa)));
            c_on_total(1+k,hexa+1,d) = length(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==hexa));
        end
        rel_ev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa); % Find estimated ASP matching all criteria
        E.single.N_ev_ASP(1,hexa,d) = sum(~isnan(rel_ev_ASP))/length(rel_ev_ASP);
        for k = 1:5
            rel_ev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==hexa & E.spec.prevTrial(:,2)==k); % One additional criterium: pPiS
            E.single.N_ev_ASP(k+1,hexa,d) = sum(~isnan(rel_ev_ASP))/length(rel_ev_ASP);
        end
    end
end

E.P_evASP = c_ev_good(:,:,:)./c_ev_total(:,:,:)*100;

%% Calculate mean & SD of velocities for multi-session files
if multiSession == 1
    E.multi.AV_rv_ASP = ones(6,2,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x Dr
    E.multi.SD_rv_ASP = ones(6,2,2)*NaN;% deg/s | SD of real ASP velocity | pPiS x hexablock x Dr
    E.multi.AV_ev_ASP = ones(6,2,2)*NaN;% deg/s | Average real ASP velocity | pPiS x hexablock x Dr
    E.multi.SD_ev_ASP = ones(6,2,2);% deg/s | SD of real ASP velocity | pPiS x hexablock x Dr
    
    for d = 1:2 % Two directions
        for stim = 1:2 % Stimulation types
            E.multi.AV_rv_ASP(1,stim,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.SD_rv_ASP(1,stim,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.AV_ev_ASP(1,stim,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.SD_ev_ASP(1,stim,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.AV_on_ASP(1,stim,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.SD_on_ASP(1,stim,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.AV_sa_ASP(1,stim,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            E.multi.SD_sa_ASP(1,stim,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            for k = 1:5 % Six conditions
                E.multi.AV_rv_ASP(k+1,stim,d) = nanmean(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.SD_rv_ASP(k+1,stim,d) = nanstd(E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.AV_ev_ASP(k+1,stim,d) = nanmean(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.SD_ev_ASP(k+1,stim,d) = nanstd(E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.AV_on_ASP(k+1,stim,d) = nanmean(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.SD_on_ASP(k+1,stim,d) = nanstd(E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.AV_sa_ASP(k+1,stim,d) = nanmean(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                E.multi.SD_sa_ASP(k+1,stim,d) = nanstd(E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.prevTrial(:,2)==k & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            end
            rel_ev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3) == 2 & E.spec.stimType(:,3) == stim); % Find estimated ASP matching all criteria
            E.multi.N_ev_ASP(1,stim,d) = sum(~isnan(rel_ev_ASP))/length(rel_ev_ASP);
            for k = 1:5
                rel_ev_ASP = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3) == 2 & E.spec.prevTrial(:,2)==k & E.spec.stimType(:,3) == stim); % One additional criterium: pPiS
                E.multi.N_ev_ASP(k+1,stim,d) = sum(~isnan(rel_ev_ASP))/length(rel_ev_ASP);
            end
        end
    end
end

%% Calculate mean & SD of entire trial (-150 pre-blank ~> 250 ms post-stop) for single session
s.avtl_trial = ones(1600,5,6,2)*NaN; % Average timeline of rv_ASP | timepoints | hexablock (1:all | 5:diff) | pPiS | pDr
s.sdtl_trial = ones(1600,5,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:1599
    for Dr = 1:2
        % Average of direction
        s.avtl_trial(i+1,1,1,Dr)= nanmean(C.eyeXv(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialDr==Dr));
        s.sdtl_trial(i+1,1,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialDr==Dr));
        for hb = 1:3
            % Specific for hexablock
            s.avtl_trial(i+1,hb+1,1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.trialDr==Dr));
            s.sdtl_trial(i+1,hb+1,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.trialDr==Dr));
            for PiS = 1:5
                % Specific for PiS x hexablock
                s.avtl_trial(i+1,hb+1,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
                s.sdtl_trial(i+1,hb+1,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
            end
        end
        % Specific for PiS
        for PiS = 1:5
            s.avtl_trial(i+1,1,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
            s.sdtl_trial(i+1,1,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.trialPiS==PiS & E.spec.trialDr==Dr));
        end
    end
end
s.avtl_trial(:,5,:,:)= s.avtl_trial(:,3,:,:) - s.avtl_trial(:,2,:,:); % Calculate difference of velocities per condition | (Stim - NoStim)

%% Calculate mean & SD of entire trial (-150 pre-blank ~> 250 ms post-stop) for multi-session
m.avtl_trial = ones(1600,3,6,2)*NaN; % Average timeline of rv_ASP | timepoints | stim (1:an | 2:cat) | pPiS | pDr
m.sdtl_trial = ones(1600,3,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:1599
    for Dr = 1:2
        for stim = 1:2
            % Specific for hexablock
            m.avtl_trial(i+1,stim,1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim & E.spec.trialDr==Dr));
            m.sdtl_trial(i+1,stim,1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim & E.spec.trialDr==Dr));
            for PiS = 1:5
                % Specific for pPiS x hexablock
                m.avtl_trial(i+1,stim,PiS+1,Dr)= nanmean(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.trialPiS==PiS & E.spec.stimType(:,3)==stim & E.spec.trialDr==Dr));
                m.sdtl_trial(i+1,stim,PiS+1,Dr)= nanstd(C.eyeXvws(E.tEvents(2)-150+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.trialPiS==PiS & E.spec.stimType(:,3)==stim & E.spec.trialDr==Dr));
            end
        end
    end
end
m.avtl_trial(:,3,:,:)= m.avtl_trial(:,2,:,:) - m.avtl_trial(:,1,:,:); % Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Calculate mean & SD of blank reaction period for single session
s.avtl_rv = ones(600,5,6,2)*NaN; % Average timeline of rv_ASP | timepoints | hexablock (1:all | 5:diff) | pPiS | pDr
s.sdtl_rv = ones(600,5,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:599
    for pDr = 1:2
        % Average of previous direction
        s.avtl_rv(i+1,1,1,pDr)= nanmean(C.eyeXv(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr));
        s.sdtl_rv(i+1,1,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,1)==pDr));
        for hb = 1:3
            % Specific for hexablock
            s.avtl_rv(i+1,hb+1,1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.prevTrial(:,1)==pDr));
            s.sdtl_rv(i+1,hb+1,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.prevTrial(:,1)==pDr));
            for pPiS = 1:5
                % Specific for pPiS x hexablock
                s.avtl_rv(i+1,hb+1,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
                s.sdtl_rv(i+1,hb+1,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==hb & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
            end
        end
        % Specific for pPiS
        for pPiS = 1:5
        s.avtl_rv(i+1,1,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
        s.sdtl_rv(i+1,1,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.prevTrial(:,2)==pPiS & E.spec.prevTrial(:,1)==pDr));
        end
    end
end
s.avtl_rv(:,5,:,:)= s.avtl_rv(:,3,:,:) - s.avtl_rv(:,2,:,:); % Calculate difference of velocities per condition | (Stim - NoStim)

%% Calculate mean & SD of blank reaction period for multi-session
m.avtl_rv = ones(600,3,6,2)*NaN; % Average timeline of rv_ASP | timepoints | stim (1:an | 2:cat) | pPiS | pDr
m.sdtl_rv = ones(600,3,6,2)*NaN; % Standard deviation timeline of rv_ASP

for i = 0:599
    for pDr = 1:2
        for stim = 1:2
            % Specific for hexablock
            m.avtl_rv(i+1,stim,1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim & E.spec.prevTrial(:,1)==pDr));
            m.sdtl_rv(i+1,stim,1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim & E.spec.prevTrial(:,1)==pDr));
            for pPiS = 1:5
                % Specific for pPiS x hexablock
                m.avtl_rv(i+1,stim,pPiS+1,pDr)= nanmean(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType(:,3)==stim & E.spec.prevTrial(:,1)==pDr));
                m.sdtl_rv(i+1,stim,pPiS+1,pDr)= nanstd(C.eyeXvws(E.tEvents(2)+i,E.spec.exclude==0 & E.spec.HB(:,3)==multiHB & E.spec.prevTrial(:,2)==pPiS & E.spec.stimType(:,3)==stim & E.spec.prevTrial(:,1)==pDr));
            end
        end
    end
end
m.avtl_rv(:,3,:,:)= m.avtl_rv(:,2,:,:) - m.avtl_rv(:,1,:,:); % Calculate difference of velocities per condition | (Cathodal - Anodal)

%% Calculate mean & SD of blip reaction period for single session
s.avtl_bl_a = ones(400,4,5,2)*NaN; % Complete v_mean of each time point of the blip period | timepoints / hexablocks (1:all) / conditions / direction
s.sdtl_bl_a = ones(400,4,4,2)*NaN; % STD of v_mean of each time point of the blip period

for i = 1:400
    for d = 1:2
        s.avtl_bl_a(i,1,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d));
        s.sdtl_bl_a(i,1,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d));
        for hexa = 1:3
            s.avtl_bl_a(i,hexa+1,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==hexa));
            s.sdtl_bl_a(i,hexa+1,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==hexa));
        end
        for b = 1:3
           s.avtl_bl_a(i,1,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2));
           s.sdtl_bl_a(i,1,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2));
           for hexa = 1:3
               s.avtl_bl_a(i,hexa+1,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB(:,3)==hexa));
               s.sdtl_bl_a(i,hexa+1,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB(:,3)==hexa));
           end
        end
    end
end
s.avtl_bl_a(:,:,5,:)= s.avtl_bl_a(:,:,4,:) - s.avtl_bl_a(:,:,2,:); % Calculate difference of velocities per condition | (In/De - De/In)

%% Calculate mean & SD of blip reaction period for multi-session
m.avtl_bl_a = ones(400,2,5,2)*NaN; % Complete v_mean of each time point of the blip period | timepoints / hexablocks (1:all) / conditions / direction
m.sdtl_bl_a = ones(400,2,4,2)*NaN; % STD of v_mean of each time point of the blip period

for i = 1:400
    for d = 1:2
        for stim = 1:2
            m.avtl_bl_a(i,stim,1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            m.sdtl_bl_a(i,stim,1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            for b = 1:3
                m.avtl_bl_a(i,stim,b+1,d) = nanmean(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
                m.sdtl_bl_a(i,stim,b+1,d) = nanstd(C.eyeXvws(E.tEvents(4)+i-1,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.trialBlip==b-2 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==stim));
            end
        end
    end
end
m.avtl_bl_a(:,:,5,:)= m.avtl_bl_a(:,:,4,:) - m.avtl_bl_a(:,:,2,:); % Calculate difference of velocities per condition | (Anodal - Cathodal)

%% Find peaks, zerocrossings
E.blippeaks_a = ones(2,4,2)*NaN; locs_a = ones(2,4,2)*NaN; E.blippeaks_g = ones(2,4,2)*NaN; 
% locs_g = ones(2,4,2)*NaN; % | max/min | hexa | dir
zerocross_a = ones(3,4,2)*NaN; 
% zerocross_g = ones(3,4,2)*NaN;% Start / Middle / End | hexa | dir

for d = 1:2
    for h = 1:4
        % All trials
        [maxpks, maxlocs] = findpeaks(s.avtl_bl_a(:,h,5,d)); % All max-peaks
        [minpks, minlocs] = findpeaks(-s.avtl_bl_a(:,h,5,d)); % All min-peaks
        minpks = -1*minpks; % invert
        
        [E.blippeaks_a(d,h,d),p1] = min(minpks);
        [E.blippeaks_a(3-d,h,d),p2] = max(maxpks);
        locs_a(d,h,d) = minlocs(p1);
        locs_a(3-d,h,d) = maxlocs(p2);
        
        if min(abs(s.avtl_bl_a(1:locs_a(1,h,d),h,5,d))) <= 0.1
            zerocross_a(1,h,d) = find(abs(s.avtl_bl_a(1:locs_a(1,h,d),h,5,d)) <= 0.1,1,'last');
        else
            zerocross_a(1,h,d) = NaN;
        end
        zerocross_a(2,h,d) = round(mean(find(abs(s.avtl_bl_a(locs_a(1,h,d):locs_a(2,h,d),h,5,d)) <= 0.1))) +locs_a(1,h,d) -1;
        if min(abs(s.avtl_bl_a(locs_a(2,h,d):end,h,5,d))) <= 0.1
            zerocross_a(3,h,d) = find(abs(s.avtl_bl_a(locs_a(2,h,d):end,h,5,d)) <= 0.1,1,'first') +locs_a(2,h,d) -1;
        else
            zerocross_a(3,h,d) = NaN;
        end
    end
end

E.bliptimes_a = ones(5,4,2)*NaN; % E.bliptimes_g = ones(5,4,2)*NaN;
for d = 1:2
    for h = 1:4
        for i = 1:3
            E.bliptimes_a(2*i-1,h,d) = zerocross_a(i,h,d);
            %             E.bliptimes_g(2*i-1,h,d) = zerocross_g(i,h,d);
        end
        for i = 1:2
            E.bliptimes_a(2*i,h,d) = locs_a(i,h,d);
            %             E.bliptimes_g(2*i,h,d) = locs_g(i,h,d);
        end
    end
end
E.bliptimes_a = E.bliptimes_a + E.tEvents(4); % Convert from relative (after blip onset) to absolute timepoint


%% Calculate significances and effect sizes
[E] = statistics(C,E,multiSession,multiHB,X_single_ASP);

%% Overview of results
E.Overview.Excluded = (sum(E.spec.exclude)/E.numTrials)*100;
E.Overview.detected_ASP = cell(3,4);
E.Overview.detected_ASP(2:3,1) = {'Left','Right'};
E.Overview.detected_ASP(1,2:4) = {'Hex1','Hex2','Hex3'};

%% Save data and figures
cd D:\Felix\Data\04_Extracted
mkdir(strcat(ename))
cd(strcat('D:\Felix\Data\04_Extracted\',ename))
save(ename,'E');

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Average_Traces')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Average_Traces'))
extractFigures(E,multiSession,multiHB,s,m);

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Histograms')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Histograms'))
extractHisto(C,E,multiSession,multiHB);

cd(strcat('D:\Felix\Data\04_Extracted\',ename))
mkdir('Rainclouds')
cd(strcat('D:\Felix\Data\04_Extracted\',ename,'\Rainclouds'))
extractRainstick(C,E,multiSession,multiHB);


cd(origPath)
end

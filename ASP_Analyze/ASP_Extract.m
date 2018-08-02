function [E] = ASPExtract(C,filename1,origPath)

%% Creates data file E with all relevant parameters for each experiment
E = [];
E.name = filename1(1:end-4);
E.subjectID = C.subjectID;
E.numBlocks = C.numBlocks;
E.numTrials = length(C.paraTrials(1,:));
E.v_target = C.v_target;
E.vmax_blip = C.v_blip;
E.tEvents = [0;765;1049;1399;1599;1965;2416;2916];

%% Basic task parameters
%  Extract from paraTrials
E.trialDr = C.paraTrials(1,:)'; % Direction the target moved to | 1: Leftwards | 2: Rightwards
E.trialNiS = C.paraTrials(2,:)'; % Number in (direction) sequence
E.trialBlip = C.paraTrials(4,:)'; % -1: De/In-Blip | 0: Zero-Blip | 1: In/De-Blip
E.blockNr = C.paraTrials(5,:)'; % Number of block the trial is in
E.goodBlank = C.paraTrials(7,:)'; % No (relevant) saccade in 'blank' period
E.goodBlip = C.paraTrials(8,:)'; % No (relevant) saccade in 'blip'-period + 100 ms afterwards

% Define lengths of hexablocks
hexblk = zeros(4,4);
hexblk(1,2:4) = [sum(E.blockNr<=6) ; sum(E.blockNr >=7 & E.blockNr <=12) ; sum(E.blockNr >=13 & E.blockNr <=18)];
for b = 1:3
    hexblk(2,b+1) = hexblk(2,b) + hexblk(1,b+1);
    E.blockNr(hexblk(2,b)+1:hexblk(2,b+1),2) = b;% Define HexaBlock-Nr of each trial
    hexblk(3,b) = hexblk(2,b)/2+1;
    hexblk(4,b) = hexblk(2,b+1)/2;
end
E.hexaBlock = hexblk(1,2:4); % Number of trials per HexaBlock

%  Get new parameters
E.exclude = zeros(E.numTrials,1); % Has the trial to be excluded completely?
E.prevTrial = ones(E.numTrials,2)*NaN; % Data from previous trial ~> 1: Which Dr | 2: Which NiS? ~> sets expectation
E.trialNiDr = ones(E.numTrials,2)*NaN; % How much trials did already go in same dr? | 1: This block | 2: Overall
td = [1;1]; % counter for NiDr

% Define all positions for each individual trial
for t = 1:E.numTrials
    if t == 1 || E.blockNr(t)-E.blockNr(t-1) ~= 0 % First trial in new direction
        td = [1;1]; % reset counter
    end
    E.trialNiDr(t,1) = td(E.trialDr(t));
    E.trialNiDr(t,2) = 28*(E.blockNr(t)-1)+E.trialNiDr(t,1);
    td(E.trialDr(t)) = td(E.trialDr(t))+1; % increase counter
    if t ~= 1
        E.prevTrial(t,1) = E.trialDr(t-1); % Set previous Dr
        E.prevTrial(t,2) = E.trialNiS(t-1); % Set previous NiS
    else
        E.prevTrial(t,1) = 1; E.prevTrial(t,2) = 1; % First trial = 1|1
    end
    if C.paraTrials(7,t) == 0 && C.paraTrials(8,t) == 0 % Exclude trials where neither is good
        E.exclude(t) = 1;
    end
end

if length(C.paraTrials(:,1)) == 9
    E.exclude = C.paraTrials(9,:); % Take exclude values from verifyer if they exist
end

%% Single-Trial results

E.rv_ASP = C.realVOn';% deg/s | real velocity of anticipatory smooth pursuit at 400 ms post-blank
E.ev_ASP = C.estVOn';% deg/s  | estimated velocity of ASP at 400 ms, based on linear fit
E.on_ASP = C.detOn';%  ms     | estimated onset of ASP, based on linear fitASP velocity & detected onset
E.saccades(1:E.numTrials,1) = C.numSacc; % number of saccades in the blank & move part of each trial
%E.durSacc % duration of (all?) catch-up saccades

%% Sum up single trial data
M_rv = ones(E.numTrials/2,6,2)*NaN; % matrix for real velocities
M_ev = ones(E.numTrials/2,6,2)*NaN; % matrix for estimated velocities
c_ev = zeros(6,4,2,2); % counter for number of ASP estimated
M_on = ones(E.numTrials/2,6,2)*NaN; % matrix for estimated onsets
c_on = zeros(6,4,2,2); % counter for number of estimated onsets

M_sa = ones(E.numTrials/2,6,2)*NaN;% matrix for saccade number
tc = [1;1]; % counter for total trials per direction

M_bl_a = ones(E.numTrials/2,401,4,2)*NaN;% matrix for velocities in blip period (0 - 400 ms post-blip)
M_bl_g = ones(E.numTrials/2,401,4,2)*NaN;% same as above, but only for 'good' trials
c_bl = zeros(4,2,2);

for t = 1:E.numTrials
    if E.exclude(t) ~= 1 % Don't use exclude trials
        % set marker % Use of previous trial parameters since expectation
        pdr = E.prevTrial(t,1); %previous direction
        pns = E.prevTrial(t,2); %previous NiS
        hxb = E.blockNr(t,2); %current hexablock
        
        % fill velocity matrices
        M_rv(tc(pdr),1,pdr) = E.rv_ASP(t); % All trials with same previous dr
        M_rv(tc(pdr),pns+1,pdr) = E.rv_ASP(t); % Trials with same previous dr & NiS
        M_ev(tc(pdr),1,pdr) = E.ev_ASP(t); % All trials with same previous dr
        M_ev(tc(pdr),pns+1,pdr) = E.ev_ASP(t); % Trials with same previous dr & NiS
        
        % fill onset matrix, count good estimates
        M_on(tc(pdr),1,pdr) = E.on_ASP(t); % All trials with same previous dr
        M_on(tc(pdr),pns+1,pdr) = E.on_ASP(t); % Trials with same previous dr & NiS
        c_ev(1,1,2,pdr) = c_ev(1,1,2,pdr)+1; c_ev(pns+1,1,2,pdr) = c_ev(pns+1,1,2,pdr)+1; % Add one to total count of condition
        c_ev(1,hxb+1,2,pdr) = c_ev(1,hxb+1,2,pdr)+1; c_ev(pns+1,hxb+1,2,pdr) = c_ev(pns+1,hxb+1,2,pdr)+1;
        c_on(1,1,2,pdr) = c_on(1,1,2,pdr)+1; c_on(pns+1,1,2,pdr) = c_on(pns+1,1,2,pdr)+1;
        c_on(1,hxb+1,2,pdr) = c_on(1,hxb+1,2,pdr)+1; c_on(pns+1,hxb+1,2,pdr) = c_on(pns+1,hxb+1,2,pdr)+1;
        if ~isnan(E.ev_ASP(t))
            c_ev(1,1,1,pdr) = c_ev(1,1,1,pdr)+1; c_ev(pns+1,1,1,pdr) = c_ev(pns+1,1,1,pdr)+1;% Add one to count of condition when onset was estimated
            c_ev(1,hxb+1,1,pdr) = c_ev(1,hxb+1,1,pdr)+1; c_ev(pns+1,hxb+1,1,pdr) = c_ev(pns+1,hxb+1,1,pdr)+1;
        end
        if ~isnan(E.on_ASP(t))
            c_on(1,1,1,pdr) = c_on(1,1,1,pdr)+1; c_on(pns+1,1,1,pdr) = c_on(pns+1,1,1,pdr)+1;% Add one to count of condition when onset was estimated
            c_on(1,hxb+1,1,pdr) = c_on(1,hxb+1,1,pdr)+1; c_on(pns+1,hxb+1,1,pdr) = c_on(pns+1,hxb+1,1,pdr)+1;
        end
        
        % fill saccade matrices % Use NiS here
        M_sa(tc(pdr),1,E.trialDr(t)) = E.saccades(t); % All trials with same previous dr
        M_sa(tc(pdr),E.trialNiS(t)+1,E.trialDr(t)) = E.saccades(t); % Trials with same previous dr & NiS
        
        % fill blip reaction matrix
        for i = 1:401 %timepoint after blank
            c_bl(1,E.trialDr(t),2) = c_bl(1,E.trialDr(t),2)+1;
            c_bl(E.trialBlip(t)+3,E.trialDr(t),2) = c_bl(E.trialBlip(t)+3,E.trialDr(t),2)+1;
            M_bl_a(tc(E.trialDr(t)),i,1,E.trialDr(t)) = C.eyeXvws(E.tEvents(4)+i-1,t);
            M_bl_a(tc(E.trialDr(t)),i,E.trialBlip(t)+3,E.trialDr(t)) = C.eyeXvws(E.tEvents(4)+i-1,t);
            if E.goodBlip(t) == 1
                c_bl(1,E.trialDr(t),1) = c_bl(1,E.trialDr(t),1)+1;
                c_bl(E.trialBlip(t)+3,E.trialDr(t),1) = c_bl(E.trialBlip(t)+3,E.trialDr(t),1)+1;
                M_bl_g(tc(E.trialDr(t)),i,1,E.trialDr(t)) = C.eyeXvws(E.tEvents(4)+i-1,t);
                M_bl_g(tc(E.trialDr(t)),i,E.trialBlip(t)+3,E.trialDr(t)) = C.eyeXvws(E.tEvents(4)+i-1,t);
            end
        end
    end
    if tc(E.trialDr(t)) ~= E.numTrials/2% Increase trial counter (but not for the last trial, to not add a line)
        tc(E.trialDr(t)) = tc(E.trialDr(t))+1; % increase trial counter
    end
end

%% Calculate mean and standard deviation of velocities
E.AV_rv_ASP = ones(6,3,2);% deg/s | Average real ASP velocity | pNiS x hexablock x Dr
E.SD_rv_ASP = ones(6,3,2);% deg/s | SD of real ASP velocity | pNiS x hexablock x Dr
E.AV_ev_ASP = ones(6,3,2);% deg/s | Average real ASP velocity | pNiS x hexablock x Dr
E.SD_ev_ASP = ones(6,3,2);% deg/s | SD of real ASP velocity | pNiS x hexablock x Dr
X_ASP = ones(max(hexblk(1,:))/2,3,2)*NaN; % Vector of ASP velocities for ANOVA | trials x hexablock x Dr

for d = 1:2 % Two directions
    for h = 1:3 % Three hexablocks
        for k = 1:6 % Six conditions
            X_ASP(1:length(M_rv(hexblk(3,h):hexblk(4,h),1,d)),h,d) = M_rv(hexblk(3,h):hexblk(4,h),1,d);
            E.AV_rv_ASP(k,h,d) = nanmean(M_rv(hexblk(3,h):hexblk(4,h),k,d));
            E.SD_rv_ASP(k,h,d) = nanstd(M_rv(hexblk(3,h):hexblk(4,h),k,d));
            E.AV_ev_ASP(k,h,d) = nanmean(M_ev(hexblk(3,h):hexblk(4,h),k,d));
            E.SD_ev_ASP(k,h,d) = nanstd(M_ev(hexblk(3,h):hexblk(4,h),k,d));
            E.AV_on_ASP(k,h,d) = nanmean(M_on(hexblk(3,h):hexblk(4,h),k,d));
            E.SD_on_ASP(k,h,d) = nanstd(M_on(hexblk(3,h):hexblk(4,h),k,d));
            E.N_ev_ASP = c_ev;
            E.PC_ev_ASP(k,h,d) = c_ev(k,h+1,1,d)/c_ev(k,h+1,2,d);
            E.AV_N_Sacc(k,h,d) = nanmean(M_sa(hexblk(3,h):hexblk(4,h),k,d));
            E.SD_N_Sacc(k,h,d) = nanstd(M_sa(hexblk(3,h):hexblk(4,h),k,d));
        end
    end
end

%% Calculate mean and standard deviation for pertubation reaction period
av_bl_a = ones(401,4,5,2)*NaN; % Complete v_mean of each time point of the blip period | timepoints / hexablocks (1:all) / conditions / direction
sd_bl_a = ones(401,4,4,2)*NaN; % STD of v_mean of each time point of the blip period
av_bl_g = ones(401,4,5,2)*NaN; % Same as above, but only 'good' trials
sd_bl_g = ones(401,4,4,2)*NaN; % Same as above, but only 'good' trials

for i = 1:401
    for b = 1:4
        for d = 1:2
            %All trials
            av_bl_a(i,1,b,d)= nanmean(M_bl_a(:,i,b,d));
            sd_bl_a(i,1,b,d)= nanstd(M_bl_a(:,i,b,d));
            av_bl_g(i,1,b,d)= nanmean(M_bl_g(:,i,b,d));
            sd_bl_g(i,1,b,d)= nanstd(M_bl_g(:,i,b,d));
            
            %Specific hexablocks
            for h = 1:3
                av_bl_a(i,h+1,b,d)= nanmean(M_bl_a(hexblk(3,h):hexblk(4,h),i,b,d));
                sd_bl_a(i,h+1,b,d)= nanstd(M_bl_a(hexblk(3,h):hexblk(4,h),i,b,d));
                av_bl_g(i,h+1,b,d)= nanmean(M_bl_g(hexblk(3,h):hexblk(4,h),i,b,d));
                sd_bl_g(i,h+1,b,d)= nanstd(M_bl_g(hexblk(3,h):hexblk(4,h),i,b,d));
            end
        end
    end
end
av_bl_a(:,:,5,:)= av_bl_a(:,:,4,:) - av_bl_a(:,:,2,:); % Calculate difference of velocities per condition | (In/De - De/In)
av_bl_g(:,:,5,:)= av_bl_g(:,:,4,:) - av_bl_g(:,:,2,:); % Same as above, but 'good' trials only | (In/De - De/In)


%% Find peaks, zerocrossings
E.blippeaks_a = ones(2,4,2)*NaN; locs_a = ones(2,4,2)*NaN; E.blippeaks_g = ones(2,4,2)*NaN; locs_g = ones(2,4,2)*NaN; % | max/min | hexa | dir
zerocross_a = ones(3,4,2)*NaN; zerocross_g = ones(3,4,2)*NaN;% Start / Middle / End | hexa | dir

for d = 1:2
    for h = 1:4
        % All trials
        [maxpks, maxlocs] = findpeaks(av_bl_a(:,h,5,d)); % All max-peaks
        [minpks, minlocs] = findpeaks(-av_bl_a(:,h,5,d)); % All min-peaks
        minpks = -1*minpks; % invert
        
        [E.blippeaks_a(d,h,d),p1] = min(minpks);
        [E.blippeaks_a(3-d,h,d),p2] = max(maxpks);
        locs_a(d,h,d) = minlocs(p1);
        locs_a(3-d,h,d) = maxlocs(p2);
        
        if min(abs(av_bl_a(1:locs_a(1,h,d),h,5,d))) <= 0.1
            zerocross_a(1,h,d) = find(abs(av_bl_a(1:locs_a(1,h,d),h,5,d)) <= 0.1,1,'last');
        else
            zerocross_a(1,h,d) = NaN;
        end
        zerocross_a(2,h,d) = round(mean(find(abs(av_bl_a(locs_a(1,h,d):locs_a(2,h,d),h,5,d)) <= 0.1))) +locs_a(1,h,d) -1;
        if min(abs(av_bl_a(locs_a(2,h,d):end,h,5,d))) <= 0.1
            zerocross_a(3,h,d) = find(abs(av_bl_a(locs_a(2,h,d):end,h,5,d)) <= 0.1,1,'first') +locs_a(2,h,d) -1;
        else
            zerocross_a(3,h,d) = NaN;
        end
        
        % Good trials
        %         [maxpks, maxlocs] = findpeaks(av_bl_g(:,h,5,d)); % All max-peaks
        %         [minpks, minlocs] = findpeaks(-av_bl_g(:,h,5,d)); % All min-peaks
        %         minpks = -1*minpks; % invert
        %
        %         [E.blippeaks_g(d,h,d),p1] = min(minpks);
        %         [E.blippeaks_g(3-d,h,d),p2] = max(maxpks);
        %         locs_g(d,h,d) = minlocs(p1);
        %         locs_g(3-d,h,d) = maxlocs(p2);
        %
        %         if min(abs(av_bl_g(1:locs_a(1,h,d),h,5,d))) <= 0.1
        %             zerocross_g(1,h,d) = find(abs(av_bl_g(1:locs_a(1,h,d),h,5,d)) <= 0.1,1,'last');
        %         else
        %             zerocross_g(1,h,d) = NaN;
        %         end
        %         zerocross_g(2,h,d) = round(mean(find(abs(av_bl_g(locs_g(1,h,d):locs_g(2,h,d),h,5,d)) <= 0.1))) +locs_g(1,h,d) -1;
        %         if min(abs(av_bl_g(locs_g(2,h,d):end,h,5,d))) <= 0.1
        %             zerocross_g(3,h,d) = find(abs(av_bl_g(locs_g(2,h,d):end,h,5,d)) <= 0.1,1,'first') +locs_g(2,h,d) -1;
        %         else
        %             zerocross_g(3,h,d) = NaN;
        %         end
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


%% Calculate significances and effect sizes
[E] = statistics(X_ASP,M_rv,E,hexblk,M_bl_a);

%% Save data and figures
prompt = {'Name for extracted file?'};
dlg_title = 'Namet';
num_lines = 1;
defaultans = {''}; %# of sequences per direction
inputcluster = inputdlg(prompt,dlg_title,num_lines,defaultans);
ename = ['Sub' num2str(E.subjectID) '_' inputcluster{1}];

cd D:\Felix\Data\04_Extracted
mkdir(strcat(ename))
cd(strcat('D:\Master\Data\04_Extracted\','Sub',num2str(E.subjectID),'_',inputcluster{1}))

%ename = [E.name(1:4) '_E'];
save(ename,'E');
extractFigures(E,hexblk,M_bl_a,av_bl_a,av_bl_g);

cd(origPath)
end

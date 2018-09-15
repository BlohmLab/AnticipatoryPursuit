function E2 = correctData(E,v_cBlip)
%% Create basic identical structure
E2 = struct;
E2.name = E.name; E2.numBlocks = E.numBlocks; E2.numTrials = E.numTrials; E2.tEvents = E.tEvents; E2.spec = E.spec;
E2.rv_ASP = ones(size(E.rv_ASP))*NaN; E2.ev_ASP = ones(size(E.ev_ASP))*NaN; E2.on_ASP = ones(size(E.on_ASP))*NaN; E2.saccades = ones(size(E.saccades))*NaN;
E2.AV = []; E2.pre = E.pre;

%% Correct specific average measures - v_ASP, Onset, Number of Saccades, Slope etc.
% Calculate Differences, differentiate between (p)PiS
% corrAV_RV = E.pre.AV_RV(:,2,:) - E.pre.AV_RV(:,1,:); % Difference between anticipatory velocity between Pre_C - Pre_A
% corrAV_EV = E.pre.AV_EV(:,2,:) - E.pre.AV_EV(:,1,:);
% corrAV_ON = E.pre.AV_ON(:,2,:) - E.pre.AV_ON(:,1,:);
% corrAV_SA = E.pre.AV_SA(:,2,:) - E.pre.AV_SA(:,1,:);
% corrAV_Slope = E.pre.AV_Slope(:,2,:) - E.pre.AV_Slope(:,1,:);

% Calculate Differences based on complete average over conditions
corrAV_RV = E.pre.AV_RV(1,2,:) - E.pre.AV_RV(1,1,:); % Difference between anticipatory velocity between Pre_C - Pre_A
corrAV_EV = E.pre.AV_EV(1,2,:) - E.pre.AV_EV(1,1,:);
corrAV_ON = E.pre.AV_ON(1,2,:) - E.pre.AV_ON(1,1,:);
corrAV_SA = E.pre.AV_SA(1,2,:) - E.pre.AV_SA(1,1,:);
corrAV_Slope = E.pre.AV_Slope(1,2,:) - E.pre.AV_Slope(1,1,:);

% Apply corrective baseline to E.stim
for dr = 1:2
    E2.stim.AV_RV(:,1,dr) = E.stim.AV_RV(:,1,dr) + corrAV_RV(dr);
    E2.stim.AV_RV(:,2,dr) = E.stim.AV_RV(:,2,dr);
    E2.stim.AV_EV(:,1,dr) = E.stim.AV_EV(:,1,dr) + corrAV_EV(dr);
    E2.stim.AV_EV(:,2,dr) = E.stim.AV_EV(:,2,dr);
    E2.stim.AV_ON(:,1,dr) = E.stim.AV_ON(:,1,dr) + corrAV_ON(dr);
    E2.stim.AV_ON(:,2,dr) = E.stim.AV_ON(:,2,dr);
    E2.stim.AV_SA(:,1,dr) = E.stim.AV_SA(:,1,dr) + corrAV_SA(dr);
    E2.stim.AV_SA(:,2,dr) = E.stim.AV_SA(:,2,dr);
    E2.stim.AV_Slope(:,1,dr) = E.stim.AV_Slope(:,1,dr) + corrAV_Slope(dr);
    E2.stim.AV_Slope(:,2,dr) = E.stim.AV_Slope(:,2,dr);
    
    % Apply corrective baseline to E.post
    E2.post.AV_RV(:,1,dr) = E.post.AV_RV(:,1,dr) + corrAV_RV(dr);
    E2.post.AV_RV(:,2,dr) = E.post.AV_RV(:,2,dr);
    E2.post.AV_EV(:,1,dr) = E.post.AV_EV(:,1,dr) + corrAV_EV(dr);
    E2.post.AV_EV(:,2,dr) = E.post.AV_EV(:,2,dr);
    E2.post.AV_ON(:,1,dr) = E.post.AV_ON(:,1,dr) + corrAV_ON(dr);
    E2.post.AV_ON(:,2,dr) = E.post.AV_ON(:,2,dr);
    E2.post.AV_SA(:,1,dr) = E.post.AV_SA(:,1,dr) + corrAV_SA(dr);
    E2.post.AV_SA(:,2,dr) = E.post.AV_SA(:,2,dr);
    E2.post.AV_Slope(:,1,dr) = E.post.AV_Slope(:,1,dr) + corrAV_Slope(dr);
    E2.post.AV_Slope(:,2,dr) = E.post.AV_Slope(:,2,dr);
end

%% Correct average values for blip
% Calculate blip correction for each peak
E2.bliptimes = E.bliptimes;
E2.v_Blip = ones(E.numTrials,2)*NaN;
E2.BlipDiff = ones(E.numTrials,2)*NaN;
E2.BlipSum = ones(E.numTrials,2)*NaN;
corrBLIP = ones(2,2)*NaN; % General for only dr x peak

for dr = 1:2
    for peak = 1:2
        corrBLIP(peak,dr) = E.AV.m_avtl_blip(E.bliptimes(2*peak,1,dr)-E.tEvents(4),2,1,dr,1)-E.AV.m_avtl_blip(E.bliptimes(2*peak,1,dr)-E.tEvents(4),1,1,dr,1);
        %for blipcond = 1:3
        %             corrBLIP(peak,stim,dr,HB) = E.AV.m_avtl_blip(E.bliptimes(2*peak,1,dr)-E.tEvents(4),stim,1,dr,HB);
        %end
    end
end

%% Correct average timelines - trial / blank / blip
% Calculate Difference, differentiate between PiS / pPiS / blipcond
% corr_avtl_trial = E.AV.m_avtl_trial(:,3,:,:,1);
% corr_avtl_blank = E.AV.m_avtl_blank(:,3,:,:,1);
% corr_avtl_blip =  E.AV.m_avtl_blip(:,3,:,:,1);

% Calculate Difference based on complete average over conditions
corr_avtl_trial = E.AV.m_avtl_trial(:,3,1,:,1);
corr_avtl_blank = E.AV.m_avtl_blank(:,3,1,:,1);
corr_avtl_blip =  E.AV.m_avtl_blip(:,3,1,:,1);

% Apply corrective timeline to average timelines
E2.AV.m_avtl_trial(:,1,:,:,:) = E.AV.m_avtl_trial(:,1,:,:,:) + corr_avtl_trial(:,:,:,:,:);
E2.AV.m_avtl_trial(:,2,:,:,:) = E.AV.m_avtl_trial(:,2,:,:,:);
E2.AV.m_avtl_trial(:,3,:,:,:) = E.AV.m_avtl_trial(:,3,:,:,:) - corr_avtl_trial(:,:,:,:,:);
E2.AV.m_avtl_blank(:,1,:,:,:) = E.AV.m_avtl_blank(:,1,:,:,:) + corr_avtl_blank(:,:,:,:,:);
E2.AV.m_avtl_blank(:,2,:,:,:) = E.AV.m_avtl_blank(:,2,:,:,:);
E2.AV.m_avtl_blank(:,3,:,:,:) = E.AV.m_avtl_blank(:,3,:,:,:) - corr_avtl_blank(:,:,:,:,:);
E2.AV.m_avtl_blip(:,1,:,:,:) = E.AV.m_avtl_blip(:,1,:,:,:) + corr_avtl_blip(:,:,:,:,:);
E2.AV.m_avtl_blip(:,2,:,:,:) = E.AV.m_avtl_blip(:,2,:,:,:);
E2.AV.m_avtl_blip(:,3,:,:,:) = E.AV.m_avtl_blip(:,3,:,:,:) - corr_avtl_blip(:,:,:,:,:);



%% Correct single rv-values for statistics
E2.v_Blip = ones(size(E.v_Blip))*NaN;
E2.BlipDiff = ones(size(E.BlipDiff))*NaN;
E2.BlipSum = ones(size(E.BlipSum))*NaN;

for Dr = 1:2
    E2.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==1) + corrAV_RV(Dr);
    E2.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==2) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==2);
    E2.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==1) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==1) + corrAV_EV(Dr);
    E2.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==2) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==2);
    E2.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==1) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==1) + corrAV_ON(Dr);
    E2.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==2) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.stimType==2);
    E2.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==1) = E.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==1) + corrAV_SA(Dr);
    E2.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==2) = E.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==2);
    % for PiS = 1:5
    %         E2.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==1) + corrAV_RV(PiS,Dr);
    %         E2.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==2) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==2);
    %         E2.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==1) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==1) + corrAV_EV(PiS,Dr);
    %         E2.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==2) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==2);
    %         E2.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==1) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==1) + corrAV_ON(PiS,Dr);
    %         E2.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==2) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==Dr & E.spec.prevTrial(:,2)==PiS & E.spec.stimType==2);
    %         E2.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialPiS(:,2)==PiS & E.spec.stimType==1) = E.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialPiS(:,2)==PiS & E.spec.stimType==1) + corrAV_SA(PiS,Dr);
    %         E2.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialPiS(:,2)==PiS & E.spec.stimType==2) = E.saccades(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialPiS(:,2)==PiS & E.spec.stimType==2);
    %end
    for peak = 1:2
        E2.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==1,peak) = E.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==1,peak) + corrBLIP(peak,dr);
        E2.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==2,peak) = E.v_Blip(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.stimType==2,peak);
    end
    E2.BlipDiff(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==1) = abs(v_cBlip(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==1,2) - v_cBlip(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==1,1) + corrBLIP(2,dr) - corrBLIP(1,dr));     % Difference of velocity from both 'peaks' for peak-to-peak amplitude
    E2.BlipDiff(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==2) = E.BlipDiff(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==2);
    E2.BlipSum(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==1) = E.BlipSum(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==1) + corrBLIP(1,dr) + corrBLIP(2,dr);
    E2.BlipSum(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==2) = E.BlipSum(E.spec.exclude==0&E.spec.trialDr==Dr&E.spec.stimType==2);
end

%% Calculate corrected mean & SD for BlipDiff & BlipSum
E2.total.AV_BDiff = ones(4,4,2)*NaN; % BlipCondition (1:All) | HexaBlock (1:All) | Dr
E2.total.SD_BDiff = ones(4,4,2)*NaN;
E2.total.AV_BSum = ones(4,4,2)*NaN;
E2.total.SD_BSum = ones(4,4,2)*NaN;

for Dr = 1:2
    E2.total.AV_BDiff(1,1,Dr) = nanmean(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr));
    E2.total.SD_BDiff(1,1,Dr) = nanstd(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr));
    E2.total.AV_BSum(1,1,Dr) = nanmean(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr));
    E2.total.SD_BSum(1,1,Dr) = nanstd(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr));
    for HB = 1:3
        E2.total.AV_BDiff(1,HB+1,Dr) = nanmean(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        E2.total.SD_BDiff(1,HB+1,Dr) = nanstd(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        E2.total.AV_BSum(1,HB+1,Dr) = nanmean(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        E2.total.SD_BSum(1,HB+1,Dr) = nanstd(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
        for BC = 1:3
            E2.total.AV_BDiff(BC+1,HB+1,Dr) = nanmean(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
            E2.total.SD_BDiff(BC+1,HB+1,Dr) = nanstd(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
            E2.total.AV_BSum(BC+1,HB+1,Dr) = nanmean(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
            E2.total.SD_BSum(BC+1,HB+1,Dr) = nanstd(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2));
        end
    end
    for BC = 1:3
        E2.total.AV_BDiff(BC+1,1,Dr) = nanmean(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
        E2.total.SD_BDiff(BC+1,1,Dr) = nanstd(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
        E2.total.AV_BSum(BC+1,1,Dr) = nanmean(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
        E2.total.SD_BSum(BC+1,1,Dr) = nanstd(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.trialBlip==BC-2));
    end
end


AV_BDiff = ones(4,2,2,3)*NaN; % BlipCondition (1:All) | Stim(1:All) | Dr | HexaBlock
SD_BDiff = ones(4,2,2,3)*NaN;
AV_BSum = ones(4,2,2,3)*NaN;
SD_BSum = ones(4,2,2,3)*NaN;

for HB = 1:3
    for Dr = 1:2
        for stim = 1:2
            AV_BDiff(1,stim,Dr,HB) = nanmean(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
            SD_BDiff(1,stim,Dr,HB) = nanstd(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
            AV_BSum(1,stim,Dr,HB) = nanmean(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
            SD_BSum(1,stim,Dr,HB) = nanstd(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB));
            for BC = 1:3
                AV_BDiff(BC+1,stim,Dr,HB) = nanmean(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                SD_BDiff(BC+1,stim,Dr,HB) = nanstd(E2.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                AV_BSum(BC+1,stim,Dr,HB) = nanmean(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
                SD_BSum(BC+1,stim,Dr,HB) = nanstd(E2.BlipSum(E.spec.exclude==0 & E.spec.trialDr==Dr & E.spec.HB==HB & E.spec.trialBlip==BC-2 & E.spec.stimType==stim));
            end
        end
    end
end

E2.pre.AV_BDiff = AV_BDiff(1:4,1:2,1:2,1); E2.stim.AV_BDiff = AV_BDiff(1:4,1:2,1:2,2); E2.post.AV_BDiff = AV_BDiff(1:4,1:2,1:2,3);
E2.pre.SD_BDiff = SD_BDiff(1:4,1:2,1:2,1); E2.stim.SD_BDiff = SD_BDiff(1:4,1:2,1:2,2); E2.post.AV_BDiff = SD_BDiff(1:4,1:2,1:2,3);
E2.pre.AV_BSum = AV_BSum(1:4,1:2,1:2,1); E2.stim.AV_BSum = AV_BSum(1:4,1:2,1:2,2); E2.post.AV_BSum = AV_BSum(1:4,1:2,1:2,3);
E2.pre.SD_BSum = SD_BSum(1:4,1:2,1:2,1); E2.stim.SD_BSum = SD_BSum(1:4,1:2,1:2,2); E2.post.AV_BSum = SD_BSum(1:4,1:2,1:2,3);

end
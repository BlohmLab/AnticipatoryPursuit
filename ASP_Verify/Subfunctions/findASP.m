%findASP detects smooth pursuit through velocity-deviation, calculates the velocity of different groups and uses the most fitting one.
function D = findASP(D,trn,tBlankOn,tMoveOn)

D{trn}.isASP = 0; % Is there detectable anticipatory pursuit? - 1:Yes 0:No

%% - Find group(s) of timepoints with velocity > average fix velocity + 2 SD
baseline =500:tBlankOn; % 266 ms baseline period before blank onset in ms
bslV = D{trn}.eyeXvws(baseline); % velocity values during baseline
bslM(trn) = abs(nanmean(bslV)); %baseline mean
bslS(trn) = nanstd(bslV);  %baseline standart deviation
SPoff = tMoveOn+50;
sigE = D{trn}.eyeXvws(tBlankOn:SPoff); % period of interest: blankBeg to visual input
indE = find(abs(sigE) > bslM(trn) + 2*bslS(trn)); %timepoints for signal over baseline
[posE, nE] = group(indE, 2, 20); %Find groups in indE (above threshold) with distance 2 & continuity 20

%% - Calculate parameters for each group
if ~isempty(posE)
    D{trn}.isASP = 1; % Detected anticipatory pursuit
    % find position of highest anticipatory velocity
    D{trn}.posMaxASP = find(abs(sigE)==max(abs(sigE)))+tBlankOn-1;
    sumBeOn=ones(nE,2)*NaN; % beOn values (slope, offset) for fit of all groups
    sumTimes=ones(nE,2)*NaN;
    sumSPlot=ones(nE,1500)*NaN;
    sumRMSE=zeros(nE,1);
    for n = 1:nE % all groups of velocity above baseline threshold
        %Calculate fit for this group
        eyeSP = sigE(indE(posE(2*n-1)):334); % all velocity from group onset until end of blank phase
        timeSP = 0:length(eyeSP)-1;
        beOn = [ones(size(timeSP)); timeSP]'\eyeSP'; % calculate fit with beOn(1):velocity at detection point and beOn(2): slope
        detOn = tBlankOn+indE(posE(2*n-1)); % time point of detection in absolute ms
        SPon = round(detOn -beOn(1)/beOn(2)); % calculate anticipatory pursuit onset in absolute ms
        if SPon < 250 || SPon > SPoff+D{1}.delay % Reject fit if onset earlier then 250 ms or after visual input
            beOn = [NaN;NaN];
            detOn = NaN;
            SPon = NaN;
        end
        % calculate all values for plot line
        spPlot = zeros(length(SPon:SPoff),1);
        for i = 1:length(spPlot)
            spPlot(i)=beOn(2)*i;
        end
        sumBeOn(n,:)=beOn;
        sumTimes(n,1)=SPon;
        sumTimes(n,2)=detOn;
        sumSPlot(n,1:length(spPlot))=spPlot;
        if isnan(beOn(1)) == 1 || isnan(beOn(2)) == 1
            sumRMSE(n) = NaN;
        else
            %Calculate RMSE of fit to find optimal one
            MSE = 0;
            for i = SPon:SPoff-1
                if isnan(D{trn}.eyeXvws(i)) ~= 1
                    MSE = MSE+((spPlot(i-SPon+1)-D{trn}.eyeXvws(i))^2);
                end
            end
            sumRMSE(n) = sqrt(MSE/(SPoff-SPon));
        end
        [opMSE,opPos]=min(sumRMSE);
    end
else
    sumBeOn = [NaN;NaN];
    sumTimes(1,1:2) = NaN;
    sumSPlot = NaN;
    [opMSE,opPos] = deal(1);
end

%% - Choose optimal fit values
D{trn}.beOn = sumBeOn(opPos,:);
D{trn}.detOn = sumTimes(opPos,2);
D{trn}.SPon = sumTimes(opPos,1);
D{trn}.SPoff = SPoff;
D{trn}.ASPlot = sumSPlot(opPos,:);
D{trn}.ASPlot = D{trn}.ASPlot(~isnan(D{trn}.ASPlot));
D{trn}.realVOn = nanmean(D{trn}.eyeXvws(SPoff-10:SPoff+10));
D{trn}.maxVOn = NaN; D{trn}.estVOn = NaN;
if D{trn}.isASP == 1
    D{trn}.maxVOn = D{trn}.eyeXvws(D{trn}.posMaxASP);
end
if ~isnan(D{trn}.ASPlot)
    D{trn}.estVOn = D{trn}.ASPlot(end);
end
end
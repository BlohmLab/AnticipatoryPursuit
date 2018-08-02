% blipAverage averages the eye velocities of all trials with same blip properties & direction from 100 ms before until 400 ms after blip onset.
if isempty(D) %Error in case data can't be found
    fprintf('D is empty. Something wrong with loading data.');
    return
end

%%reload pre-existing data?
if isfield(D{1},'avBlip') == 1
    
    combi = (2+D{1}.randPlot)*plotCase + randBlip*(plotCase-1)^2;%plotCase = 0 ~> BlipAverage / plotCase = 0 ~> PlotAverage
    if combi == 0 || combi == 2
        choice = questdlg('You already calculated an all-trials plot.','Old or new plot?','Use it again','New Plot','New Plot');
    else
        choice = questdlg('You already calculated an random-balanced plot.','Old or new plot?','Use it again','New Plot','New Plot');
    end
    switch choice
        case 'New Plot'
            newPlot = 1;
        case 'Use it again'
            newPlot = 0;
    end
else
    newPlot = 1;
end

%% condition - sum all or random-balanced?
if newPlot == 1
    
    choice = questdlg('Which 0-blip trials do you want to use?','All or Balanced','All Trials','Random-Balanced','Random-Balanced');
    switch choice
        case 'All Trials'
            tpc= D{1}.numTrials/2-D{1}.numBlips;%trials per condition
            random = 0;%don't pick random trials
        case 'Random-Balanced'
            tpc= D{1}.numBlips/2;
            random = 1;
    end
    
    %% create a sieve
    if random == 1
        sieve = zeros(1,length(D));%create array with a '1' for every used trial: Blip-trials and randomly matched 0-Trials
        sieve(D{1}.paraTrial(4,:)<0)=1;
        sieve(D{1}.paraTrial(4,:)>0)=1;
        for d = 1:2
            for i = 1:length(D{1}.blipCount)
                numbers=1:length(D);
                wire=numbers(D{1}.paraTrial(1,:)>(d-1) & D{1}.paraTrial(1,:)<(d+1) & D{1}.paraTrial(2,:)>(i-1) & D{1}.paraTrial(2,:)<(i+1) & D{1}.paraTrial(4,:)>-1 & D{1}.paraTrial(4,:)<1);
                wire=wire(randperm(length(wire)));
                wire(D{1}.blipCount(i)+1:end)=[];
                sieve(wire)=1;
            end
        end
    else
        sieve = ones(1,length(D));
    end
    
    if plotCase == 1
        prompt = {'How long is the required pre-blank period?'};
        dlg_title = 'PreBlankPeriod';
        num_lines = 1;
        defaultans = {'550'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
        preblank = str2double(answer);
        LoT = ceil(max(D{1}.nFrames)*D{1}.TF);%Length of timeline
    else
        preblank = 101;
        LoT = 501;
    end
    
    %summary = ones(D{1}.nDr,3,tpc,length(D{1}.eyeXvws)+5-cutoff)*NaN;
    summary = ones(D{1}.nDr,3,tpc,LoT)*NaN;
    tC=ones(D{1}.nDr,3);%trialCounter
    for i = 1:length(D)
        if sieve(i) ==1
            if plotCase == 1
                tBlankOn = D{i}.tBlankStart-D{i}.tFixation;
                cutoff = tBlankOn - preblank;
                summary(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2,tC(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2),1:length(D{i}.eyeXvws)-cutoff)= D{i}.eyeXvws(cutoff+1:end);
            else
                if D{1}.paraTrial(4,i) ~= 0
                    tBlipStart = D{i}.tBlipStart-D{i}.tFixation;
                else
                    %tBlipStart = D{1}.durFix+D{1}.durBlank+blipStart;
                    tBlipStart = D{1}.durFix(i)+D{1}.durBlank+350; %!!!!!!!!!!!!!!!!!!!!!TÖTE MICH!!!!!!!!!!!
                end
                summary(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2,tC(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2),1:501)= D{i}.eyeXvws((-100:400)+tBlipStart);
            end
            tC(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2)=tC(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2)+1;
        else
            continue;
        end
    end
    
    %% divide each sum through the amount of trials it had
    avBlip = zeros(D{1}.nDr,3,LoT);
    sdBlip = zeros(D{1}.nDr,3,LoT);
    for n = 1:D{1}.nDr
        for b = 1:3
            for tt = 1:LoT
                if plotCase == 0
                    avBlip(n,b,tt) = nanmean(summary(n,b,:,tt));
                    sdBlip(n,b,tt) = nanstd(summary(n,b,:,tt));
                else
                    avPlot(n,b,tt) = nanmean(summary(n,b,:,tt));
                    sdPlot(n,b,tt) = nanstd(summary(n,b,:,tt));
                end
            end
        end
    end
    
    if plotCase == 0
        D{1}.randBlip = random;
        D{1}.avBlip = avBlip;
    else
        D{1}.randPlot = random;
        D{1}.avPlot = avPlot;
    end
    
end

%% save & plot
if plotCase == 0
    D{1}.avBlip = avBlip;
else
    D{1}.avPlot = avPlot;
    z = 1;
    while z ~= length(D)
        if isnan(D{z}.tBlipStart) == 0
            tBlipOn = D{z}.tBlipStart-D{z}.tBlankStart;
            tBlipOff = D{z}.tBlipStop-D{z}.tBlankStart;
            z = length(D);
        else
            z = z+1;
        end
    end
    tBlankOn = 0;
    tMoveOn = D{z}.tMoveStart-D{z}.tBlankStart;
    tMoveOff = D{z}.tMoveStop-D{z}.tBlankStart;
    tPause = D{z}.tPauseStart-D{z}.tBlankStart;
    tEnd = D{z}.tTrialEnd-D{z}.tBlankStart;
end

for i = 1:2
    axes(ax(3+i));
    cla;
    hold on;
    if plotCase == 0
        plot([1:length(D{1}.avBlip(i,1,:))]-preblank,permute(D{1}.avBlip(i,1,:),[3 1 2]),'r');
        plot([1:length(D{1}.avBlip(i,2,:))]-preblank,permute(D{1}.avBlip(i,2,:),[3 1 2]),'b');
        plot([1:length(D{1}.avBlip(i,3,:))]-preblank,permute(D{1}.avBlip(i,3,:),[3 1 2]),'g');
        plot([-100 length(D{1}.avBlip(1,1,:))-101],[0 0],'k');
        set(ax(3+i),'xlim',[-100 400],'ylim',[-10 10]+(-1)^i*ceil(D{trn}.v_target/5)*5)
    else
        plot([1:length(D{1}.avPlot(i,1,:))]-preblank,permute(D{1}.avPlot(i,1,:),[3 1 2]),'r');
        plot([1:length(D{1}.avPlot(i,2,:))]-preblank,permute(D{1}.avPlot(i,2,:),[3 1 2]),'b');
        plot([1:length(D{1}.avPlot(i,3,:))]-preblank,permute(D{1}.avPlot(i,3,:),[3 1 2]),'g');
        plot([-100 length(D{1}.avPlot(1,1,:))-101],[0 0],'k');
        plot(tBlankOn*[1 1],[-50 50],'k');
        plot(tMoveOn*[1 1],[-50 50],'k');
        plot(tBlipOn*[1 1],[-50 50],'c');
        plot(tBlipOff*[1 1],[-50 50],'c');
        plot(tMoveOff*[1 1],[-50 50],'k');
        plot(tPause*[1 1],[-50 50],'k');
        plot(tEnd*[1 1],[-50 50],'k');
        set(ax(3+i),'xlim',[-preblank tEnd],'ylim',[i-2 i-1]*ceil(D{trn}.v_target/7)*7);
    end
    plot([0 0],[-40 40],'k');
    legend('de/in-blip','0-blip','in/de-blip');
end

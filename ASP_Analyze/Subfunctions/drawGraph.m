function [plotData] = drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw)

if auto == 0
    prompt = {'Direction:','Previous Dr','Position in Sequence','Previous PiS','Blip Condition','# of Block','Subject ID','Type of Stimulation','Blank Good?','Blip Good?'};
    dlg_title = 'Graph-Parameters';
    num_lines = 1;
    defaultans = {'1','0','[2 3 4 5]','0','0','0','99','0','0','0'};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    
    for i = 1:10
        plotData.para(numPlot,i,1:length(str2num(answer{i})))= str2num(answer{i});
        lAnsw(i) = length(str2num(answer{i}));
    end
    
end

%% Create the sieve
[sieve,NoAT,NoGT] = dataSieve(C,plotData,numPlot,lAnsw);

%% sum up values for each condition and time point, than average and sd
if auto == 0
    prompt = {'pre-blank period [ms]','post-stop period [ms]'};
    dlg_title = 'BaselinePeriod';
    num_lines = 1;
    defaultans = {'0','0'};
    baseline = inputdlg(prompt,dlg_title,num_lines,defaultans);
    plotData.preblank(numPlot) = str2double(baseline{1});%time period in plotdata before blank onset
    plotData.poststop(numPlot) = str2double(baseline{2});%time period in plotdata after target finally disappears
end

LoT = length(C.eyeXvws(:,1));%length of timeline
numTrials = length(C.paraTrials(1,:));
summary = ones(LoT,sum(sieve))*NaN;
maxTV = 0;%maximal target velocity
tC = 1;
EA_vOn = ones(1,numTrials)*NaN;
RA_vOn = ones(1,numTrials)*NaN;

for i = 1:numTrials
    if sieve(i) == 1
        cutoff1 = C.tEvents(2,i) - plotData.preblank(numPlot);
        cutoff2 = C.tEvents(7,i) + plotData.poststop(numPlot);
        summary(1:(cutoff2-cutoff1),tC)= C.eyeXvws(cutoff1+1:cutoff2,i);
        tC = tC+1;
        RA_vOn(i) = C.realVOn(i);
        if ~isnan(C.estVOn(i))
            EA_vOn(i) = C.estVOn(i);
        end
        if max(abs(C.target_v(:,i))) >= maxTV
            maxTV = max(abs(C.target_v(:,i)));
        end
    end
end

plotData.LoT = ceil((cutoff2-cutoff1)/100)*100;
summary(plotData.LoT+1:end,:)=[];

%% Fill data into plotData and draw graph
color = {[0.75 0 1];[1 0.25 0];[1 0.5 0];[0.25 0.75 0];[0 0.75 0.75];[0 0.25 1]};
% plot target
if ~isempty(plotData.av(numPlot,:))
    cmd = 6;plotControl;
end
plotData.av(numPlot,1:plotData.LoT) = nanmean(summary');
plotData.av(:,plotData.LoT+1:end) = [];
plotData.sd(numPlot,1:plotData.LoT) = nanstd(summary');
plotData.sd(:,plotData.LoT+1:end) = [];
plotData.tC(numPlot) = tC;
plotData.maxTV(numPlot) = maxTV;

for s = 1:10
    uicontrol('Style','text','String',permute(plotData.para(numPlot,s,1:lAnsw(s)),[3 2 1])','Visible','on','units','normalized','Position', [0.70+numPlot/30 0.90-0.025*(s-1) 0.05 0.025]);
end

plotData.avData(numPlot,1)= NoGT;
plotData.avData(numPlot,2)= 100*NoGT/NoAT;

uicontrol('Style','text','String',plotData.avData(numPlot,1),'Visible','on','units','normalized','Position', [0.70+numPlot/30 0.525 0.05 0.025]);
uicontrol('Style','text','String',round(plotData.avData(numPlot,2)),'Visible','on','units','normalized','Position', [0.70+numPlot/30 0.500 0.05 0.025]);
plotData.avData(numPlot,3) = nanmean(EA_vOn);
plotData.avData(numPlot,4) = nanmean(RA_vOn);
plotData.avData(numPlot,5) = plotData.av(numPlot,tMoveOn+plotData.preblank(numPlot)+100);
plotData.avData(numPlot,6) = (100*sum(~isnan(EA_vOn))/NoGT);
plotData.avData(numPlot,7) = nanstd(EA_vOn);
plotData.avData(numPlot,8) = nanstd(RA_vOn);
plotData.avData(numPlot,9) = std(summary(tMoveOn+plotData.preblank(numPlot)+100,:));
for s = 1:7
    if s == 4
    uicontrol('Style','text','String',round(plotData.avData(numPlot,6)),'Visible','on','units','normalized','Position', [0.70+numPlot/30 0.45-0.025*(s-1) 0.05 0.025]);    
    else    
    uicontrol('Style','text','String',plotData.avData(numPlot,s+2),'Visible','on','units','normalized','Position', [0.70+numPlot/30 0.45-0.025*(s-1) 0.05 0.025]);
    end
end    
axes(ax(1));
hold on; %hold all previous axes
plotData.fig1(numPlot) = plot([1:plotData.LoT], plotData.av(numPlot,:),'Color',color{numPlot});%average eye velocity without saccade for this condition
axes(ax(3));
hold on; %hold all previous axes
plotData.fig3(numPlot) = plot([1:plotData.LoT], plotData.sd(numPlot,:),'Color',color{numPlot});%sd of average eye velocity for this condition

end
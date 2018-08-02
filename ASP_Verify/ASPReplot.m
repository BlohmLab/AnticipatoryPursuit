%% Plot position, velocity and acceleration data for single trial
origPath = 'D:\Master\Program\ASPVerify';
if firstload == 1
    savePath = 'D:\Master\Data\02_Loaded';
else
    savePath = pathname1;
end

if isempty(D) %Error in case data can't be found
    fprintf('D is empty. Something wrong with loading data.');
    return
end

N = D{1}.numTrials; % N = numTrials // trn = trial number {1,N}
if trn < 1, trn = 1; end
if trn > N, trn = N; end
ASPGoodBadToggle;

filestr = D{1}.dFilename(1:end-5);
set(f,'name',['ASPAI: Anticipatory SP Analysis Interface: ' filestr ',trial #: ' num2str(trn)]);

%% - Draw plots for postion, velocity, acceleration

for a = 1:3
    axes(ax(a));
    cla reset; %Clear axes
    hold on; %hold all previous axes
    plot([0 length(D{trn}.eyeX)], [0 0],'k');
    plot(tBlankOn*[1 1],[-5500 5500],'k');
    plot(tMoveOn*[1 1],[-5500 5500],'k');
    plot(D{trn}.SPoff*[1 1],[-50 50],'Color',[0 0.8 0.8]);
    plot(tBlipOn*[1 1],[-5500 5500],'Color',[0 0.25 1]);
    plot((tBlipOff+200)*[1 1],[-5500 5500],'Color',[0 0.25 1]);
    plot(tMoveOff*[1 1],[-5500 5500],'Color',[0.25 0.25 0.25]);
    plot(tPause*[1 1],[-5500 5500],'Color',[0.25 0.25 0.25]);
    
    %plot position
    if a == 1
        %eyeX = plot(D{trn}.t, D{trn}.eyeX - D{trn}.eyeX(500),'r'); %plot of eye position in X
        %eyeY = plot(D{trn}.t, D{trn}.eyeY - D{trn}.eyeY(500),'Color',[0.75 0 0.75]); %plot of eye position in Y
        eyeX = plot(D{trn}.t, D{trn}.eyeX,'r'); %plot of eye position in X
        eyeY = plot(D{trn}.t, D{trn}.eyeY,'Color',[0.75 0 0.75]); %plot of eye position in Y
        tarX = plot(D{trn}.tTarget, rad2deg(atan((D{trn}.target_x(1:D{1}.nFrames(trn))- D{1}.centerWidth)/D{1}.distToScreen/D{1}.ppcmx)),'g');%plot of target position in X
        legend([eyeX eyeY tarX],{'Position Eye (X)', 'Position Eye (Y)', 'Position Target (X)'},'Location','northwest');%, 'X without sacc');
        set(ax(1),'xlim',[0 length(D{trn}.eyeX)],'ylim',[-30 30]);
        %set(ax(1),'xlim',[766 2416],'ylim',[-30 30]);
    end
    
    %plot velocity
    if a == 2
        eyeV = plot(D{trn}.t, D{trn}.eyeXv,'r'); %plot of eye velocity in X
        tarV = plot(D{trn}.tTarget, D{trn}.target_v(1:D{1}.nFrames(trn)),'g'); %plot of target velocity in X
        eyeVws = plot(D{trn}.t, D{trn}.eyeXvws,'r'); %plot eye velocity without saccades in X
        if isnan(D{trn}.beOn) ~= 1
            SPonset = plot(D{trn}.SPon*[1 1],[-50 50],'Color',[0 0.8 0.8]);
            DetOnset = plot(D{trn}.detOn*[1 1],[-50 50],'Color',[0 0.8 0.8]);
            ASPlot = plot(D{trn}.SPon:D{trn}.SPoff, D{trn}.ASPlot(~isnan(D{trn}.ASPlot)),'Color',[0 0 0]);
            realVOn = plot([D{trn}.SPoff-10 D{trn}.SPoff+10], D{trn}.realVOn*[1 1],'k');
        end
        legend([eyeV tarV eyeVws],{'X-Velocity Eye', 'X-Velocity Target'},'Location','northwest');%, 'V without sacc');
        set(ax(2),'xlim',[0 length(D{trn}.eyeXv)],'ylim',[-40 40]);
        %set(ax(2),'xlim',[766 2416],'ylim',[-40 40]);
    end
    
    %plot acceleration
    if a == 3
        eyeA = plot(D{trn}.t, D{trn}.eyeXa,'r'); %plot of eye acceleration in X
        tarA = plot(D{trn}.tTarget, D{trn}.target_a(1:D{1}.nFrames(trn))*500,'g'); %plot of target acceleration in X
        legend([eyeA tarA],{'X-Acceleration Eye', 'X-Acceleration Target'},'Location','northwest');%, 'A without sacc');
        set(ax(3),'xlim',[0 length(D{trn}.eyeXa)],'ylim',[-1000 1000]);
        %set(ax(3),'xlim',[766 2416],'ylim',[-1000 1000]);
    end
    
end

h.Number = uicontrol('Style','text','String','Trial-Number','Visible','off','units','normalized','Position', [0.82 0.25 0.05 0.025]);
h.lNumber = uicontrol('Style','text','String',num2str(trn),'Visible','off','units','normalized','Position', [0.87 0.25 0.05 0.025]);
h.NiS = uicontrol('Style','text','String','# in Sequenz','Visible','off','units','normalized','Position', [0.82 0.23 0.05 0.025]);
h.lNiS = uicontrol('Style','text','String',num2str(D{1}.paraTrial(2,trn)),'Visible','off','units','normalized','Position', [0.87 0.23 0.05 0.025]);
h.VisOnset = uicontrol('Style','text','String','BlankOn','Visible','off','units','normalized','Position', [0.82 0.20 0.05 0.025]);
h.lVisOnset = uicontrol('Style','text','String',[num2str(tBlankOn+D{1}.delay) ' ms'],'Visible','off','units','normalized','Position', [0.87 0.20 0.05 0.025]);
h.lSPOnset = uicontrol('Style','text','String','ASP_Onset','Visible',' off','units','normalized','Position', [0.82 0.18 0.05 0.025]);
h.SPOnset = uicontrol('Style','text','String',[num2str(D{trn}.SPon) ' ms'],'Visible','off','units','normalized','Position', [0.87 0.18 0.05 0.025]);
h.lDetOnset = uicontrol('Style','text','String','Det_Onset','Visible','off','units','normalized','Position', [0.82 0.16 0.05 0.025]);
h.DetOnset = uicontrol('Style','text','String',[num2str(D{trn}.detOn) ' ms'],'Visible','off','units','normalized','Position', [0.87 0.16 0.05 0.025]);
h.lVOn_335 = uicontrol('Style','text','String','v_335','Visible',' off','units','normalized','Position', [0.82 0.14 0.05 0.025]);
h.VOn_335 = uicontrol('Style','text','String',[num2str(D{trn}.realVOn) ' deg/s'],'Visible','off','units','normalized','Position', [0.87 0.14 0.05 0.025]);
h.lVOn_Max = uicontrol('Style','text','String','v_Max','Visible','off','units','normalized','Position', [0.82 0.12 0.05 0.025]);
h.VOn_Max = uicontrol('Style','text','String',[num2str(D{trn}.maxVOn) ' deg/s'],'Visible','off','units','normalized','Position', [0.87 0.12 0.05 0.025]);
h.lVOn_Est = uicontrol('Style','text','String','v_Est','Visible','off','units','normalized','Position', [0.82 0.10 0.05 0.025]);
h.VOn_Est = uicontrol('Style','text','String',[num2str(D{trn}.estVOn) ' ms'],'Visible','off','units','normalized','Position', [0.87 0.10 0.05 0.025]);
h.lSPDuration = uicontrol('Style','text','String','SP-Duration','Visible','off','units','normalized','Position', [0.82 0.08 0.05 0.025]);
h.SPDuration = uicontrol('Style','text','String',[num2str(D{trn}.SPoff-D{trn}.SPon) ' ms'],'Visible','off','units','normalized','Position', [0.87 0.08 0.05 0.025]);

% finalize
sstr = fieldnames(h);
for i = 1:length(sstr)
    set(eval(['h.' sstr{i}]),'visible','on')
end

%define previous and next 'unclear' trial
c = 0;
nextrn=trn;
while c == 0 && trn ~= D{1}.numTrials
    nextrn = nextrn+1;
    if D{1}.sorting(1,nextrn) == 1 || nextrn >= D{1}.numTrials
        c = 1;
    end
end
c = 0;
lastrn=trn;
while c == 0
    lastrn = lastrn-1;
    if lastrn <= 1 || D{1}.sorting(1,lastrn) == 1
        c = 1;
    end
end

cd(savePath);
save(D{1}.dFilename,'D');
cd(origPath);
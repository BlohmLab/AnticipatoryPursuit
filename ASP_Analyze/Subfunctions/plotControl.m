try
    origPath = 'D:\Master\Program\ASPAnalyze';
    %% Load data
    if cmd == 1
        loadPath = 'D:\Master\Data\03_Combined';
        cd(loadPath);
        [filename1,pathname1] = uigetfile({'*.mat'},'Choose XP record file you want to load....'); %load in mat-file = Trial parameters
        cd(pathname1);
        load([pathname1 filename1]);
        cd(origPath);
        
        %% Create timepoints in plot
    elseif cmd == 2
        z = 1;
        while z ~= length(C.tEvents(1,:))+1
            if isnan(C.tEvents(4,z)) == 0 || z == length(C.tEvents(1,:))
                tBlankOn = 0;
                tMoveOn = C.tEvents(3,z)-C.tEvents(2,z);
                tBlankVis = tMoveOn + 100;
                if isnan(C.tEvents(4,z)) == 0
                    tBlipOn = C.tEvents(4,z)-C.tEvents(2,z);
                    tBlipOff = C.tEvents(5,z)-C.tEvents(2,z);
                    tBlipVis = tBlipOn+100;
                end
                tMoveOff = C.tEvents(6,z)-C.tEvents(2,z);
                tPause = C.tEvents(7,z)-C.tEvents(2,z);
                tStop = C.tEvents(8,z)-C.tEvents(2,z);
                z = length(C.tEvents(1,:))+1;
            else
                z = z+1;
            end
        end
        timePlot = 1;
        ex = 100;
        for a = [1 3]
            axes(ax(a));
            cla; %Clear axes
            hold on; %hold all previous axes
            plot([-1000 3000], [0 0],'k');
            lineBlankOn(a) = plot(tBlankOn*[1 1],[-ex ex],'k');
            lineMoveOn(a) = plot(tMoveOn*[1 1],[-ex ex],'k');
            lineBlankVis = plot((tMoveOn+100)*[1 1],[-ex ex],'Color',[0 0.8 0.8]);
            lineBlipkOn(a) = plot(tBlipOn*[1 1],[-ex ex],'Color',[0 0.25 1]);
            %lineBlipOff(a) = plot(tBlipOff*[1 1],[-ex ex],'Color',[0 0.25 1]);
            lineBlipEnd(a) = plot((tBlipOff+200)*[1 1],[-ex ex],'Color',[0 0.25 1]);
            lineMoveOff(a) = plot(tMoveOff*[1 1],[-ex ex],'Color',[0.25 0.25 0.25]);
            linePause(a) = plot(tPause*[1 1],[-ex ex],'Color',[0.25 0.25 0.25]);
            lineStop(a) = plot(tStop*[1 1],[-ex ex],'Color',[0.25 0.25 0.25]);
        end
        axes(ax(2));
        cla;
        
        %% Resize figure 1
    elseif cmd == 3
        if timePlot == 1
            xmin = -plotData.preblank(numPlot);
            xmax = plotData.LoT-plotData.preblank(numPlot);
        elseif timePlot == 2
            xmin = tBlankOn;
            xmax = tBlankOn + 600;
        elseif timePlot == 3
            xmin = tBlipOn;
            xmax = tBlipOn + 600;
        end
        
        ymin1 = 50;
        ymax1 = -50;
        for p = 1:4
            if sum(plotData.av(p,:)) ~= 0
                if min(plotData.av(p,(xmin+1:xmax)+plotData.preblank(p))) <= ymin1
                    ymin1 = floor(min(plotData.av(p,(xmin+1:xmax)+plotData.preblank(p)))/5)*5;
                end
                if max(plotData.av(p,(xmin+1:xmax)+plotData.preblank(p))) >= ymax1
                    ymax1 = ceil(max(plotData.av(p,(xmin+1:xmax)+plotData.preblank(p)))/5)*5;
                end
            end
        end
        if ymin1 <= -50
            ymin1 = -50;
        end
        if ymax1 >= 50
            ymax1 = 50;
        end
        if ymin1 >= ymax1
            ymin1 = 0;ymax1=1;
        end
        set(ax(1),'xlim',[xmin xmax],'ylim',[ymin1 ymax1]);
    end
    %% Resize figure 2
    if cmd == 4
        if timePlot == 1
            xmin = -plotData.preblank(numPlot);
            xmax = plotData.LoT-plotData.preblank(numPlot);
        elseif timePlot == 2
            xmin = tBlankOn;
            xmax = tBlankOn + 600;
        elseif timePlot == 3
            xmin = tBlipOn;
            xmax = tBlipOn + 600;
        end
        
        ymin2 = 50;
        ymax2 = -50;
        for p = 1:4
            if sum(plotData.sub(p,:)) ~= 0
                if min(plotData.sub(p,(xmin+1:xmax-500)+plotData.preblank(p))) <= ymin2
                    ymin2 = floor(min(plotData.sub(p,(xmin+1:xmax)+plotData.preblank(p)))*0.5)/0.5;
                end
                if max(plotData.sub(p,(xmin+1:xmax-500)+plotData.preblank(p))) >= ymax2
                    ymax2 = ceil(max(plotData.sub(p,(xmin+1:xmax)+plotData.preblank(p)))/1);
                end
            end
        end
        if ymin2 <= -50
            ymin2 = -50;
        end
        if ymax2 >= 50
            ymax2 = 50;
        end
        if ymin2 >= ymax2
            ymin2 = 0;ymax2=1;
        end
        set(ax(2),'xlim',[xmin xmax],'ylim',[ymin2 ymax2]);
        
        %% Resize figure 3
    end
    if cmd == 3 || cmd == 5
        if timePlot == 1
            xmin = -plotData.preblank(numPlot);
            xmax = plotData.LoT-plotData.preblank(numPlot);
        elseif timePlot == 2
            xmin = tBlankOn;
            xmax = tBlankOn + 600;
        elseif timePlot == 3
            xmin = tBlipOn;
            xmax = tBlipOn + 600;
        end
        
        ymin3 = 15;
        ymax3 = -15;
        for p = 1:4
            if sum(plotData.sd(p,:)) ~= 0
                if min(plotData.sd(p,(xmin+1:xmax)+plotData.preblank(p))) <= ymin3
                    ymin3 = floor(min(plotData.sd(p,(xmin+1:xmax)+plotData.preblank(p)))/1);
                end
                if max(plotData.sd(p,(xmin+1:xmax)+plotData.preblank(p))) >= ymax3
                    ymax3 = ceil(max(plotData.sd(p,(xmin+1:xmax)+plotData.preblank(p)))/1);
                end
            end
        end
        if ymin3 <= -20
            ymin3 = -20;
        end
        if ymax3 >= 20
            ymax3 = 20;
        end
        if ymin3 >= ymax3
            ymin3 = 0;ymax3=0.1;
        end
        set(ax(3),'xlim',[xmin xmax],'ylim',[ymin3 ymax3]);
        
        %% Delete an old plot in fig 1 - fig 3
    elseif cmd == 6
        set(plotData.fig1(numPlot),'Visible','off');
        if isfield(plotData,'fig2')
            axes(ax(2));
            set(plotData.fig2(numPlot),'Visible','off');
        end
        if isfield(plotData,'fig3')
            axes(ax(3));
            set(plotData.fig3(numPlot),'Visible','off');
        end
        plotData.av(numPlot,:) = NaN;
        plotData.sub(numPlot,:) = NaN;
        plotData.sd(numPlot,:) = NaN;
        for s = 1:8
            uicontrol('Style','text','String','         ','Visible','on','units','normalized','Position', [0.70+numPlot/20 0.90-0.025*(s-1) 0.05 0.025]);
        end
        uicontrol('Style','text','String','         ','Visible','on','units','normalized','Position', [0.70+numPlot/20 0.625 0.05 0.025]);
        uicontrol('Style','text','String','         ','Visible','on','units','normalized','Position', [0.70+numPlot/20 0.600 0.05 0.025]);
        for s = 1:7
            uicontrol('Style','text','String','         ','Visible','on','units','normalized','Position', [0.70+numPlot/20 0.55-0.025*(s-1) 0.05 0.025]);
        end
        
        %% Delete old plots in fig 2
    elseif cmd == 7
        for o = 1:4
            axes(ax(2));
            set(plotData.fig2(o),'Visible','off');
            plotData.sub(o,:) = NaN;
        end
    end
catch
    cd(origPath)
end
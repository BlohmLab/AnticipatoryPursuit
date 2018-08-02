origPath = 'D:\Master\Program\ASPAnalyze';
try
    color = {[0.75 0 1]; [1 0.25 0]; [0.5 1 0]; [0 0.5 1]};
    %% Invert plot
    if cmd == 1
        axes(ax(1));
        hold on; %hold all previous axes
        if ~isempty(plotData.fig1(numPlot))
            set(plotData.fig1(numPlot),'Visible','off');
            clear plotData.fig1(numPlot) = [];
            plotData.av(numPlot,:) = -plotData.av(numPlot,:);
            plotData.fig1(numPlot) = plot([1:length(plotData.av(numPlot,:))]-plotData.preblank(numPlot), plotData.av(numPlot,:),'Color',color{numPlot});
        end
        
        %% Subtract plot
    elseif cmd == 2
        cmd = 7;plotControl;
        for n = 1:4
            axes(ax(2));
            hold on;
            if sum(plotData.av(n,:)) ~= 0
                plotData.sub(n,1:length(plotData.av(n,:))) = plotData.av(n,:) - plotData.av(numPlot,:);
                plotData.fig2(n) = plot([1:length(plotData.sub(n,:))]-plotData.preblank(n), plotData.sub(n,:),'Color',color{n});
            end
        end
        set(ax(2),'xlim',[xmin xmax],'ylim',[ymin ymax]);
        
        %% Calculate ASP-Amplitudes
    elseif cmd == 3
        plotData.blipData=ones(2,6)*NaN;
        if plotData.avData(2,3) >= 0 %positive
            [Max1,Mxi1] = max(plotData.sub(3,750:950));
            [Max2,Mxi2] = max(plotData.sub(1,850:1050));
            [Max3,Mxi3] = max(plotData.sub(3,950:1150));
            [Min1,Mni1] = min(plotData.sub(1,750:950));
            [Min2,Mni2] = min(plotData.sub(3,850:1050));
            [Min3,Mni3] = min(plotData.sub(1,950:1150));
            Fac = 1;
        else %negative
            [Max1,Mxi1] = min(plotData.sub(3,750:950));
            [Max2,Mxi2] = min(plotData.sub(1,850:1050));
            [Max3,Mxi3] = min(plotData.sub(3,950:1150));
            [Min1,Mni1] = max(plotData.sub(1,750:950));
            [Min2,Mni2] = max(plotData.sub(3,850:1050));
            [Min3,Mni3] = max(plotData.sub(1,950:1150));
            Fac = -1;
        end
        plotData.blipData(1,1)=Fac*Min1;
        plotData.blipData(1,2)=Mni1+749;
        plotData.blipData(1,3)=Fac*Max2;
        plotData.blipData(1,4)=Mxi2+849;
        plotData.blipData(1,5)=Fac*Min3;
        plotData.blipData(1,6)=Mni3+949;
        plotData.blipData(2,1)=Fac*Max1;
        plotData.blipData(2,2)=Mxi1+749;
        plotData.blipData(2,3)=Fac*Min2;
        plotData.blipData(2,4)=Mni2+849;
        plotData.blipData(2,5)=Fac*Max3;
        plotData.blipData(2,6)=Mxi3+949;
        
        %% Calculate % of saccades at each time point
    elseif cmd == 4
        
        % Define total amount of trials and time points
        C.numTrials = length(C.paraTrials(1,:));
        C.trialLength = length(C.eyeXv(:,1));
        
        %Define which trials to average
        if sacOption == 1 %Total saccade count
            sieve(1,1:C.numTrials) = ones(1,C.numTrials);
            NoAT = C.numTrials;
            sacPlots = 1;
        else
            sacPlots = sum(~isnan(plotData.para(:,1,1)));
            for n = 1:sacPlots
                for s = 1:8
                    lAnsw(n,s)=sum(~isnan(plotData.para(n,s,:)));
                end    
                [sieve(n,1:C.numTrials),NoAT(n),NoGT(n)] = dataSieve(C,plotData,n,lAnsw(n,:));
            end
        end
        C.perSacc = zeros(sacPlots,C.trialLength);
        
        for n = 1:sacPlots
            % Sum up number of times timepoint was in saccade
            for i = 1:C.numTrials
                if sieve(n,i) == 1
                    for t = 1:C.trialLength
                        C.perSacc(n,t) = C.perSacc(n,t) + (C.eyeXv(t,i) == C.eyeXvws(t,i));
                    end
                end
            end
            
            % Calculate total saccade percentage for each time point
            perSacControl(n,:) = C.perSacc(n,:);%!!!!!!!!!!!!!!TÖTE MICH!!!!!!!!!!!
            C.perSacc(n,:) = C.perSacc(n,:)*100/NoGT(n);
            % Draw graph on axis 2
            axes(ax(2));
            hold on;
            plotData.fig2(n) = plot([1:C.trialLength]-C.tEvents(2,1), C.perSacc(n,:),'Color',color{n});
        end
        
        % Display lines on axis 2
        axes(ax(2));
        hold on;
        ex = 100;
        lineBlankOn(2) = plot(tBlankOn*[1 1],[-ex ex],'b');
        lineMoveOn(2) = plot(tMoveOn*[1 1],[-ex ex],'b');
        lineBlipkOn(2) = plot(tBlipOn*[1 1],[-ex ex],'c');
        lineBlipOff(2) = plot(tBlipOff*[1 1],[-ex ex],'c');
        lineMoveOff(2) = plot(tMoveOff*[1 1],[-ex ex],'b');
        linePause(2) = plot(tPause*[1 1],[-ex ex],'b');
        lineStop(2) = plot(tStop*[1 1],[-ex ex],'b');
        %set(ax(2),'xlim',[1 C.trialLength]-C.tEvents(2,1),'ylim',[0 100]);
        set(ax(2),'xlim',[xmin xmax],'ylim',[0 100]);
        ylabel('No saccades [%]');
        
    end
catch
end
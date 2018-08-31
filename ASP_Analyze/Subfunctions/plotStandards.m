try
prompt = {'pre-blank period [ms]','post-stop period [ms]'};
dlg_title = 'BaselinePeriod';
num_lines = 1;
defaultans = {'0','0'};
baseline = inputdlg(prompt,dlg_title,num_lines,defaultans);
plotData.preblank(1:6) = str2double(baseline{1});%time period in plotdata before blank onset
plotData.poststop(1:6) = str2double(baseline{2});%time period in plotdata after target finally disappears
auto = 1;
plotData.para = ones(6,10,12)*NaN;
    %% - Direction Bias -
    if cmd == 1
        plotData.para([1 3],1,1) = deal(1);
        plotData.para([2 4],1,1) = deal(2);
        plotData.para(1:4,2,1) = deal(0);
        plotData.para(1,3,1:4) = [2 3 4 5];
        plotData.para(2,3,1:4) = [2 3 4 5];
        plotData.para([3 4],3,1) = deal(1);
        plotData.para(1:4,4,1) = deal(0);
        plotData.para(1:4,5:6,1) = deal(0);
        plotData.para(1:4,7,1) = deal(99);
        plotData.para(1:4,8:10,1) = deal(0);
        plots = [1 2 3 4];
        cmd=6; numPlot=5; plotControl; % Delete Plot 5
        cmd=6; numPlot=6; plotControl; % Delete Plot 6
        
        %% - Position in Sequence / 2:Dr 1 (left) / 3:Dr 2 (right) -
    elseif cmd == 2 || cmd == 3
        plotData.para(1:5,1,1) = deal(cmd-1);
        plotData.para(1:5,2,1) = deal(0);
        for i = 1:5
            plotData.para(i,3,1) = i;
        end
        plotData.para(1:5,4,1) = deal(0);
        plotData.para(1:5,5:6,1) = deal(0);
        plotData.para(1:5,7,1) = deal(99);
        plotData.para(1:5,8:10,1) = deal(0);
        plots = [1 2 3 4 5];
        cmd=6; numPlot=6; plotControl; % Delete Plot 6
        
        %% - Previous PiS / 2:Dr 1 (left) / 3:Dr 2 (right) -
    elseif cmd == 4 || cmd == 5
        plotData.para(1:5,1,1) = deal(0);
        plotData.para(1:5,2,1) = deal(cmd-3);
        plotData.para(1:5,3,1) = deal(0);
        for i = 1:5
            plotData.para(i,4,1) = i;
        end
        plotData.para(1:5,5:6,1) = deal(0);
        plotData.para(1:5,7,1) = deal(99);
        plotData.para(1:5,8:10,1) = deal(0);
        plots = [1 2 3 4 5];
        cmd=6; numPlot=6; plotControl; % Delete Plot 6
        
        %% - Learning over Time / 4:Dr 1 (left) / 5:Dr 2 (right) -
    elseif cmd == 6 || cmd == 7
        plotData.para([1 3 4],1,1) = deal(cmd-5);
        plotData.para([1 3 4],2,1) = deal(0);
        plotData.para(1,3,1:4) = [2 3 4 5];
        plotData.para(3,3,1:4) = [2 3 4 5];
        plotData.para(4,3,1:4) = [2 3 4 5];
        plotData.para([1 3 4],4,1) = deal(0);
        plotData.para([1 3 4],5,1) = deal(0);
        plotData.para(1,6,1:6) = 1:6;
        plotData.para(3,6,1:6) = 7:12;
        plotData.para(4,6,1:6) = 13:18;
        plotData.para([1 3 4],7,1) = deal(99);
        plotData.para([1 3 4],8:10,1) = deal(0);
        plots = [1 3 4];
        cmd=6; numPlot=2; plotControl; % Delete Plot 4
        cmd=6; numPlot=5; plotControl; % Delete Plot 5
        cmd=6; numPlot=6; plotControl; % Delete Plot 6
        
        %% - Reaction to Perturbation / 6:Dr 1 (left) / 7:Dr 2 (right) -
    elseif cmd == 8 || cmd == 9
        plotData.para([1 3 4],1,1) = deal(cmd-7);
        plotData.para([1 3 4],2,1) = deal(0);
        plotData.para(1,3,1:4) = [2 3 4 5];
        plotData.para(3,3,1:4) = [2 3 4 5];
        plotData.para(4,3,1:4) = [2 3 4 5];
        plotData.para([1 3 4],4,1) = deal(0);
        plotData.para(1,5,1) = 1;
        plotData.para(3,5,1) = 2;
        plotData.para(4,5,1) = 3;
        plotData.para([1 3 4],6,1) = deal(0);
        plotData.para([1 3 4],7,1) = deal(99);
        plotData.para([1 3 4],8:10,1) = deal(0);
        plots = [1 3 4];
        cmd=6; numPlot=2; plotControl; % Delete Plot 4
        cmd=6; numPlot=5; plotControl; % Delete Plot 5
        cmd=6; numPlot=6; plotControl; % Delete Plot 6
        
    end
    for i = 1:length(plots)
        numPlot = plots(i);
        for l = 1:10
            lAnsw(l) = sum(~isnan(plotData.para(numPlot,l,:)));
        end
        [plotData] = drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);
    end
    cmd=3;
    plotControl;
    auto = 0;
catch
end
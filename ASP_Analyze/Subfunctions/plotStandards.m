try
prompt = {'pre-blank period [ms]','post-stop period [ms]'};
dlg_title = 'BaselinePeriod';
num_lines = 1;
defaultans = {'0','0'};
baseline = inputdlg(prompt,dlg_title,num_lines,defaultans);
plotData.preblank(1:4) = str2double(baseline{1});%time period in plotdata before blank onset
plotData.poststop(1:4) = str2double(baseline{2});%time period in plotdata after target finally disappears
auto = 1;
plotData.para = ones(4,8,12)*NaN;
    %% - Direction Bias -
    if cmd == 1
        plotData.para([1 3],1,1) = deal(1);
        plotData.para([2 4],1,1) = deal(2);
        plotData.para(1,2,1:4) = [2 3 4 5];
        plotData.para(2,2,1:4) = [2 3 4 5];
        plotData.para([3 4],2,1) = deal(1);
        plotData.para(:,3,1) = deal(1);
        plotData.para(:,4:6,1) = deal(0);
        %plotData.para(:,7:8,1) = deal(2);
        plotData.para(:,7,1) = deal(2);
        plotData.para(:,8,1) = deal(0);
        numofplots = 4;
        
        %% - Number in Sequence / 2:Dr 1 (left) / 3:Dr 2 (right) -
    elseif cmd == 2 || cmd == 3
        plotData.para(:,1,1) = deal(cmd-1);
        plotData.para(1,2,1) = 1;
        plotData.para(2,2,1) = 2;
        plotData.para(3,2,1:2) = [3 4];
        plotData.para(4,2,1) = 5;
        plotData.para(:,3,1) = deal(1);
        plotData.para(:,4:6,1) = deal(0);
        plotData.para(:,7:8,1) = deal(2);
        numofplots = 4;
        
        %% - Learning over Time / 4:Dr 1 (left) / 5:Dr 2 (right) -
    elseif cmd == 4 || cmd == 5
        plotData.para(:,1,1) = deal(cmd-3);
        plotData.para(1,2,1:4) = [2 3 4 5];
        plotData.para(2,2,1:4) = [2 3 4 5];
        plotData.para(3,2,1:4) = [2 3 4 5];
        plotData.para(4,2,1:4) = [2 3 4 5];
        plotData.para(1:3,3,1) = deal(1);
        plotData.para(1:3,4,1) = deal(0);
        plotData.para(1,5,1:6) = 1:6;
        plotData.para(2,5,1:6) = 7:12;
        plotData.para(3,5,1:6) = 13:18;
        plotData.para(1:3,6,1) = deal(0);
        plotData.para(1:3,7,1) = deal(0);
        plotData.para(1:3,8,1) = deal(0);
        numofplots = 4;
        
        %% - Reaction to Perturbation / 6:Dr 1 (left) / 7:Dr 2 (right) -
    elseif cmd == 6 || cmd == 7
        plotData.para(1:3,1,1) = deal(cmd-5);
        plotData.para(1,2,1:4) = [2 3 4 5];
        plotData.para(2,2,1:4) = [2 3 4 5];
        plotData.para(3,2,1:4) = [2 3 4 5];
        plotData.para(1:3,3,1) = deal(1);
        plotData.para(1,4,1) = 1;
        plotData.para(2,4,1) = 2;
        plotData.para(3,4,1) = 3;
        plotData.para(1:3,5:6,1) = deal(0);
        %plotData.para(:,7:8,1) = deal(2);
        plotData.para(:,7,1) = deal(0);
        plotData.para(:,8,1) = deal(2);
        numofplots = 3;
        
    end
    for numPlot = 1:numofplots
        for l = 1:8
            lAnsw(l) = sum(~isnan(plotData.para(numPlot,l,:)));
        end
        [plotData] = drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);
    end
    cmd=3;
    plotControl;
    auto = 0;
catch
end
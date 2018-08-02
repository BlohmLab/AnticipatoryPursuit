% ASP Experiment Analysis interface
clear
warning off
RectRight = 3;
origPath = 'D:\Master\Program\ASPAnalyze';
addpath('D:\Master\Program\ASPAnalyze\Subfunctions','D:\Felix\Program\ASPAnalyze\MES');

timePlot = 1;
plotData = [];
plotData.av = zeros(4,1);
plotData.sd = zeros(4,1);
plotData.sub = zeros(4,1);
plotData.preblank = zeros(1,4);
plotData.poststop = zeros(1,4);
plotData.para = ones(4,8,12)*NaN;
auto = 0;
lAnsw = ones(1,8)*NaN;  
%% create figure
f = figure('Name','ASP Analysis Interface','Units','normalized','Position',[.01 .01 .98 .94],'toolbar','none','NumberTitle','off');

% create axes
ylab = {'Velocity [degree/s]','Difference [degree/s]','SD[degree/s]' };
for i = 1:3
    ax(i) = axes('Units','normalized','Position',[.05 1.02-i*.32 .45 .28]);
    ylabel(ylab{i});
end
xlabel('Time (ms)')

%%%%%%%%%%%%
%% add menu items
%plotControl: 1 - Load // 2 - Timepoints // 3 - Resize figure // 4 - Delete plot 
%plotChange:  1 - Invert // 2 - Subtract
gm(1) = uimenu('label','File');
gm(2) = uimenu(gm(1),'label','Load existing file','callback','cmd=6;plotControl;cmd=1;plotControl;cmd=2;plotControl');
gm(3) = uimenu(gm(1),'label','Create new file','callback','dataCombine;cmd=2;plotControl;cmd=1;plotControl;cmd=2;plotControl');
gm(4) = uimenu('label','Create new plot');
gm(5) = uimenu(gm(4),'label','Graph A','callback','numPlot=1;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(6) = uimenu(gm(4),'label','Graph B','callback','numPlot=2;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(7) = uimenu(gm(4),'label','Graph C','callback','numPlot=3;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(8) = uimenu(gm(4),'label','Graph D','callback','numPlot=4;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(9) = uimenu('label','Delete plot');
gm(10) = uimenu(gm(9),'label','Graph A','callback','cmd=6;numPlot=1;plotControl;cmd=3;plotControl');
gm(11) = uimenu(gm(9),'label','Graph B','callback','cmd=6;numPlot=2;plotControl;cmd=3;plotControl');
gm(12) = uimenu(gm(9),'label','Graph C','callback','cmd=6;numPlot=3;plotControl;cmd=3;plotControl');
gm(13) = uimenu(gm(9),'label','Graph D','callback','cmd=6;numPlot=4;plotControl;cmd=3;plotControl');
gm(14) = uimenu('label','Timeframe');
gm(15) = uimenu(gm(14),'label','Complete','callback','cmd=3;timePlot=1;plotControl');
gm(16) = uimenu(gm(14),'label','Blank','callback','cmd=3;timePlot=2;plotControl');
gm(17) = uimenu(gm(14),'label','Blip','callback','cmd=3;timePlot=3;plotControl');
gm(18) = uimenu('label','Manipulate plot');
gm(19) = uimenu(gm(18),'label','Invert plot');
gm(20) = uimenu(gm(19),'label','Plot A','callback','cmd=1;numPlot=1;plotChange;cmd=3;plotControl');
gm(21) = uimenu(gm(19),'label','Plot B','callback','cmd=1;numPlot=2;plotChange;cmd=3;plotControl');
gm(22) = uimenu(gm(19),'label','Plot C','callback','cmd=1;numPlot=3;plotChange;cmd=3;plotControl');
gm(23) = uimenu(gm(19),'label','Plot D','callback','cmd=1;numPlot=4;plotChange;cmd=3;plotControl');
gm(24) = uimenu(gm(18),'label','Subtract plot');
gm(25) = uimenu(gm(24),'label','Plot A','callback','cmd=2;numPlot=1;plotChange;cmd=4;plotControl');
gm(26) = uimenu(gm(24),'label','Plot B','callback','cmd=2;numPlot=2;plotChange;cmd=4;plotControl');
gm(27) = uimenu(gm(24),'label','Plot C','callback','cmd=2;numPlot=3;plotChange;cmd=4;plotControl');
gm(28) = uimenu(gm(24),'label','Plot D','callback','cmd=2;numPlot=4;plotChange;cmd=4;plotControl');
gm(29) = uimenu('label','Usual contrasts');
gm(30) = uimenu(gm(29),'label','Direction Bias','callback','cmd=1;plotStandards');
gm(31) = uimenu(gm(29),'label','Number in Sequence - Dr1','callback','cmd=2;plotStandards');
gm(32) = uimenu(gm(29),'label','Number in Sequence - Dr2','callback','cmd=3;plotStandards');
gm(33) = uimenu(gm(29),'label','Learning over Time - Dr1','callback','cmd=4;plotStandards');
gm(34) = uimenu(gm(29),'label','Learning over Time - Dr2','callback','cmd=5;plotStandards');
gm(35) = uimenu(gm(29),'label','Perturbation - Dr1','callback','cmd=6;plotStandards');
gm(36) = uimenu(gm(29),'label','Perturbation - Dr2','callback','cmd=7;plotStandards');
gm(37) = uimenu('label','Calculate ASP','callback','cmd=3;plotChange');
gm(38) = uimenu('label','%Smooth');
gm(39) = uimenu(gm(38),'label','Total %Smooth','callback','cmd=7;plotControl;cmd=4;sacOption=1;plotChange');
gm(40) = uimenu(gm(38),'label','Specific %Smooth','callback','cmd=7;plotControl;cmd=4;sacOption=2;plotChange');
gm(41) = uimenu(gm(1),'label','Extract File','callback','[E] = ASPExtract(C,filename1,origPath)');

%% %Display parameters
plotName = {'Plot A';'Plot B';'Plot C';'Plot D'};
varName = {'Dr';'NiS';'Blank';'Blip';'NumBlock';'NumProfile';'goodBlank';'goodBlip'};

%% %Open first file
cmd=1; plotControl;
cmd=2; plotControl;
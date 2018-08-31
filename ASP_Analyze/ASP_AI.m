% ASP Experiment Analysis interface
clear
warning off
RectRight = 3;
origPath = 'D:\Felix\Program\ASP_Analyze';
addpath('D:\Felix\Program\ASP_Analyze\Subfunctions','D:\Felix\Program\ASP_Analyze\MES','D:\Felix\Program\Tools\boundedline',...
'D:\Felix\Program\Tools\catuneven','D:\Felix\Program\Tools\Inpaint_nans','D:\Felix\Program\Tools\singlepatch','D:\Felix\Program\Tools\raincloudplot',...
'D:\Felix\Program\Tools\other');

timePlot = 1;
plotData = [];
plotData.av = zeros(6,1);
plotData.sd = zeros(6,1);
plotData.sub = zeros(6,1);
plotData.preblank = zeros(1,6);
plotData.poststop = zeros(1,6);
plotData.para = ones(6,9,12)*NaN;
plotData.avData = ones(6,9)*NaN;
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
gm(2) = uimenu(gm(1),'label','Load file','callback','cmd=6;plotControl;cmd=1;plotControl;cmd=2;plotControl');
gm(3) = uimenu(gm(1),'label','Create file','callback','dataCombine;cmd=1;plotControl;cmd=2;plotControl');
gm(4) = uimenu(gm(1),'label','Combine files','callback','groupData');
gm(5) = uimenu('label','Draw Graph');
gm(6) = uimenu(gm(5),'label','Graph A','callback','numPlot=1;auto=0;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(7) = uimenu(gm(5),'label','Graph B','callback','numPlot=2;auto=0;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(8) = uimenu(gm(5),'label','Graph C','callback','numPlot=3;auto=0;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(9) = uimenu(gm(5),'label','Graph D','callback','numPlot=4;auto=0;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(10) = uimenu(gm(5),'label','Graph E','callback','numPlot=5;auto=0;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(11) = uimenu(gm(5),'label','Graph F','callback','numPlot=6;auto=0;[plotData]=drawGraph(C,ax,numPlot,plotData,tMoveOn,auto,lAnsw);cmd=3;plotControl');
gm(12) = uimenu('label','Delete Graph');
gm(13) = uimenu(gm(12),'label','Graph A','callback','cmd=6;numPlot=1;plotControl;cmd=3;plotControl');
gm(14) = uimenu(gm(12),'label','Graph B','callback','cmd=6;numPlot=2;plotControl;cmd=3;plotControl');
gm(15) = uimenu(gm(12),'label','Graph C','callback','cmd=6;numPlot=3;plotControl;cmd=3;plotControl');
gm(16) = uimenu(gm(12),'label','Graph D','callback','cmd=6;numPlot=4;plotControl;cmd=3;plotControl');
gm(17) = uimenu(gm(12),'label','Graph E','callback','cmd=6;numPlot=5;plotControl;cmd=3;plotControl');
gm(18) = uimenu(gm(12),'label','Graph F','callback','cmd=6;numPlot=6;plotControl;cmd=3;plotControl');
gm(19) = uimenu('label','Change Graph');
gm(20) = uimenu(gm(19),'label','Invert Graph');
gm(21) = uimenu(gm(19),'label','Plot A','callback','cmd=1;numPlot=1;plotChange;cmd=3;plotControl');
gm(22) = uimenu(gm(19),'label','Plot B','callback','cmd=1;numPlot=2;plotChange;cmd=3;plotControl');
gm(23) = uimenu(gm(19),'label','Plot C','callback','cmd=1;numPlot=3;plotChange;cmd=3;plotControl');
gm(24) = uimenu(gm(19),'label','Plot D','callback','cmd=1;numPlot=4;plotChange;cmd=3;plotControl');
gm(25) = uimenu(gm(19),'label','Plot E','callback','cmd=1;numPlot=5;plotChange;cmd=3;plotControl');
gm(26) = uimenu(gm(19),'label','Plot F','callback','cmd=1;numPlot=6;plotChange;cmd=3;plotControl');
gm(27) = uimenu('label','Timeframe');
gm(28) = uimenu(gm(27),'label','Complete','callback','cmd=3;timePlot=1;plotControl');
gm(29) = uimenu(gm(27),'label','Blank','callback','cmd=3;timePlot=2;plotControl');
gm(30) = uimenu(gm(27),'label','Blip','callback','cmd=3;timePlot=3;plotControl');
gm(31) = uimenu(gm(19),'label','Subtract Graph');
gm(32) = uimenu(gm(31),'label','Plot A','callback','cmd=2;numPlot=1;plotChange;cmd=4;plotControl');
gm(33) = uimenu(gm(31),'label','Plot B','callback','cmd=2;numPlot=2;plotChange;cmd=4;plotControl');
gm(34) = uimenu(gm(31),'label','Plot C','callback','cmd=2;numPlot=3;plotChange;cmd=4;plotControl');
gm(35) = uimenu(gm(31),'label','Plot D','callback','cmd=2;numPlot=4;plotChange;cmd=4;plotControl');
gm(36) = uimenu(gm(31),'label','Plot E','callback','cmd=2;numPlot=5;plotChange;cmd=4;plotControl');
gm(37) = uimenu(gm(31),'label','Plot F','callback','cmd=2;numPlot=6;plotChange;cmd=4;plotControl');
gm(38) = uimenu('label','Usual Contrasts');
gm(39) = uimenu(gm(38),'label','Direction Bias','callback','cmd=1;plotStandards');
gm(40) = uimenu(gm(38),'label','Position in Sequence - Left','callback','cmd=2;plotStandards');
gm(41) = uimenu(gm(38),'label','Position in Sequence - Right','callback','cmd=3;plotStandards');
gm(42) = uimenu(gm(38),'label','Previous PiS - Left','callback','cmd=4;plotStandards');
gm(43) = uimenu(gm(38),'label','Previous PiS - Right','callback','cmd=5;plotStandards');
gm(44) = uimenu(gm(38),'label','Learning over Time - Left','callback','cmd=6;plotStandards');
gm(45) = uimenu(gm(38),'label','Learning over Time - Right','callback','cmd=7;plotStandards');
gm(46) = uimenu(gm(38),'label','Perturbation - Left','callback','cmd=8;plotStandards');
gm(47) = uimenu(gm(38),'label','Perturbation - Right','callback','cmd=9;plotStandards');
gm(48) = uimenu('label','Calculate');
gm(49) = uimenu(gm(48),'label','Calculate ASP','callback','cmd=3;plotChange');
gm(50) = uimenu(gm(48),'label','Total %Smooth','callback','cmd=7;plotControl;cmd=4;sacOption=1;plotChange');
gm(51) = uimenu(gm(48),'label','Specific %Smooth','callback','cmd=7;plotControl;cmd=4;sacOption=2;plotChange');
gm(52) = uimenu(gm(48),'label','BoundPlot','callback','drawBoundline');
gm(53) = uimenu('label','Extract File','callback','[E] = ASP_Extract(C,filename1,origPath)');

%% %Display parameters
plotName = {'Plot A';'Plot B';'Plot C';'Plot D';'Plot E';'Plot F'};
varName = {'Dr';'pDr';'PiS';'pPiS';'Blip';'#Block';'Subject';'Stim';'gBlank';'gBlip'};
color = [0.75 0 1;1 0.25 0;1 0.5 0;0.25 0.75 0;0 0.75 0.75;0 0.25 1];
for s = 1:10
    uicontrol('Style','text','String',varName{s},'Visible','on','units','normalized','Position', [0.70 0.90-0.025*(s-1) 0.05 0.025]);
end
for n = 1:6
    uicontrol('Style','text','String',plotName{n},'ForegroundColor',color(n,:),'Visible','on','units','normalized','Position', [0.70+n/30 0.95 0.05 0.025]);
end
varName = {'NoT';'%Good';'   ';'EA_vOn';'RA_vOn';'AE_vOn';'%EA';'EA_sd';'RA_sd';'AE_sd'};
% for s = 1:10
%     uicontrol('Style','text','String',varName{s},'Visible','on','units','normalized','Position', [0.70 0.625-0.025*(s-1) 0.05 0.025]);
% end

%% %Open first file
cmd=1; plotControl;
cmd=2; plotControl;
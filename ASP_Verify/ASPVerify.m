%% Analysis Interface to inspect single trials of ASP task
clear 
warning off
RectRight = 3;
addpath('D:\Master\Program\ASPVerify\Subfunctions');
loadPath = 'D:\Master\Data';

%% create figure
f = figure('Name','ASP Analysis Interface','Units','normalized','Position',[.01 .01 .98 .94],'toolbar','none','NumberTitle','off');

% create axes
ylab = {'Eye Gaze X/Y(degree)','Eye velo X/Y(degree/s)','Eye acce X/Y(degree/s^2)' };
for i = 1:3
    ax(i) = axes('Units','normalized','Position',[.05 1.02-i*.32 .6 .28]);
    ylabel(ylab{i});
end
xlabel('Time (ms)')

%%%%%%%%%%
ax(4) = axes('Units','normalized','Position',[.70 .70 .25 .28]);
ylabel('Eye velocity (deg/s)')
ax(5) = axes('Units','normalized','Position',[.70 .38 .25 .28]);
xlabel('Time after blip onset(ms)')
ylabel('Eye velocity (deg/s)')

%%%%%%%%%%%%
%% initialize basic variables
trn = 1;
horiB = [0;1];
vertB = [0;1];

%% add menu items
gm(1) = uimenu('label','ASP-AI');
gm(2) = uimenu(gm(1),'label','Load block of data','callback','[D,pathname1,firstload,loadPath]=ASPLoad(loadPath);[D,tBlankOn,tMoveOn,tBlipOn,tBlipOff,tMoveOff,tPause]=sortASP(D);trn=1;ASPReplot');
gm(3) = uimenu(gm(1),'label','Automatic SaccOnset marking','callback','D=ASPSaccSet(D);ASPReplot');
gm(4) = uimenu(gm(1),'label','Average blip','callback','[D,pathname1,firstload,loadPath]=ASPLoad(loadPath);trn=1;plotCase=0;average');
gm(5) = uimenu(gm(1),'label','Average plot','callback','[D,pathname1,firstload,loadPath]=ASPLoad(loadPath);trn=1;plotCase=1;average');
gm(6) = uimenu('label','Automatic GoodBad','callback','[D,tBlankOn,tMoveOn,tBlipOn,tBlipOff,tMoveOff,tPause]=sortASP(D);');

%% add buttons & controls
h.blankGood = uicontrol('Style', 'pushbutton', 'String', 'Blank GOOD', 'foregroundcolor', 'g','units','normalized','Position', [0.7 0.25 0.05 0.025],'Visible','off',...
    'Callback','D{trn}.goodBlank=rem(D{trn}.goodBlank+1,2);ASPGoodBadToggle');
h.blipGood = uicontrol('Style', 'pushbutton', 'String', 'Blip GOOD', 'foregroundcolor', 'g','units','normalized','Position', [0.75 0.25 0.05 0.025],'Visible','off',...
    'Callback','D{trn}.goodBlip=rem(D{trn}.goodBlip+1,2);ASPGoodBadToggle');
h.nextTrial = uicontrol('Style', 'pushbutton', 'String', 'Next Trial','Visible','off','units','normalized','Position', [0.75 0.2 0.05 0.025], 'Callback', 'trn=trn+1;ASPReplot');
h.previousTrial = uicontrol('Style', 'pushbutton', 'String', 'Previous Trial','Visible','off','units','normalized','Position', [0.7 0.2 0.05 0.025], 'Callback', 'trn=trn-1;ASPReplot');
h.exclude = uicontrol('Style', 'pushbutton', 'String', 'SP Onset','Visible','off','units','normalized','Position', [0.75 0.15 0.05 0.025],'Visible','off',...
    'Callback','D{trn}.exclude=rem(D{trn}.exclude+1,2);ASPGoodBadToggle');
h.spOn = uicontrol('Style', 'pushbutton', 'String', 'SP Onset','Visible','off','units','normalized','Position', [0.7 0.15 0.05 0.025], 'Callback', 'CAIspon');	
h.goToTrial = uicontrol('Style','text','String','Go to trial #','Visible','off','units','normalized','Position', [0.7 0.10 0.05 0.025]);
h.edit = uicontrol('Style','edit','Visible','off','units','normalized','Position', [0.75 0.10 0.025 0.025]);
h.go = uicontrol('Style','pushbutton','String','Go','Visible','off','units','normalized','Position', [0.775 0.10 0.025 0.025], 'Callback','trn=str2num(get(h.edit,''String'')); ASPReplot');
h.nextCheck = uicontrol('Style', 'pushbutton', 'String', 'Next Check','Visible','off','units','normalized','Position', [0.75 0.05 0.05 0.025], 'Callback', 'trn=nextrn;ASPReplot');
h.previousCheck = uicontrol('Style', 'pushbutton', 'String', 'Previous Check','Visible','off','units','normalized','Position', [0.7 0.05 0.05 0.025], 'Callback', 'trn=lastrn;ASPReplot');

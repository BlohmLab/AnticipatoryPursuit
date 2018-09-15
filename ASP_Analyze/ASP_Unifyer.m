function U = ASP_Unifyer
origPath = 'D:\Felix\Program\ASP_Analyze';
loadPath = 'D:\Felix\Data\04_Extracted';

%% load or create file
choice = questdlg('Which data file do you want to use?','New or existing','Create new file','Use existing file','Use existing file');
switch choice
    case 'Create new file'
        prompt = {'Name for unified file?'};
        dlg_title = 'Namet';
        num_lines = 1;
        defaultans = {''}; %# of sequences per direction
        inputcluster = inputdlg(prompt,dlg_title,num_lines,defaultans);
        uname = ['Uni_' inputcluster{1}];
        newFile = 1;
        
    case 'Use existing file'
        cd(loadPath);
        [oFilename,oPathname] = uigetfile({'*.mat'},'Choose existing file to load....');
        cd(oPathname);
        load([oPathname oFilename]);
        uname = oFilename;
        newFile = 0;
end
ongoing = 1;

%% Create parameters
if newFile == 1
    PL = struct;
    PL.subject = 0;
    PL.Multi_RV = ones(5,4,2,8)*NaN;
    PL.Multi_EV = ones(5,4,2,8)*NaN;
    PL.Multi_ON = ones(5,4,2,8)*NaN;
    PL.Multi_SA = ones(5,4,2,8)*NaN;
    PL.Multi_Slope = ones(5,4,2,8)*NaN;
    PL.HB_BDiff = ones(3,4,2,8)*NaN;
    PL.HB_BSum = ones(3,4,2,8)*NaN;
    
    Stim = struct;
    Stim.subject = 0;
    Stim.Multi_RV = ones(5,2,2,8)*NaN;
    Stim.Multi_EV = ones(5,2,2,8)*NaN;
    Stim.Multi_ON = ones(5,2,2,8)*NaN;
    Stim.Multi_SA = ones(5,2,2,8)*NaN;
    Stim.Multi_Slope = ones(5,2,2,8)*NaN;
    Stim.Pre_BDiff = ones(3,2,2,8)*NaN;
    Stim.Pre_BSum = ones(3,2,2,8)*NaN;
    Stim.Stim_BDiff = ones(3,2,2,8)*NaN;
    Stim.Stim_BSum = ones(3,2,2,8)*NaN;
    
    Corr = struct;
    Corr.subject = 0;
    Corr.Multi_RV = ones(5,2,2,8)*NaN;
    Corr.Multi_EV = ones(5,2,2,8)*NaN;
    Corr.Multi_ON = ones(5,2,2,8)*NaN;
    Corr.Multi_SA = ones(5,2,2,8)*NaN;
    Corr.Multi_Slope = ones(5,2,2,8)*NaN;
    Corr.Pre_BDiff = ones(3,2,2,8)*NaN;
    Corr.Pre_BSum = ones(3,2,2,8)*NaN;
    Corr.Stim_BDiff = ones(3,2,2,8)*NaN;
    Corr.Stim_BSum = ones(3,2,2,8)*NaN;
    
    U = struct;
else
    PL = U.PL;
    Stim = U.Stim;
    Corr = U.Corr;
    
end

%% Load in files
while ongoing == 1
    cd(loadPath);
    [filename1,pathname1] = uigetfile({'*.mat'},'Choose XP record file you want to load....'); %load in mat-file = Trial parameters
    loadPath = pathname1;
    cd(pathname1);
    load([pathname1 filename1]);
    cd(origPath);
    
    answer1 = questdlg('Did you load PreLim or Stim data?','Type of Data','Prelim','Stim','Corr','Corr');
    switch answer1
        case 'Prelim'
            PL.subject = PL.subject +1;
            PL.Multi_RV(1:5,1:4,1:2,PL.subject) = E.total.AV_rv_ASP(2:6,1:4,1:2);
            PL.Multi_EV(1:5,1:4,1:2,PL.subject) = E.total.AV_ev_ASP(2:6,1:4,1:2);
            PL.Multi_ON(1:5,1:4,1:2,PL.subject) = E.total.AV_on_ASP(2:6,1:4,1:2);
            PL.Multi_SA(1:5,1:4,1:2,PL.subject) = E.total.AV_sa_ASP(2:6,1:4,1:2);
            PL.Multi_Slope(1:5,1:4,1:2,PL.subject) = E.total.AV_Slope(2:6,1:4,1:2);
            PL.HB_BDiff(1:3,1:4,1:2,PL.subject) = E.total.AV_BDiff(2:4,1:4,1:2);
            PL.HB_BSum(1:3,1:4,1:2,PL.subject) = E.total.AV_BSum(2:4,1:4,1:2);
            
        case 'Stim'
            Stim.subject = Stim.subject +1;
            Stim.Multi_RV(1:5,1:2,1:2,Stim.subject) = E.stim.AV_RV(2:6,1:2,1:2);
            Stim.Multi_EV(1:5,1:2,1:2,Stim.subject) = E.stim.AV_EV(2:6,1:2,1:2);
            Stim.Multi_ON(1:5,1:2,1:2,Stim.subject) = E.stim.AV_ON(2:6,1:2,1:2);
            Stim.Multi_SA(1:5,1:2,1:2,Stim.subject) = E.stim.AV_SA(2:6,1:2,1:2);
            Stim.Multi_Slope(1:5,1:2,1:2,Stim.subject) = E.stim.AV_Slope(2:6,1:2,1:2);
            Stim.Pre_BDiff(1:3,1:2,1:2,Stim.subject) =  E.pre.AV_BDiff(2:4,1:2,1:2);
            Stim.Pre_BSum(1:3,1:2,1:2,Stim.subject) = E.pre.AV_BSum(2:4,1:2,1:2);
            Stim.Stim_BDiff(1:3,1:2,1:2,Stim.subject) = E.stim.AV_BDiff(2:4,1:2,1:2);
            Stim.Stim_BSum(1:3,1:2,1:2,Stim.subject) =  E.stim.AV_BSum(2:4,1:2,1:2);
            
        case 'Corr'
            Corr.subject = Corr.subject +1;
            Corr.Multi_RV(1:5,1:2,1:2,Corr.subject) = E2.stim.AV_RV(2:6,1:2,1:2);
            Corr.Multi_EV(1:5,1:2,1:2,Corr.subject) = E2.stim.AV_EV(2:6,1:2,1:2);
            Corr.Multi_ON(1:5,1:2,1:2,Corr.subject) = E2.stim.AV_ON(2:6,1:2,1:2);
            Corr.Multi_SA(1:5,1:2,1:2,Corr.subject) = E2.stim.AV_SA(2:6,1:2,1:2);
            Corr.Multi_Slope(1:5,1:2,1:2,Corr.subject) = E2.stim.AV_Slope(2:6,1:2,1:2);
            Corr.Pre_BDiff(1:3,1:2,1:2,Corr.subject) =  E2.pre.AV_BDiff(2:4,1:2,1:2);
            Corr.Pre_BSum(1:3,1:2,1:2,Corr.subject) = E2.pre.AV_BSum(2:4,1:2,1:2);
            Corr.Stim_BDiff(1:3,1:2,1:2,Corr.subject) = E2.stim.AV_BDiff(2:4,1:2,1:2);
            Corr.Stim_BSum(1:3,1:2,1:2,Corr.subject) =  E2.stim.AV_BSum(2:4,1:2,1:2);
            
        case 'Skip'
    end
    
    answer1 = questdlg('What now?','Continue?','Load more files','Save&Quit','Save&Quit');
    switch answer1
        case 'Load more files'
            newFile = 0;
            
        case 'Save&Quit'
            U.PL = PL;
            U.Stim = Stim;
            U.Corr = Corr;
            ongoing = 0;
    end
end

% Save U
cd D:\Felix\Data\04_Extracted
mkdir(strcat(uname))
cd(strcat('D:\Felix\Data\04_Extracted\',uname))
save(uname,'U');

answer1 = questdlg('Create figures?','Figures?','Yes','No','No');
    switch answer1
        case 'Load more files'
            newFile = 0;
            
        case 'Yes'
            uniteFigures(U,uname);
            
        case 'No'
    end

cd(origPath);
end

function C = groupData

origPath = 'D:\Felix\Program\ASP_Analyze';
savePath = 'D:\Felix\Data\03_Combined';
loadPath = 'D:\Felix\Data\03_Combined';

%% Create file

prompt = {'Output Name'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {''}; %# of sequences per direction
inputcluster = inputdlg(prompt,dlg_title,num_lines,defaultans);
outFilename = [inputcluster{1} '_Comb.mat'];
newFile = 1;

%% Create intermediate values from smaller combined_files
ongoing = 1;
numBlocks = 0;
startPoint = 0;
paraTrials = ones(11,25000)*NaN;
tEvents = ones(8,25000)*NaN;
eyeX = ones(3001,25000)*NaN;
eyeXv =  ones(3001,25000)*NaN;
eyeXvws = ones(3001,25000)*NaN;
eyeXa = ones(3001,25000)*NaN;
target_x = ones(175,25000)*NaN;
target_v = ones(175,25000)*NaN;
target_a = ones(175,25000)*NaN;
tTarget = ones(175,25000)*NaN;
detOn = ones(1,25000)*NaN;
SPon = ones(1,25000)*NaN;
ASPlot = ones(845,25000)*NaN;
realVOn = ones(1,25000)*NaN;
%         C.maxVOn = ones(1,D{1}.numTrials)*NaN;
estVOn = ones(1,25000)*NaN;
numSacc = ones(1,25000)*NaN;
prevTrial = ones(25000,2)*NaN;
trialPiDr = ones(25000,2)*NaN;


while ongoing == 1
    
    % Choose file to include
    cd(loadPath);
    [iFilename,iPathname] = uigetfile({'D.mat'},'Choose comb.mat file to integrate....');
    cd(iPathname);
    load([iPathname iFilename]);
    
    numBlocks = numBlocks + C.numBlocks;
    paraTrials(:,(1:length(C.paraTrials))+startPoint) = C.paraTrials;
    tEvents(:,(1:length(C.paraTrials))+startPoint) = C.tEvents;
    eyeX(:,(1:length(C.paraTrials))+startPoint) = C.eyeX;
    eyeXv(:,(1:length(C.paraTrials))+startPoint) =  C.eyeXv;
    eyeXvws(:,(1:length(C.paraTrials))+startPoint) = C.eyeXvws;
    eyeXa(:,(1:length(C.paraTrials))+startPoint) = C.eyeXa;
    target_x(:,(1:length(C.paraTrials))+startPoint) = C.target_x;
    target_v(:,(1:length(C.paraTrials))+startPoint) = C.target_v;
    target_a(:,(1:length(C.paraTrials))+startPoint) = C.target_a;
    tTarget(:,(1:length(C.paraTrials))+startPoint) = C.tTarget;
    detOn(:,(1:length(C.paraTrials))+startPoint) = C.detOn;
    SPon(:,(1:length(C.paraTrials))+startPoint) = C.SPon;
    ASPlot(1:length(C.ASPlot(:,1)),(1:length(C.paraTrials))+startPoint) = C.ASPlot;
    realVOn(:,(1:length(C.paraTrials))+startPoint) = C.realVOn;
    %         C.maxVOn = ones(1,D{1}.numTrials)*NaN;
    estVOn(:,(1:length(C.paraTrials))+startPoint) = C.estVOn;
    numSacc(:,(1:length(C.paraTrials))+startPoint) = C.numSacc;
    v_target = C.v_target;
    v_blip = C.v_blip;
    prevTrial((1:length(C.paraTrials))+startPoint,:) = C.prevTrial;
    trialPiDr((1:length(C.paraTrials))+startPoint,:) = C.trialPiDr;
    
    startPoint = startPoint+length(C.paraTrials);
    clear C;
    
    %% Load further files or save and quit
    choice = questdlg('Do you want to include more files?','Continue?','Include another file','Save and quit','Include another file');
    switch choice
        case 'Include another file'
            loadPath = iPathname;
            
        case 'Save and quit'
            
            % Rename as C and quit
            if range(paraTrials(10,:))==0
                C.subjectID = paraTrials(10,1);
            else
                C.subjectID = 99; % Mixed subjects
            end
            C.numBlocks = numBlocks;
            C.paraTrials = paraTrials(:,1:startPoint);
            C.tEvents = tEvents(:,1:startPoint);
            C.eyeX = eyeX(:,1:startPoint);
            C.eyeXv =  eyeXv(:,1:startPoint);
            C.eyeXvws = eyeXvws(:,1:startPoint);
            C.eyeXa = eyeXa(:,1:startPoint);
            C.target_x = target_x(:,1:startPoint);
            C.target_v = target_v(:,1:startPoint);
            C.target_a = target_a(:,1:startPoint);
            C.tTarget = tTarget(:,1:startPoint);
            C.detOn = detOn(:,1:startPoint);
            C.SPon = SPon(:,1:startPoint);
            C.ASPlot = ASPlot(:,1:startPoint);
            C.realVOn = realVOn(:,1:startPoint);
            %         C.maxVOn = ones(1,D{1}.numTrials)*NaN;
            C.estVOn = estVOn(:,1:startPoint);
            C.numSacc = numSacc(:,1:startPoint);
            C.v_target = v_target;
            C.v_blip = v_blip;
            C.prevTrial = prevTrial(1:startPoint,:);
            C.trialPiDr = trialPiDr(1:startPoint,:);
            
            % Save and quit
            cd(savePath);
            save(outFilename,'C');
            ongoing = 0;
            cd(origPath);
    end
end
end
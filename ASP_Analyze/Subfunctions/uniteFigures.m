%function uniteFigures(U,uname)

%% Create AV-Sequence-Figures
uname = 'Uni_ALL_8';
cd(strcat('D:\Felix\Data\04_Extracted\',uname));
mkdir('SequenceFigures');
cd(strcat('D:\Felix\Data\04_Extracted\',uname,'\SequenceFigures'));

% Prelim-Figure of overall sequence effect in RV
Multi_RV = figure('Name','Multi_RV');
limits = {[0.85 5.15 -12 0];[0.85 5.15 -1.1 0];[0.85 5.15 -1 8];[0.85 5.15 -0.2 1.1]};
titles = ["Left - Actual values","Left - Relative","Right - Actual values","Right - Relative"];
labels = ["pPiS","v_A_S_P","v_A_S_P/v_A_S_P(max)",];
for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_RV(:,1,Dr,subject),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr-1)));
    xlabel(labels(1)); ylabel(labels(2));
    xticks(1:5);
    title(titles(2*Dr-1));
    
    subplot(2,2,2*Dr)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_RV(:,1,Dr,subject)/max(abs(U.PL.Multi_RV(:,1,Dr,subject))),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr)));
    xlabel(labels(1)); ylabel(labels(3));
    xticks(1:5);
    title(titles(2*Dr));
end
savefig(Multi_RV,strcat(uname(5:end),'_RV_Sequence.fig'));
close Multi_RV;

% Prelim-Figure of overall sequence effect in EV
Multi_EV = figure('Name','Multi_EV');
limits = {[0.85 5.15 -12 0];[0.85 5.15 -1.1 0];[0.85 5.15 -1 8];[0.85 5.15 -0.2 1.1]};
titles = ["Left - Actual values","Left - Relative","Right - Actual values","Right - Relative"];
labels = ["pPiS","ev_A_S_P","ev_A_S_P/ev_A_S_P(max)",];
for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_EV(:,1,Dr,subject),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr-1)));
    xlabel(labels(1)); ylabel(labels(2));
    xticks(1:5);
    title(titles(2*Dr-1));
    
    subplot(2,2,2*Dr)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_EV(:,1,Dr,subject)/max(abs(U.PL.Multi_EV(:,1,Dr,subject))),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr)));
    xlabel(labels(1)); ylabel(labels(3));
    xticks(1:5);
    title(titles(2*Dr));
end
savefig(Multi_EV,strcat(uname(5:end),'_EV_Sequence.fig'));
close Multi_EV;

% Prelim-Figure of overall sequence effect in ON
Multi_ON = figure('Name','Multi_ON');
limits = {[0.85 5.15 765 1100];[0.85 5.15 0 1.05];[0.85 5.15 765 1100];[0.85 5.15 0 1.05]};
titles = ["Left - Actual values","Left - Relative","Right - Actual values","Right - Relative"];
labels = ["pPiS","Onset(ms post-blank)","Onset(ms post-blank - norm)",];
for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_ON(:,1,Dr,subject),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr-1)));
    xlabel(labels(1)); ylabel(labels(2));
    xticks(1:5);
    title(titles(2*Dr-1));
    
    subplot(2,2,2*Dr)
    hold on;
    for subject = 1:8
        plot(1:5,(U.PL.Multi_ON(:,1,Dr,subject)-765)/(max(U.PL.Multi_ON(:,1,Dr,subject))-765),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr)));
    xlabel(labels(1)); ylabel(labels(3));
    xticks(1:5);
    title(titles(2*Dr));
end
savefig(Multi_ON,strcat(uname(5:end),'_ON_Sequence.fig'));
close Multi_ON;

% Prelim-Figure of overall sequence effect in SA
Multi_SA = figure('Name','Multi_SA');
limits = {[0.85 5.15 0 4];[0.85 5.15 0 1];[0.85 5.15 0 4];[0.85 5.15 0 1.1]};
titles = ["Left - Actual values","Left - Relative","Right - Actual values","Right - Relative"];
labels = ["pPiS","N of Saccades","N of Saccades (norm)",];
for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_SA(:,1,Dr,subject),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr-1)));
    xlabel(labels(1)); ylabel(labels(2));
    xticks(1:5);
    title(titles(2*Dr-1));
    
    subplot(2,2,2*Dr)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_SA(:,1,Dr,subject)/max(abs(U.PL.Multi_SA(:,1,Dr,subject))),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr)));
    xlabel(labels(1)); ylabel(labels(3));
    xticks(1:5);
    title(titles(2*Dr));
end
savefig(Multi_SA,strcat(uname(5:end),'_SA_Sequence.fig'));
close Multi_SA;

% Prelim-Figure of overall sequence effect in Slope
Multi_Slope = figure('Name','Multi_Slope');
limits = {[0.85 5.15 -0.25 0.1];[0.85 5.15 -1.1 0.2];[0.85 5.15 -0.1 0.25];[0.85 5.15 -0.2 1.1]};
titles = ["Left - Actual values","Left - Relative","Right - Actual values","Right - Relative"];
labels = ["pPiS","Slope (deg/s^2)","Slope (deg/s^2) - norm",];
for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_Slope(:,1,Dr,subject),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr-1)));
    xlabel(labels(1)); ylabel(labels(2));
    xticks(1:5);
    title(titles(2*Dr-1));
    
    subplot(2,2,2*Dr)
    hold on;
    for subject = 1:8
        plot(1:5,U.PL.Multi_Slope(:,1,Dr,subject)/max(abs(U.PL.Multi_Slope(:,1,Dr,subject))),'--o','MarkerSize',10);
    end
    hold off;
    axis(cell2mat(limits(2*Dr)));
    xlabel(labels(1)); ylabel(labels(3));
    xticks(1:5);
    title(titles(2*Dr));
   
end
savefig(Multi_Slope,strcat(uname(5:end),'_Slope_Sequence.fig'));
close Multi_Slope;

%% Create HexBlock-Stability Figure for Blip Response (Preliminary)
% Diagonale Figure of Blip_Pre - Corrected
Hex1Hex2_PL_Blip = figure('Name','Hex1Hex2_PL_Blip');
titles = ["Left - Mean of Blip Peaks","Left - Mean Peak-to-Peak","Right - Mean of Blip Peaks","Right - Mean Peak-to-Peak"];

for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for BC = 1:3
        x = U.PL.HB_BSum(BC,2,Dr,1:U.Stim.subject)/2;
        y = U.PL.HB_BSum(BC,3,Dr,1:U.Stim.subject)/2;
        scatter(x,y,'filled');
        line([-30 30]*(2*Dr-3),[-30 30]*(2*Dr-3),'Color','black');
        axis([10 30 10 30]);
        if Dr == 1
            axis([-30 -10 -30 -10]);
            ax = gca;
            ax.XDir = 'reverse';
        end
        title(titles(2*Dr-1));
        xlabel('HexBlock 1 - Mean of Blip Peaks (deg/s)'); ylabel('HexBlock 2 - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end

for Dr = 1:2
    subplot(2,2,2*Dr)
    hold on;
    for BC = 1:3
        x = U.PL.HB_BDiff(BC,2,Dr,1:U.Stim.subject);
        y = U.PL.HB_BDiff(BC,3,Dr,1:U.Stim.subject);
        scatter(x,y,'filled');
        line([0 7],[0 7],'Color','black');
        axis([0 7 0 7]);
        title(titles(2*Dr));
        xlabel('HexBlock 1 - Mean of Blip Peaks (deg/s)'); ylabel('HexBlock 2 - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end
savefig(Hex1Hex2_PL_Blip,strcat(uname(5:end),'_PLBlip_Hex1Hex2.fig'));
close Hex1Hex2_PL_Blip;

%% Create An/Cat-Comparisons - Blank & Steady - Corrected
cd(strcat('D:\Felix\Data\04_Extracted\',uname));
mkdir('An_Cat_Corrected');
cd(strcat('D:\Felix\Data\04_Extracted\',uname,'\An_Cat_Corrected'));

% Diagonale Figure of RV - Corrected
CatAn_RV_C = figure('Name','CatAn_RV_C');
titles = ["Left - pPiS 1","Left - pPiS 2","Left - pPiS 3","Left - pPiS 4","Left - pPiS 5","Right - pPiS 1","Right - pPiS 2","Right - pPiS 3","Right - pPiS 4","Right - pPiS 5"];
Dr = 1;
for pPiS = 1:5
    subplot(2,5,pPiS)
    x = U.Corr.Multi_RV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_RV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-12 0.25],[-12 0.25],'Color','black');
    axis([-12 0.25 -12 0.25]);
    ax = gca;
    ax.XDir = 'reverse';
    title(titles(pPiS));
    xlabel('AN - v_A_S_P (deg/s)'); ylabel('CAT - v_A_S_P (deg/s)');
end
Dr = 2;
for pPiS = 1:5
    subplot(2,5,5+pPiS)
    x = U.Corr.Multi_RV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_RV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    if pPiS == 5
        line([-5 8],[0 0],'Color','black');line([0 0],[-5 8],'Color','black');
        line([-5 8],[-5 8],'Color','black');
        axis([-5 8 -5 8]);
    else
        line([-0.25 12],[-0.25 12],'Color','black');
        axis([-0.25 12 -0.25 12]);
    end
    title(titles(5+pPiS));
    xlabel('AN - v_A_S_P (deg/s)'); ylabel('CAT - v_A_S_P (deg/s)');
end
savefig(CatAn_RV_C,strcat(uname(5:end),'_RV_CatAn_Corr.fig'));
close CatAn_RV_C;

% Diagonale Figure of EV - Corrected
CatAn_EV_C = figure('Name','CatAn_EV_C');
titles = ["Left - pPiS 1","Left - pPiS 2","Left - pPiS 3","Left - pPiS 4","Left - pPiS 5","Right - pPiS 1","Right - pPiS 2","Right - pPiS 3","Right - pPiS 4","Right - pPiS 5"];
Dr = 1;
for pPiS = 1:5
    subplot(2,5,pPiS)
    x = U.Corr.Multi_EV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_EV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-12 0.25],[-12 0.25],'Color','black');
    axis([-12 0.25 -12 0.25]);
    ax = gca;
    ax.XDir = 'reverse';
    title(titles(pPiS));
    xlabel('AN - ev_A_S_P (deg/s)'); ylabel('CAT - ev_A_S_P (deg/s)');
end
Dr = 2;
for pPiS = 1:5
    subplot(2,5,5+pPiS)
    x = U.Corr.Multi_EV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_EV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    if pPiS == 5
        line([-5 8],[0 0],'Color','black');line([0 0],[-5 8],'Color','black');
        line([-5 8],[-5 8],'Color','black');
        axis([-5 8 -5 8]);
    else
        line([-0.25 12],[-0.25 12],'Color','black');
        axis([-0.25 12 -0.25 12]);
    end
    title(titles(5+pPiS));
    xlabel('AN - ev_A_S_P (deg/s)'); ylabel('CAT - ev_A_S_P (deg/s)');
end
savefig(CatAn_EV_C,strcat(uname(5:end),'_EV_CatAn_Corr.fig'));
close CatAn_EV_C;

% Diagonale Figure of ON - Corrected
CatAn_ON_C = figure('Name','CatAn_ON_C');
titles = ["Left - pPiS 1","Left - pPiS 2","Left - pPiS 3","Left - pPiS 4","Left - pPiS 5","Right - pPiS 1","Right - pPiS 2","Right - pPiS 3","Right - pPiS 4","Right - pPiS 5"];
Dr = 1;
for pPiS = 1:5
    subplot(2,5,pPiS)
    x = U.Corr.Multi_ON(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_ON(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([750 1050],[750 1050],'Color','black');
    axis([750 1050 750 1050]);
    title(titles(pPiS));
    xlabel('AN - Onset(ms post-blank)'); ylabel('CAT - Onset(ms post-blank)');
end
Dr = 2;
for pPiS = 1:5
    subplot(2,5,5+pPiS)
    x = U.Corr.Multi_ON(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_ON(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([750 1050],[750 1050],'Color','black');
        axis([750 1050 750 1050]);
    title(titles(5+pPiS));
    xlabel('AN - Onset(ms post-blank)'); ylabel('CAT - Onset(ms post-blank)');
end
savefig(CatAn_ON_C,strcat(uname(5:end),'_ON_CatAn_Corr.fig'));
close CatAn_ON_C;

% Diagonale Figure of SA - Corrected
CatAn_SA_C = figure('Name','CatAn_SA_C');
titles = ["Left - PiS 1","Left - PiS 2","Left - PiS 3","Left - PiS 4","Left - PiS 5","Right - PiS 1","Right - PiS 2","Right - PiS 3","Right - PiS 4","Right - PiS 5"];
Dr = 1;
for PiS = 1:5
    subplot(2,5,PiS)
    x = U.Corr.Multi_SA(PiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_SA(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([0 5],[0 5],'Color','black');
    axis([0 5 0 5]);
    title(titles(PiS));
    xlabel('AN - N of Saccades'); ylabel('CAT - N of Saccades');
end
Dr = 2;
for PiS = 1:5
    subplot(2,5,5+PiS)
    x = U.Corr.Multi_SA(PiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_SA(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([0 5],[0 5],'Color','black');
    axis([0 5 0 5]);
    title(titles(5+PiS));
    xlabel('AN - N of Saccades'); ylabel('CAT - N of Saccades');
end
savefig(CatAn_SA_C,strcat(uname(5:end),'_SA_CatAn_Corr.fig'));
close CatAn_SA_C;

% Diagonale Figure of Slope - Corrected
CatAn_Slope_C = figure('Name','CatAn_Slope_C');
titles = ["Left - PiS 1","Left - PiS 2","Left - PiS 3","Left - PiS 4","Left - PiS 5","Right - PiS 1","Right - PiS 2","Right - PiS 3","Right - PiS 4","Right - PiS 5"];
Dr = 1;
for PiS = 1:5
    subplot(2,5,PiS)
    x = U.Corr.Multi_Slope(PiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_Slope(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-0.3 0.05],[-0.3 0.05],'Color','black');
    axis([-0.3 0.05 -0.3 0.05]);
    ax = gca;
    ax.XDir = 'reverse';
    title(titles(PiS));
    xlabel('AN - Slope (deg/s^2)'); ylabel('CAT - Slope (deg/s^2)');
end
Dr = 2;
for PiS = 1:5
    subplot(2,5,5+PiS)
    x = U.Corr.Multi_Slope(PiS,1,Dr,1:U.Stim.subject);
    y = U.Corr.Multi_Slope(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-0.05 0.3],[-0.05 0.3],'Color','black');
    axis([-0.05 0.3 -0.05 0.3]);
    title(titles(5+PiS));
    xlabel('AN - Slope (deg/s^2)'); ylabel('CAT - Slope (deg/s^2)');
end
savefig(CatAn_Slope_C,strcat(uname(5:end),'_Slopes_CatAn_Corr.fig'));
close CatAn_Slope_C;

%% Create An/Cat-Comparisons - Blip - Corrected

% Diagonale Figure of Blip_Pre - Corrected
CatAn_Pre_Blip_C = figure('Name','CatAn_Pre_Blip_C');
titles = ["Left - Mean of Blip Peaks","Left - Mean Peak-to-Peak","Right - Mean of Blip Peaks","Right - Mean Peak-to-Peak"];

for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for BC = 1:3
        x = U.Corr.Pre_BSum(BC,1,Dr,1:U.Stim.subject)/2;
        y = U.Corr.Pre_BSum(BC,2,Dr,1:U.Stim.subject)/2;
        scatter(x,y,'filled');
        line([-30 30]*(2*Dr-3),[-30 30]*(2*Dr-3),'Color','black');
        axis([10 30 10 30]);
        if Dr == 1
            axis([-30 -10 -30 -10]);
            ax = gca;
            ax.XDir = 'reverse';
        end
        title(titles(2*Dr-1));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end

for Dr = 1:2
    subplot(2,2,2*Dr)
    hold on;
    for BC = 1:3
        x = U.Corr.Pre_BDiff(BC,1,Dr,1:U.Stim.subject);
        y = U.Corr.Pre_BDiff(BC,2,Dr,1:U.Stim.subject);
        scatter(x,y,'filled');
        line([0 7],[0 7],'Color','black');
        axis([0 7 0 7]);
        title(titles(2*Dr));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end
savefig(CatAn_Pre_Blip_C,strcat(uname(5:end),'_PreBlip_CatAn_Corr.fig'));
close CatAn_Pre_Blip_C;

% Diagonale Figure of Blip_Stim - Corrected
CatAn_Stim_Blip_C = figure('Name','CatAn_Stim_Blip_C');
titles = ["Left - Mean of Blip Peaks","Left - Mean Peak-to-Peak","Right - Mean of Blip Peaks","Right - Mean Peak-to-Peak"];

for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for BC = 1:3
        x = U.Corr.Stim_BSum(BC,1,Dr,1:U.Stim.subject)/2;
        y = U.Corr.Stim_BSum(BC,2,Dr,1:U.Stim.subject)/2;
        scatter(x,y,'filled');
        line([-30 30]*(2*Dr-3),[-30 30]*(2*Dr-3),'Color','black');
        axis([10 30 10 30]);
        if Dr == 1
            axis([-30 -10 -30 -10]);
            ax = gca;
            ax.XDir = 'reverse';
        end
        title(titles(2*Dr-1));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end

for Dr = 1:2
    subplot(2,2,2*Dr)
    hold on;
    for BC = 1:3
        x = U.Corr.Stim_BDiff(BC,1,Dr,1:U.Stim.subject);
        y = U.Corr.Stim_BDiff(BC,2,Dr,1:U.Stim.subject);
        scatter(x,y,'filled');
        line([0 7],[0 7],'Color','black');
        axis([0 7 0 7]);
        title(titles(2*Dr));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end
savefig(CatAn_Stim_Blip_C,strcat(uname(5:end),'_StimBlip_CatAn_Corr.fig'));
close CatAn_Stim_Blip_C;

%% Create An/Cat-Comparisons - Original
cd(strcat('D:\Felix\Data\04_Extracted\',uname));
mkdir('An_Cat_Original');
cd(strcat('D:\Felix\Data\04_Extracted\',uname,'\An_Cat_Original'));

% Diagonale Figure of RV - Original
CatAn_RV_O = figure('Name','CatAn_RV_O');
titles = ["Left - pPiS 1","Left - pPiS 2","Left - pPiS 3","Left - pPiS 4","Left - pPiS 5","Right - pPiS 1","Right - pPiS 2","Right - pPiS 3","Right - pPiS 4","Right - pPiS 5"];
Dr = 1;
for pPiS = 1:5
    subplot(2,5,pPiS)
    x = U.Stim.Multi_RV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_RV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-12 0.25],[-12 0.25],'Color','black');
    axis([-12 0.25 -12 0.25]);
    ax = gca;
    ax.XDir = 'reverse';
    title(titles(pPiS));
    xlabel('AN - v_A_S_P (deg/s)'); ylabel('CAT - v_A_S_P (deg/s)');
end
Dr = 2;
for pPiS = 1:5
    subplot(2,5,5+pPiS)
    x = U.Stim.Multi_RV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_RV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    if pPiS == 5
        line([-5 8],[0 0],'Color','black');line([0 0],[-5 8],'Color','black');
        line([-5 8],[-5 8],'Color','black');
        axis([-5 8 -5 8]);
    else
        line([-0.25 12],[-0.25 12],'Color','black');
        axis([-0.25 12 -0.25 12]);
    end
    title(titles(5+pPiS));
    xlabel('AN - v_A_S_P (deg/s)'); ylabel('CAT - v_A_S_P (deg/s)');
end
savefig(CatAn_RV_O,strcat(uname(5:end),'_RV_CatAn_Orig.fig'));
close CatAn_RV_O;

% Diagonale Figure of EV - Original
CatAn_EV_O = figure('Name','CatAn_EV_O');
titles = ["Left - pPiS 1","Left - pPiS 2","Left - pPiS 3","Left - pPiS 4","Left - pPiS 5","Right - pPiS 1","Right - pPiS 2","Right - pPiS 3","Right - pPiS 4","Right - pPiS 5"];
Dr = 1;
for pPiS = 1:5
    subplot(2,5,pPiS)
    x = U.Stim.Multi_EV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_EV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-12 0.25],[-12 0.25],'Color','black');
    axis([-12 0.25 -12 0.25]);
    ax = gca;
    ax.XDir = 'reverse';
    title(titles(pPiS));
    xlabel('AN - ev_A_S_P (deg/s)'); ylabel('CAT - ev_A_S_P (deg/s)');
end
Dr = 2;
for pPiS = 1:5
    subplot(2,5,5+pPiS)
    x = U.Stim.Multi_EV(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_EV(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    if pPiS == 5
        line([-5 8],[0 0],'Color','black');line([0 0],[-5 8],'Color','black');
        line([-5 8],[-5 8],'Color','black');
        axis([-5 8 -5 8]);
    else
        line([-0.25 12],[-0.25 12],'Color','black');
        axis([-0.25 12 -0.25 12]);
    end
    title(titles(5+pPiS));
    xlabel('AN - ev_A_S_P (deg/s)'); ylabel('CAT - ev_A_S_P (deg/s)');
end
savefig(CatAn_EV_O,strcat(uname(5:end),'_EV_CatAn_Orig.fig'));
close CatAn_EV_O;

% Diagonale Figure of ON - Original
CatAn_ON_O = figure('Name','CatAn_ON_O');
titles = ["Left - pPiS 1","Left - pPiS 2","Left - pPiS 3","Left - pPiS 4","Left - pPiS 5","Right - pPiS 1","Right - pPiS 2","Right - pPiS 3","Right - pPiS 4","Right - pPiS 5"];
Dr = 1;
for pPiS = 1:5
    subplot(2,5,pPiS)
    x = U.Stim.Multi_ON(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_ON(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([750 1050],[750 1050],'Color','black');
    axis([750 1050 750 1050]);
    title(titles(pPiS));
    xlabel('AN - Onset(ms post-blank)'); ylabel('CAT - Onset(ms post-blank)');
end
Dr = 2;
for pPiS = 1:5
    subplot(2,5,5+pPiS)
    x = U.Stim.Multi_ON(pPiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_ON(pPiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([750 1050],[750 1050],'Color','black');
    axis([750 1050 750 1050]);
    title(titles(5+pPiS));
    xlabel('AN - Onset(ms post-blank)'); ylabel('CAT - Onset(ms post-blank)');
end
savefig(CatAn_ON_O,strcat(uname(5:end),'_ON_CatAn_Orig.fig'));
close CatAn_ON_O;

% Diagonale Figure of SA - Original
CatAn_SA_O = figure('Name','CatAn_SA_O');
titles = ["Left - PiS 1","Left - PiS 2","Left - PiS 3","Left - PiS 4","Left - PiS 5","Right - PiS 1","Right - PiS 2","Right - PiS 3","Right - PiS 4","Right - PiS 5"];
Dr = 1;
for PiS = 1:5
    subplot(2,5,PiS)
    x = U.Stim.Multi_SA(PiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_SA(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([0 5],[0 5],'Color','black');
    axis([0 5 0 5]);
    title(titles(PiS));
    xlabel('AN - N of Saccades'); ylabel('CAT - N of Saccades');
end
Dr = 2;
for PiS = 1:5
    subplot(2,5,5+PiS)
    x = U.Stim.Multi_SA(PiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_SA(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([0 5],[0 5],'Color','black');
    axis([0 5 0 5]);
    title(titles(5+PiS));
    xlabel('AN - N of Saccades'); ylabel('CAT - N of Saccades');
end
savefig(CatAn_SA_O,strcat(uname(5:end),'_SA_CatAn_Orig.fig'));
close CatAn_SA_O;

% Diagonale Figure of Slope - Original
CatAn_Slope_O = figure('Name','CatAn_Slope_O');
titles = ["Left - PiS 1","Left - PiS 2","Left - PiS 3","Left - PiS 4","Left - PiS 5","Right - PiS 1","Right - PiS 2","Right - PiS 3","Right - PiS 4","Right - PiS 5"];
Dr = 1;
for PiS = 1:5
    subplot(2,5,PiS)
    x = U.Stim.Multi_Slope(PiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_Slope(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-0.3 0.05],[-0.3 0.05],'Color','black');
    axis([-0.3 0.05 -0.3 0.05]);
    ax = gca;
    ax.XDir = 'reverse';
    title(titles(PiS));
    xlabel('AN - Slope (deg/s^2)'); ylabel('CAT - Slope (deg/s^2)');
end
Dr = 2;
for PiS = 1:5
    subplot(2,5,5+PiS)
    x = U.Stim.Multi_Slope(PiS,1,Dr,1:U.Stim.subject);
    y = U.Stim.Multi_Slope(PiS,2,Dr,1:U.Stim.subject);
    scatter(x,y,'filled');
    line([-0.05 0.3],[-0.05 0.3],'Color','black');
    axis([-0.05 0.3 -0.05 0.3]);
    title(titles(5+PiS));
    xlabel('AN - Slope (deg/s^2)'); ylabel('CAT - Slope (deg/s^2)');
end
savefig(CatAn_Slope_O,strcat(uname(5:end),'_Slopes_CatAn_Orig.fig'));
close CatAn_Slope_O;

%% Create An/Cat-Comparisons - Blip - Original
% Diagonale Figure of Blip_Pre - Original
CatAn_Pre_Blip_O = figure('Name','CatAn_Pre_Blip_O');
titles = ["Left - Mean of Blip Peaks","Left - Mean Peak-to-Peak","Right - Mean of Blip Peaks","Right - Mean Peak-to-Peak"];

for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for BC = 1:3
        x = U.Stim.Pre_BSum(BC,1,Dr,1:U.Stim.subject)/2;
        y = U.Stim.Pre_BSum(BC,2,Dr,1:U.Stim.subject)/2;
        scatter(x,y,'filled');
        line([-30 30]*(2*Dr-3),[-30 30]*(2*Dr-3),'Color','black');
        axis([10 30 10 30]);
        if Dr == 1
            axis([-30 -10 -30 -10]);
            ax = gca;
            ax.XDir = 'reverse';
        end
        title(titles(2*Dr-1));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end

for Dr = 1:2
    subplot(2,2,2*Dr)
    hold on;
    for BC = 1:3
        x = U.Stim.Pre_BDiff(BC,1,Dr,1:U.Stim.subject);
        y = U.Stim.Pre_BDiff(BC,2,Dr,1:U.Stim.subject);
        scatter(x,y,'filled');
        line([0 7],[0 7],'Color','black');
        axis([0 7 0 7]);
        title(titles(2*Dr));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end
savefig(CatAn_Pre_Blip_O,strcat(uname(5:end),'_PreBlip_CatAn_Orig.fig'));
close CatAn_Pre_Blip_O;

% Diagonale Figure of Blip_Stim - Original
CatAn_Stim_Blip_O = figure('Name','CatAn_Stim_Blip_O');
titles = ["Left - Mean of Blip Peaks","Left - Mean Peak-to-Peak","Right - Mean of Blip Peaks","Right - Mean Peak-to-Peak"];

for Dr = 1:2
    subplot(2,2,2*Dr-1)
    hold on;
    for BC = 1:3
        x = U.Stim.Stim_BSum(BC,1,Dr,1:U.Stim.subject)/2;
        y = U.Stim.Stim_BSum(BC,2,Dr,1:U.Stim.subject)/2;
        scatter(x,y,'filled');
        line([-30 30]*(2*Dr-3),[-30 30]*(2*Dr-3),'Color','black');
        axis([10 30 10 30]);
        if Dr == 1
            axis([-30 -10 -30 -10]);
            ax = gca;
            ax.XDir = 'reverse';
        end
        title(titles(2*Dr-1));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end

for Dr = 1:2
    subplot(2,2,2*Dr)
    hold on;
    for BC = 1:3
        x = U.Stim.Stim_BDiff(BC,1,Dr,1:U.Stim.subject);
        y = U.Stim.Stim_BDiff(BC,2,Dr,1:U.Stim.subject);
        scatter(x,y,'filled');
        line([0 7],[0 7],'Color','black');
        axis([0 7 0 7]);
        title(titles(2*Dr));
        xlabel('AN - Mean of Blip Peaks (deg/s)'); ylabel('CAT - Mean of Blip Peaks (deg/s)');
    end
    hold off;
end
savefig(CatAn_Stim_Blip_O,strcat(uname(5:end),'_StimBlip_CatAn_Orig.fig'));
close CatAn_Stim_Blip_O;

%end
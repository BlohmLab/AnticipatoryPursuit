function extractFigures(E,multiSession,multiHB,s,m)

if multiHB == 1
    multiCond = 'Control';
else
    multiCond = 'An-Cat';
end

%% Average traces of trial for single session
figTrialSingle = figure('Name','figTrialSingle');
plots = {'Left - No Stimulation';'Left - Stimulation';'Left - Difference';'Right - No Stimulation';'Right - Stimulation';'Right - Difference'};
limits = {[-150 1450 -35 10];[-150 1450 -35 10];[-150 1450 -5 5];[-150 1450 -10 35];[-150 1450 -10 35];[-150 1450 -5 5]};
for dr = 1:2
    pc = 1;
    for stim = [2 3 5]
        subplot(2,3,3*dr+pc-3);
        hold on
        plot([-150 1450],[0 0],'k');
        plot([0 0],[-40 40],'b');
        plot((E.tEvents(3)-E.tEvents(2))*[1 1],[-40 40],'b');
        plot((E.tEvents(4)-E.tEvents(2))*[1 1],[-40 40],'c');
        plot((E.tEvents(5)-E.tEvents(2))*[1 1],[-40 40],'c');
        plot((E.tEvents(6)-E.tEvents(2))*[1 1],[-40 40],'k');
        %plot((E.tEvents(3)-E.tEvents(2)+50)*[1 1],[-20 20],'c');
        %PiS1 = plot(-250:1449,s.avtl_trial(:,stim,2,dr));
        PiS2 = plot(-150:1449,s.avtl_trial(:,stim,3,dr));
        PiS3 = plot(-150:1449,s.avtl_trial(:,stim,4,dr));
        PiS4 = plot(-150:1449,s.avtl_trial(:,stim,5,dr));
        PiS5 = plot(-150:1449,s.avtl_trial(:,stim,6,dr));
        hold off
        %legend([PiS1 PiS2 PiS3 PiS4 PiS5],{'PiS 1','PiS 2','PiS 3','PiS 4','PiS 5'});
        legend([PiS2 PiS3 PiS4 PiS5],{'PiS 2','PiS 3','PiS 4','PiS 5'});
        xlabel('time after blank onset [ms]');
        ylabel('Velocity diff [deg/s]');
        title(plots(3*dr+pc-3));
        axis(cell2mat(limits(3*dr+pc-3)));
        pc = pc+1;
    end
end
savefig(figTrialSingle,strcat(E.name(1:4),'_AVTrace_Trial(HB1-HB2).fig'));
close figTrialSingle;

%% Average traces of trial for multi-session
figTrialMulti = figure('Name','figTrialMulti');
plots = {'Left - Anodal';'Left - Cathodal';'Left - Difference';'Right - Anodal';'Right - Cathodal';'Right - Difference'};
limits = {[-150 1450 -35 10];[-150 1450 -35 10];[-150 1450 -5 5];[-150 1450 -10 35];[-150 1450 -10 35];[-150 1450 -5 5]};
for dr = 1:2
    pc = 1;
    for stim = 1:3
        subplot(2,3,3*dr+pc-3);
        hold on
        plot([-150 1450],[0 0],'k');
        plot([0 0],[-40 40],'b');
        plot((E.tEvents(3)-E.tEvents(2))*[1 1],[-40 40],'b');
        plot((E.tEvents(4)-E.tEvents(2))*[1 1],[-40 40],'c');
        plot((E.tEvents(5)-E.tEvents(2))*[1 1],[-40 40],'c');
        plot((E.tEvents(6)-E.tEvents(2))*[1 1],[-40 40],'k');
        %plot((E.tEvents(3)-E.tEvents(2)+50)*[1 1],[-20 20],'c');
        %PiS1 = plot(-250:1449,s.avtl_trial(:,stim,2,dr));
        PiS2 = plot(-150:1449,m.avtl_trial(:,stim,3,dr));
        PiS3 = plot(-150:1449,m.avtl_trial(:,stim,4,dr));
        PiS4 = plot(-150:1449,m.avtl_trial(:,stim,5,dr));
        PiS5 = plot(-150:1449,m.avtl_trial(:,stim,6,dr));
        hold off
        %legend([PiS1 PiS2 PiS3 PiS4 PiS5],{'PiS 1','PiS 2','PiS 3','PiS 4','PiS 5'});
        legend([PiS2 PiS3 PiS4 PiS5],{'PiS 2','PiS 3','PiS 4','PiS 5'});
        xlabel('time after blank onset [ms]');
        ylabel('Velocity diff [deg/s]');
        title(plots(3*dr+pc-3));
        axis(cell2mat(limits(3*dr+pc-3)));
        pc = pc+1;
    end
end
savefig(figTrialMulti,strcat(E.name(1:4),'_AVTrace_Trial(',multiCond,').fig'));
close figTrialMulti;
%% Average trace of blank period for single session
figBlankSingle = figure('Name','figBlankSingle');
plots = {'Left - No Stimulation';'Left - Stimulation';'Left - Difference';'Right - No Stimulation';'Right - Stimulation';'Right - Difference'};
limits = {[0 500 -20 5];[0 500 -20 5];[0 500 -5 5];[0 500 -5 20];[0 500 -5 20];[0 500 -5 5]};
for dr = 1:2
    pc = 1;
    for stim = [2 3 5]
        subplot(2,3,3*dr+pc-3);
        hold on
        plot([0 600],[0 0],'k');
        plot((E.tEvents(3)-E.tEvents(2))*[1 1],[-20 20],'k');
        plot((E.tEvents(3)-E.tEvents(2)+50)*[1 1],[-20 20],'c');
        pPiS1 = plot(1:600,s.avtl_rv(:,stim,2,dr));
        pPiS2 = plot(1:600,s.avtl_rv(:,stim,3,dr));
        pPiS3 = plot(1:600,s.avtl_rv(:,stim,4,dr));
        pPiS4 = plot(1:600,s.avtl_rv(:,stim,5,dr));
        pPiS5 = plot(1:600,s.avtl_rv(:,stim,6,dr));
        hold off
        legend([pPiS1 pPiS2 pPiS3 pPiS4 pPiS5],{'pPiS 1','pPiS 2','pPiS 3','pPiS 4','pPiS 5'});
        xlabel('time after blank onset [ms]');
        ylabel('Velocity diff [deg/s]');
        xlim([0 600]);
        title(plots(3*dr+pc-3));
        axis(cell2mat(limits(3*dr+pc-3)));
        pc = pc+1;
    end
end
savefig(figBlankSingle,strcat(E.name(1:4),'_AVTrace_Blank(HB1-HB2).fig'));
close figBlankSingle;

%% Average trace of blank period for multi-session
if multiSession == 1
    figBlankMulti = figure('Name','figBlankMulti');
    plots = {'Left - Anodal';'Left - Cathodal';'Left - Difference';'Right - Anodal';'Right - Cathodal';'Right - Difference'};
    limits = {[0 500 -20 5];[0 500 -20 5];[0 500 -5 5];[0 500 -5 20];[0 500 -5 20];[0 500 -5 5]};
    for dr = 1:2
        for stim = 1:3
            subplot(2,3,3*dr+stim-3);
            hold on
            plot([0 600],[0 0],'k');
            plot((E.tEvents(3)-E.tEvents(2))*[1 1],[-20 20],'k');
            plot((E.tEvents(3)-E.tEvents(2)+50)*[1 1],[-20 20],'c');
            pPiS1 = plot(1:600,m.avtl_rv(:,stim,2,dr));
            pPiS2 = plot(1:600,m.avtl_rv(:,stim,3,dr));
            pPiS3 = plot(1:600,m.avtl_rv(:,stim,4,dr));
            pPiS4 = plot(1:600,m.avtl_rv(:,stim,5,dr));
            pPiS5 = plot(1:600,m.avtl_rv(:,stim,6,dr));
            hold off
            legend([pPiS1 pPiS2 pPiS3 pPiS4 pPiS5],{'pPiS 1','pPiS 2','pPiS 3','pPiS 4','pPiS 5'});
            xlabel('time after blank onset [ms]');
            ylabel('Velocity diff [deg/s]');
            axis(cell2mat(limits(3*dr+stim-3)));
            title(plots(3*dr+stim-3));
        end
    end
    savefig(figBlankMulti,strcat(E.name(1:4),'_AVTrace_Blank(',multiCond,').fig'));
    close figBlankMulti;
end

%% Average trace of blip reactions for single session
figBlipSingle = figure('Name','figBlipSingle');
plots = {'Left - Conditions';'Right - Conditions';'Left - Difference';'Right - Difference'};
limits = {[0 400 -30 -15];[0 400 15 30];[0 400 -6 6];[0 400 -6 6]};
for dr = 1:2
    subplot(2,2,dr);
    hold on
    plot((E.bliptimes_a(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
    plot((E.bliptimes_a(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
    Stim1Hex1 = plot(1:400,s.avtl_bl_a(:,2,2,dr));
    Stim2Hex1 = plot(1:400,s.avtl_bl_a(:,3,2,dr));
    Stim1Hex2 = plot(1:400,s.avtl_bl_a(:,2,4,dr));
    Stim2Hex2 = plot(1:400,s.avtl_bl_a(:,3,4,dr));
    hold off
    legend([Stim1Hex1 Stim2Hex1 Stim1Hex2 Stim2Hex2],{'DE/IN - No Stim','DE/IN - Stim','IN/DE - No Stim','IN/DE - Stim'},'location','northwest');
    xlabel('time post-blip [ms]');
    ylabel('Velocity diff [deg/s]');
    axis(cell2mat(limits(dr)));
    title(plots(dr));
end

for dr = 1:2
    subplot(2,2,dr+2);
    hold on
    plot([0 400],[0 0],'k');
    plot((E.bliptimes_a(2,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
    plot((E.bliptimes_a(4,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
    DiffHex1 = plot(1:400,s.avtl_bl_a(:,2,5,dr));
    DiffHex2 = plot(1:400,s.avtl_bl_a(:,3,5,dr));
    hold off
    legend([DiffHex1 DiffHex2],{'Diff - No Stim','Diff - Stim'});
    xlabel('time post-blip [ms]');
    ylabel('Velocity diff [deg/s]');
    axis(cell2mat(limits(dr+2)));
    title(plots(dr+2));
end
savefig(figBlipSingle,strcat(E.name(1:4),'_AVTrace_Blip(HB1-HB2).fig'));
close figBlipSingle;

%% Average trace of blip reactions for multi-session
if multiSession == 1
    figBlipMulti = figure('Name','figBlipMulti');
    plots = {'Left - Conditions';'Right - Conditions';'Left - Difference';'Right - Difference'};
    limits = {[0 400 -30 -15];[0 400 15 30];[0 400 -6 6];[0 400 -6 6]};
    for dr = 1:2
        subplot(2,2,dr);
        hold on
        plot((E.bliptimes_a(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
        plot((E.bliptimes_a(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
        Stim1Hex1 = plot(1:400,m.avtl_bl_a(:,1,2,dr));
        Stim2Hex1 = plot(1:400,m.avtl_bl_a(:,2,2,dr));
        Stim1Hex2 = plot(1:400,m.avtl_bl_a(:,1,4,dr));
        Stim2Hex2 = plot(1:400,m.avtl_bl_a(:,2,4,dr));
        hold off
        legend([Stim1Hex1 Stim2Hex1 Stim1Hex2 Stim2Hex2],{'DE/IN - Anodal','DE/IN - Cathodal','IN/DE - Anodal','IN/DE - Cathodal'},'location','northwest');
        xlabel('time post-blip [ms]');
        ylabel('Velocity diff [deg/s]');
        axis(cell2mat(limits(dr)));
        title(plots(dr));
    end
    
    for dr = 1:2
        subplot(2,2,dr+2);
        hold on
        plot([0 400],[0 0],'k');
        plot((E.bliptimes_a(2,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
        plot((E.bliptimes_a(4,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
        DiffHex1 = plot(1:400,m.avtl_bl_a(:,1,5,dr));
        DiffHex2 = plot(1:400,m.avtl_bl_a(:,2,5,dr));
        hold off
        legend([DiffHex1 DiffHex2],{'Diff - Anodal','Diff - Cathodal'});
        xlabel('time post-blip [ms]');
        ylabel('Velocity diff [deg/s]');
        axis(cell2mat(limits(dr+2)));
        title(plots(dr+2));
    end
    savefig(figBlipMulti,strcat(E.name(1:4),'_AVTrace_Blip(',multiCond,').fig'));
    close figBlipMulti;
end
end
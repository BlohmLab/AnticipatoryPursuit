function extractFigures(E,multiSession,real)

multiCond = ["PreStim","Stim","PostStim"];

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
        %PiS1 = plot(-250:1449,real.s_avtl_trial(:,stim,2,dr));
        PiS2 = plot(-150:1449,real.s_avtl_trial(:,stim,3,dr));
        PiS3 = plot(-150:1449,real.s_avtl_trial(:,stim,4,dr));
        PiS4 = plot(-150:1449,real.s_avtl_trial(:,stim,5,dr));
        PiS5 = plot(-150:1449,real.s_avtl_trial(:,stim,6,dr));
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
savefig(figTrialSingle,strcat(E.name(1:4),'_AVTrace_Trial(Total).fig'));
saveas(figTrialSingle,strcat(E.name(1:4),'_AVTrace_Trial(Total).png'));
saveas(figTrialSingle,strcat(E.name(1:4),'_AVTrace_Trial(Total).svg'));
close figTrialSingle;

%% Average traces of trial for multi-session
if multiSession == 1
    limits = {[-150 1450 -35 10];[-150 1450 -35 10];[-150 1450 -5 5];[-150 1450 -10 35];[-150 1450 -10 35];[-150 1450 -5 5]};
    for HB = 1:3
        figTrialMulti = figure('Name','figTrialMulti');
        plots = {'Left - Session A';'Left - Session C';'Left - Difference';'Right - Session A';'Right - Session C';'Right - Difference'};
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
                %PiS1 = plot(-250:1449,real.s_avtl_trial(:,stim,2,dr));
                PiS2 = plot(-150:1449,real.m_avtl_trial(:,stim,3,dr,HB));
                PiS3 = plot(-150:1449,real.m_avtl_trial(:,stim,4,dr,HB));
                PiS4 = plot(-150:1449,real.m_avtl_trial(:,stim,5,dr,HB));
                PiS5 = plot(-150:1449,real.m_avtl_trial(:,stim,6,dr,HB));
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
        savefig(figTrialMulti,strcat(E.name(1:4),'_AVTrace_Trial(',multiCond(HB),').fig'));
        saveas(figTrialMulti,strcat(E.name(1:4),'_AVTrace_Trial(',multiCond(HB),').png'));
        saveas(figTrialMulti,strcat(E.name(1:4),'_AVTrace_Trial(',multiCond(HB),').svg'));
        close figTrialMulti;
    end
end

%% Average traces of Steady-pursuit-phase for single session
figSteadySingle = figure('Name','figSteadySingle');
plots = {'Left - No Stimulation';'Left - Stimulation';'Left - Difference';'Right - No Stimulation';'Right - Stimulation';'Right - Difference'};
limits = {[400 600 -35 10];[400 600 -35 10];[400 600 -5 5];[400 600 -10 35];[400 600 -10 35];[400 600 -5 5]};
for dr = 1:2
    pc = 1;
    for stim = [2 3 5]
        subplot(2,3,3*dr+pc-3);
        hold on
        plot([400 600],[0 0],'k');
        plot((E.tEvents(2)+500)*[1 1],[-40 40],'k');
        %PiS1 = plot(-250:1449,real.s_avtl_trial(:,stim,2,dr));
        PiS2 = plot(400:600,real.s_avtl_trial(550:750,stim,3,dr));
        PiS3 = plot(400:600,real.s_avtl_trial(550:750,stim,4,dr));
        PiS4 = plot(400:600,real.s_avtl_trial(550:750,stim,5,dr));
        PiS5 = plot(400:600,real.s_avtl_trial(550:750,stim,6,dr));
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
savefig(figSteadySingle,strcat(E.name(1:4),'_AVTrace_Steady(Total).fig'));
saveas(figSteadySingle,strcat(E.name(1:4),'_AVTrace_Steady(Total).png'));
saveas(figSteadySingle,strcat(E.name(1:4),'_AVTrace_Steady(Total).svg'));
close figSteadySingle;

%% Average traces of Steady-pursuit-phase for multi-session
if multiSession == 1
    limits = {[400 600 -35 10];[400 600 -35 10];[400 600 -5 5];[400 600 -10 35];[400 600 -10 35];[400 600 -5 5]};
    for HB = 1:3
        figSteadyMulti = figure('Name','figSteadyMulti');
        plots = {'Left - Session A';'Left - Session C';'Left - Difference';'Right - Session A';'Right - Session C';'Right - Difference'};
        for dr = 1:2
            pc = 1;
            for stim = 1:3
                subplot(2,3,3*dr+pc-3);
                hold on
                plot([400 600],[0 0],'k');
                plot((E.tEvents(2)+500)*[1 1],[-40 40],'k');
                %PiS1 = plot(-250:1449,real.s_avtl_trial(:,stim,2,dr));
                PiS2 = plot(400:600,real.m_avtl_trial(550:750,stim,3,dr,HB));
                PiS3 = plot(400:600,real.m_avtl_trial(550:750,stim,4,dr,HB));
                PiS4 = plot(400:600,real.m_avtl_trial(550:750,stim,5,dr,HB));
                PiS5 = plot(400:600,real.m_avtl_trial(550:750,stim,6,dr,HB));
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
        savefig(figSteadyMulti,strcat(E.name(1:4),'_AVTrace_Steady(',multiCond(HB),').fig'));
        saveas(figSteadyMulti,strcat(E.name(1:4),'_AVTrace_Steady(',multiCond(HB),').png'));
        saveas(figSteadyMulti,strcat(E.name(1:4),'_AVTrace_Steady(',multiCond(HB),').svg'));
        close figSteadyMulti;
    end
end

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
        pPiS1 = plot(1:600,real.s_avtl_blank(:,stim,2,dr));
        pPiS2 = plot(1:600,real.s_avtl_blank(:,stim,3,dr));
        pPiS3 = plot(1:600,real.s_avtl_blank(:,stim,4,dr));
        pPiS4 = plot(1:600,real.s_avtl_blank(:,stim,5,dr));
        pPiS5 = plot(1:600,real.s_avtl_blank(:,stim,6,dr));
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
savefig(figBlankSingle,strcat(E.name(1:4),'_AVTrace_Blank(Total).fig'));
saveas(figBlankSingle,strcat(E.name(1:4),'_AVTrace_Blank(Total).png'));
saveas(figBlankSingle,strcat(E.name(1:4),'_AVTrace_Blank(Total).svg'));
close figBlankSingle;

%% Average trace of blank period for multi-session
if multiSession == 1
    limits = {[0 500 -20 5];[0 500 -20 5];[0 500 -5 5];[0 500 -5 20];[0 500 -5 20];[0 500 -5 5]};
    for HB = 1:3
        figBlankMulti = figure('Name','figBlankMulti');
        plots = {'Left - Session A';'Left - Session C';'Left - Difference';'Right - Session A';'Right - Session C';'Right - Difference'};
        for dr = 1:2
            for stim = 1:3
                subplot(2,3,3*dr+stim-3);
                hold on
                plot([0 600],[0 0],'k');
                plot((E.tEvents(3)-E.tEvents(2))*[1 1],[-20 20],'k');
                plot((E.tEvents(3)-E.tEvents(2)+50)*[1 1],[-20 20],'c');
                pPiS1 = plot(1:600,real.m_avtl_blank(:,stim,2,dr,HB));
                pPiS2 = plot(1:600,real.m_avtl_blank(:,stim,3,dr,HB));
                pPiS3 = plot(1:600,real.m_avtl_blank(:,stim,4,dr,HB));
                pPiS4 = plot(1:600,real.m_avtl_blank(:,stim,5,dr,HB));
                pPiS5 = plot(1:600,real.m_avtl_blank(:,stim,6,dr,HB));
                hold off
                legend([pPiS1 pPiS2 pPiS3 pPiS4 pPiS5],{'pPiS 1','pPiS 2','pPiS 3','pPiS 4','pPiS 5'});
                xlabel('time after blank onset [ms]');
                ylabel('Velocity diff [deg/s]');
                axis(cell2mat(limits(3*dr+stim-3)));
                title(plots(3*dr+stim-3));
            end
        end
        savefig(figBlankMulti,strcat(E.name(1:4),'_AVTrace_Blank(',multiCond(HB),').fig'));
        saveas(figBlankMulti,strcat(E.name(1:4),'_AVTrace_Blank(',multiCond(HB),').png'));
        saveas(figBlankMulti,strcat(E.name(1:4),'_AVTrace_Blank(',multiCond(HB),').svg'));
        close figBlankMulti;
    end
end

%% Average trace of blip reactions for single session
figBlipSingle = figure('Name','figBlipSingle');
plots = {'Left - Conditions';'Right - Conditions';'Left - Difference';'Right - Difference'};
limits = {[0 400 -30 -15];[0 400 15 30];[0 400 -6 6];[0 400 -6 6]};
for dr = 1:2
    subplot(2,2,dr);
    hold on
    plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
    plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
    Stim1Hex1 = plot(1:400,real.s_avtl_blip(:,2,2,dr));
    Stim2Hex1 = plot(1:400,real.s_avtl_blip(:,3,2,dr));
    Stim1Hex2 = plot(1:400,real.s_avtl_blip(:,2,4,dr));
    Stim2Hex2 = plot(1:400,real.s_avtl_blip(:,3,4,dr));
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
    plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
    plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
    DiffHex1 = plot(1:400,real.s_avtl_blip(:,2,5,dr));
    DiffHex2 = plot(1:400,real.s_avtl_blip(:,3,5,dr));
    hold off
    legend([DiffHex1 DiffHex2],{'Diff - No Stim','Diff - Stim'});
    xlabel('time post-blip [ms]');
    ylabel('Velocity diff [deg/s]');
    axis(cell2mat(limits(dr+2)));
    title(plots(dr+2));
end
savefig(figBlipSingle,strcat(E.name(1:4),'_AVTrace_Blip(Total).fig'));
saveas(figBlipSingle,strcat(E.name(1:4),'_AVTrace_Blip(Total).png'));
saveas(figBlipSingle,strcat(E.name(1:4),'_AVTrace_Blip(Total).svg'));
close figBlipSingle;

%% Average trace of blip reactions for multi-session
if multiSession == 1
    limits = {[0 400 -30 -15];[0 400 15 30];[0 400 -6 6];[0 400 -6 6]};
    for HB = 1:3
        figBlipMulti = figure('Name','figBlipMulti');
        plots = {'Left - Conditions';'Right - Conditions';'Left - Difference';'Right - Difference'};
        for dr = 1:2
            subplot(2,2,dr);
            hold on
            plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
            plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
            Stim1Hex1 = plot(1:400,real.m_avtl_blip(:,1,2,dr,HB));
            Stim2Hex1 = plot(1:400,real.m_avtl_blip(:,2,2,dr,HB));
            Stim1Hex2 = plot(1:400,real.m_avtl_blip(:,1,4,dr,HB));
            Stim2Hex2 = plot(1:400,real.m_avtl_blip(:,2,4,dr,HB));
            hold off
            legend([Stim1Hex1 Stim2Hex1 Stim1Hex2 Stim2Hex2],{'DE/IN - Session A','DE/IN - Session C','IN/DE - Session A','IN/DE - Session C'},'location','northwest');
            xlabel('time post-blip [ms]');
            ylabel('Velocity diff [deg/s]');
            axis(cell2mat(limits(dr)));
            title(plots(dr));
        end
        
        for dr = 1:2
            subplot(2,2,dr+2);
            hold on
            plot([0 400],[0 0],'k');
            plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
            plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-6 6],'k');
            DiffHex1 = plot(1:400,real.m_avtl_blip(:,1,5,dr,HB));
            DiffHex2 = plot(1:400,real.m_avtl_blip(:,2,5,dr,HB));
            hold off
            legend([DiffHex1 DiffHex2],{'Diff - Anodal','Diff - Cathodal'});
            xlabel('time post-blip [ms]');
            ylabel('Velocity diff [deg/s]');
            axis(cell2mat(limits(dr+2)));
            title(plots(dr+2));
        end
        savefig(figBlipMulti,strcat(E.name(1:4),'_AVTrace_Blip(',multiCond(HB),').fig'));
        saveas(figBlipMulti,strcat(E.name(1:4),'_AVTrace_Blip(',multiCond(HB),').png'));
        saveas(figBlipMulti,strcat(E.name(1:4),'_AVTrace_Blip(',multiCond(HB),').svg'));
        close figBlipMulti;
    end
end
end
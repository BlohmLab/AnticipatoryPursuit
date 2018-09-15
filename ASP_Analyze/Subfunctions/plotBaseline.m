function plotBaseline(E)

%% Plot session difference in blank phase depending on direction, pPiS and block (1+2/3+4/5+6)
direction = ["Left","Right"];
limits = {[0 450 -25 10];[0 450 -25 10];[0 450 -4 4];[0 450 -10 25];[0 450 -10 25];[0 450 -4 4]};
plots = {'Session A - Average';'Session A - pPiS 1';'Session A - pPiS 2';'Session A - pPiS 3';'Session A - pPiS 4';'Session A - pPiS 5';...
    'Session C - Average';'Session C - pPiS 1';'Session C - pPiS 2';'Session C - pPiS 3';'Session C - pPiS 4';'Session C - pPiS 5';...
    'Difference - Average';'Difference - pPiS 1';'Difference - pPiS 2';'Difference - pPiS 3';'Difference - pPiS 4';'Difference - pPiS 5'};
for dr = 1:2
    stable_diff_fig = figure('Name','stable_diff_fig');
    for session = 1:3
        for cond = 1:6
            subplot(3,6,6*session+cond-6)
            hold on
            plot([0 450],[0 0],'k');
            plot((E.tEvents(3)-E.tEvents(2)+50)*[1 1],[-30 30],'c');
            db1 = plot(0:449,E.HB1_stable_blank(1:450,session,cond,1,dr));
            db2 = plot(0:449,E.HB1_stable_blank(1:450,session,cond,2,dr));
            db3 = plot(0:449,E.HB1_stable_blank(1:450,session,cond,3,dr));
            av = plot(0:449,E.HB1_stable_blank(1:450,session,cond,4,dr),'k');
            %legend([db1 db2 db3 av],{'Block 1&2','Block 3&4','Block 5&6','Average'});
            axis(cell2mat(limits(3*dr+session-3)));
            title(plots(6*session+cond-6));
            xlabel('time post-blank [ms]');
            ylabel('Velocity [deg/s]');
            hold off
            %legend([db1 db2 db3],{'Block 1+2','Block 3+4','Block 5+6'});
        end
    end
    savefig(stable_diff_fig,strcat(E.name(1:4),'_HB1_Blank_Stability(',direction(dr),').fig'));
    saveas(stable_diff_fig,strcat(E.name(1:4),'_HB1_Blank_Stability(',direction(dr),').svg'));
    close stable_diff_fig
end

%% Plot session difference in blip phase depending on direction, blip condition and block (1+2/3+4/5+6)
limits = {[0 400 -30 -15];[0 400 -30 -15];[0 400 -5 5];[0 400 15 30];[0 400 15 30];[0 400 -5 5]};
plots = {'Session A - Average';'Session A - De/In-Blip';'Session A - Zero-Blip';'Session A - In/De-Blip';...
    'Session C - Average';'Session C - De/In-Blip';'Session C - Zero-Blip';'Session C - In/De-Blip';...
    'Difference - Average';'Difference - De/In-Blip';'Difference - Zero-Blip';'Difference - In/De-Blip'};
for dr = 1:2
    stable_diff_fig = figure('Name','stable_diff_fig');
    for session = 1:3
        for cond = 1:4
            subplot(3,4,4*session+cond-4);
            hold on
            plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
            plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
            db1 = plot(0:399,E.HB1_stable_blip(:,session,cond,1,dr));
            db2 = plot(0:399,E.HB1_stable_blip(:,session,cond,2,dr));
            db3 = plot(0:399,E.HB1_stable_blip(:,session,cond,3,dr));
            av = plot(0:399,E.HB1_stable_blip(:,session,cond,4,dr),'k');
            hold off
            xlabel('time post-blip [ms]');
            ylabel('Velocity diff [deg/s]');
            axis(cell2mat(limits(3*dr+session-3)));
            title(plots(4*session+cond-4));
        end
    end
    savefig(stable_diff_fig,strcat(E.name(1:4),'_HB1_Blip_Stability(',direction(dr),').fig'));
    saveas(stable_diff_fig,strcat(E.name(1:4),'_HB1_Blip_Stability(',direction(dr),').svg'));
    close stable_diff_fig;
end

%% Plot difference in blip phase for zero-blip
limits = {[0 400 -30 -15];[0 400 15 30];[0 400 -6 6];[0 400 -6 6]};
stable_diff_fig = figure('Name','stable_diff_fig');
plots = {'Left - HB1';'Left - HB2';'Left - Compare Diffs';'Right - HB1';'Right - HB2';'Right - Compare Diffs'};
for dr = 1:2
    for HB = 1:2
        subplot(2,3,3*dr+HB-3);
        hold on
        plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
        plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
        Anodal = plot(1:400,E.AV.m_avtl_blip(:,1,3,dr,HB));
        Cathodal = plot(1:400,E.AV.m_avtl_blip(:,2,3,dr,HB));
        hold off
        legend([Anodal Cathodal],{'Zero-Blip - Anodal','Zero-Blip - Cathodal'},'location','northwest');
        xlabel('time post-blip [ms]');
        ylabel('Velocity diff [deg/s]');
        axis(cell2mat(limits(dr)));
        title(plots(3*dr+HB-3));
    end
    subplot(2,3,3*dr);
    hold on
    plot([0 400],[0 0],'k');
    plot((E.bliptimes(2,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
    plot((E.bliptimes(4,1,dr)-E.tEvents(4))*[1 1],[-30 30],'k');
    HB1 = plot(1:400,E.AV.m_avtl_blip(:,2,3,dr,1)-E.AV.m_avtl_blip(:,1,3,dr,1),'g');
    HB2 = plot(1:400,E.AV.m_avtl_blip(:,2,3,dr,2)-E.AV.m_avtl_blip(:,1,3,dr,2),'m');
    hold off
    legend([HB1 HB2],{'Diff(Cat-An) - Hexablock 1','Diff(Cat-An) - Hexablock 2'},'location','northwest');
    xlabel('time post-blip [ms]');
    ylabel('Velocity diff [deg/s]');
    axis(cell2mat(limits(dr+2)));
    title(plots(3*dr+HB-3));
end
savefig(stable_diff_fig,strcat(E.name(1:4),'_AVTrace_Blip_B.fig'));
saveas(stable_diff_fig,strcat(E.name(1:4),'_AVTrace_Blip_B.svg'));
close stable_diff_fig;
end
function extractRainstick(C,E,multiSession)

direction = ["Left","Right"];
multiCond = ["PreStim","Stim","PostStim"];
colors = {[0 0.5 1],[1 0.5 0],[0 1 0]};

%% Distribution of ASP & Onset depending on pPiS and stimulation for single session
for para = 1:3
    rainBlankSingle = figure('Name','rainBlankSingle');
    plots = {'Left - Previous PiS 1';'Left - Previous PiS 2';'Left - Previous PiS 3';'Left - Previous PiS 4';'Left - Previous PiS 5';...
        'Right - Previous PiS 1';'Right - Previous PiS 2';'Right - Previous PiS 3';'Right - Previous PiS 4';'Right - Previous PiS 5'};
    for dr = 1:2
        for pPiS = 1:5
            if para == 1
                data1 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==1);
                data2 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==2);
                data3 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==3);
            elseif para == 2
                data1 = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==1);
                data2 = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==2);
                data3 = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==2);
            elseif para == 3
                data1 = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==1);
                data2 = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==2);
                data3 = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==3);
            end
            subplot(2,5,5*dr+pPiS-5);
            hold on;
            rain1 = raincloud_plot('X',data1,'box_on',1,'color',cell2mat(colors(1)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .1, 'dot_dodge_amount', .1,'box_col_match', 0);
            rain2 = raincloud_plot('X',data2,'box_on',1,'color',cell2mat(colors(2)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .3, 'dot_dodge_amount', .3,'box_col_match', 0);
            rain3 = raincloud_plot('X',data3,'box_on',1,'color',cell2mat(colors(3)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .5, 'dot_dodge_amount', .5,'box_col_match', 0);
            hold off;
            if para == 1
                ylim([-0.15 0.225]);
                xlim([15*dr-45,15*dr]);
                paraName = 'RV';
            elseif para == 2
                ylim([-0.1 0.225]);
                xlim([15*dr-45,15*dr]);
                paraName = 'EV';
            elseif para == 3
                ylim([-0.025 0.035]);
                xlim([750,1100]);
                paraName = 'ON';
            end
            title(plots(5*dr+pPiS-5));
            
        end
    end
    savefig(rainBlankSingle,strcat(E.name(1:4),'_Rain_',paraName,'_Blank(Total).fig'));
    saveas(rainBlankSingle,strcat(E.name(1:4),'_Rain_',paraName,'_Blank(Total).png'));
    saveas(rainBlankSingle,strcat(E.name(1:4),'_Rain_',paraName,'_Blank(Total).svg'));
    close rainBlankSingle;
end

%% Distribution of ASP & Onset depending on pPiS and stimulation for multi-session
if multiSession == 1
    for HB = 1:3
        for para = 1:3
            rainBlankMulti = figure('Name','rainBlankMulti');
            plots = {'Left - Previous PiS 1';'Left - Previous PiS 2';'Left - Previous PiS 3';'Left - Previous PiS 4';'Left - Previous PiS 5';...
                'Right - Previous PiS 1';'Right - Previous PiS 2';'Right - Previous PiS 3';'Right - Previous PiS 4';'Right - Previous PiS 5'};
            for dr = 1:2
                for pPiS = 1:5
                    if para == 1
                        data1 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==1);
                        data2 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==2);
                    elseif para == 2
                        data1 = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==1);
                        data2 = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==2);
                    elseif para == 3
                        data1 = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==1);
                        data2 = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==2);
                    end
                    subplot(2,5,5*dr+pPiS-5);
                    hold on;
                    rain1 = raincloud_plot('X',data1,'box_on',1,'color',cell2mat(colors(1)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .1, 'dot_dodge_amount', .1,'box_col_match', 0);
                    rain2 = raincloud_plot('X',data2,'box_on',1,'color',cell2mat(colors(2)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .3, 'dot_dodge_amount', .3,'box_col_match', 0);
                    hold off;
                    if para == 1
                        ylim([-0.1 0.25]);
                        xlim([15*dr-45,15*dr]);
                        paraName = 'RV';
                    elseif para == 2
                        ylim([-0.1 0.25]);
                        xlim([15*dr-45,15*dr]);
                        paraName = 'EV';
                    elseif para == 3
                        ylim([-0.02 0.025]);
                        xlim([750,1100]);
                        paraName = 'ON';
                    end
                    title(plots(5*dr+pPiS-5));
                end
            end
            savefig(rainBlankMulti,strcat(E.name(1:4),'_Rain_',paraName,'_Blank(',multiCond(HB),').fig'));
            saveas(rainBlankMulti,strcat(E.name(1:4),'_Rain_',paraName,'_Blank(',multiCond(HB),').png'));
            saveas(rainBlankMulti,strcat(E.name(1:4),'_Rain_',paraName,'_Blank(',multiCond(HB),').svg'));
            close rainBlankMulti;
        end
    end
end

%% Distribution of blip reaction depending on blip condition and stimulation for single session
plots = {'P1 - De/In-Blip';'P1 - Zero-Blip';'P1 - In/De-Blip';'P2 - De/In-Blip';'P2 - Zero-Blip';'P2 - In/De-Blip'};
for dr = 1:2
    rainBlipSingle = figure('Name','rainBlipSingle');
    for peak = 1:2
        for bc = 1:3
            data1 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==bc-2 & E.spec.HB==1);
            data2 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==bc-2 & E.spec.HB==2);
            data3 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==bc-2 & E.spec.HB==3);
            subplot(2,3,3*peak+bc-3);
            hold on;
            rain1 = raincloud_plot('X',data1,'box_on',1,'color',cell2mat(colors(1)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .1, 'dot_dodge_amount', .1,'box_col_match', 0);
            rain2 = raincloud_plot('X',data2,'box_on',1,'color',cell2mat(colors(2)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .3, 'dot_dodge_amount', .3,'box_col_match', 0);
            rain3 = raincloud_plot('X',data3,'box_on',1,'color',cell2mat(colors(3)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .5, 'dot_dodge_amount', .5,'box_col_match', 0);
            hold off;
            ylim([-0.085 0.205]);
            xlim([40*dr-75,40*dr-45]);
            title(plots(3*peak+bc-3));
        end
    end
    savefig(rainBlipSingle,strcat(E.name(1:4),'_Rain_Blip(Total)_',direction(dr),'.fig'));
    saveas(rainBlipSingle,strcat(E.name(1:4),'_Rain_Blip(Total)_',direction(dr),'.png'));
    saveas(rainBlipSingle,strcat(E.name(1:4),'_Rain_Blip(Total)_',direction(dr),'.svg'));
    close rainBlipSingle;
end

%% Distribution of blip reaction depending on blip condition and stimulation for muti-session
if multiSession == 1
    plots = {'P1 - De/In-Blip';'P1 - Zero-Blip';'P1 - In/De-Blip';'P2 - De/In-Blip';'P2 - Zero-Blip';'P2 - In/De-Blip'};
    for HB = 1:3
        for dr = 1:2
            rainBlipMulti = figure('Name','rainBlipMulti');
            for peak = 1:2
                for bc = 1:3
                    data1 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==bc-2 & E.spec.HB==HB & E.spec.stimType==1);
                    data2 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==bc-2 & E.spec.HB==HB & E.spec.stimType==2);
                    subplot(2,3,3*peak+bc-3);
                    hold on;
                    rain1 = raincloud_plot('X',data1,'box_on',1,'color',cell2mat(colors(1)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .1, 'dot_dodge_amount', .1,'box_col_match', 0);
                    rain2 = raincloud_plot('X',data2,'box_on',1,'color',cell2mat(colors(2)),'alpha',0.5,'box_dodge', 1, 'box_dodge_amount', .3, 'dot_dodge_amount', .3,'box_col_match', 0);
                    hold off;
                    ylim([-0.085 0.205]);
                    xlim([40*dr-75,40*dr-45]);
                    title(plots(3*peak+bc-3));
                end
            end
            savefig(rainBlipMulti,strcat(E.name(1:4),'_Rain_Blip(',multiCond(HB),')_',direction(dr),'.fig'));
            saveas(rainBlipMulti,strcat(E.name(1:4),'_Rain_Blip(',multiCond(HB),')_',direction(dr),'.png'));
            saveas(rainBlipMulti,strcat(E.name(1:4),'_Rain_Blip(',multiCond(HB),')_',direction(dr),'.svg'));
            close rainBlipMulti;
        end
    end
end

end
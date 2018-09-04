function extractHisto(C,E,multiSession)

direction = ["Left","Right"];
multiCond = ["PreStim","Stim","PostStim"];
colors = {[0 0.5 1],[1 0.5 0],[0 1 0]};

%% Distribution of rv_ASP depending on pPiS and stimulation for single session
hisBlankSingle = figure('Name','hisBlankSingle');
plots = {'Left - Previous PiS 1';'Left - Previous PiS 2-4';'Left - Previous PiS 5';'Right - Previous PiS 1';'Right - Previous PiS 2-4';'Right - Previous PiS 5'};
for dr = 1:2
    for stim = 1:3
        data1 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB==1);
        data2 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB==2);
        data3 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB==3);
        subplot(2,3,3*dr+stim-3);
        hold on;
        his1 = histogram(data1,'BinWidth',1,'BinLimits',[15*dr-45,15*dr],'FaceColor',cell2mat(colors(1)));
        his2 = histogram(data2,'BinWidth',1,'BinLimits',[15*dr-45,15*dr],'FaceColor',cell2mat(colors(2)));
        his3 = histogram(data3,'BinWidth',1,'BinLimits',[15*dr-45,15*dr],'FaceColor',cell2mat(colors(3)));
        hold off;
        title(plots(3*dr+stim-3));
        legend([his1 his2 his3],{'Pre-Stim','Stim','Post-Stim'});
    end
end
savefig(hisBlankSingle,strcat(E.name(1:4),'_Histo_Blank(Total).fig'));
saveas(hisBlankSingle,strcat(E.name(1:4),'_Histo_Blank(Total).svg'));
saveas(hisBlankSingle,strcat(E.name(1:4),'_Histo_Blank(Total).png'));
close hisBlankSingle;

%% Distribution of rv_ASP depending on pPiS and stimulation for multi-session
if multiSession == 1
    for HB = 1:3
        hisBlankMulti = figure('Name','hisBlankMulti');
        plots = {'Left - Previous PiS 1';'Left - Previous PiS 2-4';'Left - Previous PiS 5';'Right - Previous PiS 1';'Right - Previous PiS 2-4';'Right - Previous PiS 5'};
        for dr = 1:2
            for stim = 1:3
                data1 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB==HB & E.spec.stimType==1);
                data2 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB==HB & E.spec.stimType==2);
                subplot(2,3,3*dr+stim-3);
                hold on;
                his1 = histogram(data1,'BinWidth',1,'BinLimits',[15*dr-45,15*dr],'FaceColor',cell2mat(colors(1)));
                his2 = histogram(data2,'BinWidth',1,'BinLimits',[15*dr-45,15*dr],'FaceColor',cell2mat(colors(2)));
                hold off;
                title(plots(3*dr+stim-3));
                if HB == 2
                    legend([his1 his2],{'Anodal','Cathodal'});
                else
                    legend([his1 his2],{'Session A','Session C'});
                end
            end
        end
        savefig(hisBlankMulti,strcat(E.name(1:4),'_Histo_Blank(',multiCond(HB),').fig'));
        saveas(hisBlankMulti,strcat(E.name(1:4),'_Histo_Blank(',multiCond(HB),').png'));
        saveas(hisBlankMulti,strcat(E.name(1:4),'_Histo_Blank(',multiCond(HB),').svg'));
        close hisBlankMulti;
    end
end

%% Number of saccades depending on pPiS and stimulation for single session
hisSaccSingle = figure('Name','hisSaccSingle');
plots = {'Left - Previous PiS 1';'Left - Previous PiS 2';'Left - Previous PiS 3';'Left - Previous PiS 4';'Left - Previous PiS 5';...
    'Right - Previous PiS 1';'Right - Previous PiS 2';'Right - Previous PiS 3';'Right - Previous PiS 4';'Right - Previous PiS 5'};
for dr = 1:2
    for pPiS = 1:5
        data1 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==1);
        data2 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==2);
        data3 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==3);
        subplot(2,5,5*dr+pPiS-5);
        hold on;
        his1 = histogram(data1,'BinWidth',1,'BinLimits',[0,7],'FaceColor',cell2mat(colors(1)));
        his2 = histogram(data2,'BinWidth',1,'BinLimits',[0,7],'FaceColor',cell2mat(colors(2)));
        his3 = histogram(data3,'BinWidth',1,'BinLimits',[0,7],'FaceColor',cell2mat(colors(3)));
        hold off;
        title(plots(5*dr+pPiS-5));
        legend([his1 his2 his3],{'Pre-Stim','Stim','Post-Stim'});
    end
end
savefig(hisSaccSingle,strcat(E.name(1:4),'_Histo_NSacc(Total).fig'));
saveas(hisSaccSingle,strcat(E.name(1:4),'_Histo_NSacc(Total).png'));
saveas(hisSaccSingle,strcat(E.name(1:4),'_Histo_NSacc(Total).svg'));
close hisSaccSingle;

%% Number of saccades depending on pPiS and stimulation for multi-session
if multiSession == 1
    for HB = 1:3
        hisSaccMulti = figure('Name','hisSaccMulti');
        plots = {'Left - Previous PiS 1';'Left - Previous PiS 2';'Left - Previous PiS 3';'Left - Previous PiS 4';'Left - Previous PiS 5';...
            'Right - Previous PiS 1';'Right - Previous PiS 2';'Right - Previous PiS 3';'Right - Previous PiS 4';'Right - Previous PiS 5'};
        for dr = 1:2
            for pPiS = 1:5
                data1 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==1);
                data2 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB==HB & E.spec.stimType==2);
                subplot(2,5,5*dr+pPiS-5);
                hold on;
                his1 = histogram(data1,'BinWidth',1,'BinLimits',[0,10],'FaceColor',cell2mat(colors(1)));
                his2 = histogram(data2,'BinWidth',1,'BinLimits',[0,10],'FaceColor',cell2mat(colors(2)));
                hold off;
                title(plots(5*dr+pPiS-5));
                if HB == 2
                    legend([his1 his2],{'Anodal','Cathodal'});
                else
                    legend([his1 his2],{'Session A','Session C'});
                end
            end
        end
        savefig(hisSaccMulti,strcat(E.name(1:4),'_Histo_NSacc(',multiCond(HB),').fig'));
        saveas(hisSaccMulti,strcat(E.name(1:4),'_Histo_NSacc(',multiCond(HB),').png'));
        saveas(hisSaccMulti,strcat(E.name(1:4),'_Histo_NSacc(',multiCond(HB),').svg'));
        close hisSaccMulti;
    end
end

%% Distribution of blip peak velocities depending on blip condition and stimulation for single session
for dr = 1:2
    hisBlipSingle = figure('Name','hisBlipSingle');
    plots = {'DE/IN-Blip - Peak 1';'DE/IN-Blip - Peak 2';'IN/DE-Blip - Peak 1';'IN/DE-Blip - Peak 2'};
    for bc = 1:2
        for peak = 1:2
            data1 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB==1);
            data2 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB==2);
            subplot(2,2,2*bc+peak-2);
            hold on;
            his1 = histogram(data1,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50],'FaceColor',cell2mat(colors(1)));
            his2 = histogram(data2,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50],'FaceColor',cell2mat(colors(2)));
            hold off;
            title(plots(2*bc+peak-2));
            legend([his1 his2],{'Pre-Stim','Stim','Post-Stim'});
        end
    end
    savefig(hisBlipSingle,strcat(E.name(1:4),'_Histo_Blip(Total)_',direction(dr),'.fig'));
    saveas(hisBlipSingle,strcat(E.name(1:4),'_Histo_Blip(Total)_',direction(dr),'.png'));
    saveas(hisBlipSingle,strcat(E.name(1:4),'_Histo_Blip(Total)_',direction(dr),'.svg'));
    close hisBlipSingle;
end

%% Distribution of blip peak velocities depending on blip condition and stimulation for multi-session
if multiSession == 1
    for HB = 1:3
        for dr = 1:2
            hisBlipMulti = figure('Name','hisBlipMulti');
            plots = {'DE/IN-Blip - Peak 1';'DE/IN-Blip - Peak 2';'IN/DE-Blip - Peak 1';'IN/DE-Blip - Peak 2'};
            for bc = 1:2
                for peak = 1:2
                    data1 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB==HB & E.spec.stimType==1);
                    data2 = C.eyeXvws(E.bliptimes(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB==HB & E.spec.stimType==2);
                    subplot(2,2,2*bc+peak-2);
                    hold on;
                    his1 = histogram(data1,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50],'FaceColor',cell2mat(colors(1)));
                    his2 = histogram(data2,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50],'FaceColor',cell2mat(colors(2)));
                    hold off;
                    title(plots(2*bc+peak-2));
                    if HB == 2
                        legend([his1 his2],{'Anodal','Cathodal'});
                    else
                        legend([his1 his2],{'Session A','Session C'});
                    end
                end
            end
            savefig(hisBlipMulti,strcat(E.name(1:4),'_Histo_Blip(',cell2mat(multiCond(HB)),')_',cell2mat(direction(dr)),'.fig'));
            saveas(hisBlipMulti,strcat(E.name(1:4),'_Histo_Blip(',cell2mat(multiCond(HB)),')_',cell2mat(direction(dr)),'.png'));
            saveas(hisBlipMulti,strcat(E.name(1:4),'_Histo_Blip(',cell2mat(multiCond(HB)),')_',cell2mat(direction(dr)),'.svg'));
            close hisBlipMulti;
        end
    end
end

end
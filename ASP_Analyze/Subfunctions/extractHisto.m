function extractHisto(C,E,multiSession,multiHB)

if multiHB == 1
    multiCond = 'Control';
else
    multiCond = 'An-Cat';
end

%% Distribution of rv_ASP depending on pPiS and stimulation for single session
hisBlankSingle = figure('Name','hisBlankSingle');
plots = {'Left - Previous PiS 1';'Left - Previous PiS 2-4';'Left - Previous PiS 5';'Right - Previous PiS 1';'Right - Previous PiS 2-4';'Right - Previous PiS 5'};
for dr = 1:2
    for stim = 1:3
        data1 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB(:,3)==1);
        data2 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB(:,3)==2);
        subplot(2,3,3*dr+stim-3);
        hold on;
        his1 = histogram(data1,'BinWidth',1,'BinLimits',[15*dr-45,15*dr]);
        his2 = histogram(data2,'BinWidth',1,'BinLimits',[15*dr-45,15*dr]);
        hold off;
        title(plots(3*dr+stim-3));
        legend([his1 his2],{'No Stim','Stim'});
    end
end
savefig(hisBlankSingle,strcat(E.name(1:4),'_Histo_Blank(HB1-HB2).fig'));
close hisBlankSingle;

%% Distribution of rv_ASP depending on pPiS and stimulation for multi-session
if multiSession == 1
    hisBlankMulti = figure('Name','hisBlankMulti');
    plots = {'Left - Previous PiS 1';'Left - Previous PiS 2-4';'Left - Previous PiS 5';'Right - Previous PiS 1';'Right - Previous PiS 2-4';'Right - Previous PiS 5'};
    for dr = 1:2
        for stim = 1:3
            data1 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==1);
            data2 = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & round(E.spec.prevTrial(:,2)/3)==stim-1 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==2);
            subplot(2,3,3*dr+stim-3);
            hold on;
            his1 = histogram(data1,'BinWidth',1,'BinLimits',[15*dr-45,15*dr]);
            his2 = histogram(data2,'BinWidth',1,'BinLimits',[15*dr-45,15*dr]);
            hold off;
            title(plots(3*dr+stim-3));
            legend([his1 his2],{'Anodal','Cathodal'});
        end
    end
    savefig(hisBlankMulti,strcat(E.name(1:4),'_Histo_Blank(',multiCond,').fig'));
    close hisBlankMulti;
end

%% Number of saccades depending on pPiS and stimulation for single session
hisSaccSingle = figure('Name','hisSaccSingle');
plots = {'Left - Previous PiS 1';'Left - Previous PiS 2';'Left - Previous PiS 3';'Left - Previous PiS 4';'Left - Previous PiS 5';...
    'Right - Previous PiS 1';'Right - Previous PiS 2';'Right - Previous PiS 3';'Right - Previous PiS 4';'Right - Previous PiS 5'};
for dr = 1:2
    for pPiS = 1:5
        data1 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB(:,3)==1);
        data2 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB(:,3)==2);
        subplot(2,5,5*dr+pPiS-5);
        hold on;
        his1 = histogram(data1,'BinWidth',1,'BinLimits',[0,7]);
        his2 = histogram(data2,'BinWidth',1,'BinLimits',[0,7]);
        hold off;
        title(plots(5*dr+pPiS-5));
        legend([his1 his2],{'No Stim','Stim'});
    end
end
savefig(hisSaccSingle,strcat(E.name(1:4),'_Histo_NSacc(HB1-HB2).fig'));
close hisSaccSingle;

%% Number of saccades depending on pPiS and stimulation for multi-session
if multiSession == 1
    hisSaccMulti = figure('Name','hisSaccMulti');
    plots = {'Left - Previous PiS 1';'Left - Previous PiS 2';'Left - Previous PiS 3';'Left - Previous PiS 4';'Left - Previous PiS 5';...
        'Right - Previous PiS 1';'Right - Previous PiS 2';'Right - Previous PiS 3';'Right - Previous PiS 4';'Right - Previous PiS 5'};
    for dr = 1:2
        for pPiS = 1:5
            data1 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==1);
            data2 = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==dr & E.spec.prevTrial(:,2)==pPiS & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==2);
            subplot(2,5,5*dr+pPiS-5);
            hold on;
            his1 = histogram(data1,'BinWidth',1,'BinLimits',[0,10]);
            his2 = histogram(data2,'BinWidth',1,'BinLimits',[0,10]);
            hold off;
            title(plots(5*dr+pPiS-5));
            legend([his1 his2],{'Anodal','Cathodal'});
        end
    end
    savefig(hisSaccMulti,strcat(E.name(1:4),'_Histo_NSacc(',multiCond,').fig'));
    close hisSaccMulti;
end

%% Distribution of blip peak velocities depending on blip condition and stimulation for single session
for dr = 1:2
    hisBlipSingle = figure('Name','hisBlipSingle');
    plots = {'DE/IN-Blip - Peak 1';'DE/IN-Blip - Peak 2';'IN/DE-Blip - Peak 1';'IN/DE-Blip - Peak 2'};
    for bc = 1:2
        for peak = 1:2
            data1 = C.eyeXvws(E.bliptimes_a(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB(:,3)==1);
            data2 = C.eyeXvws(E.bliptimes_a(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB(:,3)==2);
            subplot(2,2,2*bc+peak-2);
            hold on;
            his1 = histogram(data1,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50]);
            his2 = histogram(data2,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50]);
            hold off;
            title(plots(2*bc+peak-2));
            legend([his1 his2],{'No Stim','Stim'});
        end
    end
    if dr ==1
        savefig(hisBlipSingle,strcat(E.name(1:4),'_Histo_Blip(HB1-HB2)_Left.fig'));
    else
        savefig(hisBlipSingle,strcat(E.name(1:4),'_Histo_Blip(HB1-HB2)_Right.fig'));
    end
    close hisBlipSingle;
end

%% Distribution of blip peak velocities depending on blip condition and stimulation for multi-session
if multiSession == 1
    for dr = 1:2
        hisBlipMulti = figure('Name','hisBlipMulti');
        plots = {'DE/IN-Blip - Peak 1';'DE/IN-Blip - Peak 2';'IN/DE-Blip - Peak 1';'IN/DE-Blip - Peak 2'};
        for bc = 1:2
            for peak = 1:2
                data1 = C.eyeXvws(E.bliptimes_a(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==1);
                data2 = C.eyeXvws(E.bliptimes_a(2*peak,1,dr),E.spec.exclude==0 & E.spec.trialDr==dr & E.spec.trialBlip==2*bc-3 & E.spec.HB(:,3)==multiHB & E.spec.stimType(:,3)==2);
                subplot(2,2,2*bc+peak-2);
                hold on;
                his1 = histogram(data1,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50]);
                his2 = histogram(data2,'BinWidth',0.5,'BinLimits',[50*dr-100,50*dr-50]);
                hold off;
                title(plots(2*bc+peak-2));
                legend([his1 his2],{'Anodal','Cathodal'});
            end
        end
        if dr ==1
            savefig(hisBlipMulti,strcat(E.name(1:4),'_Histo_Blip(',multiCond,')_Left.fig'));
        else
            savefig(hisBlipMulti,strcat(E.name(1:4),'_Histo_Blip(',multiCond,')_Right.fig'));
        end
        close hisBlipMulti;
    end
end

end
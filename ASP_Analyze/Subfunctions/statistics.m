function [E] = statistics(C,E,multiSession)

%% Calculate ANOVA for hexablock x pPiS - single session (rv|ev|On)
ANO2_Stats = cell(11,8,3);

for para = 1:3 % 1:rv_ASP | 2:ev_ASP | 3:N_Sacc | 4:Onset
    for n = 0:2
        ANO2_Stats(4*n+1,1:7,para) = {'Dir','F','p','pn^2','w^2','SS','MS';};
        ANO2_Stats(4*n+1:4*n+3,1,para) = {'Dir','Left','Right'};
    end
    ANO2_Stats(1,8,para) = {'HexaBlock'}; ANO2_Stats(5,8,para) = {'pPiS'}; ANO2_Stats(9,8,para) = {'Interact'};
    for d = 1:2
%         if para ~= 1 && d == 2
%             
%         else
            % Resort data for analysis
            group = [];
            group(:,1) = E.spec.HB(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
            group(:,2) = E.spec.prevTrial(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d,2);
            sANO = [];
            if para == 1
                sANO(:,1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
            elseif para == 2
                sANO(:,1) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
            elseif para == 3
                sANO(:,1) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
            end
            sANO(:,2:3) = group(:,1:2);
            sANO = sortrows(sANO,[2 3]); % Sort values according to hexablock & pPiS
            [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','pPiS'}); % 2-way ANOVA
            mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','pPiS'}); % 2-way MES analysis
            close Figure 2;
            % Save stats
            %     E.LearnStats.dfe(1,d) = ano_stats.dfe;
            %     E.LearnStats.s(1,d) = sqrt(cell2mat(tbl(4,5)));
            for n = 0:2
                ANO2_Stats(4*n+d+1,2,para) = tbl(2+n,6);
                ANO2_Stats(4*n+d+1,3,para) = {p(n+1)};
                ANO2_Stats(4*n+d+1,4,para) = {mes_stats.partialeta2(n+1)};
                ANO2_Stats(4*n+d+1,5,para) = {mes_stats.omega2(n+1)};
                %ANO2_Stats(4*n+d+1,6) = {ano_stats.s}; % square root of mean squared error
                %ANO2_Stats(4*n+d+1,7) = {ano_stats.n}; % number of observations per group
                ANO2_Stats(4*n+d+1,6,para) = tbl(2+n,2);
                ANO2_Stats(4*n+d+1,7,para) = tbl(2+n,5);
            end
%         end
    end
end
E.total.rASP2_Stats = ANO2_Stats(:,:,1);
E.total.eASP2_Stats = ANO2_Stats(:,:,2);
E.total.ONSET2_Stats = ANO2_Stats(:,:,3);

%% Calculate ANOVA for hexablock x pPiS - multi-session (rv|ev|NSacc|On)
if multiSession == 1
    ANO2_Stats = cell(11,8,3,3);
    for HB = 1:3
        for para = 1:3 % 1:rv_ASP | 2:ev_ASP | 3:N_Sacc | 4:Onset
            for n = 0:2
                ANO2_Stats(4*n+1,1:7,para,HB) = {'Dir','F','p','pn^2','w^2','SS','MS'};
                ANO2_Stats(4*n+1:4*n+3,1,para,HB) = {'Dir','Left','Right'};
            end
            ANO2_Stats(1,8,para,HB) = {'Stim'}; ANO2_Stats(5,8,para,HB) = {'pPiS'}; ANO2_Stats(9,8,para,HB) = {'Interact'};
            
            for d = 1:2
                % Resort data for analysis
                group = [];
                group(:,1) = E.spec.stimType(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB);
                group(:,2) = E.spec.prevTrial(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB,2);
                sANO = [];
                if para == 1
                    sANO(:,1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB);
                elseif para == 2
                    sANO(:,1) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB);
                elseif para == 3
                    sANO(:,1) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB==HB);
                end
                sANO(:,2:3) = group(:,1:2);
                sANO = sortrows(sANO,[2 3]); % Sort values according to hexablock & pPiS
                [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','pPiS'}); % 2-way ANOVA
                mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','pPiS'}); % 2-way MES analysis
                close Figure 2;
                % Save stats
                %     E.LearnStats.dfe(1,d) = ano_stats.dfe;
                %     E.LearnStats.s(1,d) = sqrt(cell2mat(tbl(4,5)));
                for n = 0:2
                    ANO2_Stats(4*n+d+1,2,para,HB) = tbl(2+n,6);
                    ANO2_Stats(4*n+d+1,3,para,HB) = {p(n+1)};
                    ANO2_Stats(4*n+d+1,4,para,HB) = {mes_stats.partialeta2(n+1)};
                    ANO2_Stats(4*n+d+1,5,para,HB) = {mes_stats.omega2(n+1)};
                    %ANO2_Stats(4*n+d+1,6) = {ano_stats.s}; % square root of mean squared error
                    %ANO2_Stats(4*n+d+1,7) = {ano_stats.n}; % number of observations per group
                    ANO2_Stats(4*n+d+1,6,para,HB) = tbl(2+n,2);
                    ANO2_Stats(4*n+d+1,7,para,HB) = tbl(2+n,5);
                end
            end
        end 
    end
        E.pre.rASP2_Stats = ANO2_Stats(:,:,1,1);
        E.pre.eASP2_Stats = ANO2_Stats(:,:,2,1);
        E.pre.ONSET2_Stats = ANO2_Stats(:,:,3,1);
        E.stim.rASP2_Stats = ANO2_Stats(:,:,1,2);
        E.stim.eASP2_Stats = ANO2_Stats(:,:,2,2);
        E.stim.ONSET2_Stats = ANO2_Stats(:,:,3,2);
        E.post.rASP2_Stats = ANO2_Stats(:,:,1,3);
        E.post.eASP2_Stats = ANO2_Stats(:,:,2,3);
        E.post.ONSET2_Stats = ANO2_Stats(:,:,3,3);
end

%% Calculate ANOVA for hexablock x PiS - multi-session (Slope | N_Sacc)
if multiSession == 1
    ANO2_Stats = cell(11,8,2,3);
    
    for para = 1:2 % 1: Steady-Velocity at t = 200 ms post-move | 2: Number of Saccades
        for HB = 1:3
            for n = 0:2
                ANO2_Stats(4*n+1,1:7,para,HB) = {'Dir','F','p','pn^2','w^2','SS','MS'};
                ANO2_Stats(4*n+1:4*n+3,1,para,HB) = {'Dir','Left','Right'};
            end
            ANO2_Stats(1,8,para,HB) = {'HexaBlock'}; ANO2_Stats(5,8,para,HB) = {'PiS'}; ANO2_Stats(9,8,para,HB) = {'Interact'};
            for d = 1:2
                group = [];
                group(:,1) = E.spec.stimType(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                group(:,2) = E.spec.trialPiS(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                sANO = [];
                if para == 1
                    sANO(:,1) = C.eyeXvws(E.tEvents(3)+200,E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                else
                    sANO(:,1) = E.saccades(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                end
                sANO(:,2:3) = group(:,1:2); % Sort values according to Stim & PiS
                sANO = sortrows(sANO,[2 3]);
                [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','blipDir'}); % 2-way ANOVA
                mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','blipDir'}); % 2-way MES analysis
                close Figure 2;
                % Save stats
                for n = 0:2
                    ANO2_Stats(4*n+d+1,2,para,HB) = tbl(2+n,6);
                    ANO2_Stats(4*n+d+1,3,para,HB) = {p(n+1)};
                    ANO2_Stats(4*n+d+1,4,para,HB) = {mes_stats.partialeta2(n+1)};
                    ANO2_Stats(4*n+d+1,5,para,HB) = {mes_stats.omega2(n+1)};
                    ANO2_Stats(4*n+d+1,6,para,HB) = tbl(2+n,2);
                    ANO2_Stats(4*n+d+1,7,para,HB) = tbl(2+n,5);
                end
            end
        end
    end
    E.pre.Steady2_Stats = ANO2_Stats(:,:,1,1);
    E.stim.Steady2_Stats = ANO2_Stats(:,:,1,2);
    E.post.Steady2_Stats = ANO2_Stats(:,:,1,3);
    E.pre.Sacc2_Stats = ANO2_Stats(:,:,2,1);
    E.stim.Sacc2_Stats = ANO2_Stats(:,:,2,2);
    E.post.Sacc2_Stats = ANO2_Stats(:,:,2,3);
end

%% Blip peak ANOVA for hexablock x blip cond - single session
ANO2_Stats = cell(17,9);
for n = 0:2
    ANO2_Stats(6*n+1,1:8) = {'Peak','Dir','F','p','pn^2','w^2','SS','MS'};
    ANO2_Stats(6*n+1:6*n+5,1) = {'Dir','Left','Left','Right','Right'};
end
ANO2_Stats(1,9) = {'HexaBlock'}; ANO2_Stats(7,9) = {'BlipCond'}; ANO2_Stats(13,9) = {'Interact'};

for d = 1:2
    group = [];
    group(:,1) = E.spec.HB(E.spec.exclude==0 & E.spec.trialDr==d);
    group(:,2) = E.spec.trialBlip(E.spec.exclude==0 & E.spec.trialDr==d);
    for peak = 1:2
        sANO = [];
        sANO(:,1) = E.v_Blip(E.spec.exclude==0 & E.spec.trialDr==d,peak);
        sANO(:,2:3) = group(:,1:2);
        sANO = sortrows(sANO,[2 3]);
        [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','blipDir'}); % 2-way ANOVA
        mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','blipDir'}); % 2-way MES analysis
        close Figure 2;
        % Save stats
        for n = 0:2
            ANO2_Stats(6*n+2*d+peak-1,2) = {peak};
            ANO2_Stats(6*n+2*d+peak-1,3) = tbl(2+n,6);
            ANO2_Stats(6*n+2*d+peak-1,4) = {p(n+1)};
            ANO2_Stats(6*n+2*d+peak-1,5) = {mes_stats.partialeta2(n+1)};
            ANO2_Stats(6*n+2*d+peak-1,6) = {mes_stats.omega2(n+1)};
            %E.rASP2_Stats(4*n+d+1,6) = {ano_stats.s}; % square root of mean squared error
            %E.rASP2_Stats(4*n+d+1,7) = {ano_stats.n}; % number of observations per group
            ANO2_Stats(6*n+2*d+peak-1,7) = tbl(2+n,2);
            ANO2_Stats(6*n+2*d+peak-1,8) = tbl(2+n,5);
        end
    end
end
E.total.Blip2_Stats = ANO2_Stats;

%% Blip peak ANOVA for hexablock x blip cond - multi-session
if multiSession == 1
    ANO2_Stats = cell(17,9,3);
    for HB = 1:3
        for n = 0:2
            ANO2_Stats(6*n+1,1:8,HB) = {'Dir','Peak','F','p','pn^2','w^2','SS','MS'};
            ANO2_Stats(6*n+1:6*n+5,1,HB) = {'Dir','Left','Left','Right','Right'};
        end
        ANO2_Stats(1,9,HB) = {'Stim'}; ANO2_Stats(7,9,HB) = {'BlipCond'}; ANO2_Stats(13,9,HB) = {'Interact'};
        
        for d = 1:2
            group = [];
            group(:,1) = E.spec.stimType(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
            group(:,2) = E.spec.trialBlip(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
            for peak = 1:2
                sANO = [];
                sANO(:,1) = E.v_Blip(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB,peak);
                sANO(:,2:3) = group(:,1:2); % Sorted blip peaks
                sANO = sortrows(sANO,[2 3]);
                [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','blipDir'}); % 2-way ANOVA
                mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','blipDir'}); % 2-way MES analysis
                close Figure 2;
                % Save stats
                for n = 0:2
                    ANO2_Stats(6*n+2*d+peak-1,2,HB) = {peak};
                    ANO2_Stats(6*n+2*d+peak-1,3,HB) = tbl(2+n,6);
                    ANO2_Stats(6*n+2*d+peak-1,4,HB) = {p(n+1)};
                    ANO2_Stats(6*n+2*d+peak-1,5,HB) = {mes_stats.partialeta2(n+1)};
                    ANO2_Stats(6*n+2*d+peak-1,6,HB) = {mes_stats.omega2(n+1)};
                    %E.rASP2_Stats(4*n+d+1,6) = {ano_stats.s}; % square root of mean squared error
                    %E.rASP2_Stats(4*n+d+1,7) = {ano_stats.n}; % number of observations per group
                    ANO2_Stats(6*n+2*d+peak-1,7,HB) = tbl(2+n,2);
                    ANO2_Stats(6*n+2*d+peak-1,8,HB) = tbl(2+n,5);
                end
            end
        end
    end
    
    E.pre.Blip2_Stats = ANO2_Stats(:,:,1);
    E.stim.Blip2_Stats = ANO2_Stats(:,:,2);
    E.post.Blip2_Stats = ANO2_Stats(:,:,3);
end

%% Blip peak ANOVA for hexablock x blip cond - single-session
if multiSession == 1
    ANO2_Stats = cell(9,8,2);
    for para = 1:2
            for n = 0:2
                ANO2_Stats(3*n+1,1:7,para) = {'Dir','F','p','pn^2','w^2','SS','MS'};
                ANO2_Stats(3*n+1:3*n+3,1,para) = {'Dir','Left','Right'};
            end
            ANO2_Stats(1,8,para) = {'HexaBlock'}; ANO2_Stats(4,8,para) = {'BlipCond'}; ANO2_Stats(7,8,para) = {'Interact'};
            
            for d = 1:2
                group = [];
                group(:,1) = E.spec.HB(E.spec.exclude==0 & E.spec.trialDr==d);
                group(:,2) = E.spec.trialBlip(E.spec.exclude==0 & E.spec.trialDr==d);
                sANO = [];
                if para == 1
                    sANO(:,1) = E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==d);
                else
                    sANO(:,1) = E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==d);
                end
                sANO(:,2:3) = group(:,1:2); % Sorted blip peaks
                sANO = sortrows(sANO,[2 3]);
                [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','blipDir'}); % 2-way ANOVA
                mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','blipDir'}); % 2-way MES analysis
                close Figure 2;
                % Save stats
                for n = 0:2
                    ANO2_Stats(3*n+d+1,2,para) = tbl(2+n,6);
                    ANO2_Stats(3*n+d+1,3,para) = {p(n+1)};
                    ANO2_Stats(3*n+d+1,4,para) = {mes_stats.partialeta2(n+1)};
                    ANO2_Stats(3*n+d+1,5,para) = {mes_stats.omega2(n+1)};
                    ANO2_Stats(3*n+d+1,6,para) = tbl(2+n,2);
                    ANO2_Stats(3*n+d+1,7,para) = tbl(2+n,5);
                end
            end
    end
    E.total.BlipDiff_Stats = ANO2_Stats(:,:,1);
    E.total.BlipSum_Stats = ANO2_Stats(:,:,2);
end

%% Blip peak ANOVA for hexablock x blip cond - multi-session
if multiSession == 1
    ANO2_Stats = cell(9,8,2,3);
    for para = 1:2
        for HB = 1:3
            for n = 0:2
                ANO2_Stats(3*n+1,1:7,para,HB) = {'Dir','F','p','pn^2','w^2','SS','MS'};
                ANO2_Stats(3*n+1:3*n+3,1,para,HB) = {'Dir','Left','Right'};
            end
            ANO2_Stats(1,8,para,HB) = {'Stim'}; ANO2_Stats(4,8,para,HB) = {'BlipCond'}; ANO2_Stats(7,8,para,HB) = {'Interact'};
            
            for d = 1:2
                group = [];
                group(:,1) = E.spec.stimType(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                group(:,2) = E.spec.trialBlip(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                sANO = [];
                if para == 1
                    sANO(:,1) = E.BlipDiff(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                else
                    sANO(:,1) = E.BlipSum(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB==HB);
                end
                sANO(:,2:3) = group(:,1:2); % Sorted blip peaks
                sANO = sortrows(sANO,[2 3]);
                [p,tbl,ano_stats] = anovan(sANO(:,1),sANO(:,2:3),'model','interaction','varnames',{'hexaBlock','blipDir'}); % 2-way ANOVA
                mes_stats = mes2way(sANO(:,1),sANO(:,2:3),{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','blipDir'}); % 2-way MES analysis
                close Figure 2;
                % Save stats
                for n = 0:2
                    ANO2_Stats(3*n+d+1,2,para,HB) = tbl(2+n,6);
                    ANO2_Stats(3*n+d+1,3,para,HB) = {p(n+1)};
                    ANO2_Stats(3*n+d+1,4,para,HB) = {mes_stats.partialeta2(n+1)};
                    ANO2_Stats(3*n+d+1,5,para,HB) = {mes_stats.omega2(n+1)};
                    ANO2_Stats(3*n+d+1,6,para,HB) = tbl(2+n,2);
                    ANO2_Stats(3*n+d+1,7,para,HB) = tbl(2+n,5);
                end
            end
        end
    end
    E.pre.BlipDiff_Stats = ANO2_Stats(:,:,1,1);
    E.stim.BlipDiff_Stats = ANO2_Stats(:,:,1,2);
    E.post.BlipDiff_Stats = ANO2_Stats(:,:,1,3);
    E.pre.BlipSum_Stats = ANO2_Stats(:,:,2,1);
    E.stim.BlipSum_Stats = ANO2_Stats(:,:,2,2);
    E.post.BlipSumm_Stats = ANO2_Stats(:,:,2,3);
end


end
function [E] = statistics(C,E,multiSession,multiHB,X_single_ASP)

% Define amount of non-block-first trials
% apBlocks = sum(E.spec.prevTrial(:,1)~=0)/2;

%% General real_ASP ANOVA for each hexablock
E.rASP1_Stats = cell(3,9);
E.rASP1_Stats(1,:) = {'Dir','F','p','pn^2','w^2','s','n','SS','MS'};
E.rASP1_Stats(2:3,1) = {'Left','Right'};

for d = 1:2
    [p,tbl,ano_stats]=anova1(X_single_ASP(:,:,d)); % 1-way ANOVA
    mes_stats=mes1way(X_single_ASP(:,:,d),{'omega2','eta2','partialeta2'}); % 1-way MES analysis
    close Figure 2; close Figure 3; 
    % Save stats
    E.rASP1_Stats(d+1,2) = tbl(2,5);
    E.rASP1_Stats(d+1,3) = {p};
    E.rASP1_Stats(d+1,4) = {mes_stats.partialeta2};
    E.rASP1_Stats(d+1,5) = {mes_stats.omega2};
    E.rASP1_Stats(d+1,6) = {ano_stats.s}; % square root of mean squared error
    E.rASP1_Stats(d+1,7) = {ano_stats.n}; % number of observations per group
    E.rASP1_Stats(d+1,8) = {cell2mat(tbl(2:4,2))};
    E.rASP1_Stats(d+1,9) = {cell2mat(tbl(2:3,4))};
end

%% Calculate ANOVA for hexablock x pPiS - single session (rv|ev|NSacc|On)
for para = 1:4 % 1:rv_ASP | 2:ev_ASP | 3:N_Sacc | 4:Onset  
    ANO2_Stats = cell(11,8);
    for n = 0:2
        ANO2_Stats(4*n+1,1:7) = {'Dir','F','p','pn^2','w^2','SS','MS'};
        ANO2_Stats(4*n+1:4*n+3,1) = {'Dir','Left','Right'};
    end
    ANO2_Stats(1,8) = {'HexaBlock'}; ANO2_Stats(5,8) = {'pPiS'}; ANO2_Stats(9,8) = {'Interact'};
    
    for d = 1:2
        % Resort data for analysis
        group = [];
        group(:,1) = E.spec.HB(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d,3);
        group(:,2) = E.spec.prevTrial(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d,2);
        sANO = [];
        if para == 1
            sANO(:,1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
        elseif para == 2
            sANO(:,1) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
        elseif para == 3
            sANO(:,1) = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d);
        elseif para == 4
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
            ANO2_Stats(4*n+d+1,2) = tbl(2+n,6);
            ANO2_Stats(4*n+d+1,3) = {p(n+1)};
            ANO2_Stats(4*n+d+1,4) = {mes_stats.partialeta2(n+1)};
            ANO2_Stats(4*n+d+1,5) = {mes_stats.omega2(n+1)};
            %ANO2_Stats(4*n+d+1,6) = {ano_stats.s}; % square root of mean squared error
            %ANO2_Stats(4*n+d+1,7) = {ano_stats.n}; % number of observations per group
            ANO2_Stats(4*n+d+1,6) = tbl(2+n,2);
            ANO2_Stats(4*n+d+1,7) = tbl(2+n,5);
        end
    end
    if para == 1
        E.single.rASP2_Stats = ANO2_Stats;
    elseif para == 2
        E.single.eASP2_Stats = ANO2_Stats;
    elseif para == 3
        E.single.SACC2_Stats = ANO2_Stats;
    elseif para == 4
        E.single.ONSET2_Stats = ANO2_Stats;
    end
end

%% Calculate ANOVA for hexablock x pPiS - multi-session (rv|ev|NSacc|On)
if multiSession == 1
    for para = 1:4 % 1:rv_ASP | 2:ev_ASP | 3:N_Sacc | 4:Onset
        ANO2_Stats = cell(11,8);
        for n = 0:2
            ANO2_Stats(4*n+1,1:7) = {'Dir','F','p','pn^2','w^2','SS','MS'};
            ANO2_Stats(4*n+1:4*n+3,1) = {'Dir','Left','Right'};
        end
        ANO2_Stats(1,8) = {'Stim'}; ANO2_Stats(5,8) = {'pPiS'}; ANO2_Stats(9,8) = {'Interact'};
        
        for d = 1:2
            % Resort data for analysis
            group = [];
            group(:,1) = E.spec.stimType(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB,3);
            group(:,2) = E.spec.prevTrial(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB,2);
            sANO = [];
            if para == 1
                sANO(:,1) = E.rv_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB);
            elseif para == 2
                sANO(:,1) = E.ev_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB);
            elseif para == 3
                sANO(:,1) = E.saccades(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB);
            elseif para == 4
                sANO(:,1) = E.on_ASP(E.spec.exclude==0 & E.spec.prevTrial(:,1)==d & E.spec.HB(:,3)==multiHB);
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
                ANO2_Stats(4*n+d+1,2) = tbl(2+n,6);
                ANO2_Stats(4*n+d+1,3) = {p(n+1)};
                ANO2_Stats(4*n+d+1,4) = {mes_stats.partialeta2(n+1)};
                ANO2_Stats(4*n+d+1,5) = {mes_stats.omega2(n+1)};
                %ANO2_Stats(4*n+d+1,6) = {ano_stats.s}; % square root of mean squared error
                %ANO2_Stats(4*n+d+1,7) = {ano_stats.n}; % number of observations per group
                ANO2_Stats(4*n+d+1,6) = tbl(2+n,2);
                ANO2_Stats(4*n+d+1,7) = tbl(2+n,5);
            end
        end
        if para == 1
            E.multi.rASP2_Stats = ANO2_Stats;
        elseif para == 2
            E.multi.eASP2_Stats = ANO2_Stats;
        elseif para == 3
            E.multi.SACC2_Stats = ANO2_Stats;
        elseif para == 4
            E.multi.ONSET2_Stats = ANO2_Stats;
        end
    end
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
    group(:,1) = E.spec.HB(E.spec.exclude==0 & E.spec.trialDr==d,3);
    group(:,2) = E.spec.trialBlip(E.spec.exclude==0 & E.spec.trialDr==d);
    for peak = 1:2
        sANO = [];
        %sANO(:,1) = M_bl_a(:,E.bliptimes_a(2*peak,1,d),1,d); sANO(:,2:3) = group(:,1:2); % Sorted blip peaks
        sANO(:,1) = C.eyeXvws(E.bliptimes_a(2*peak,1,d),E.spec.exclude==0 & E.spec.trialDr==d); 
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
E.single.Blip2_Stats = ANO2_Stats;

%% Blip peak ANOVA for hexablock x blip cond - multi-session
ANO2_Stats = cell(17,9);
for n = 0:2
    ANO2_Stats(6*n+1,1:8) = {'Dir','Peak','F','p','pn^2','w^2','SS','MS'};
    ANO2_Stats(6*n+1:6*n+5,1) = {'Dir','Left','Left','Right','Right'};
end
ANO2_Stats(1,9) = {'Stim'}; ANO2_Stats(7,9) = {'BlipCond'}; ANO2_Stats(13,9) = {'Interact'};

for d = 1:2
    group = [];
    group(:,1) = E.spec.stimType(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==multiHB,3);
    group(:,2) = E.spec.trialBlip(E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==multiHB);
    for peak = 1:2
        sANO = [];
        sANO(:,1) = C.eyeXvws(E.bliptimes_a(2*peak,1,d),E.spec.exclude==0 & E.spec.trialDr==d & E.spec.HB(:,3)==multiHB); 
        sANO(:,2:3) = group(:,1:2); % Sorted blip peaks
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
E.multi.Blip2_Stats = ANO2_Stats;
end
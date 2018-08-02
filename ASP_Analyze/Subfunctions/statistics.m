function [E] = statistics(X_ASP,M_rv,E,hexblk,M_bl_a)

%% General ASP ANOVA for each hexablock
for d = 1:2
    [p,tbl,ano_stats]=anova1(X_ASP(:,:,d)); % 1-way ANOVA
    mes_stats=mes1way(X_ASP(:,:,d),{'omega2','eta2','partialeta2'}); % 1-way MES analysis
    % Save stats
    E.AspStats.SS(1:3,d) = cell2mat(tbl(2:4,2));
    E.AspStats.MS(1:2,d) = cell2mat(tbl(2:3,4));
    E.AspStats.F(1,d) = cell2mat(tbl(2,5));
    E.AspStats.p(1,d) = p;
    E.AspStats.n(1:3,d) = ano_stats.n; % number of observations per group
    E.AspStats.df(1,d) = ano_stats.df; % Error degrees of freedom
    E.AspStats.s(1,d) = ano_stats.s; % square root of mean squared error
    E.AspStats.eta2(1,d) = mes_stats.eta2;
    E.AspStats.peta2(1,d) = mes_stats.partialeta2;
    E.AspStats.omega2(1,d) = mes_stats.omega2;
    
end

%% ASP ANOVA for hexablock x pNiS
for d = 1:2
    % Resort data for analysis
    group = [];
    group(:,1) = E.blockNr(E.prevTrial(:,1)==d,2);
    group(:,2) = E.prevTrial(E.prevTrial(:,1)==d,2);
    sgroup = ones(length(group),2)*NaN; % Sorted data information (group identity)
    S_rv(1:hexblk(4,3),1) = M_rv(1:length(group),1,d); S_rv(:,2) = group(:,2); % Sorted mean ASP velocities
    for h = 1:3
        sgroup(hexblk(3,h):hexblk(4,h),:) = sortrows(group(group(:,1)==h,:),2);
        S_rv(group(:,1)==h,:) = sortrows(S_rv(group(:,1)==h,:),2);
    end
    [p,tbl,ano_stats] = anovan(S_rv(1:length(group),1),sgroup,'model','interaction','varnames',{'hexaBlock','pNiS'}); % 2-way ANOVA
    mes_stats = mes2way(S_rv(1:length(group),1),sgroup,{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','pNiS'}); % 2-way MES analysis
    %Save stats
    E.LearnStats.SS(1:4,d) = cell2mat(tbl(2:5,2));
    E.LearnStats.MS(1:3,d) = cell2mat(tbl(2:4,5)); % 1:HexaBlock / 2:pNiS / 3:Error
    E.LearnStats.F(1:3,d) = cell2mat(tbl(2:4,6));
    E.LearnStats.p(1:3,d) = p;
    E.LearnStats.dfe(1,d) = ano_stats.dfe;
    E.LearnStats.s(1,d) = sqrt(cell2mat(tbl(4,5)));
    E.LearnStats.eta2(1:3,d) = mes_stats.eta2;
    E.LearnStats.peta2(1:3,d) = mes_stats.partialeta2;
    E.LearnStats.omega2(1:3,d) = mes_stats.omega2;
end

%% Blip peak ANOVA for hexablock x blip condition

for d = 1:2
    %figHistoBlip(d) = figure;
    group(:,1) = E.blockNr(E.trialDr(:,1)==d,2);
    group(:,2) = E.trialBlip(E.trialDr==d);
    for peak = 1:2
        S_bl(:,1) = M_bl_a(:,E.bliptimes_a(2*peak,h,d),1,d); S_bl(:,2) = group(:,2); % Sorted blip peaks
        for h = 1:3
            sgroup(hexblk(3,h):hexblk(4,h),:) = sortrows(group(group(:,1)==h,:),2);
            S_bl(group(:,1)==h,:) = sortrows(S_bl(group(:,1)==h,:),2);
        end
        [p,tbl,ano_stats] = anovan(S_bl(1:length(group),1),sgroup,'model','interaction','varnames',{'hexaBlock','blipDir'}); % 2-way ANOVA
        mes_stats = mes2way(S_bl(1:length(group),1),sgroup,{'omega2','eta2','partialeta2'},'fName',{'hexaBlock','blipDir'}); % 2-way MES analysis
        %Save stats
        E.BlipStats.SS(1:4,peak,d) = cell2mat(tbl(2:5,2));
        E.BlipStats.MS(1:3,peak,d) = cell2mat(tbl(2:4,5)); % 1:HexaBlock / 2:pNiS / 3:Error
        E.BlipStats.F(1:3,peak,d) = cell2mat(tbl(2:4,6));
        E.BlipStats.p(1:3,peak,d) = p;
        E.BlipStats.dfe(1,peak,d) = ano_stats.dfe;
        E.BlipStats.s(1,peak,d) = sqrt(cell2mat(tbl(4,5)));
        E.BlipStats.eta2(1:3,peak,d) = mes_stats.eta2;
        E.BlipStats.peta2(1:3,peak,d) = mes_stats.partialeta2;
        E.BlipStats.omega2(1:3,peak,d) = mes_stats.omega2;
    end
end

end
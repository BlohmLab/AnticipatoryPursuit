% detectSaccades2.m detects saccade use acceleration threhold, for the pursuit this is the only method to be used.
function [numSacc,sacc,eyeXvws,eyeYvws,eyeVvws] = detectSaccades2(D,trn)
%% detect saccades (acceleration threshold: 500deg/s2)
ens = find(D{trn}.eyeVa >= 500); % degree > 500
[pos,n] = group(ens,round(0.030*D{1}.sfr1),round(0.030*D{1}.sfr1));
temp = ens(pos);

sacc = zeros(round(length(temp)/2),2);
for i = 1:round(length(temp)/2)
    %     pos_sacc = [temp(2*i-1):temp(2*i)];
    %     sacc = [sacc NaN pos_sacc];
    sacc(i,1) =  temp(2*i-1); %saccade onset
    sacc(i,2) =  temp(2*i);  %saccade offset
    
    %     %% plot saccades
    %     axes(ax(1));
    %     plot(D{trn}.t1(pos_sacc), D{trn}.eyeX(pos_sacc), 'color', 'r', 'linewidth', 3); % horizontal eye
    %     plot(D{trn}.t1(pos_sacc), D{trn}.eyeZ(pos_sacc), 'color', 'g', 'linewidth', 3); % vertical eye
end

%% remove saccades from velocity trace
lg = length(D{trn}.eyeXv);            %lg=nbre de mesures
eyeXvws = D{trn}.eyeXv;%Xvws = X-direction Velocity Without Saccades
eyeYvws = D{trn}.eyeYv;
for i=1:round(length(temp)/2),
    begi = round(max(temp(i*2-1)-round(0.025*D{1}.sfr1),1));% index of saccade onset
    endi = round(min(temp(i*2)+round(0.025*D{1}.sfr1),lg));% index of saccade end
    d = endi-begi;											 %duration of saccade
    yaX = D{trn}.eyeXv(begi);                                %velocity 24 ms before
    ybX = D{trn}.eyeXv(endi);                                %velocity 24 ms after
    yaY = D{trn}.eyeYv(begi);                                %velocity 24 ms before
    ybY = D{trn}.eyeYv(endi);                                %velocity 24 ms after
    eyeXvws(begi:endi)=(yaX+(0:d)*(ybX-yaX)/d)';          %=> linear interpolation
    eyeYvws(begi:endi)=(yaY+(0:d)*(ybY-yaY)/d)';          %=> linear interpolation
end
eyeVvws = sqrt(eyeXvws.^2 + eyeYvws.^2);

numSacc = 0;
for s = 1:length(sacc(:,1))
    if sacc(s,1)>= D{1}.tMoveStart-D{1}.tFixation && sacc(s,1) <= D{1}.tMoveStop-D{1}.tFixation
        numSacc = numSacc+1;
    end
end

% axes(ax(2));
% plot(D{trn}.t1, D{trn}.eyeVvws, 'linewidth',2, 'color','b'); % vectorial eye velo

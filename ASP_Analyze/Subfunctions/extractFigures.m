function extractFigures(E,hexblk,M_bl_a,av_bl_a,av_bl_g)
%% Plot results
% Blip histograms
plots = {'1.Peak - HexaBlock 1';'1.Peak - HexaBlock 2';'1.Peak - HexaBlock 3';'2.Peak - HexaBlock 1';'2.Peak - HexaBlock 2';'2.Peak - HexaBlock 3'};
for d = 1:2
    figHistoBlip(d) = figure;
    for p = 1:2
        for h = 1:3
            subplot(2,3,3*(p-1)+h);
            histogram(M_bl_a(hexblk(3,h):hexblk(4,h),E.bliptimes_a(2*p,h,d),2,d),20);
            hold on;
            histogram(M_bl_a(hexblk(3,h):hexblk(4,h),E.bliptimes_a(2*p,h,d),4,d),20);
            title(plots(3*(p-1)+h));
        end
    end
end
savefig(figHistoBlip,strcat(E.name(1:4),'_BlipHisto.fig'));

figHexaBlip = figure;
plots = {'Left - All';'Left - Good';'Right - All';'Right - Good'};

%Blip means
for dr = 1:2
    subplot(2,2,2*dr-1);
    hold on
    baseline = plot([0 400],[0 0],'k');
    hexblock1 = plot(1:401,av_bl_a(:,2,5,dr));
    hexblock2 = plot(1:401,av_bl_a(:,3,5,dr));
    hexblock3 = plot(1:401,av_bl_a(:,4,5,dr));
    hold off
    legend([hexblock1 hexblock2 hexblock3],{'HexBlock 1','HexBlock 2', 'HexBlock 3'});
    xlabel('time post-blip [ms]');
    ylabel('Velocity diff [deg/s]');
    xlim([0 400]);
    title(plots(2*dr-1));
end

for dr = 1:2
    subplot(2,2,2*dr);
    hold on
    baseline = plot([0 400],[0 0],'k');
    hexblock1 = plot(1:401,av_bl_g(:,2,5,dr));
    hexblock2 = plot(1:401,av_bl_g(:,3,5,dr));
    hexblock3 = plot(1:401,av_bl_g(:,4,5,dr));
    legend([hexblock1 hexblock2 hexblock3],{'HexBlock 1','HexBloxk 2', 'HexBlock 3'});
    xlabel('time post-blip [ms]');
    ylabel('Velocity diff [deg/s]');
    xlim([0 400]);
    title(plots(2*dr));
end

hold off
savefig(figHexaBlip,strcat(E.name(1:4),'_BlipMean.fig'));

end
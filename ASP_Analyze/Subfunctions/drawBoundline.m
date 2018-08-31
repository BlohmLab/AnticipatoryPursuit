%% Create figure
bl = figure ('Name','Bounded Lines Plot','Units','normalized','Position',[.01 .01 .98 .94],'toolbar','none','NumberTitle','off');

cmap = [0.75 0 1;1 0.25 0;1 0.5 0;0.25 0.75 0;0 0.75 0.75;0 0.25 1];

for nPlot = 1:6

boundedline([1:plotData.LoT] , plotData.av(nPlot,:) , plotData.sd(nPlot,:) , 'alpha' , 'transparency', 0.1, 'cmap', cmap(nPlot,:));

end

xlabel('time post-blank [s]');
ylabel('Velocity [degree/s]');
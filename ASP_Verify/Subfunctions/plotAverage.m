% blipAverage averages the eye velocities of all trials with same blip properties & direction from 100 ms before until 400 ms after blip onset.
function [avPlot] = plotAverage(D)

%% sum up all x_velo time points of the same dr-blip condition
avBlip = zeros(D{1}.nDr,3,501); %avBlip(dr:,bdr: 1=di,t:-100ms ~ +400ms) 

for i = 1:length(D)	
    for t = 1:length(D{i}.eyeXvws)
        avPlot(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2,t) = avPlot(D{1}.paraTrial(1,i),D{1}.paraTrial(4,i)+2,t) + D{i}.eyeXvws(t);
    end
end

%% divide each sum through the amount of trials it had
for tt = 1:length(D{1}.eyeXvws)
	for n = 1:D{1}.nDr
		avBlip(n,1,tt) = avBlip(n,1,tt)/(D{1}.numBlips-round(D{1}.numBlips/2));
		avBlip(n,2,tt) = avBlip(n,2,tt)/(D{1}.numTrials/2-D{1}.numBlips);
		avBlip(n,3,tt) = avBlip(n,3,tt)/(round(D{1}.numBlips/2));
    end
 end


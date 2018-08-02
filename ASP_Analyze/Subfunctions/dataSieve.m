function [sieve,NoAT,NoGT] = dataSieve(C,plotData,numPlot,lAnsw)

%% Create the sieve
sieve = zeros(1,length(C.paraTrials));
NoAT = 0; %Number of absolute trials

for iTrial = 1:length(sieve)
    correct = 0;
    if plotData.para(numPlot,1,1) == C.paraTrials(1,iTrial) || plotData.para(numPlot,1,1) == 0 %Dr
        correct = correct+1;
    end
    if sum(plotData.para(numPlot,2,1:lAnsw(2)) == C.paraTrials(2,iTrial)) == 1 || plotData.para(numPlot,2,lAnsw(2)) == 0 %NiS
        correct = correct+1;
    end
    if plotData.para(numPlot,3,1) == C.paraTrials(3,iTrial) %blank
        correct = correct+1;
    end
    if plotData.para(numPlot,4,1) == C.paraTrials(4,iTrial)+2  || plotData.para(numPlot,4,1) == 0 %blip
        correct = correct+1;
    end
    if sum(plotData.para(numPlot,5,1:lAnsw(5)) == C.paraTrials(5,iTrial)) == 1 || plotData.para(numPlot,5,1) == 0 %Block-Number
        correct = correct+1;
    end
    if sum(plotData.para(numPlot,6,1:lAnsw(6)) == C.paraTrials(6,iTrial)) == 1 || plotData.para(numPlot,6,1) == 0 %Profile-Number
        correct = correct+1;
    end
    if correct == 6
        NoAT = NoAT+1;
    end
    if plotData.para(numPlot,7,1) == C.paraTrials(7,iTrial)+1 || plotData.para(numPlot,7,1) == 0 %Blank good?
        correct = correct+1;
    end
    if plotData.para(numPlot,8,1) == C.paraTrials(8,iTrial)+1 || plotData.para(numPlot,8,1) == 0 %Blip good?
        correct = correct+1;
    end
    if correct == 8
        sieve(iTrial) = 1;
    end
    NoGT = sum(sieve);
end

end


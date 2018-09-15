function [sieve,NoAT,NoGT] = dataSieve(C,plotData,numPlot,lAnsw)

%% Create the sieve
sieve = zeros(1,length(C.paraTrials));
NoAT = 0; %Number of absolute trials

for iTrial = 1:length(sieve)
    if C.paraTrials(9,iTrial) == 0 % Ignore excluded trials
        correct = 0;
        if plotData.para(numPlot,1,1) == C.paraTrials(1,iTrial) || plotData.para(numPlot,1,1) == 0 %Dr
            correct = correct+1;
        end
        if plotData.para(numPlot,2,1) == C.prevTrial(iTrial,1) || plotData.para(numPlot,2,1) == 0 %Previous Dr
            correct = correct+1;
        end
        if sum(plotData.para(numPlot,3,1:lAnsw(3)) == C.paraTrials(2,iTrial)) == 1 || plotData.para(numPlot,3,lAnsw(3)) == 0 %Positon in sequence
            correct = correct+1;
        end
        if sum(plotData.para(numPlot,4,1:lAnsw(4)) == C.prevTrial(iTrial,2)) == 1 || plotData.para(numPlot,4,lAnsw(4)) == 0 %Previous position in sequence
            correct = correct+1;
        end
        if plotData.para(numPlot,5,1) == C.paraTrials(4,iTrial)+2  || plotData.para(numPlot,5,1) == 0 %blip condition
            correct = correct+1;
        end
        if sum(plotData.para(numPlot,6,1:lAnsw(6)) == C.paraTrials(5,iTrial)) == 1 || plotData.para(numPlot,6,1) == 0 % Block-Number
            correct = correct+1;
        end
        if sum(plotData.para(numPlot,7,1:lAnsw(7)) == C.paraTrials(10,iTrial)) == 1 || plotData.para(numPlot,7,1) == 99 % Subject-Number
            correct = correct+1;
        end
        if sum(plotData.para(numPlot,8,1:lAnsw(8)) == C.paraTrials(11,iTrial)) == 1 || plotData.para(numPlot,8,1) == 0 % Stimulation
            correct = correct+1;
        end
        %     if sum(plotData.para(numPlot,6,1:lAnsw(6)) == C.paraTrials(6,iTrial)) == 1 || plotData.para(numPlot,6,1) == 0 %Profile-Number
        %         correct = correct+1;
        %     end
        if correct == 8
            NoAT = NoAT+1;
        end
        if plotData.para(numPlot,9,1) == C.paraTrials(7,iTrial) || plotData.para(numPlot,9,1) == 0 %Blank good?
            correct = correct+1;
        end
        if plotData.para(numPlot,10,1) == C.paraTrials(8,iTrial) || plotData.para(numPlot,10,1) == 0 %Blip good?
            correct = correct+1;
        end
        if correct == 10
            sieve(iTrial) = 1;
        end
    end
end
NoGT = sum(sieve);
end


function [D] = saccParaSaccSet(D)
for ii = 1: D{1}.numTrials

    [D{ii}.numSacc,D{ii}.sacc, D{ii}.eyeXvws, D{ii}.eyeYvws, D{ii}.eyeVvws] = detectSaccades2(D,ii);
    if ~isempty(D{ii}.sacc)
        
        indSacc = find(D{ii}.t(D{ii}.sacc(:,1))>=(D{ii}.tBlankStart-D{ii}.tFixation) & D{ii}.t(D{ii}.sacc(:,1))<(D{ii}.tPauseStart-D{ii}.tFixation));%find saccades between blank start and pause
        if ~isempty(indSacc)
            
			for n = 1:length(indSacc)
				D{ii}.saccNumber = length(indSacc);
				D{ii}.saccOn(n) = D{ii}.sacc(indSacc(n),1);%if such saccades exist, define their start points here
				D{ii}.saccOff(n) = D{ii}.sacc(indSacc(n),2);%if such saccades exist, define their end points here
			end
            
            % if length(indSacc)>1,
                % D{ii}.saccOn2 = D{ii}.sacc(indSacc(2),1);
                % D{ii}.saccOff2 = D{ii}.sacc(indSacc(2),2);
            % else
                % D{ii}.saccOn2 = -9999;
                % D{ii}.saccOff2 = -9999;
            % end
         %else
            %D{ii}.saccOn = -9999;
            %D{ii}.saccOff = -9999;
            %D{ii}.saccOn2 = -9999;
            %D{ii}.saccOff2 = -9999;
        end
    else
        D{ii}.saccOn = NaN;
        D{ii}.saccOff = NaN;
        %D{ii}.saccOn2 = -9999;
        %D{ii}.saccOff2 = -9999;
    end
end

fprintf('Saccace Onset and Offset are all set.\n');

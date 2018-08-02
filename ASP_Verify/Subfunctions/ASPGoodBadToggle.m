if D{trn}.goodBlank == 1
    set(h.blankGood,'foregroundcolor','g','string','Blank GOOD');
elseif D{trn}.goodBlank == 0
    set(h.blankGood,'foregroundcolor','r','string','Blank BAD');
end    
    
if D{trn}.goodBlip == 1
    set(h.blipGood,'foregroundcolor','g','string','Blip GOOD');
elseif D{trn}.goodBlip == 0
    set(h.blipGood,'foregroundcolor','r','string','Blip BAD');
end

if D{trn}.exclude == 0
    set(h.exclude,'foregroundcolor','g','string','Use Trial');
elseif D{trn}.exclude == 1
    set(h.exclude,'foregroundcolor','r','string','EXCLUDE');
end


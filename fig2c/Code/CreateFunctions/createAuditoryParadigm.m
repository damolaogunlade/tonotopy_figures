function [paradigm, parpath] = createAuditoryParadigm(matpath)
% [paradigm] = createAuditoryParadigm.m
%
% The prf presentation code will spit out a matfile containing a variable
% called stim. While it contains all the information about what frequency
% tone was played when, and when the breaks were, it does not include the
% necessary paradigm file as the analysis code expects it (as far as I can
% tell) which is a 1xnvol vector with frequency over time and breaks
% plotted as NaNs. This function will create that variabel for us. It will
% save it in the same path as the fed matpath and return it as a variable
% as well. 
%
%%%%%%%%%%%%%%%%%%%


load(matpath)

% We will subtract one so that tone events are aligned with brain volumes
% (first tone presented during volume 1 of bold data)
toneEnds = stim.toneEnd;
toneBegs = toneEnds-1;

breakEnds = stim.breakEnd;
breakBegs1 = breakEnds-4;
breakBegs2 = breakEnds-2;


allEvents = [toneBegs; breakBegs1; breakBegs2];
allValues = [stim.paradigm; nan(size(breakBegs1)); nan(size(breakBegs2))];

paradigmTone = reshape(allValues,1,size(allValues,1)*size(allValues,2)); % frequency played during that volume number, Nan is break


paradigmVol = reshape(allEvents,1,size(allValues,1)*size(allValues,2));% Volume at which 2s frequency began playing

paradigm = paradigmTone;
[filepath, name, ext] = fileparts(matpath);
savepath = fullfile(filepath,[name '_paradigm' ext]);
save(savepath,'paradigmTone')
parpath = savepath;






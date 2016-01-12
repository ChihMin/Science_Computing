%% perfLoo4audio
% Leave-one-file-out CV (for audio)
%% Syntax
% * 		ds2=perfLoo4audio(ds, opt, showPlot)
%% Description
% 		perfLoo4audio(ds, opt, showPlot) performs leave-one-out cross validation for audio data
%% Example
%%
%
cellStr={'abcd', 'abde', 'abc', 'asdf', 'abd', 'abcd', 'abd'};
opt=strCentroid('defaultOpt');
output=strCentroid(cellStr, opt);
fprintf('The centroid of %s is %s.\n', cell2str(cellStr), output);
%% See Also
% <perfCv_help.html perfCv>,
% <perfCv4classifier_help.html perfCv4classifier>,
% <perfLoo_help.html perfLoo>.

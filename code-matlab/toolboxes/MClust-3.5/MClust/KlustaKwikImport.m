function MCC = KlustaKwikImport(clu_file)
%function MCC = KlustaImport(clu_file)
%%%%%%%%%%%%%%%%%%%%%%
% Load the cluster file generated by KlustaKwik
%%%%%%%%%%%%%%%%%%%%%%
% INPUT: a .clu.n file from KK
% OUTPUT: The MClust_Clusters cell array of precut cluster objects for each cluster
% 
% cowen
% ADR 2008
%
% Status: PROMOTED (Release version) 
% See documentation for copyright (owned by original authors) and warranties (none!).
% This code released as part of MClust 3.5.
% Version control M3.5.

% ADR fix 2010-11-11 adding FeatureIndex of idx rather than idx
[fd,fn,xt] = fileparts(clu_file);
[fd_,fn,xt] = fileparts(fn);
KK_GeneratingFile = fullfile(fd,[fn, '.fd']);
 
z = load(KK_GeneratingFile, '-mat'); 

clusters = load(clu_file);
clusters = clusters(2:end);
unique_clusters = unique(clusters);
nClusters = length(unique_clusters);

%%%%%%%%%%%%%%%%%%%%%%
% Export to Mclust as individual clusters.
%%%%%%%%%%%%%%%%%%%%%%
MCC = cell(nClusters,1);
for iClust = 1:nClusters
    idx = clusters == unique_clusters(iClust);
	MCC{iClust} = precut(sprintf('KK %02d', iClust));
	MCC{iClust} = AddIndices(MCC{iClust},z.FeatureIndex(idx)');
end
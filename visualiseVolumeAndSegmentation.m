function visualiseVolumeAndSegmentation(V, S, S2, pausedtime)
%

if nargin < 3
    S2 = zeros(size(S));
    pausedtime = nan;
elseif nargin < 4
    pausedtime = nan;
elseif isempty(S2)
    S2 = zeros(size(S));
end

for ix=1:size(V,3)
    plotBoundariesAndPoints(V(:,:,ix), [], bwboundaries(S(:,:,ix)), '-m');
    plotBoundariesAndPoints(V(:,:,ix), [], bwboundaries(S2(:,:,ix)), '-g');
    turbo;
    if isnan(pausedtime)
        pause;
    else
        pause(pausedtime)
    end
end
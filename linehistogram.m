function linehistogram(DATA, colour)
% LINE HISTOGRAM
% 
%

if nargin < 2
    colour='k';
end
[N,edges] = histcounts(DATA(:));
stem(edges(2:end), N, 'Marker', 'none', 'Color', colour, 'LineWidth', 3);
hold on
stem(edges(1:end-1), N, 'Marker', 'none','Color', colour,'LineWidth', 3);

for ix=1:length(N)
    plot([edges(ix) edges(ix+1)], [N(ix) N(ix)], 'Color', colour,'LineWidth', 3);
end


function plotVertLine(vector, values)
% Plot a(many) vertical line(s) on a plot. 
% where: 
%       vector := the x values you want the lines in
%       values := the y limits for the vertical lines [ymin ymax]
% 
gcf;
hold on;

nPoints = length(vector);

for ix=1:nPoints
    plot([vector(ix) vector(ix)], [values(1) values(2)]);
end

function [minYmaxY, minLoc, maxLoc] = minimax(Y)
% MIN/MAX values for a vector

minYmaxY = zeros(1,2);
minYmaxY(1) = min(Y(:));
minYmaxY(2) = max(Y(:));

switch nargout 
    case 1
        minYmaxY(1) = min(Y(:));
        minYmaxY(2) = max(Y(:));
    case 2
        minYmaxY = min(Y(:));
        minLoc = max(Y(:));
    case 3
        [minYmaxY(1), minLoc] = min(Y(:));
        [minYmaxY(2), maxLoc] = max(Y(:));
end
        
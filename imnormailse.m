function [IN] = imnormalise(I)
% [IN] = imnormalise(I)
%
%

I = double(I);
IN= (I - (mean(I(:))))./std(I(:));
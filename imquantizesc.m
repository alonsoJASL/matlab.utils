function imquantizesc(I,n)
% imquantizesc(I,n)
% 

if nargin == 1
    n=1;
end

imagesc(imquantize(I, multithresh(I,n)));

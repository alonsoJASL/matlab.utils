function [BW, acmask] = extractAorta(V, opts)
% 

if nargin < 2
    iter = 20;
    contractionbias = -0.4;
    acmethod = 'edge';
else 
    [iter, contractionbias, acmethod] = getoptions(opts);
end
    
V = imgaussfilt3(double(V));

S = zeros(size(V));
for ix=1:size(V,3)
   S(:,:,ix) = extractAorta2D(V(:,:,ix));
end

A = sum(S, 3) ;
A = A./max(A(:));
B = A > multithresh(A, 1);

regs = regionprops(B);

C = bwareafilt(B, [max([regs.Area]) inf]);
D = imdilate(C, strel('diamond', 7));

% BW1 = activecontour(V,repmat(D, 1,1,size(V,3)), 15, 'Chan-Vese', 'ContractionBias', 0.4);
BW2 = activecontour(V,repmat(C, 1,1,size(V,3)), iter, acmethod, 'ContractionBias', contractionbias);

BW = BW2;
if nargout > 1 
    acmask = repmat(C, 1,1,size(V,3));
end

end

function [iter, contractionbias, acmethod] = getoptions(opts)
iter = 15;
contractionbias = -0.4;
acmethod = 'edge';

s = fieldnames(opts);
for ix=1:length(s)
    thisField = s{ix};
    switch lower(thisField)
        case {'iter', 'numiter', 'iterations'}
            iter = opts.(thisField);
        case {'contractionbias', 'cbias'}
            contractionbias = opts.(thisField);
        case 'acmethod'
            acmethod = opts.(thisField);
        otherwise
            fprintf('[WARNING] Option (%s) not recognised, using default value\n', thisField);
    end
end
end
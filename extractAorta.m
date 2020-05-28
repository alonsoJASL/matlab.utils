function [BW3] = extractAorta(V)
% 
V = double(V);

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

BW3 = activecontour(V,repmat(D, 1,1,size(V,3)),20,'Chan-Vese', 'ContractionBias', 0.4);
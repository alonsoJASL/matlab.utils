function [BW] = extractAorta2D(V)
% 

A = imgaussfilt(imdiv(V));
levs = multithresh(A,2);

B = A < levs(1); 
C = imdilate(B, strel('diamond', 2));
D = C==0;
E = imclearborder(D);

BW = E;
function [BW,centers,maskedImage] = myFindCircles(X, range)
%segmentImage Segment image using auto-generated code from imageSegmenter app
%  [BW, CENTERS, MASKEDIMAGE] = myFindCircles(X) segments image X using 
%  imfindcircles. The final segmentation is returned in
%  BW, CENTERS is a Nx2 vector of detected circles, and a masked image is 
%  returned in MASKEDIMAGE.


if nargin < 2
    range = [10 55];
end

% Normalize input data to range in [0,1].
X = double(X);
Xmin = min(X(:));
Xmax = max(X(:));
if isequal(Xmax,Xmin)
    X = 0*X;
else
    X = (X - Xmin) ./ (Xmax - Xmin);
end

% Adjust data to span data range.
X = imadjust(X);

% Find circles
[centers,radii,~] = imfindcircles(X,range,'ObjectPolarity','bright','Sensitivity',0.8);
BW = false(size(X,1),size(X,2));
[Xgrid,Ygrid] = meshgrid(1:size(BW,2),1:size(BW,1));
if ~isempty(centers)
    for n = 1:size(centers,1)
        BW = BW | (hypot(Xgrid-centers(n,1),Ygrid-centers(n,2)) <= radii(n));
    end
end

% Create masked image.
if nargout > 2
    maskedImage = X;
    maskedImage(~BW) = 0;
end
end


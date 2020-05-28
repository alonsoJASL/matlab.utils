function D = imdiv(I)

if numel(size(I))==2
    [Ix, Iy] = imgradientxy(I);
    [X, Y] = meshgrid(1:size(I, 2), 1:size(I, 1));

    D = divergence(X, Y, Ix, Iy);
else
    [Ix, Iy, Iz] = imgradientxyz(I);
    [X, Y, Z] = meshgrid(1:size(I, 2), 1:size(I, 1), 1:size(I,3));

    D = divergence(X, Y, Z, Ix, Iy, Iz);
end
    
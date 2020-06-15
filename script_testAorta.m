vinfo = niftiinfo('E:\KCL_FI_PATIENT\POST\ANALYSIS\dcm-LGE-LGECART20MIN.nii');
V = niftiread(vinfo);

%% Find circles
range = [10 55];
BW = zeros(size(V));
for ix=1:size(V,3)
    X = V(:,:,ix);    
    [BW(:,:,ix)] = myFindCircles(X);
end
%
sumbw = sum(BW,3);
sumlevs = multithresh(sumbw,2);
sumbw1 = sumbw>sumlevs(1);
sumbw2 = sumbw>sumlevs(2);

[bwlab] = bwlabeln(sumbw1);
keeplabs = unique(bwlab .* sumbw2);
keeplabs(1) = []; % the background entry (0)

avgAorta = zeros(size(sumbw));
for ix=1:length(keeplabs)
    avgAorta = bitor(avgAorta, bwlab==keeplabs(ix)); 
end

for ix=1:size(V,3)
    thisSlice = BW(:,:,ix);
    testSlice = bitand(thisSlice, avgAorta);
    [~, n] = bwlabeln(testSlice);
    if n == 0 % there's nothing in there
        BW(:,:,ix) = avgAorta;
    else
        BW(:,:,ix) = testSlice;
    end
end

%% OTHER METHOD

[BW2] = extractAorta(V);



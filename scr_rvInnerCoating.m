%% Read data
tidy; 
inputImageInfo = niftiinfo('E:\KCL_EP\1_seg\mhd\MASK.nii');
V = niftiread(inputImageInfo);
se = strel('sphere',3);

vinfo2 = niftiinfo('E:\KCL_EP\1_seg\mhd\dilatedImage.nii');
V2 = niftiread(vinfo2);
se2 = strel('sphere',5);

%
Vnew = V;
oldlabels = unique(V(:))';
oldlabels(1) = [];
newlabels = [2 3 5 7 11];
for ix=1:length(oldlabels)
Vnew(V==oldlabels(ix)) = newlabels(ix);
end

se = strel('sphere',3);
Vdilate = ones(size(V));
for ix=1:length(newlabels)
thisV = newlabels(ix).*(imdilate(Vnew==newlabels(ix), se));
thisV(thisV==0) = 1;
Vdilate = Vdilate.*thisV;
end

Vmix = ~isprime(Vdilate);

Vdilate(Vdilate==1) = 13;
Vmix = ~isprime(Vdilate);
Vmixlab = bwlabeln(Vmix);

VLvMix = (V==1)+2.*(Vmix);
%volumeViewer(VLvMix, 'VolumeType', 'Labels')

%% Inner 
Vinner = zeros(size(V));
for ix=1:size(V, 3)
A = imclearborder(squeeze(V(:,:,ix)==0));
Vinner(:,:,ix) = Vinner(:,:,ix) + reshape(A, size(V(:,:,ix)));
end
for ix=1:size(V, 2)
A = imclearborder(squeeze(V(:,ix,:)==0));
Vinner(:,ix,:) = Vinner(:,ix,:) + reshape(A, size(V(:,ix,:)));
end
for ix=1:size(V, 1)
A = imclearborder(squeeze(V(ix,:,:)==0));
Vinner(ix,:,:) = Vinner(ix,:,:) + reshape(A, size(V(ix,:,:)));
end

Vinner = uint16(Vinner);
VpartialFill = Vinner + V;
VpartialFill(VpartialFill > 0) = 1;
for ix=1:size(V, 3)
A = uint16(imclearborder(squeeze(VpartialFill(:,:,ix)==0)));
Vinner(:,:,ix) = Vinner(:,:,ix) + reshape(A, size(V(:,:,ix)));
end
for ix=1:size(V, 2)
A = uint16(imclearborder(squeeze(VpartialFill(:,ix,:)==0)));
Vinner(:,ix,:) = Vinner(:,ix,:) + reshape(A, size(V(:,ix,:)));
end
volshow(Vinner)
for ix=1:size(V, 1)
A = uint16(imclearborder(squeeze(VpartialFill(ix, :,:)==0)));
Vinner(ix, :,:) = Vinner(ix, :,:) + reshape(A, size(V(ix, :,:)));
end

Linner = bwlabeln(Vinner);

regs3 = regionprops3(Vinner>0, 'Volume');
ventrVolumes = regs3.Volume;
[aa, bb] = sort(ventrVolumes, 'descend');
aa(3:end) = []; bb(3:end) = [];
volumeViewer(V.*uint16(imdilate(Linner==bb(1), se)), 'VolumeType', 'Labels');

%% Using dilatedImageCav RV_bp=30, LV_bp=10
tidy;

caseNo = 'case04';
maskPath = ['E:\KCL_EP_WIN\' caseNo '\seg_folder\seginputs\MASK_original.nii'];
bpPath = ['E:\KCL_EP_WIN\' caseNo '\seg_folder\seginputs\dilatedImageCav.nii'];

inputImageInfo = niftiinfo(maskPath);
bpImageInfo = niftiinfo(bpPath);
%
outputImage = niftiread(inputImageInfo);
bloodpoolImage = niftiread(bpImageInfo);
bloodpoolImage = imresize3(bloodpoolImage, size(outputImage), 'nearest');

se = strel('sphere', 1);

VFragment = uint16(imdilate(bloodpoolImage==30, se)).*outputImage;
outputImage(VFragment==1) = 5;

% save
[~,name,ext] = fileparts(inputImageInfo.Filename);
outpath = 'E:\KCL_EP_WIN\case04\seg_folder';
vinfoOut = inputImageInfo;
vinfoOut.Filename = fullfile(outpath, [name ext]);

niftiwrite(outputImage, vinfoOut.Filename, vinfoOut);

disp('finished');






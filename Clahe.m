clc
clear all
close all
cd 
ds = imageDatastore('brain_tumor_dataset','IncludeSubfolders',1,'LabelSource','Foldernames');
for i = 1:253
    I = readimage(ds,i);
    if(size(I,3)~=1)
    I = rgb2gray(I);
    I=uint8(I);
    end
    J = adapthisteq(I,'clipLimit',0.02,'Distribution','rayleigh');
%imshowpair(I,J,'montage');
%title('Original Image (left) and Contrast Enhanced Image (right)')
clahe_entropy = entropy(J)
clahe_niqe = niqe(J)
clahe_piqe = piqe(J)
clahe_brisque = brisque(J)

ce(i)= clahe_entropy
cn(i)= clahe_niqe
cp(i)= clahe_piqe
cb(i)= clahe_brisque

end

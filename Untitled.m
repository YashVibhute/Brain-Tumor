clc
clear all
close all 
%% Obtain the original image
input_image = imread("C:\Users\Yash\PycharmProjects\Brain tumor detection\sample\Y17.jpg");
%% Get histogram of the original image
figure(1)
subplot(3,3,1)
imshow(input_image);
title('ORIGINAL IMAGE')
subplot(3,3,2)
imhist(input_image);
%% BBHE 
%% Calculate mean of the histogram
bbhe_mean = round(mean(input_image(:)));
%% Divide the histogram on the basis of the mean in two parts
[H, ~] = imhist(input_image);
H1 = H(1:bbhe_mean);
H2 = H(bbhe_mean+1:256);
%% Equalize each part independently 
H1 = H1/sum(H1);
H2 = H2/sum(H2);
%% Combine both sub-images for the processed image
C1 = cumsum(H1);
C2 = cumsum(H2);
C1n = uint8(bbhe_mean * C1);
C2n = uint8(bbhe_mean+1 + (255-bbhe_mean+1)*C2);
img_sum1 = [C1n; C2n];
%% output image of BBHE
figure(1)
subplot(3,3,4)
j=intlut(input_image,img_sum1);
imshow(j);
title("BBHE IMG")
subplot(3,3,5)
imhist(intlut(input_image,img_sum1));
%% DSIHE 
%% Obtain the original image
[X, Y] = size(input_image);
%% Get histogram of the original image
[H, ~] = imhist(input_image);
%% Calculate median of the histogram. 
[value, lm] = min (abs(H-(X*Y/2)));
%% Divide the histogram on the basis of the median in two parts.
H1 = H(1:lm);
H2 = H(lm+1:256);
%% Equalize each part independently
H1 = H1/sum(H1);
H2 = H2/sum(H2);
%% Combine both sub-images for the processed image
C1 = cumsum(H1);
C2 = cumsum(H2);
C1n = uint8(lm * C1);
C2n = uint8(lm+1 + (255-lm+1)*C2);
img_sum2 = [C1n; C2n];
%% output image of DSIHE
figure(1)
subplot(3,3,7)
kot = intlut(input_image,img_sum2)
imshow(kot);

title("DSIHE IMG")
subplot(3,3,8)
imhist(intlut(input_image,img_sum2));
%% PSNR code
%% For BBHE
P1= psnr(intlut(input_image,img_sum1),input_image); 
%% For DSIHE
P2= psnr(intlut(input_image,img_sum2),input_image); 
%% Display Results
%disp(P1);
%disp(P2);
%figure(1)
%subplot(3,3,6)
%title("PSNR= ",P1)
%subplot(3,3,9)
%title("PSNR= ",P2)
%% entropy
before_entropy = entropy(input_image)
entro_bbhe = entropy(j)
entro_dsihe = entropy(kot)
%% NIQE
niqe_original = niqe(input_image);
fprintf('NIQE score for original image is %0.4f.\n',niqe_original)
niqe_BBHE = niqe(j);
fprintf('NIQE score for niqe_BBHE image is %0.4f.\n',niqe_BBHE)
niqe_dsihe = niqe(kot);
fprintf('NIQE score for niqe_dsihe image is %0.4f.\n',niqe_dsihe)

%% PIQE
piqe_original = piqe(input_image);
fprintf('Piqe score for original image is %0.4f.\n',piqe_original)
piqe_bbhe = piqe(j);
fprintf('Piqe score for piqe_bbhe image is %0.4f.\n',piqe_bbhe)
piqe_dsihe = piqe(kot);
fprintf('Piqe score for piqe_dsihe image is %0.4f.\n',piqe_dsihe)

%% Brisque
brisque_original = brisque(input_image);
fprintf('BRISQUE score for input_image image is %0.4f.\n',brisque_original)
brisque_bbhe = brisque(j);
fprintf('BRISQUE score for brisque_bbhe image is %0.4f.\n',brisque_bbhe)
brisque_dsihe = brisque(kot);
fprintf('BRISQUE score for brisque_dsihe image is %0.4f.\n',brisque_dsihe)

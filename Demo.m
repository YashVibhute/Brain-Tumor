
%%Demo code for executing RS-ESIHE and R-ESIHE algorithm
clc
clear all
close all 
 img=imread("C:\Users\Yash\PycharmProjects\Brain tumor detection\sample\Y17.jpg");
 if(size(img,3)~=1)
    img = rgb2gray(img);
    img=uint8(img);
end
imshow(img,[]);title('Original')
RSESIHEoutput=RS_ESIHE_ALGO(img);
figure;
imshow(RSESIHEoutput,[]);title('RS-ESIHE')
RESIHEoutput=R_ESIHE_ALGO(img); % For r=2
figure;
imshow(RESIHEoutput,[]);title('R-ESIHE')
%% entropy
R_ESIHE_entropy = entropy(RESIHEoutput)
RS_ESIHE_entropy = entropy(RSESIHEoutput)

%% NIQE
R_ESIHE_niqe = niqe(RESIHEoutput);
fprintf('NIQE score for R_ESIHE_niqe image is %0.4f.\n',R_ESIHE_niqe)
RS_ESIHE_niqe = niqe(RSESIHEoutput);
fprintf('NIQE score for RS_ESIHE_niqe image is %0.4f.\n',RS_ESIHE_niqe)

%% PIQE
R_ESIHE_piqe = piqe(RESIHEoutput);
fprintf('NIQE score for R_ESIHE_piqe image is %0.4f.\n',R_ESIHE_piqe)
RS_ESIHE_piqe = piqe(RSESIHEoutput);
fprintf('NIQE score for RS_ESIHE_piqe image is %0.4f.\n',RS_ESIHE_piqe)
%% Brisque
R_ESIHE_brisque = brisque(RESIHEoutput);
fprintf('NIQE score for R_ESIHE_brisque image is %0.4f.\n',R_ESIHE_brisque)
RS_ESIHE_brisque = brisque(RSESIHEoutput);
fprintf('NIQE score for RS_ESIHE_brisque image is %0.4f.\n',RS_ESIHE_brisque)

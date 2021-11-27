clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
  % User does not have the toolbox installed.
  message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
  reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
  if strcmpi(reply, 'No')
    % User said No, so exit.
    return;
  end
end
% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
button = menu('Use which demo image?', 'CameraMan', 'Moon', 'Eight', 'Coins', 'Pout');
if button == 1
  baseFileName = 'cameraman.tif';
elseif button == 2
  baseFileName = 'moon.tif';
elseif button == 3
  baseFileName = 'eight.tif';
elseif button == 4
  baseFileName = 'coins.png';
else
  baseFileName = 'pout.tif';
end
% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
% Get the full filename, with path prepended.
fullFileName = fullfile(folder, baseFileName);
% Check if file exists.
if ~exist(fullFileName, 'file')
  % File doesn't exist -- didn't find it there.  Check the search path for it.
  fullFileName = baseFileName; % No path this time.
  if ~exist(fullFileName, 'file')
    % Still didn't find it.  Alert user.
    errorMessage = sprintf('Error: %s does not exist in the search path folders.', fullFileName);
    uiwait(warndlg(errorMessage));
    return;
  end
end
grayImage = imread(fullFileName);
% Get the dimensions of the image.  
% numberOfColorBands should be = 1.
[rows, columns, numberOfColorBands] = size(grayImage);
if numberOfColorBands > 1
  % It's not really gray scale like we expected - it's color.
  % Convert it to gray scale by taking only the green channel.
  grayImage = grayImage(:, :, 2); % Take green channel.
end
% Display the original gray scale image.
subplot(2, 2, 1);
imshow(grayImage, []);
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Give a name to the title bar.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off') 
% Calculate mean gray level.
meanGL = mean2(grayImage)
% Let's compute and display the histogram.
[pixelCount, grayLevels] = imhist(grayImage);
subplot(2, 2, 2); 
bar(pixelCount);
grid on;
title('Histogram of original image', 'FontSize', fontSize);
xlim([0 grayLevels(end)]); % Scale x axis manually.
% Put line at mean
yl = ylim;
line([meanGL, meanGL], [yl(1), yl(2)], 'LineWidth', 2, 'Color', 'r');
binaryImageLow = grayImage < meanGL;
binaryImageHigh = grayImage >= meanGL;
% Display the image.
subplot(2, 2, 3);
imshow(binaryImageLow, []);
title('Binary Image Below Mean', 'FontSize', fontSize);
% Display the image.
subplot(2, 2, 4);
imshow(binaryImageHigh, []);
title('Binary Image Above Mean', 'FontSize', fontSize);
% Get maps for each
[~, lowMap] = histeq(grayImage(binaryImageLow));
[~, highMap] = histeq(grayImage(binaryImageHigh));
% Combine them.
intMeanGL = int32(meanGL);
lookupTable = uint8(256*[lowMap(1:intMeanGL), highMap(intMeanGL+1:end)]);
%========================================================
% Use lookup table to map image.
% KEY PART RIGHT HERE!!!
dualHistEqImage = intlut(grayImage, lookupTable);
%========================================================
% Display the image.
figure;
imshow(dualHistEqImage, []);
title('Output Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% Give a name to the title bar.
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off')
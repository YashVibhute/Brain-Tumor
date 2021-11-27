clc
clear all
close all 
a = imread('C:\\Users\\Yash\\PycharmProjects\\Brain tumor detection\\yes\\Y17.jpg');
x = a(:,:,1);
y = BBHE(x);
figure,imshow(y);
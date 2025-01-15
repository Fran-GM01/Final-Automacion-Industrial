clear
close all
clc

img='segmentation.png';
im=iread(img);

im=1-im;

figure
idisp(im)

S = kcircle(4);
iClosed=iclose(1-im,S);

S = strel("disk",4);
iClosed2=iclose(1-im,S);

figure
idisp(1-iClosed)


figure
idisp(1-iClosed2)
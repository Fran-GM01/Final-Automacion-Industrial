clear
clc
close all

foto='warped3.jpg';
im=iread(foto,'double');

frameCorner=getCorners(im);
[correctedImg,finalCorners]=warpImage(im,frameCorner);
endPoints=getLineCoordinates(correctedImg,finalCorners);

figure
idisp(correctedImg)
hold on
plot(endPoints(:,1),endPoints(:,2),'*b')

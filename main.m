clear
clc
close all

foto='Ejemplo.jpg';
im=iread(foto,'double');

frameCorner=getCorners(im);
[correctedImg,finalCorners]=warpImage(im,frameCorner);
[endPoints,realDsitance]=getLineCoordinates(correctedImg,finalCorners);

%realDistance es la distancia de los puntos a la esquina suroeste, en [m].
%[x1 y1
% x2 y2]

figure
idisp(correctedImg)
hold on
plot(endPoints(:,1),endPoints(:,2),'*b')

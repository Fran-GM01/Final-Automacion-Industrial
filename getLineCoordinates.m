function [endPoints,realDistance]=getLineCoordinates(img,corners)

uSize=size(img,2);
vSize=size(img,1);

minU=min(corners(:,1));
maxU=max(corners(:,1));

minV=min(corners(:,2));
maxV=max(corners(:,2));

img(isnan(img))=1;  %Se cambia el fondo negro por uno blanco

imRed=img(:,:,1);
imGreen=img(:,:,2);
imSub=imGreen-imRed;

t=-0.07;
imThresh=imSub>=t;
% 
% figure
% idisp(imSub)
% 
% figure
% idisp(imThresh)

% img=imono(img);
% 
% offset=40; %offset de pixeles para recortar la imagen
% 
% cropedImage=zeros(vSize,uSize);
% cropedImage(minV+offset:maxV-offset,minU+offset:maxU-offset)=imSub(minV+offset:maxV-offset,minU+offset:maxU-offset);

% 
% figure
% idisp(cropedImageThresh)

filteredImage=imageFiltering(imThresh,25,'No');


%% Deteccion de bordes

K=ksobel();
imbordeh=iconvolve(filteredImage,K);
imbordev=iconvolve(filteredImage,K');
imbordenorm=((imbordeh).^2+(imbordev).^2).^0.5;

imBorderThresh=imbordenorm>=0.001;
imBorderThresh(1,:)=0;
imBorderThresh(end,:)=0;
imBorderThresh(:,1)=0;
imBorderThresh(:,end)=0;


%% Deteccion de lineas

imLines=Hough(imBorderThresh,'nbins',[800,401]);
imLines.houghThresh=0.85;
imLines.suppress=28;

% figure
% idisp(imBorderThresh)
% imLines.plot

lines=imLines.lines;
nLines=size(lines,2);

imLines=zeros(vSize,uSize,nLines);
finalImage=zeros(vSize,uSize);

for iLine=1:nLines
    imLines(:,:,iLine)=generarlinea(lines(iLine).rho,lines(iLine).theta,uSize,vSize);
    finalImage=finalImage+imBorderThresh.*imLines(:,:,iLine);   
end

% figure
% idisp(imBorderClosed)

[fil,col]=find(finalImage); %Se obtienen todos los pixeles blancos

lineCoordiantes=[col,fil]; %[u,v]

[~,positionMin]=min(col);
[~,positionMax]=max(col);

leftPoint=lineCoordiantes(positionMin,:);
rightPoint=lineCoordiantes(positionMax,:);

endPoints=[leftPoint;rightPoint]; %[u,v]

%% 	Coordenadas reales

%Origen en la esquina suroeste

distancePixel=zeros(2);

for iPoint=1:2
    
    distancePixel(iPoint,:)=[endPoints(iPoint,1)-minU,maxV-endPoints(iPoint,2)];
    
end

frameWidth=maxU-minU;
frameHeight=maxV-minV;

realDistance=distancePixel.*[0.2/frameWidth,0.15/frameHeight];


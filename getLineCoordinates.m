function endPoints=getLineCoordinates(img,corners)

img=imono(img);

minU=min(corners(:,1));
maxU=max(corners(:,1));

minV=min(corners(:,2));
maxV=max(corners(:,2));

offset=20; %offset de 15 pixeles

uSize=size(img,2);
vSize=size(img,1);

cropedImage=ones(vSize,uSize);
cropedImage(minV+offset:maxV-offset,minU+offset:maxU-offset)=img(minV+offset:maxV-offset,minU+offset:maxU-offset);

t=0.4;
cropedImageThresh=cropedImage>=t;


%% Deteccion de bordes

K=ksobel();
imbordeh=iconvolve(cropedImageThresh,K);
imbordev=iconvolve(cropedImageThresh,K');
imbordenorm=((imbordeh).^2+(imbordev).^2).^0.5;

imBorderThresh=imbordenorm>=0.001;
imBorderThresh(1,:)=0;
imBorderThresh(end,:)=0;
imBorderThresh(:,1)=0;
imBorderThresh(:,end)=0;

%% Clausura

S=kcircle(20);
imBorderClosed=iclose(imBorderThresh,S);

%% Deteccion de lineas

imLines=Hough(imBorderClosed);
imLines.houghThresh=0.40;
imLines.suppress=20;

% figure
% idisp(imBorderClosed)
% imLines.plot

lines=imLines.lines;
nLines=size(lines,2);

imLines=zeros(vSize,uSize,nLines);
finalImage=zeros(vSize,uSize);

for iLine=1:nLines
    imLines(:,:,iLine)=generarlinea(lines(iLine).rho,lines(iLine).theta,uSize,vSize);
    finalImage=finalImage+imBorderClosed.*imLines(:,:,iLine);   
end

% figure
% idisp(imBorderClosed)

[fil,col]=find(finalImage); %Se obtienen todos los pixeles blancos

lineCoordiantes=[col,fil]; %[u,v]

[~,positionMin]=min(col);
[~,positionMax]=max(col);

leftPoint=lineCoordiantes(positionMin,:);
rightPoint=lineCoordiantes(positionMax,:);

endPoints=[leftPoint;rightPoint];




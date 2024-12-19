function frameCorner=getCorners(img)

%% Tamano de imagen

[vSize,uSize,~]=size(img);

t=0.3;
imRed=img(:,:,1);

imThresh=imRed>=t;  %Elimino la linea roja

%% Filtrado

% S=kcircle(3);
% imClosed=iclose(imThresh,S); %Eliminar la cuadricula
% imClosed=iopen(imClosed,S);

imClosed=imThresh;
% figure
% idisp(imClosed)

%% Deteccion de bordes

K=ksobel();
imbordeh=iconvolve(imClosed,K);
imbordev=iconvolve(imClosed,K');
imbordenorm=((imbordeh).^2+(imbordev).^2).^0.5;

imBorderThresh=imbordenorm>=0.001;
imBorderThresh(1,:)=0;
imBorderThresh(end,:)=0;
imBorderThresh(:,1)=0;
imBorderThresh(:,end)=0;

% figure
% idisp(imBorderThresh)


%% Deteccion de lineas

imLines=Hough(imBorderThresh);
imLines.houghThresh=0.42;
imLines.suppress=22;

% figure
% idisp(imBorderThresh)
% imLines.plot

%% Esquinas

lines=imLines.lines;
nLines=size(lines,2);

imLines=zeros(vSize,uSize,nLines);
finalImage=zeros(vSize,uSize);
corners=zeros(vSize,uSize);

for iLine=1:nLines
    imLines(:,:,iLine)=generarlinea(lines(iLine).rho,lines(iLine).theta,uSize,vSize);
    finalImage=finalImage+imBorderThresh.*imLines(:,:,iLine);
    corners=corners+imLines(:,:,iLine);    
end

findCorner=corners==2;
% figure
% idisp(findCorner)

[fil,col]=find(findCorner);
cornerIntersection=[col,fil]; %Cada fila es [u,v]

%% Eliminar esquinas en el borde de la imagen

for iFil=1:length(fil)    
    if any(cornerIntersection(iFil,:)<=3) || abs(cornerIntersection(iFil,1)-uSize)<=3 ||...
       abs(cornerIntersection(iFil,2)-vSize)<=3  
              
       cornerIntersection(iFil,:)=NaN;        
       
    end    
end

validCorners=any(~isnan(cornerIntersection),2);
frameCorner=cornerIntersection(validCorners,:); 
    

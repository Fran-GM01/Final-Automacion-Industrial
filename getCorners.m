function frameCorners=getCorners(img)

%% Tamaño imagen

[vSize,uSize]=size(img);

%% Eliminar la linea roja

imRed=img(:,:,1);
imGreen=img(:,:,2);

figure
idisp(imRed)
figure
idisp(imGreen)

imSub=imRed-imGreen;

figure
idisp(imSub)

t=-0.03;
imThresh=imSub>t; 

figure
idisp(imThresh)

filteredImage=imageFiltering(imThresh,'Yes');


%% Deteccion de bordes
% 
K=ksobel();
imbordeh=iconvolve(filteredImage,K);
imbordev=iconvolve(filteredImage,K');
imbordenorm=((imbordeh).^2+(imbordev).^2).^0.5;

imBorderThresh=imbordenorm>=0.001;
imBorderThresh(1,:)=0;
imBorderThresh(end,:)=0;
imBorderThresh(:,1)=0;
imBorderThresh(:,end)=0;

% figure
% idisp(imBorderThresh)

%% Deteccion de lineas (Hough)

imLines=Hough(imBorderThresh,'nbins',[800,401]);
imLines.houghThresh=0.6;
imLines.suppress=40;

figure
idisp(imBorderThresh)
imLines.plot

%% Esquinas

lines=imLines.lines;
nLines=size(lines,2);

rho=lines.rho;
theta=lines.theta;

%Se prueban todas las combinaciones de linea y se buscan los puntos de interseccion

%Es muy improbable que las lineas sean paralelas, por lo que se cruzan fuera de la imagen.
%Se eliminan esos puntos

intersectionPoints=zeros(nchoosek(nLines,2),2);
iRow=1;

for i=1:nLines-1
    for j=i+1:nLines
        
        A=[cos(theta(i)) sin(theta(i))
           cos(theta(j)) sin(theta(j))];
        
        B=[rho(i);rho(j)];
        
        if det(A)==0% Si la matriz es singular, las lineas son paralelas
            intersectionPoints(iRow,:)=[-1,-1];
        else
            intersectionPoint=(A\B).'; %[v,u]

            if intersectionPoint(1)<0 || intersectionPoint(2)<0 || ...
               intersectionPoint(1)>vSize || intersectionPoint(2)>uSize 
                
                intersectionPoints(iRow,:)=[-1,-1];
            else
                intersectionPoints(iRow,:)=round(intersectionPoint);
            end   
            
        end
        
        iRow=iRow+1;
        
    end
end


validRows=any(intersectionPoints>0,2);
frameCorners=intersectionPoints(validRows,:);
frameCorners=[frameCorners(:,2) frameCorners(:,1)]; %devuelve [u,v]

% imLines=zeros(vSize,uSize,nLines); 
% finalImage=zeros(vSize,uSize);
% corners=zeros(vSize,uSize);
% 
% for iLine=1:nLines
%     imLines(:,:,iLine)=generarlinea(lines(iLine).rho,lines(iLine).theta,uSize,vSize);
%     finalImage=finalImage+imBorderThresh.*imLines(:,:,iLine);
%     corners=corners+imLines(:,:,iLine);
% end
% 
% findCorner=corners==2;
% figure
% idisp(findCorner)

% [fil,col]=find(findCorner);
% cornerIntersection=[col,fil]; %Cada fila es [u,v]

% %% Eliminar esquinas en el borde de la imagen
% 
% for iFil=1:length(fil)    
%     if any(cornerIntersection(iFil,:)<=3) || abs(cornerIntersection(iFil,1)-uSize)<=3 ||...
%        abs(cornerIntersection(iFil,2)-vSize)<=3  
%               
%        cornerIntersection(iFil,:)=NaN;        
%        
%     end    
% end
% 
% validCorners=any(~isnan(cornerIntersection),2);
% frameCorner=cornerIntersection(validCorners,:); 
    

function [correctedImg,finalCorners]=warpImage(img,initialCorners)

%[correctedImg,finalCorners]=WARPIMAGE(img,initialCorners)
%
%Recibe la imagen en perspectiva y la devuelve alineada.
%
%img: imagen en perspectiva
%initialCorners: matriz de esquinas [u,v] del marco de 15 x 20 cm (en cualquier orden)
%
%correctedImg: imagen alineada
%finalCorners: posición final de las esquinas


%% Ordenar los nodos

%Metodo si no hay coordenadas iguales

initialCorners=sortrows(initialCorners,2,'ascend');

southCorners=initialCorners([end-1,end],:); %Los dos maximos V serán las esquinas inferiores
southCorners=sortrows(southCorners,1,'ascend');

southWestCorner=southCorners(1,:);
southEastCorner=southCorners(2,:);

northCorners=initialCorners([1,2],:);
northCorners=sortrows(northCorners,1,'ascend');

northWestCorner=northCorners(1,:);
northEastCorner=northCorners(2,:);

%% Homografia

initialPosition=[southWestCorner;southEastCorner;northEastCorner;northWestCorner].';
finalPosition=[1 2001 2001 1; 1501 1501 1 1];

[matH,~]=homography(initialPosition,finalPosition);
[correctedImg,off]=homwarp(matH,img,'full');

finalNorthWest=[1,1]-off; %[u,v]
finalNorthEast=finalNorthWest+[2000,0];
finalSouthEast=finalNorthEast+[0,1500];
finalSouthWest=finalSouthEast-[2000,0];

finalCorners=[finalSouthWest;finalSouthEast;finalNorthEast;finalNorthWest];
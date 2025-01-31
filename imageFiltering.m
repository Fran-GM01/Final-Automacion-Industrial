function filteredImage=imageFiltering(img,plot)


%% Obtener los bordes

imThresh=1-img; %Se invierte la imagen

S = strel("disk",5);
imClosed=iclose(imThresh,1); %Rellenar los bordes


S = strel("disk",1);
imOpen=iopen(imClosed,S); %Eliminar la cuadrícula

filteredImage=1-imOpen;

%% Plots

if strcmpi(plot,'yes')

figure
idisp(1-imClosed)
title('Cierre')

figure
idisp(filteredImage)
title('Cierre y Apertura')

end
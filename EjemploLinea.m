clear
close all
clc

foto='Ejemplo.jpg';
im=iread(foto,'double');

im=im(300:2150,760:3085,:);

im=imono(im);

im=im>=0.5;
figure
idisp(im)

imageFiltering(im,'Yes');


clear
clc
close all

image='EjemploEsnel.png';

%% Crear el manipulador

Trossen=createRobot;

%% Vision

localCoordinates=visionSolver(image);

%% Marco de la hoja

frameOffset = 90;
frameLength = 150;
frameHeight = 200;

figure
hold on
createFrame(frameOffset,frameHeight,frameLength,30)

%% Trayectoria

globalLineCoordinates=zeros(2);

for i=1:2
    globalLineCoordinates(i,1)=frameOffset+1000*localCoordinates(i,2);
    globalLineCoordinates(i,2)=frameHeight/2-1000*localCoordinates(i,1);
end

getTrajectory(Trossen,globalLineCoordinates(1,:),globalLineCoordinates(2,:));


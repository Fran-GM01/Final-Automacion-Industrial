function createFrame(offset,height,length,lineLength)

%% Piso

axis([-200,300,-250,250,0,500])
view(45,30);

x_lim = [-1000, 1000];  % Ajusta según el tamaño del robot
y_lim = [-1000, 1000];  

% Definir los vértices del plano
X = [x_lim(1), x_lim(2), x_lim(2), x_lim(1)];
Y = [y_lim(1), y_lim(1), y_lim(2), y_lim(2)];
Z = [0, 0, 0, 0];  % Plano en z = 0

% Graficar el plano negro
patch(X, Y, Z, [100/255,100/255,100/255])  % 'k' indica color negro

%% Esquinas verdes

nwCorner = [offset,height/2];
neCorner = nwCorner + [length,0];
swCorner = [offset,-height/2];
seCorner = swCorner + [length,0];

plot3([nwCorner(1),nwCorner(1)+lineLength],[nwCorner(2),nwCorner(2)],[0,0],'g','LineWidth',2)
plot3([nwCorner(1),nwCorner(1)],[nwCorner(2),nwCorner(2)-lineLength],[0,0],'g','LineWidth',2)

plot3([neCorner(1)-lineLength,neCorner(1)],[neCorner(2),neCorner(2)],[0,0],'g','LineWidth',2)
plot3([neCorner(1),neCorner(1)],[neCorner(2),neCorner(2)-lineLength],[0,0],'g','LineWidth',2)

plot3([swCorner(1),swCorner(1)+lineLength],[swCorner(2),swCorner(2)],[0,0],'g','LineWidth',2)
plot3([swCorner(1),swCorner(1)],[swCorner(2),swCorner(2)+lineLength],[0,0],'g','LineWidth',2)

plot3([seCorner(1)-lineLength,seCorner(1)],[seCorner(2),seCorner(2)],[0,0],'g','LineWidth',2)
plot3([seCorner(1),seCorner(1)],[seCorner(2),seCorner(2)+lineLength],[0,0],'g','LineWidth',2)
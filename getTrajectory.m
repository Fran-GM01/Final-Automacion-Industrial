function getTrajectory(robot,p1,p2)

%% Ubicacion del marco (hoja)

frameOffset = 90;
frameHeight = 200;

hWork = 50; %Altura de trabajo
hSafety = hWork+5; %Altura de avance

%Valores para usar de "semilla" en ikine
qSeed=[0,-atan(50/144),-pi/2+atan(50/144),0,pi/2];

p0 = [frameOffset,frameHeight/2,hSafety];
T0 = transl(p0)*troty(180)*trotz(90);
q0=robot.ikine(T0,'mask',[1 1 1 1 0 1],'q0',qSeed);

%% Trayectoria de avance (p0 a p1)

dt=0.05;    %Intervalo de tiempo
t=0:dt:3;
t=t.';
 
p1Top=[p1,hSafety];

[x,~,~] = tpoly(p0(1),p1Top(1),t);
[y,~,~] = tpoly(p0(2),p1Top(2),t);
z=hSafety*ones(length(t),1);

approachP=[x,y,z];
translationT=transl(approachP);

approachT=zeros(4,4,length(t));

for i=1:length(t)
   approachT(:,:,i)=translationT(:,:,i)*troty(180)*trotz(90);     
end

qApproach=robot.ikine(approachT,'mask',[1 1 1 1 0 1],'q0',q0);


%% Descenso

tDescent=0:dt:1;
tDescent=tDescent.';

x=p1(1)*ones(length(tDescent),1);
y=p1(2)*ones(length(tDescent),1);
[z,~,~] = tpoly(hSafety,hWork,tDescent);

descentP=[x,y,z];
translationT=transl(descentP);

descentT=zeros(4,4,length(tDescent));

for i=1:length(tDescent)
   descentT(:,:,i)=translationT(:,:,i)*troty(180)*trotz(90);     
end

qDescent=robot.ikine(descentT,'mask',[1 1 1 1 0 1],'q0',qApproach(end,:));

%% Dibuja la linea

tWork=0:dt:5;
tWork=tWork.';
 
p1Work=[p1,hWork];
p2Work=[p2,hWork];

[x,~,~] = tpoly(p1Work(1),p2Work(1),tWork);
[y,~,~] = tpoly(p1Work(2),p2Work(2),tWork);
z=hWork*ones(length(tWork),1);

workP=[x,y,z];
translationT=transl(workP);

workT=zeros(4,4,length(tWork));

for i=1:length(tWork)
   workT(:,:,i)=translationT(:,:,i)*troty(180)*trotz(90);     
end

qWork=robot.ikine(workT,'mask',[1 1 1 1 0 1],'q0',qDescent(end,:));

%% Ascenso

tAscent=0:dt:1;
tAscent=tAscent.';

x=p2(1)*ones(length(tAscent),1);
y=p2(2)*ones(length(tAscent),1);
[z,~,~] = tpoly(hWork,hSafety,tAscent);

ascentP=[x,y,z];
translationT=transl(ascentP);

ascentT=zeros(4,4,length(tAscent));

for i=1:length(tAscent)
   ascentT(:,:,i)=translationT(:,:,i)*troty(180)*trotz(90);     
end

qAscent=robot.ikine(ascentT,'mask',[1 1 1 1 0 1],'q0',qWork(end,:));

%% Retract (p2 a p0)

tRetract=0:dt:3;
tRetract=tRetract.';
 
p2Top=[p2,hSafety];

[x,~,~] = tpoly(p2Top(1),p0(1),tRetract);
[y,~,~] = tpoly(p2Top(2),p0(2),tRetract);
z=hSafety*ones(length(tRetract),1);

retractP=[x,y,z];
translationT=transl(retractP);

retractT=zeros(4,4,length(tRetract));

for i=1:length(tRetract)
   retractT(:,:,i)=translationT(:,:,i)*troty(180)*trotz(90);     
end

qRetract=robot.ikine(retractT,'mask',[1 1 1 1 0 1],'q0',qAscent(end,:));


%% Plot final

qFinal=[qApproach;qDescent;qWork;qAscent;qRetract];
pFinal=[approachP;descentP;workP;ascentP;retractP];
robot.plot(qFinal)
plot3(pFinal(:,1),pFinal(:,2),pFinal(:,3),'-k','LineWidth',0.5)
plot3([p1(1),p2(1)],[p1(2),p2(2)],[0,0],'-r','LineWidth',1.5)
view(45,30);

end

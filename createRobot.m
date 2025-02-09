function robot = createRobot

l1=130;
l2=144;
l3=50;
l4 = 144;
l5 = 144;

Link1 = Link('d', l1, 'a', 0, 'alpha', 0, 'modified','qlim',deg2rad([-50,50])); %-50 a 50
Link2 = Link('d', 0, 'a', 0, 'alpha', pi/2,'modified','offset',pi/2,'qlim',[-pi/2,pi/6]); %-90 a 30 
Link3 = Link('d', 0, 'a', sqrt(l2^2+l3^2), 'alpha',0,'modified'); 
Link4 = Link('d', 0, 'a', l4, 'alpha',0,'modified','offset',-pi/2,'qlim',[-pi/2,pi/2]); 
Link5 = Link('d', 0, 'a', 0, 'alpha',-pi/2,'modified','qlim',[pi/2,pi/2]); 
Tool = transl([0 0 l5]);  %End Effector

% Crear el robot con la clase SerialLink
robot = SerialLink([Link1 Link2 Link3 Link4 Link5],'tool',Tool, 'name', 'Trossen');


end
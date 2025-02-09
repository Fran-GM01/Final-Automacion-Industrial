function realDistance = visionSolver(imFile)

im=iread(imFile,'double');

frameCorner=getCorners(im);
[correctedImg,finalCorners]=warpImage(im,frameCorner);
[endPoints,realDistance]=getLineCoordinates(correctedImg,finalCorners);

figure
idisp(correctedImg)
hold on
plot(endPoints(:,1),endPoints(:,2),'*b')

end


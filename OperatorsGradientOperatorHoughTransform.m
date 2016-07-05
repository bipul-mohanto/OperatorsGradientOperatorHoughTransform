%% Bipul Mohanto
% Color in Informatics and MEdia Technology
% contact: bipul.mohanto@yahoo.com

close all
clear all
clc

%% Sobel masks
I=imread('T.png');

figure(1), imshow(I);

kernelW = [-1 0 1;-2 0 2;-1 0 1]

kernelN = kernelW';
kernelS = rot90(kernelW);
kernelE = kernelS';

outW=imfilter(I,kernelW,'replicate');
outN=imfilter(I,kernelN,'replicate');
outS=imfilter(I,kernelS,'replicate');
outE=imfilter(I,kernelE,'replicate');

figure(2), imshow(outW,[]);
figure(3), imshow(outN,[]);
figure(4), imshow(outS,[]);
figure(5), imshow(outE,[]);

out = max(outW,outN);
out = max(out,outS);
out = max(out,outE);
figure(6), imshow(out,[]);

%% edge function, for example Canny
%% idea to extract the T object, using imfill 
close all
clear all
clc

I=imread('T.png');

BW = edge(I,'canny',0.3,1);
figure(1), imshow(BW);

% remplissage de l'objet
O=imfill(BW,'holes');
figure(2), imshow(O);

% ouverture
SE=strel('square',3);
Objet=uint8(imopen(O,SE)); % to remove the little part, possibility to prune  
figure(3), imshow(Objet,[]);

%% gradient vector
close all
clear all
clc

I=imread('T.png');
A=double(I);
    
[Jx, Jy] = gradient(A);
mag = sqrt(Jx.*Jx+Jy.*Jy);
mag = uint8(mag);
imshow(mag);
th = atan2(Jy,Jx);
        
imagesc(I); colormap(gray)
hold on
for i=1:20:size(I,1)
    for j=1:20:size(I,2)
    quiver(j,i,Jx(i,j),Jy(i,j),'r')
    end
end
hold off

%% Hough transform
close all
clear all
clc

I=imread('musical_score.png');
I=imcomplement(I);
BW = edge(I,'canny',[],1);

[H,T,R] = hough(BW,'RhoResolution',0.1,'ThetaResolution',0.1);
imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');

P  = houghpeaks(H,20,'threshold',ceil(0.3*max(H(:))));

x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
% Find lines and plot them
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',3);
imshow(I), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end


clc;
clear all;
myFolder='C:\Users\lovely\Documents\MATLAB\DRIMDB';
filePattern = fullfile(myFolder, '*.jpg');
%Select full file specification from a selected folder
jpegFiles = dir(filePattern);
%lists files and folders in the current folder
  for i=1:length(jpegFiles)
        
    baseFileName = jpegFiles(i).name;
     fullFileName = fullfile(myFolder, baseFileName);
      I= imread(fullFileName);
	
greenC = I(:,:,2);
%Selecting green channel image of the input image
comp = imcomplement(greenC);
%Taking the complementary image
histe = adapthisteq(comp);
%Histogram equilization
adjustImage = imadjust(histe,[],[],3);
% maps intensity values in I to new values in J, where gamma specifies the shape of the curve describing the relationship between the values in I and J.
comp = imcomplement(adjustImage);
J = imadjust(comp,[],[],4);
J = imcomplement(J);
J = imadjust(J,[],[],4);
K=fspecial('disk',5);
%returns a circular averaging filter (pillbox) within the square matrix of size 2*radius+1.
L=imfilter(J,K,'replicate');
%filters the multidimensional array J with the multidimensional filter K and returns the result in L.
%'replicate':Input array values outside the bounds of the array are assumed to equal the nearest array border value.
L = im2bw(L,0.4);
M =  bwmorph(L,'tophat');
%Performs morphological "top hat" operation, returning the image minus the morphological opening of the image (erosion followed by dilation).
% M = im2bw(M);
wname = 'sym4';
[CA,CH,CV,CD] = dwt2(M,wname,'mode','per');
%dwt2(X,wname) computes the single-level 2-D discrete wavelet transform (DWT) of the input data X using the wname wavelet.
%dwt2 returns the approximation coefficients matrix cA and detail coefficients matrices cH, cV, and cD (horizontal, vertical, and diagonal, respectively).
%figure,imshow(CA);
b = bwboundaries(CA);
I = imresize(I,[303 350]);
%figure, imshow(I);
hold on
for area_bloodvessels = 1:numel(b)
    plot(b{area_bloodvessels}(:,2), b{area_bloodvessels}(:,1), 'b', 'Linewidth', 1)
end  
[m,n]=size(I);
R(i,1)=energy(CA);
R(i,2)=mean2(I);
R(i,3)=std2(I);

[r t g]=Hessian2D(I,2);
    %H{i,1}=r;
    %H{i,2}=t;
    %H{i,3}=g;
average1=mean2(r~=0);
average2=mean2(t~=0);
average3=mean2(g~=0);
R(i,4)=average1;
R(i,5)=average2;
R(i,6)=average3;
R(i,7)=area_bloodvessels;
if i<=69
    OP(i,1)=0;
    OP(i,2)=1;
    O=logical(OP);
else
    OP(i,1)=1;
    OP(i,2)=0;
    O=logical(OP);
end

  end


clc
close all    
clear all 
%% test a color image
name = "tree.png";
f_moto = imread('input/'+name);
f_ori = double(f_moto);

%% parameters
cluster = 6; % the number of clustering centers
se = 3; % the parameter of structuing element used for morphological reconstruction
w_size = 3; % the size of fitlering window
%% cluster the image
[~,U1,~,~] = FRFCM_c(double(f_ori),cluster,se,w_size);
[f_seg,center_p] = fcm_image_color(f_ori,U1);
%% divide the image
a = center_p(:,3);
n = size(a,1);
f_orig = double(f_moto);
tmp = uint8(f_orig);
%imshow(tmp);
Sum = zeros(size(tmp,1),size(tmp,2),3);
%% loop to divide
for i = 1:n
    %% divide the image
    tmp = f_seg;
    tmp(f_seg~=i) = 0;
    tmp(f_seg==i) = 1;
    C = zeros(size(tmp,1),size(tmp,2),3);
    C(:,:,1) = tmp;
    C(:,:,2) = tmp;
    C(:,:,3) = tmp;
    
    tmp = C.*f_orig;
    tmp = uint8(tmp);
    
    %figure;
    %imshow(tmp);
    %saveName = ['res/' num2str(i) '.png'];
    %imwrite(tmp, saveName);
    %% Dehazing the image and Sum
    out_tmp = runDehazing(tmp, a(i));
    out_tmp(out_tmp<0) = 0;
    Sum = Sum + out_tmp;
    %figure;
    imshow(Sum);
    title('dehazing image');
end
%% output
%figure;
imshow(Sum);
title('dehazed image');
imwrite(Sum, 'res/ans-'+name);

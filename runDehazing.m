function J=runDehazing(I, center)

r = 15;
beta = 1.0;

%% Parameters for Guided Image Filtering
%gimfiltR = 60;
motofiltR = center;
eps = 10^-3;
%% filter
[dR, dP] = calVSMap(I, r);
refineDR = fastguidedfilter_color(double(I)/255, dP, r, eps, r/4);
tR = exp(-beta*refineDR);

%% output
a = estA(I, dR);
t0 = 0.05;
t1 = 1;
I = double(I)/255;
[h w c] = size(I);
J = zeros(h,w,c);
J(:,:,1) = I(:,:,1)-a(1);
J(:,:,2) = I(:,:,2)-a(2);
J(:,:,3) = I(:,:,3)-a(3);

t = tR;
t(t<t0)=t0;
t(t>t1)=t1;

J(:,:,1) = J(:,:,1)./t;
J(:,:,2) = J(:,:,2)./t;
J(:,:,3) = J(:,:,3)./t;

J(:,:,1) = J(:,:,1)+a(1);
J(:,:,2) = J(:,:,2)+a(2);
J(:,:,3) = J(:,:,3)+a(3);


clear;clc;close all;

delta=1;
epsilon=1e-5;

%%% Create a grid of data points
t=-3:.1:3;
[x,y]=meshgrid(t,t);
x=x(:)';  y=y(:)'; r=x.^2+y.^2;
%%% remove the points with r>3
x=x(r<=3); y=y(r<=3); r=r(r<=3);
%%% remove an annulus .75<r<1.5
x=x((r<=.75)|(r>=1.5));
y=y((r<=.75)|(r>=1.5));
r=r((r<=.75)|(r>=1.5));
%%% Define the data set X
X=[x; y];
%%% Define the `labels' c
c=(r<1)+1;


figure; %%% Plot the labeled data
scatter(X(1,:),X(2,:),20,c,'filled');

myc = jet; %%% adjust the color map
myc = myc(10:end-6,:);
set(gca,'colormap', myc);
set(gca,'fontsize',24);

%2

%%%%%%% Kernel PCA %%%%%%%%%

d = pdist2(X',X');      %%% compute matrix of pairwise distances
G=X'*X;
%%% compute the kernel matrix
K = exp(-d.^2/delta);   %%% Exponential Radial Basis Function
%K = (1+G).^delta;       %%% Polynomial
%K = 1./(1+d.^2/delta);  %%% Nonlocal
%K = acosh(1+d/delta);   %%% Hyperbolic
%K = tanh(delta+G);      %%% Sigmoid

K=(K+K')/2;             %%% ensure numerical symmetry
[U,L]=eigs(K,5);        %%% compute the eigendecomposition of the Kernel matrix
Z = sqrt(L)*U';         %%% compute the kernel PCA coordinates 

figure;                 %%% Plot the new coordinates
scatter3(Z(1,:),Z(2,:),Z(3,:),20,r,'filled');
set(gca,'colormap', myc);


%3
t=-3:.1:3;
[x,y]=meshgrid(t,t);
x=x(:)';y=y(:)';
Z=[x;y];

%a
K = exp(-d.^2/delta);

%b
c = (K+epsilon*eye(length(c)))\c';

%c
d2=pdist2(Z',X');
Kz = exp(-d2.^2/delta);

%d
cZ=Kz*c;
%e
figure
surf(t,t,reshape(cZ,length(t),[]))


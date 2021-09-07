function [f1,f2] = im_int_plots(Images,Sx,Sy)
%% Plots the images from the panel with the intensity profiles
% Images = the images from function open_his
% Sx = defines how many subplot images on x-axis in figure f1
% Sy = defines how many subplot images on y-axis in figure f2

f1 = figure;
f2 = figure;
x0=10;
y0=10;
width =1000;
height =570;
for i = 1:size(Images,3)
    Im = Images(:,:,i); 
    % Defines outliers as points outside of the percentiles specified in threshold
    % Used as contrast window => adjust [10 90] 
    Im_outliers = rmoutliers(Images(:,:,i),'percentiles',[10 90]); 
    x = [0 size(Im,2)];
    y = [size(Im,1)/2 size(Im,1)/2];
    I = improfile(Im, x, y);
    set(gcf,'position',[x0,y0,width,height])
    set(0,'CurrentFigure',f1)
    subplot(Sx,Sy,i);
    % Plot figure => adjust contrast in Im_outliers
    imagesc(Im,[min(Im_outliers(:)) max(Im_outliers(:))]); 
    colorbar;
    hold on
    plot(x,y,'r');
    title('Image ',i);
    
    hold off;
    set(gcf,'position',[x0,y0,width,height])
    set(0,'CurrentFigure',f2)
    subplot(Sx,Sy,i);
    plot(I(:,1,1),'r');
    title('Intensity profile ',i)
    hold off;
    %imcontrast;
end

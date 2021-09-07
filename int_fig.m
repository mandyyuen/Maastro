function [f1] = int_fig(original_im, correction_im)
%% Plots the intensity profiles of the images
% INPUT
% original_im = original image
% correction_im = image corrected with sensitivity map

% OUTPUT
% f1 = figure showing the intensity profiles of original and corrected
% image
% Improvement in percentage

% Set figure with settings
f1 = figure;
x0=10;
y0=10;
width =1000;
height =570;

% Original image
Im = original_im; 
% Intensity profile is over the whole x-axis of the panel 
x = [1 size(Im,2)];
% Define where the intensity profile is taken, middle of panel
y = [size(Im,1)/2 size(Im,1)/2];
% Get intensity profile values
I = improfile(Im, x, y);
% Set figure
set(gcf,'position',[x0,y0,width,height])
set(0,'CurrentFigure',f1)
% Plot figure
plot(linspace(1,43.2,2880),I(:,1,1),'r');
% Calculate noise - exclude boundaries
diff=abs([I; 0]-[0; I]);
%val=sum(diff(2:end-1));
val=sum(diff(6:end-5));

hold on;
% Corrected image
Im_corr = correction_im; 
% Calculate intensity values
I_corr = improfile(Im_corr, x, y);
% Plot figure
%plot(I_corr(:,1,1),'b');
plot(linspace(1,43.2,2880),I_corr(:,1,1),'b');
% Calculate noise
diff_corr=abs([I_corr; 0]-[0; I_corr]);
%val_corr=nansum(diff_corr(2:end-1));
val_corr=nansum(diff_corr(6:end-5));
disp(['Line length raw image 21.6 cm = ' ,num2str(val)])
disp(['Line length corrected image 21.6 cm = ' ,num2str(val_corr)])
disp(['Line length difference between raw and corrected image 21.6 cm = ' ,num2str(val-val_corr)])
disp(['Improvement in percentage 21.6 cm = ' ,num2str(((val-val_corr)/val)*100), '%'])

y = [size(Im,1)/4 size(Im,1)/4];
I = improfile(Im, x, y);
%plot(I(:,1,1),'k');
plot(linspace(1,43.2,2880),I(:,1,1),'k');
diff=abs([I; 0]-[0; I]);
%val=sum(diff(2:end-1));
val=sum(diff(6:end-5));
Im_corr = correction_im; 
I_corr = improfile(Im_corr, x, y);
%plot(I_corr(:,1,1),'m');
plot(linspace(1,43.2,2880),I_corr(:,1,1),'m');

diff_corr=abs([I_corr; 0]-[0; I_corr]);
%val_corr=nansum(diff_corr(2:end-1));
val_corr=nansum(diff_corr(6:end-5));

disp(['Line length raw image 10.8 cm = ' ,num2str(val)])
disp(['Line length corrected image 10.8 cm = ' ,num2str(val_corr)])
disp(['Line length difference between raw and corrected image 10.8 cm = ' ,num2str(val-val_corr)])
disp(['Improvement in percentage 10.8 cm = ' ,num2str(((val-val_corr)/val)*100), '%'])

%title('Single line intensity profiles');
legend({'RAW 21.6 cm', 'Corrected 21.6 cm', 'RAW 10.8 cm', 'Corrected 10.8 cm'},'Location','northeast');
ylabel('EPID response');
xlabel('Position (cm)');

end

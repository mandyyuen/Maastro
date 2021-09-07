%% Information open_IrIS
% Open image with [Im] = open_IrIS(0);

%% Acquire mean image of multiple frames
MeanImage_1 = MeanImage();
save('MeanImage_1.mat','MeanImage_1');
MeanImage_2 = MeanImage();
save('MeanImage_2.mat','MeanImage_2');
MeanImage_3 = MeanImage();
save('MeanImage_3.mat','MeanImage_3');
MeanImage_4 = MeanImage();
save('MeanImage_4.mat','MeanImage_4');
MeanImage_5 = MeanImage();
save('MeanImage_5.mat','MeanImage_5');
MeanImage_6 = MeanImage();
save('MeanImage_6.mat','MeanImage_6');
MeanImage_7 = MeanImage();
save('MeanImage_7.mat','MeanImage_7');
MeanImage_8 = MeanImage();
save('MeanImage_8.mat','MeanImage_8');
MeanImage_9 = MeanImage();
save('MeanImage_9.mat','MeanImage_9');
MeanImage_10 = MeanImage();
save('MeanImage_10.mat','MeanImage_10');
MeanImage_11 = MeanImage();
save('MeanImage_11.mat','MeanImage_11');
MeanImage_12 = MeanImage();
save('MeanImage_12.mat','MeanImage_12');
MeanImage_13 = MeanImage();
save('MeanImage_13.mat','MeanImage_13');
MeanImage_14 = MeanImage();
save('MeanImage_14.mat','MeanImage_14');
MeanImage_15 = MeanImage();
save('MeanImage_15.mat','MeanImage_15');
MeanImage_16 = MeanImage();
save('MeanImage_16.mat','MeanImage_16');
MeanImage_17 = MeanImage();
save('MeanImage_17.mat','MeanImage_17');
MeanImage_18 = MeanImage();
save('MeanImage_18.mat','MeanImage_18');
MeanImage_19 = MeanImage();
save('MeanImage_19.mat','MeanImage_19');
MeanImage_20 = MeanImage();
save('MeanImage_20.mat','MeanImage_20');
MeanImage_21 = MeanImage();
save('MeanImage_21.mat','MeanImage_21');
MeanImage_22 = MeanImage();
save('MeanImage_22.mat','MeanImage_22');
MeanImage_23 = MeanImage();
save('MeanImage_23.mat','MeanImage_23');
MeanImage_24 = MeanImage();
save('MeanImage_24.mat','MeanImage_24');
MeanImage_25 = MeanImage();
save('MeanImage_25.mat','MeanImage_25');
MeanImage_26 = MeanImage();
save('MeanImage_26.mat','MeanImage_26');
MeanImage_27 = MeanImage();
save('MeanImage_27.mat','MeanImage_27');
MeanImage_28 = MeanImage();
save('MeanImage_28.mat','MeanImage_28');
MeanImage_29 = MeanImage();
save('MeanImage_29.mat','MeanImage_29');
MeanImage_30 = MeanImage();
save('MeanImage_30.mat','MeanImage_30');
MeanImage_31 = MeanImage();
save('MeanImage_31.mat','MeanImage_31');
MeanImage_32 = MeanImage();
save('MeanImage_32.mat','MeanImage_32');
MeanImage_33 = MeanImage();
save('MeanImage_33.mat','MeanImage_33');
MeanImage_34 = MeanImage();
save('MeanImage_34.mat','MeanImage_34');
MeanImage_35 = MeanImage();
save('MeanImage_35.mat','MeanImage_35');

%% Acquire moving and fixed images
% Zeros matrix -> define size
moving = uint16(zeros(2880,2880,35));

% Append all acquisitions in moving
moving(:,:,1) = MeanImage_1;
moving(:,:,2) = MeanImage_2;
moving(:,:,3) = MeanImage_3;
moving(:,:,4) = MeanImage_4;
moving(:,:,5) = MeanImage_5;
moving(:,:,6) = MeanImage_6;
moving(:,:,7) = MeanImage_7;
moving(:,:,8) = MeanImage_8;
moving(:,:,9) = MeanImage_9;
moving(:,:,10) = MeanImage_10;
moving(:,:,11) = MeanImage_11;
moving(:,:,12) = MeanImage_12;
moving(:,:,13) = MeanImage_13;
moving(:,:,14) = MeanImage_14;
moving(:,:,15) = MeanImage_15;
moving(:,:,16) = MeanImage_16;
moving(:,:,17) = MeanImage_17;
moving(:,:,18) = MeanImage_18;
moving(:,:,19) = MeanImage_19;
moving(:,:,20) = MeanImage_20;
moving(:,:,21) = MeanImage_21;
moving(:,:,22) = MeanImage_22;
moving(:,:,23) = MeanImage_23;
moving(:,:,24) = MeanImage_24;
moving(:,:,25) = MeanImage_25;
moving(:,:,26) = MeanImage_26;
moving(:,:,27) = MeanImage_27;
moving(:,:,28) = MeanImage_28;
moving(:,:,29) = MeanImage_29;
moving(:,:,30) = MeanImage_30;
moving(:,:,31) = MeanImage_31;
moving(:,:,32) = MeanImage_32;
moving(:,:,33) = MeanImage_33;
moving(:,:,34) = MeanImage_34;
moving(:,:,35) = MeanImage_35;

% save image
save('moving.mat','moving');
% Open image in struct
moving = load('moving.mat');
% Get variable out of struct
moving = moving.moving;

% % Loop over images which have to be registered
% for im = 1:size(moving,3)
%     % Acquire mean_image of all frames of one pixel sensitivity variation 
%     [meanImage] = MeanImage();
%     % Append in one matrix
%     moving(:,:,im) = meanImage;
%     disp(im)
% end

%% Open background image
% Select and open background image
background = uint16(open_his(432,432,1,0));

% Save fixed image
save('background_image.mat','background');
% Open fixed image in struct
background = load('background_image.mat');
% Get variable out of struct
background = background.background;

%% Subtract background from images
for i = 1:size(moving,3)
    moving(:,:,i) = moving(:,:,i) - background;
end

%% Remove artefact line
x = [1171 1173 1173 1171];
y = [439 439 1446 1446];
% moving images
for i = 1:size(moving,3)
    image = moving(:,:,i);
    % Interpolate negative values and zeroes
    image = regionfill(moving(:,:,i),x,y);
    moving(:,:,i) = image;
end

% Save fixed image without artefact line
save('moving_corr.mat','moving', '-v7.3');
% Open fixed image in struct
moving = load('moving_corr.mat');
% Get variable out of struct
moving = moving.moving;

% Define fixed image
fixed = uint16(moving(:,:,18));

%% Optional show all moving images in one figure
% f1 = figure;
% for i = 1:size(moving,3)
%     set(0,'CurrentFigure',f1);
%     subplot(7,7,i);
%     imagesc(moving(:,:,i));
%     hold on;
% end

%% Image registration => moving to fixed
% Contains all unregistered images with background = 0
tot_int = uint16(zeros(size(moving)));
% Contains all registered images 
tot_reg = uint16(zeros(size(moving)));
% Matrix containing inverse transformations
T_inverse = [];

% Add initial translation for the first row and last row of images
% Loop over images which have to be registered
for im = 1:5
    % Registrate every moving image to fixed image
    [fixed_int, moving_int, moving_int_reg, tform_invert] = ImageReg(moving(:,:,im), fixed, 0.05, 0, 150);
    % Append unregistered moving images containing highest intensity values in one matrix
    tot_int(:,:,im) = moving_int;
    % Append registrated 2D matrices in one 3D matrix
    tot_reg(:,:,im) = moving_int_reg;
    % Append transformation 2D matrices in one 3D matrix
    T_inverse = [T_inverse, tform_invert];
end

% Loop over images which have to be registered
for im = 6:30
    % Registrate every moving image to fixed image
    [fixed_int, moving_int, moving_int_reg, tform_invert] = ImageReg(moving(:,:,im), fixed, 0.05, 0, 0);
    % Append unregistered moving images containing highest intensity values in one matrix
    tot_int(:,:,im) = moving_int;
    % Append registrated 2D matrices in one 3D matrix
    tot_reg(:,:,im) = moving_int_reg;
    % Append transformation 2D matrices in one 3D matrix
    T_inverse = [T_inverse, tform_invert];
end

% Loop over images which have to be registered
for im = 31:35
    % Registrate every moving image to fixed image
    [fixed_int, moving_int, moving_int_reg, tform_invert] = ImageReg(moving(:,:,im), fixed, 0.05, 0, -150);
    % Append unregistered moving images containing highest intensity values in one matrix
    tot_int(:,:,im) = moving_int;
    % Append registrated 2D matrices in one 3D matrix
    tot_reg(:,:,im) = moving_int_reg;
    % Append transformation 2D matrices in one 3D matrix
    T_inverse = [T_inverse, tform_invert];
end

% Calculate the average intensity value at every pixel location of all
% images while excluding the NaN values = reference image / pixel sensitivity matrix
NaN_tot_reg = double(tot_reg);
NaN_tot_reg(NaN_tot_reg==0)=NaN;
average_reg = nanmean(NaN_tot_reg,3);

%% Evaluate (optional)
% show difference between fixed image and registered image

f1 = figure;
for i = 1:size(tot_reg,3)
    set(0,'CurrentFigure',f1)
    subplot(6,6,i)
    imshowpair(fixed_int, tot_reg(:,:,i),'Scaling','joint')
    hold on
end

%% Save registered images and reference average image in struct
save('reg_tot_av.mat','tot_int', 'tot_reg','average_reg', 'T_inverse', '-v7.3');
% Open registered images and reference average image in struct
reg_tot_av = load('reg_tot_av.mat');
% Get the variables out of the struct
tot_int = reg_tot_av.tot_int;
tot_reg = reg_tot_av.tot_reg;
average_reg = reg_tot_av.average_reg;
T_inverse = reg_tot_av.T_inverse;

%% Image registration using inverse transformation => averaged image, T^-1, original image
% Matrix that contains the registered average image to every image
imreg_av = zeros(size(tot_reg));
for i = 1:size(tot_reg,3)
    reg_inv = imwarp(average_reg, T_inverse(1,i),'OutputView',imref2d(size(tot_reg(:,:,i))));
    imreg_av(:,:,i) = reg_inv;
end

%% Exclude boundary values from average image
% Set threshold manually 
max_int_av = 0.12 * max(average_reg(average_reg<max(average_reg)));

% Matrix that contains the registered average images with the highest
% intensity values
imreg_av_int = zeros(size(tot_reg));

for im = 1:size(imreg_av,3)
    image = imreg_av(:,:,im);
    for int = 1:numel(image)
        if image(int) >= max_int_av;
            image(int) = image(int);
        else 
            image(int) = NaN;
        end
    end
    imreg_av_int(:,:,im) = image;
end

%% Evaluate (optional)
% show difference between imreg_av_int and imreg_av

% f1 = figure;
% for i = 1:size(tot_reg,3)
%     set(0,'CurrentFigure',f1)
%     subplot(6,6,i)
%     imagesc(imreg_av_int)
%     imshowpair(imreg_av(:,:,i), imreg_av_int(:,:,i),'Scaling','joint')
%     hold on
% end

%% Fractionated pixel sensitivities: Fraction of each pixel sensitivity image with the average intensity image (ref)
NaN_tot_int = double(tot_int);
NaN_tot_int(NaN_tot_int==0)=NaN;

frac_int = zeros(size(tot_reg));
for i = 1:size(tot_reg,3)
    frac = NaN_tot_int(:,:,i) ./ imreg_av_int(:,:,i);
    frac_int(:,:,i) = frac;
end

%% Save
save('imreg_sens_frac.mat','imreg_av','imreg_av_int', 'frac_int','-v7.3');
% Open registered images and reference average image in struct
imreg_sens = load('imreg_sens_frac.mat');
% Get the variables out of the struct
imreg_av = imreg_sens.imreg_av;
imreg_av_int = imreg_sens.imreg_av_int;
frac_int = imreg_sens.frac_int;

%% Optional: Plot overlap images
% f1 = figure;
% for i = 1:size(tot_reg,3)
% 
%     set(0,'CurrentFigure',f1);
%     subplot(6,6,i);
%     colorbar;
%     imshowpair(moving(:,:,i), imreg_av(:,:,i),'Scaling','joint');
% 
% end

%% Make sensitivity map
% Only keep values lower than 0.9 and higher than 1.1
NaN_int = frac_int;
NaN_int(NaN_int>1.1)=NaN;
NaN_int(NaN_int<0.9)=NaN;

% Sensitivity map: average over all pixel sensitivities while excluding the NaN values
sens_map = nanmean(NaN_int,3);

% Save
save('sens_map.mat','sens_map');
% Open registered images and reference average image in struct
sens_map = load('sens_map.mat');
% Get the variables out of the struct
sens_map = sens_map.sens_map;

%% Optional, visualize sensitivity map
% f3 = figure;
% sens_map_im = imagesc(linspace(1,43.2,2880),linspace(1,43.2,2880), sens_map);
% colorbar;
% set(gca,'fontsize',20)
% ylabel('Position (cm)');
% xlabel('Position (cm)');

%% Evaluation
% Open an image (brachytherapy) which is not used to acquire the sensitivity map
Im = uint16(open_his(432,432,1,0));

% Select and open background image
background = uint16(open_his(432,432,1,0));

% Subtract background from original image
Im = Im - background;

% Remove artefact line
% Loop over every row
for line = 1:size(Im,1)
    % For every intensity profile on each row
    int_profile = double(Im(line,:));
    % Find highest peak value with its index
    [peak,peak_index] = findpeaks(int_profile.^-1,'MinPeakProminence',2e-4);
    % Replace peaks with zeroes 
    Im(line, peak_index) = 0;
end

% Interpolate negative values and zeroes
Im = regionfill(Im, Im <= 0);

% Divide this image with sensitivity map
Im_2 = double(Im) ./ sens_map;

% Plot intensity profiles
[f1] = int_fig(Im,Im_2);

% Plot corrected image with intensity plot
[f2,f3] = im_int_plots(Im_2,1,1);

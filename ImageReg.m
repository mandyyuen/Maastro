function [fixed_int, moving_int, moving_int_reg, tform_invert] = ImageReg(moving, fixed, thresh_bg, initial_x, initial_y)
%% Function description
% INPUT
% moving = moving image (PMx, PMy, i)
% fixed = fixed image (PMx, PMy, i)
% thresh_bg = define threshold value to set background to zero
% initial_x = initial translation in x-direction
% initial_y = initial translation in y-direction

% OUTPUT
% fixed_int = unregistered fixed image containing the highest intensity
% values and background is zero
% moving_int = unregistered moving image containing the highest intensity
% values and background is zero
% moving_int_reg = registered moving image containing the highest intensity
% values and background is zero
% tform_invert = 1x1x affine2d, contains inverse transformation matrix
%% Set low intensity values (background) to zero
% Linac
max_int = thresh_bg * max(fixed(fixed<max(fixed))); % second highest intensity

% Make zero matrix of moving image
moving_bin = uint16(zeros(size(fixed)));
% Make binary image
for int = 1:numel(moving_bin)
    if moving(int) >= max_int;
        moving_bin(int) = 1;
    else 
        moving_bin(int) = 0;
    end
end

% Make zero matrix of fixed image
fixed_bin = uint16(zeros(size(fixed)));
% Make binary image
for int = 1:numel(fixed_bin)
    if fixed(int) >= max_int;
        fixed_bin(int) = 1;
    else 
        fixed_bin(int) = 0;
    end
end


% Unregistered moving image containing the highest intensity values 
moving_int = moving .* moving_bin;

% Fixed image containing the highest intensity values
fixed_int = fixed .* fixed_bin;
%% Image registration
% Define optimizer and metric 
[optimizer, metric] = imregconfig('monomodal');
% Define minimum step length
optimizer.MinimumStepLength = 1e-7;
% Define maximum step length
optimizer.MaximumStepLength = 6;
% Define maximum iterations
optimizer.MaximumIterations = 120;

% Apply initial transformation into right direction
tform_in = affine2d([1 0 0; 0 1 0 ; initial_x initial_y 1]);
moving_int_initial = imwarp(moving_int, tform_in,'OutputView',imref2d(size(fixed_int))); 

% Find the geometric transformation that maps the image to be registered (moving) to the reference image (fixed)
tform_reg = imregtform(moving_int_initial, fixed_int, 'translation', optimizer, metric);

% Get the total transformation matrix
tform_reg_x = tform_reg.T(3,1);
tform_reg_y = tform_reg.T(3,2);
tform_tot = affine2d([1 0 0; 0 1 0; tform_reg_x+initial_x tform_reg_y+initial_y 1]);
% Create inverse geometric transformation
tform_invert = invert(tform_tot);

% Apply the transformation to the image being registered (moving) 
moving_int_reg = imwarp(moving_int, tform_tot,'OutputView',imref2d(size(fixed_int))); 

% % View fixed and registered moving image
% figure
% imshowpair(fixed_int, moving_int,'Scaling','joint')

end
%% Function that opens multiple frames (IrIS files) and takes the average over all frames 
%% while excluding visible lines (EPID and Linac/CBCT are not synchronized) 
function [meanImage] = MeanImage()
% INPUT
% Select IrIS files

%% Open IrIS files
% Open IrIS files
Im = uint16(open_IrIS(0));

%% Calculate mean image: average over all frames while excluding frames containing lines (EPID not synchronized with Linac)
% For every pixel location, compare all pixels of all frames
% If pixel has different value compared to median (~3% of median) 
% then exclude this pixel

% Contains the average frame of all frames
meanImage = uint16(zeros(size(Im,1),size(Im,2)));
% Contains list of pixel values of all frames per pixel location
val_frames = uint16(zeros(1,size(Im,3)));

% Loop over every row (y-coordinate)
for y = 1:size(Im,1)
    % Loop over every column (x-coordinate)
    for x = 1:size(Im,2)
        % Loop over every frame 
        for xy = 1:size(Im,3)
            % Select the value from the same pixel location in every frame
            val = Im(y,x,xy);
            %val_frames = [val_frames, value];
            % Add this value to the list
            val_frames(xy) = val;
        end
        % Take median of all values of all the frames
        median_val = median(val_frames);

        % Loop over every pixel value in the same pixel location of all
        % frames 
        for value = 1:length(val_frames)
            % If the pixel value is smaller than the median value,
            if val_frames(value) < median_val 
                % Replace this value with zero
                val_frames(value) = 0;
            end
        end
        % Replace specific pixel location with the mean value of all frames
        % while excluding the zero values
        meanImage(y,x)= mean(nonzeros((val_frames)));
    end
    %disp(y)
end

end

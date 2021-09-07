function [Im] = open_his(FOV_x,FOV_y,binning,varargin)
%% Function description
% INPUT
% FOX_x = Field of view in x-direction
% FOX_y = Field of view in y-direction
% binning = which binning mode
% varargin = 0

% OUTPUT
% Im = image is read out and saved in matrix in Im

%% Select folder and files
% if varargin{1} is numeric - mean the user did not provide a list of
if isnumeric(varargin{1})== 0      % files or a folder
   % check if it is a string or cell (folder or file) it can be a cell with multiple files
   % if it is a string convert to cell for consistency sake
   if iscell(varargin{1}) == 0
      varargin{1}={varargin{1}};
   end
   %
   if exist(varargin{1}{1},'file')==2
       files      = varargin{1};
   elseif exist(varargin{1}{1},'dir') ==7
       if strcmp(varargin{1}{1}(end),filesep)==0
          varargin{1}{1}=[varargin{1}{1} filesep];
       end
       f          = dir([varargin{1}{1} filesep '*.his']);
       f          = f(logical([f.isdir]-1));
       files      = {f.name};
       for i=1:length(f)
          files {i}=[varargin{1}{1} files{i}];
       end
       %
       disp(['Opening folder: ' varargin{1}{1}]);
    else
       disp('file or folder does not exist');
       return
    end
      %
else % open dlg box to select files
    [files,folder]=uigetfile('*.his','Select images','C:\EPID\','MultiSelect', 'on');
    if iscell(files)==0 
       files={files};
    end
    %
    for i=1:size(files,2)
        files {i}=[folder files{i}];
    end
    %

    %
    Buf    = 100;
   
%% For FOV => define ROI (Vy x Vx)
    if FOV_x == 432 && FOV_y == 432
        if binning == 1
            VyVx   = [0 2879 0 2879];    
        elseif binning == 2
            VyVx   = [0 1439 0 1439];
        elseif binning == 3
            VyVx   = [0 959 0 959];
        elseif binning == 4
            VyVx   = [0 719 0 703];
        else
            print('Error: binning value should be in the range of 1-4')
        end
    elseif FOV_x == 288 && FOV_y == 288
        if binning == 1
            VyVx   = [0 1919 0 1919];    
        elseif binning == 2
            VyVx   = [0 959 0 959];
        elseif binning == 3
            VyVx   = [0 639 0 639];
        elseif binning == 4
            VyVx   = [0 479 0 479];
        else
            print('Error: binning value should be in the range of 1-4')
        end
    elseif FOV_x == 216 && FOV_y == 216
        if binning == 1
            VyVx   = [0 1439 0 1439];    
        elseif binning == 2
            VyVx   = [0 719 0 735];
        elseif binning == 3
            VyVx   = [0 479 0 479];
        elseif binning == 4
            VyVx   = [0 359 0 383];
        else
            print('Error: binning value should be in the range of 1-4')
        end
     elseif FOV_x == 432 && FOV_y == 216
        if binning == 1
            VyVx   = [0 1439 0 2879];    
        elseif binning == 4
            VyVx   = [0 239 0 703];
        else
            print('Error: binning value should be 1 or 4')
        end
     elseif FOV_x == 432 && FOV_y == 72
        if binning == 1
            VyVx   = [0 479 0 2879];    
        elseif binning == 4
            VyVx   = [0 119 0 703];
        else
            print('Error: binning value should be 1 or 4')
        end
    else
        print('Error: current FOV is not available. Options: 432x432 - 288x288 - 216x216 - 432x216 - 432x72')
    end
    
%% Read image   
    Im     = zeros(diff(VyVx(1:2))+1,diff(VyVx(3:4))+1,size(files,2));
	
    for i=1:size(files,2)
      fid = fopen(files{i},'r');
      fseek(fid,Buf,'bof');
      %Im(:,:,i) = uint32(fread(fid,[diff(VyVx(3:4))+1,diff(VyVx(1:2))+1],'*uint32')');
      Im(:,:,i) = uint16(fread(fid,[diff(VyVx(3:4))+1,diff(VyVx(1:2))+1],'*uint16')');
      % Fill outliers (3 std from mean) with zero
      Im(:,:,i) = filloutliers(Im(:,:,i), 0, 'mean');
      % Interpolate negative values and zeroes
      Im(:,:,i) = regionfill(Im(:,:,i), Im(:,:,i) <= 0);

    end
    
    
%% End of file
end
function [Im] = open_IrIS(varargin)
%% Function description
% INPUT
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
    [files,folder]=uigetfile('*.IrIS','Select images','C:\EPID\','MultiSelect', 'on');
    if iscell(files)==0 
       files={files};
    end
    %
    for i=1:size(files,2)
        files {i}=[folder files{i}];
    end
    %
    %
    fid                     = fopen(files{1},'r');
    Info(1:1000)            = double(fread(fid,1000,'*uint16'));
    Info(1001:1002)         = double(fread(fid,2,'float'));
    Info(1003:1007)         = double(fread(fid,5,'*uint64'));
    %
    Buf                     = Info(1);       % buffer size
    gain                    = Info(2);       % acquisition mode
    VxVy                    = Info(5:8);     % ROI
    Binning                 = Info(9);
    fps                     = Info(1001);
    Resolution              = Info(1002);    % resolution mm    
    %
    fclose(fid);
%% Read image   
    Im     = zeros(diff(VxVy(1:2))+1,diff(VxVy(3:4))+1,size(files,2));
    for i=1:size(files,2)
      fid = fopen(files{i},'r');
      fseek(fid,Buf,'bof');
      %Im(:,:,i) = uint32(fread(fid,[diff(VxVy(3:4))+1,diff(VxVy(1:2))+1],'*uint32')');
      Im(:,:,i) = uint16(fread(fid,[diff(VxVy(3:4))+1,diff(VxVy(1:2))+1],'*uint16')');
      % Fill outliers (3 std from mean) with zero
      Im(:,:,i) = filloutliers(Im(:,:,i), 0, 'mean');
      % Interpolate negative values and zeroes
      Im(:,:,i) = regionfill(Im(:,:,i), Im(:,:,i) <= 0);
      fclose(fid);
    end
    
    
%% End of file
end
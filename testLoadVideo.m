%% Test Video Reading
% Load .mov files


%% Initialize and load
path = '..\test video\';
mov1path = strcat(path, '2013-09-08 15.06.17.mov')
mov2path = strcat(path, '2013-09-08 15.07.16.mov')

mov1obj = VideoReader( mov1path );
mov2obj = VideoReader( mov2path );





% %% Set-up to view movie
% nFrames = xyloObj.NumberOfFrames;
% vidHeight = xyloObj.Height;
% vidWidth = xyloObj.Width;

% % Preallocate movie structure.
% mov(1:nFrames) = ...
%     struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
%            'colormap', []);

% % Read one frame at a time.
% for k = 1 : nFrames
%     mov(k).cdata = read(xyloObj, k);
% end

% % Size a figure based on the video's width and height.
% hf = figure;
% set(hf, 'position', [150 150 vidWidth vidHeight])

% % Play back the movie once at the video's frame rate.
% movie(hf, mov, 1, xyloObj.FrameRate);
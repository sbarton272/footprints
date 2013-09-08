%% Test Video Reading
% Load .mov files

%% Clean-up workspace
clear('all');
close('all');

%% Initialize and load
filepath = '..\..\Footprints Files\test video\';
%mov1path = strcat(path, '2013-09-08 15.06.17.mov');
mov1path = strcat(filepath, '2013-09-08 15.07.16.mov');

mov1obj = VideoReader( mov1path );

%% Read frames
frame1 = read(mov1obj, 1);
frame2 = read(mov1obj, mov1obj.NumberOfFrames / 2);

%% manipulate image and show
img = imresize( frame1, .5);

%% display frame
hf = figure;
figSize = [150 150 mov1obj.Width mov1obj.Height];
set(hf, 'position', figSize)
figure(1);
imshow( img );

%% image diff test
imdiff = imresize( imabsdiff(frame1, frame2), .5);
figure(2);
imshow(imdiff);

%% calculate sum of differences
totalDiff = zeros(size(frame1), 'uint8');

for k = 2 : 100 :mov1obj.NumberOfFrames
	prevFrame = read(mov1obj, k-1);
	currFrame = read(mov1obj, k);
	totalDiff = totalDiff + imabsdiff(prevFrame, currFrame);
end

%% image diff test
figure(3);
totalDiff = imresize( totalDiff, .5);
imshow(totalDiff);

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
% getting background
v = VideoReader('depth-video.mp4');

% background time
v.CurrentTime = 60 + 12;
background_frame = readFrame(v);

% bo time
v.CurrentTime = 5;
bo_frame = readFrame(v) - background_frame;
%imshow(bo_frame);

% jumuk time
v.CurrentTime = 0;
jumuk_frame = readFrame(v) - background_frame;
%imshow(jumuk_frame);

% soccer time
v.CurrentTime = 19;
soccer_frame = readFrame(v) - background_frame;
%imshow(soccer_frame);

% garoro time
v.CurrentTime = 41;
garoro_frame = readFrame(v) - background_frame;
%imshow(garoro_frame);

% hab time
v.CurrentTime = 59;
hab_frame = readFrame(v) - background_frame;
%imshow(hab_frame);

img1 = bo_frame;
img1 = img1(:,:,1); % Convert to single channel.
img2 = imbinarize(img1, 0.1); % https://www.mathworks.com/help/images/ref/imbinarize.html
img2 = bwareaopen(img2, 200); % https://www.mathworks.com/help/images/ref/bwareaopen.html
% imshowpair(img1, img2, 'montage');

[m, n] = size(img2);

points = [];

for i = 1:m
    for j = 1:n
        if img2(i, j) > 0
            points = [points; [j, i]];
        end
    end
end

meanpoint= mean(points);
coeff = pca(points);

% Rotate
rotated_points = points * coeff;

min_point = min(rotated_points);

rotated_points = rotated_points - min_point;

rotated_image_size = max(rotated_points);

normalized_points_x = uint8(floor(rotated_points(:, 1) / rotated_image_size(1) * 99)) + 1; % https://www.mathworks.com/matlabcentral/newsreader/view_thread/319129
normalized_points_y = uint8(floor(rotated_points(:, 2) / rotated_image_size(2) * 99)) + 1;

normalized_points = unique([normalized_points_x normalized_points_y], 'rows');
[m, n] = size(normalized_points);

normalized_image = zeros(100, 100);

for k = 1:m
    r = normalized_points(k, :);
    normalized_image(r(1), r(2)) = 1;
end

imshow(normalized_image);
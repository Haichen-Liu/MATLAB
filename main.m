src_dir = 'TestImage';
img_ext = '.JPG';
    
% Read and display the car image
filename = uigetfile('汽车图片\*.jpg','选择图片');
car_im = imread(filename);               
figure('NumberTitle','off','Name','原始图像');
imshow(car_im);title('原始图像');% 显示待处理图像        

% License plate location
plate_im = LicPlateLoc(car_im);
if plate_im == -1
disp('车牌定位失败');
else
    figure(2), imshow(plate_im);title('车牌定位结果'); % 显示车牌定位结果
end
    
% License plate character segmentation
character_im = LicPlateSeg(plate_im);
if size(character_im, 2) == 1
disp('字符分割失败');
else
    figure(3), % 显示字符分割结果
    subplot(1,7,1), imshow(character_im{1});
    subplot(1,7,2), imshow(character_im{2});
    subplot(1,7,3), imshow(character_im{3});
    subplot(1,7,4), imshow(character_im{4});
    subplot(1,7,5), imshow(character_im{5});
    subplot(1,7,6), imshow(character_im{6});
    subplot(1,7,7), imshow(character_im{7}); 
end

% License plate character recognition
characters = LicPlateRec(character_im);
disp(characters);        

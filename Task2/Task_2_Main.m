clc; clear all; close all;

%% Setting path
% variable 'folder_path' should be adjusted to Your training dataset folder
% variable 'mat_file_name' should be adjusted to 
% .mat file withBoundingBoxes
folder_path = "C:\Users\karol\Desktop\Simuthon\Simuthon_BlueScripters\Task2\Training Dataset";
addpath(folder_path);
load('detector.mat');

%% Load image database
dataImageDataBase = imageDatastore(folder_path, "FileExtensions", ".png");

%% Variables init
num_image = length(dataImageDataBase.Files);
calculatedBoundingBox = repmat({zeros(1, 4)}, 1, num_image);

%% Detection using ACF detector
for i = 1:num_image
    im = readimage(dataImageDataBase,i);
    foundBoundingBox = detect(detectorACF, im);
    calculatedBoundingBox{i} = foundBoundingBox;
    saveToFile(i).Image = char(dataImageDataBase.Files(i));
    saveToFile(i).BoundingBox = calculatedBoundingBox{i};
end

%% Save output
saveToFile = saveToFile';
save("Task_2_BlueScripters.mat", "saveToFile")


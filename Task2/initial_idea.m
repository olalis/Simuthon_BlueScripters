clc; clear all; close all;

%% Load training data set
load("Training Dataset\Task_2_Training_Dataset.mat");

%% Load image data base
dataImageDataBase = imageDatastore("Training Dataset\WBA*.png");

%% Variables init
differenceBetweenRectangles = zeros(128,4);
isValidRectangle = zeros(128,1);
%% Prepare gTruth data
for i = 1:143
    wrong_size{i} = Task_2_Training_Data(i).BoundingBox;
end
BoundingBox = reshape(wrong_size, 143, 1);

gtSource = groundTruthDataSource(dataImageDataBase);
ldc = labelDefinitionCreator;
addLabel(ldc, 'Sign', labelType.Rectangle);
labelDefs = create(ldc);
labelNames = {'Sign'};
labelData = table(BoundingBox, 'VariableNames', labelNames);
gTruth = groundTruth(gtSource, labelDefs, labelData);

%% Training Detector with function

[images, labels] = objectDetectorTrainingData(gTruth, SamplingFactor=1);

trainingData = combine(images, labels);

% im = imread(images.Files{1});
% bb = labels.LabelData{1,1};
% im = insertObjectAnnotation(im, "rectangle",bb,"Sign");
% imshow(im)

detectorACF = trainACFObjectDetector(trainingData, NegativeSamplesFactor=1);

%%
im = imread(images.Files{66});
[foundBoundingBox, matchScore] = detect(detectorACF, im)

% for i = 1:1:length(images.Files)
% 
%     im = imread(images.Files{i});
% 
%     [foundBoundingBox, matchScore] = detect(detectorACF, im);
% 
%     differenceBetweenRectangles(i, :) = BoundingBox{i} - foundBoundingBox;
% 
%     isValidRectangle(i) = (differenceBetweenRectangles(i, 1) < 10 & ...
%                             differenceBetweenRectangles(i, 2) < 10 & ...
%                             differenceBetweenRectangles(i, 3) < 10 & ...
%                             differenceBetweenRectangles(i, 4) < 10);
% end

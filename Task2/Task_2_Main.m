clc; clear all; close all;

%% Load training data set
load("Training Dataset\Task_2_BlueScripters.mat");

%% Load image data base
dataImageDataBase = imageDatastore("Training Dataset\WBA*.png");

%% Variables init
num_image = size(dataImageDataBase.Files);
num_image = num_image(:, 1);

differenceBetweenRectangles = zeros(num_image,4);
isValidRectangle = zeros(num_image,1);
%% Prepare gTruth data
for i = 1:num_image
    wrong_size{i} = Task_2_Training_Data(i).BoundingBox;
end
BoundingBox = reshape(wrong_size, num_image, 1);

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

detectorACF = trainACFObjectDetector(trainingData, ObjectTrainingSize = [50, 50], NumStages=6, NegativeSamplesFactor=17, MaxWeakLearners=5000);

%%
valid = 0;
for i = 1:1:length(images.Files)
    i
    im = imread(images.Files{i});

    [foundBoundingBox, matchScore] = detect(detectorACF, im);
    new_bb{i} = foundBoundingBox;
    if (foundBoundingBox)
        valid = valid + check_size(BoundingBox{i}, foundBoundingBox);
    end
end
%% 
saveToFile.Image = images.Files
saveToFile.BoundingBox = reshape(new_bb, 143, 1);
save("saveToFile.mat", "saveToFile")
%% 
im = imread(images.Files{66});
[foundBoundingBox, matchScore] = detect(detectorACF, im)
im = insertObjectAnnotation(im, 'rectangle', foundBoundingBox, 'sign');
imshow(im);

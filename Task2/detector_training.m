clc; clear all; close all;

%% Setting path
% variable 'folder_path' should be adjusted to Your training dataset folder
% variable 'mat_file_name' should be adjusted to 
% .mat file withBoundingBoxes
folder_path = "C:\Users\karol\Desktop\Simuthon\Simuthon_BlueScripters\Task2\Training Dataset";
addpath(folder_path);
load("Task_2_Training_Dataset.mat");

%% Load image data base
dataImageDataBase = imageDatastore(folder_path, "FileExtensions", ".png");

%% Variables init
num_image = length(dataImageDataBase.Files);

%% Prepare gTruth data

BoundingBox = extract_boxes(Task_2_Training_Data);

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

detectorACF = trainACFObjectDetector(trainingData, ObjectTrainingSize = [80, 80], NumStages=4, NegativeSamplesFactor=4, MaxWeakLearners=5000);
%% Detection validation
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
%% Save detector
save("detector.mat", "detectorACF");


%% Different problem solution (different network, worse results).
% Below code fragment uses cascade object detector. It needed photos 
% which doesn't include priority sign. Such images were downloaded from 
% the Internet.

% Wrong image loading
wrong_photos = imageDatastore("wrong_photos\", "FileExtensions", ".png");

% Training
trainCascadeObjectDetector('D1SignDetector.xml', trainingData, wrong_photos, FalseAlarmRate=0.03, NumCascadeStages=4, ...
    TruePositiveRate=1, NegativeSamplesFactor=1, ObjectTrainingSize=[50 50])
%% Detecting
detector = vision.CascadeObjectDetector('D1SignDetector.xml');
img = imread(images.Files{22});
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'Sign');
figure();
imshow(detectedImg);

%% Result validation
valid_2 = 0;
for i = 1:1:length(images.Files)
    i
    im = imread(images.Files{i});

    bbox = step(detector,img);
    if (bbox)
        valid_2 = valid_2 + check_size(BoundingBox{i}, bbox);
    end
end

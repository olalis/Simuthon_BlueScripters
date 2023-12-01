clc; clear all; close all;

%% Load training data set
load("Training Dataset\Task_2_Training_Dataset.mat");

%% Load image data base
dataImageDataBase = imageDatastore("Training Dataset\WBA*.png");

%% Load first image

img = readimage(dataImageDataBase, 1);
imshow(img)
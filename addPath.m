function addPath
% Add folders of predefined functions into matlab searching paths.

global footpath;
footpath = cd;

addpath(genpath([footpath '/Libs']));
addpath(genpath([footpath '/Algs']));

% random seed generation
rand('twister', sum(100 * clock));
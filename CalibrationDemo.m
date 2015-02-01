clear all

width = 1280;
height = 720;

ftc0 = [1,-30,-3];

filename = 'data\001\CC-001-01-20131107-01.txt';

% k = ku1 ku2 kd1 kd2
k = [0.6322 0.5731 -0.6 0.4]; % cam01 cam02
% k = [0 0 0 0] % cam03
% k = [0.1890 0.1996 -0.2 0]; % cam05

% most precise, k is needed
ftc = CalibrateXYdFromFile(filename,  width, height,ftc0, k)

% suitble for many cases
ftc = CalibrateXYFromFile(filename,  width, height,ftc0)

% use only Y coordinates, only for height estimation
ftc = CalibrateYFromFile(filename, width, height,ftc0)

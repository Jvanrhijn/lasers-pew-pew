clear all
close all
clc
addpath('src');
addpath('src/util');

% initialize game engine, levels in directory 'levels'
ge = GameEngine('levels');
ge.start();



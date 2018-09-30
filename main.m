clear all
close all
clc
addpath('src');
addpath('src/util');

%gs = build_level('level.txt');
%gs = game_loop(gs);

% % Build levels in directory 'levels'
levels = levels_setup('levels');

% initialize game engine
ge = GameEngine();
ge.load_levels(levels);
ge.start();



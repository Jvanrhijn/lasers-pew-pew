clear all
close all
clc
addpath('src');
addpath('src/util');
addpath('levels');

gs = build_level('level.txt');
gs = game_loop(gs);
clear all
close all
clc
addpath('src');
addpath('src/util');
addpath('levels');

%gs = build_level('level.txt');
%gs = game_loop(gs);

% Build two basic levels
level_one = Level();
level_one.set_id(1);
level_one.add_component(MirrorFactory.build_rectangle(0.5, 0.5, [0.02, 0.2]));
level_one.add_component(TargetFactory.build_rectangle(0.5, 0.01, [0.05, 0.02]));
level_one.set_starting_ray(0, 0.5, pi/4.5);

level_two = Level();
level_two.set_id(2);
level_two.add_component(LensFactory.build_circle(0.5, 0.5, 0.1));
level_two.add_component(TargetFactory.build_rectangle(0.99, 0.5, [0.02, 0.05]));
level_two.set_starting_ray(0, 0.7, eps);

levels = [level_one, level_two];

% initialize game engine
ge = GameEngine();
ge.load_levels(levels);
ge.set_level(levels(1));
ge.start();


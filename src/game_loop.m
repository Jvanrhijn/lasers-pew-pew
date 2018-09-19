clear all
close all
clc

game_state=GameState()

% while true
objects = {Vec(1,2),Vec(3,4),Vec(2,5)};
% objects = game_state.components;
N_objects = size(objects,2)

gamestate.draw_state

% fig = figure;
% hold all
% for qq = 1:N_objects
%     plot(objects{qq}.x,objects{qq}.y,'.','MarkerSize',10)
% end

%ask user to select an object
disp('Select an object to manipulate')
[xi,yi] = ginput(1);
click_loc = Vec(xi,yi);

for nn = 1:N_objects
%     distance = objects{nn}-click_loc;
    distance = objects{nn}.shape.location_ - click_loc;
    norm_i(nn) = distance.norm;
end

%find the index of the nearest neighbor
[~,i_neighb] = min(norm_i);
%find string describing object
selected_object = objects{i_neighb};
object_name = 'Object Name';
disp(['Object "',object_name,'" selected'])


%ask user to apply action on object

%check if winning state has been reached
%if true: exit loop
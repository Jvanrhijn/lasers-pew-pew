clear all
close all
clc

gs=GameState();
lens = LensFactory.build_circle(0.4, 0.5, 0.1);
gs.add_component(lens);
gs.set_starting_ray(0,0.5,0.1);
gs.draw_state();


% while true
% objects = {Vec(1,2),Vec(3,4),Vec(2,5)};
objects = gs.components;
N_objects = size(objects,2);

gs.draw_state()

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
    
    % Check if location is inside shape
    if objects{nn}.shape.inside(click_loc)
        i_object = nn;
        break
   
    end
end
% else
%         disp("Please click inside an object")




%find string describing object
selected_object = objects{i_object};
object_name = 'Object Name';
disp(['Object "',object_name,'" selected'])

%ask user to apply action on object
disp(["Click on another location to move the object"])

[xj,yj] = ginput(1);
move_loc = Vec(xj,yj);

%move object to desired location
objects{i_object}.shape.move_to(move_loc)

%check if winning state has been reached
%if true: exit loop
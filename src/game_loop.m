clear all
close all
clc


gs = build_level('level.txt');

% 
% gs=GameState();
% lens = LensFactory.build_circle(0.4, 0.5, 0.1);
% mir = MirrorFactory.build_circle(0.2,0.6,0.3);
% rec = MirrorFactory.build_rectangle(0.2,0.2,[0.1, 0.5]);
% gs.add_component(lens);
% gs.add_component(mir);
% gs.add_component(rec);
% gs.set_starting_ray(0,0.5,0.2);
% gs.draw_state();

while true
% objects = {Vec(1,2),Vec(3,4),Vec(2,5)};
objects = gs.components;
N_objects = size(objects,2);


% fig = figure;
% hold all
% for qq = 1:N_objects
%     plot(objects{qq}.x,objects{qq}.y,'.','MarkerSize',10)
% end

%ask user to select an object
title('Select an object to manipulate')
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
selected_centroid = selected_object.shape.location;
plot(selected_centroid.x,selected_centroid.y,'.r','MarkerSize',15)

%ask user to apply action on object
title(["Click on another location to move the object"])


while true
    overlap=zeros(1,N_objects);
    [xj,yj] = ginput(1);
    move_loc = Vec(xj,yj);
    
    for mm = 1:N_objects
        if mm==i_object %don't check if it overlaps itself
            continue
        elseif objects{mm}.shape.inside(move_loc)
            % Check if location is inside other shapes
            title("Location must be outside other objects!")
            overlap(mm)=1;
        end
    end
    if max(overlap)==0
        break
    end
end
%move object to desired location
objects{i_object}.shape.move_to(move_loc)
gs.draw_state()

end
%check if winning state has been reached
%if true: exit loop
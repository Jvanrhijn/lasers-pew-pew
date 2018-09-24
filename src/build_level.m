function gs = build_level(level_name)
% build_level reads a .txt file containing the objects to be placed in the
% level, builds and plots the starting game state. 

% Input level_name = the name of the .txt file
% Output gs = a GameState object

fid = fopen(level_name);
C = textscan(fid,'%s %f %f %f %f','headerLines',1,'TreatAsEmpty','NaN');
fclose(fid);

gs = GameState();
j=1;
for qq = 1:size(C{1},1)
    switch C{1}{qq}
        case 'rm'
            object{j} = MirrorFactory.build_rectangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            gs.add_component(object{j})
            j=j+1;
        case 'cm'
            object{j} = MirrorFactory.build_circle(C{2}(qq),C{3}(qq),C{4}(qq));
            gs.add_component(object{j})
            j=j+1;
        case 'rl'
            object{j} = LensFactory.build_rectangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            gs.add_component(object{j})
            j=j+1;
        case 'cl'
            object{j} = LensFactory.build_circle(C{2}(qq),C{3}(qq),C{4}(qq));
            gs.add_component(object{j})
            j=j+1;
        case 'sr'
            gs.set_starting_ray(C{2}(qq),C{3}(qq),C{4}(qq));
    end
    
end

gs.draw_state()
end
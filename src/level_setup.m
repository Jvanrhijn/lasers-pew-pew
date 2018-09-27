function level_collection = level_setup(directory)
% build_level reads a directory containing level files. Level files are 
% .txt files containing the objects to be placed in the
% level. 

% Input level_name = the name of the .txt file
% Output level_collection = a Level array containing all levels in
% directory.

addpath(directory);
D = dir(directory);
ii=1;
for nn = 1:length(D)
    if D(nn).isdir
        continue
    else
        [C,level_name] = read_level(D(nn));
        level_collection(ii) = build_level(C,level_name);
        ii = ii+1;
    end
    
end

end

function [C,level_name] = read_level(D)
level_name = D.name;
fid = fopen(level_name);
C = textscan(fid,'%s %f %f %f %f','headerLines',1,'TreatAsEmpty','none');
fclose(fid);
end

function level_collection = build_level(C,level_name)
lvl = Level();
lvl.set_id(str2num(level_name(6)));
j=1;
for qq = 1:size(C{1},1)
    switch C{1}{qq}
        case 'rm'
            object{j} = MirrorFactory.build_rectangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'cm'
            object{j} = MirrorFactory.build_circle(C{2}(qq),C{3}(qq),C{4}(qq));
            lvl.add_component(object{j})
            j=j+1;
        case 'tm'
            object{j} = MirrorFactory.build_triangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'rl'
            object{j} = LensFactory.build_rectangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'cl'
            object{j} = LensFactory.build_circle(C{2}(qq),C{3}(qq),C{4}(qq));
            lvl.add_component(object{j})
            j=j+1;
        case 'tl'
            object{j} = LensFactory.build_triangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'rb'
            object{j} = BlackBodyFactory.build_rectangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'cb'
            object{j} = BlackBodyFactory.build_circle(C{2}(qq),C{3}(qq),C{4}(qq));
            lvl.add_component(object{j})
            j=j+1;
        case 'tb'
            object{j} = BlackBodyFactory.build_triangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'rt'
            object{j} = TargetFactory.build_rectangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'cb'
            object{j} = TargetFactory.build_circle(C{2}(qq),C{3}(qq),C{4}(qq));
            lvl.add_component(object{j})
            j=j+1;
        case 'tb'
            object{j} = TargetFactory.build_triangle(C{2}(qq),C{3}(qq),[C{4}(qq),C{5}(qq)]);
            lvl.add_component(object{j})
            j=j+1;
        case 'sr'
            lvl.set_starting_ray(C{2}(qq),C{3}(qq),C{4}(qq));
    end
    
end

level_collection = lvl;
end
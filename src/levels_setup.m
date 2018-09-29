function level_collection = levels_setup(directory)
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
        [level_data] = read_level(D(nn));
        level_collection(ii) = build_level(level_data);
        ii = ii+1;
    end
    
end

end

function [level_data] = read_level(D)
level_name = D.name;
fid = fopen(level_name);
fcontents = textscan(fid,'%f %s %f %f %f %f','headerLines',1,'TreatAsEmpty','none');
fclose(fid);

fields = {'n_object','type','x','y','dim1','dim2'};
level_data = cell2struct(fcontents,fields,2);
level_data.level_id=str2double(level_name(6));
end

function lvl = build_level(level_data)
lvl = Level();
lvl.set_id(level_data.level_id);

for n_object = level_data.n_object' %level_data.n_object is a column vector
    switch level_data.type{n_object} %curly brackets to extract data from cell
        case 'sr'
            lvl.set_starting_ray(level_data.x(n_object),level_data.y(n_object),level_data.dim1(n_object));
        case 'rm'
            component_builder = @(x,y,dim1,dim2) MirrorFactory.build_rectangle(x,y,[dim1,dim2]);
            lvl = build_component(lvl,level_data,n_object,component_builder);
        case 'cm'
            component_builder = @(x,y,dim1,dim2) MirrorFactory.build_circle(x,y,dim1);
            lvl = build_component(lvl,level_data,n_object,component_builder);
        case 'rl'
            component_builder = @(x,y,dim1,dim2) LensFactory.build_rectangle(x,y,[dim1,dim2]);
            lvl = build_component(lvl,level_data,n_object,component_builder);
        case 'cl'
            component_builder = @(x,y,dim1,dim2) LensFactory.build_circle(x,y,dim1);
            lvl = build_component(lvl,level_data,n_object,component_builder);
        case 'rb'
            component_builder = @(x,y,dim1,dim2) BlackBodyFactory.build_rectangle(x,y,[dim1,dim2]);
            lvl = build_component(lvl,level_data,n_object,component_builder);
        case 'cb'
            component_builder = @(x,y,dim1,dim2) BlackBodyFactory.build_circle(x,y,dim1);
            lvl = build_component(lvl,level_data,n_object,component_builder); 
        case 'rt'
            component_builder = @(x,y,dim1,dim2) TargetFactory.build_rectangle(x,y,[dim1,dim2]);
            lvl = build_component(lvl,level_data,n_object,component_builder);
        case 'ct'
            component_builder = @(x,y,dim1,dim2) TargetFactory.build_circle(x,y,dim1);
            lvl = build_component(lvl,level_data,n_object,component_builder);
    end
end
end

function lvl = build_component(lvl,level_data,n_object,component_builder)
x = level_data.x(n_object);
y = level_data.y(n_object);
dim1 = level_data.dim1(n_object);
dim2 = level_data.dim2(n_object);
object = component_builder(x,y,dim1,dim2);
lvl.add_component(object)
end




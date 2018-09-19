function sorted_array = custom_sort(array)
    length_array = length(array);
    while length_array>0    
        new_length_array = 0;    
        for i = 2:length_array
            if array(i-1)>array(i)
                buffer = array(i-1);
                array(i-1) = array(i);
                array(i) = buffer;
                new_length_array = i;
            end
        end
        length_array = new_length_array;    
    end
    sorted_array = array;
end
    
    

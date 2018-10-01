function arr = map(array, fn)
  arr = [];
  for i=1:length(array)
    arr = [arr, fn(array(i))];
  end
end

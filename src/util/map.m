function arr = map(array, fn)
  arr = zeros(1, length(array));
  for i=1:length(arr)
    arr(i) = fn(array(i));
  end
end

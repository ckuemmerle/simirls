function [med,vals] = get_med(mean_c,values)
% Computes the median of values in cell/array 'values' and returns via
% 'med'. 'vals' reformats entries of 'values' into an array.
vals = zeros(1,length(values));
for i=1:length(values)
    if not(iscell(values))
        vals(i) = values(i);
    elseif iscell(values{i})
        vals(i) = values{i}{1};
    else
        vals(i) = values{i};
    end
end
med = median(vals);
end
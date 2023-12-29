function [stdev,vals] = get_stdd(mean_c,values)
% Computes standard devation amoung values in 'values' and returns them
% in 'stdev'. 'vals' reformats entries of 'values' into an array.
vals = zeros(1,length(values));
for i=1:length(values)
    if not(iscell(values))
        vals(i) = values(i);
    else
        if iscell(values{i})
            vals(i) = values{i}{1};
        else
            vals(i) = values{i};
        end
    end
end
stdev = std(vals);
end
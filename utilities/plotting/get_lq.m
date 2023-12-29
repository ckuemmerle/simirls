function [lqd,vals] = get_lq(mean_c,values,varargin)
% Computes the deviation of 'mean_c' and lower quantile (default: 25%
% quantile) of values provided in 'values' and returns it via 'lqd'.
vals = zeros(1,length(values));
if nargin > 2
    threshold = varargin{1};
else
    threshold = 0.25;
end
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
lq = quantile(vals,threshold);
lqd = mean_c - lq; 
end
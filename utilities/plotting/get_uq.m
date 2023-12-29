function [uqd,vals] = get_uq(mean_c,values,varargin)
% Computes the deviation of 'mean_c' and upper quantile (default: 75%
% quantile) of values provided in 'values' and returns it via 'uqd'.
vals = zeros(1,length(values));
if nargin > 2
    threshold = varargin{1};
else
    threshold = 0.75;
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
uq = quantile(vals,threshold);
uqd = uq - mean_c;
end
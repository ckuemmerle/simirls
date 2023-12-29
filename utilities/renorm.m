function [ x_normed ] = renorm( x,p )
%RENORM normalizes a vector X by p-norm   
    if nargin < 2
        p = 2;
    end
    xnorm = norm(x,p);

    if (xnorm ~= 0)
        
        x_normed = x/xnorm;
        
    else
        
        x_normed = x;
        
    end

end


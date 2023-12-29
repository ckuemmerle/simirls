function [ F ] = getFr( Phi, V )
%   For the operator Phi and fixed V return F(V) with
%           
%       F(V)*U(:) = Phi*[(UV')(:)]

    r = size(V,2);
    n2 = size(V,1);
    n1 = size(Phi,2)/n2;
    d = size(Phi,1);

    F = zeros(d,r*n1);

    for k = 1:d
        
        %Matrify the k-th row of Phi and multiply with V
        Phi_k = reshape(Phi(k,:),n1,n2);
        M_k = Phi_k*V;
        
        %k-th row of F(V) is vectorization of M_k 
        F(k,:) = M_k(:)';

    end

end


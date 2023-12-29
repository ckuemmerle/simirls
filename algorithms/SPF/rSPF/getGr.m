function [ G ] = getGr( Phi,U )
%   For the operator Phi and fixed U return G(U) with
%           
%       G(U)*V(:) = Phi*[(UV')(:)]

    r = size(U,2);
    n1 = size(U,1);
    n2 = size(Phi,2)/n1;
    d = size(Phi,1);

    G = zeros(d,r*n2);
    
    for k = 1:d
        
        %Matrify the k-th row of Phi and multiply with V
        Phi_k = reshape(Phi(k,:),n1,n2);
        M_k = Phi_k'*U;
        
        %k-th row of F(V) is vectorization of M_k 
        G(k,:) = M_k(:)';

    end

end


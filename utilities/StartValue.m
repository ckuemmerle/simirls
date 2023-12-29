function [ U0,V0 ] = StartValue(y,A,n1,n2,rank)
%Returns the rank leading singular vector pairs of A'*y reshaped into n1xn2
%
%   y       -   Vector of measurements obtained by A*X(:)
%   A       -   Measurement matrix of dimension m x (n1*n2)
%   n1,n2   -   Dimensions of X
%   rank    -   Rank of X

    Xpseudoinvers = reshape(A'*y,[n1,n2]);
        
    [U,S,V] = svd(Xpseudoinvers);

    U0 = U*S;
    U0 = U0(:,1:rank);
    V0 = V(:,1:rank);

end


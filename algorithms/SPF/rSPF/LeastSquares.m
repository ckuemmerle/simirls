function [ X ] = LeastSquares( Phi,y,J,dx1,dx2 )
%   Solve
%           X = argmin | y - Phi*X_(:) |_2
%   where
%           X_ is zero in all rows not in J

    X = zeros(dx1,dx2);

    %Build reduced Phi_J
    Jextended = [];
    for k = 1:dx2
        
        Jextended = [Jextended J+(k-1)*dx1];
        
    end
    Phi_J = Phi(:,Jextended);
    
    %Solve LS with Phi_J
    X_J = Phi_J\y;
    X_J = reshape(X_J,length(J),dx2);
    
    %Expand X_J to X
    X(J,:) = X_J;

end


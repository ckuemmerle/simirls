function [ X ] = B_HTP( Phi,y,s,dx1,dx2,N0 )
%B_HTP Implements Hard Thresholding Pursuit (see Algorithm 5 of [1]).
%
% Reference:
% [1] Kiryung Lee, Yihong Wu, and Yoram Bresler. Near-optimal compressed 
% sensing of a class of sparse low-rank matrices via sparse power 
% factorization. IEEE Transactions on Information Theory, 64(3):1666–1698,
% 2018, https://doi.org/10.1109/TIT.2017.2784479.

    X = zeros(dx1,dx2);
    k = 1;
    while k <= N0
        %Residual
        Xtemp = X + reshape(Phi'*(y-Phi*X(:)),dx1,dx2);
        
        %find indices of the s largest rows in norm of Xtemp
        nX = sqrt(sum(Xtemp.^2,2));
        [~,I] = sort(nX,'descend');
        J = sort(I(1:s));
        if k > 1
            if I == I_old
                k = N0;
            end
        end
%         disp(norm(y-Phi*X(:)))
        %solve LeastSquares on support J
        X = LeastSquares(Phi,y,J,dx1,dx2);
        I_old = I;
        k = k+1;
    end

end


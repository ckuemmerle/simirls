function gam = matrixspace_to_tangspace(X,weight_op)
%matrixspace_to_tangspace Implements operator "P_{T_k}^*" in [1], which
% computes coefficients of extrinsic representation corresponding to the
% projection of (d1 x d2) matrix 'X' onto subspace T_k.
%
% Reference:
% [1] Christian Kuemmerle and Claudio Mayrink Verdun, "A scalable second 
% order method for ill-conditioned matrix completion from few samples", 
% ICML 2021, 2021,
% http://proceedings.mlr.press/v139/kummerle21a/kummerle21a-supp.pdf.
U      = weight_op.U;
[d1,r]=size(U);
if ~isfield(weight_op,'symmetricflag') || ~weight_op.symmetricflag
    V      = weight_op.V;
    d2      =size(V,1);
    gam = zeros(r*(d1+d2+r),1);
else
    V      = U;
    gam = zeros(r*((r+1)/2+d1),1);
end

if iscell(X) % in this case, X represents a factorized matrix such that X_mat = X{1}*X{2}'.
    UtX = (U'*X{1})*X{2}';
    XV = X{1}*(X{2}'*V);
    M1= UtX*V;
else
    if isfield(weight_op,'symmetricflag') && weight_op.symmetricflag
        UtX = U'*X;
        M1= UtX*U;
    else
        UtX = U'*X; 
        XV = X*V;
        M1= UtX*V;
    end
end
if isfield(weight_op,'symmetricflag') && weight_op.symmetricflag
    gam(1:r*(r+1)/2)        = M1(weight_op.symInd);
    gam(r*(r+1)/2+1:end)    = reshape((UtX'-U*M1),[r*d1,1]);
else
    gam(1:r^2)              = reshape(M1,[r^2,1]);
    gam((r^2+1):(r*(r+d1))) = reshape((XV-U*M1),[r*d1,1]);
    gam((r*(r+d1)+1):end)   = reshape((UtX-M1*V'),[r*d2,1]);
end
end
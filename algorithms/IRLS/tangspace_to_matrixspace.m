function X = tangspace_to_matrixspace(gam,weight_op)
%tangspace_to_matrixspace Implements operator "P_{T_k}" in [1], which
% computes a dense matrix of size (d1 x d2) from elements of the tangent
% space T_k (d1 is dimensionality of left singular vectors, d2 is
% dimensionality of right singular vectors of underlying weight operator
% represented by 'weight_op').
%
% Reference:
% [1] Christian Kuemmerle and Claudio Mayrink Verdun, "A scalable second 
% order method for ill-conditioned matrix completion from few samples", 
% ICML 2021, 2021,
% http://proceedings.mlr.press/v139/kummerle21a/kummerle21a-supp.pdf.
U = weight_op.U;
V = weight_op.V;
[~,M1,M3,M2] = get_Tk_matrices(gam,weight_op);
UM3 = U'*M3;
M2V = M2*V;
X = (U*M1-U*M2V)*V'+U*M2;
X = X + (M3-U*UM3)*V';
end


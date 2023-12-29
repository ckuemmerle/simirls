function Umat = compute_Umat_LRRS(Phi,W_1_diag_c,lambda,weight_op,dim_tangent,d1,d2)
%compute_Umat_LRRS Compute an auxiliary matrix for IRLS for simultaneously
% low-rank and row-sparse recovery, used in the implementation of weight
% least squares solution of [1].
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
handle_action = @(gam) Phi*((lambda./weight_op.S_c_eps+W_1_diag_c).^(-1)....
    *reshape(tangspace_to_matrixspace(gam,weight_op),d1*d2,1));
handle_matrixaction = @(Y) cell2mat(cellfun(handle_action,num2cell(Y,1),'UniformOutput',false));
Umat = handle_matrixaction(speye(dim_tangent));
end
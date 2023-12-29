function Vmat = compute_Vmat_LRRS(Phi,W_1_diag_c,lambda,weight_op,d1,d2,fac)
%compute_Vmat_LRRS Compute an auxiliary matrix for IRLS for simultaneously
% low-rank and row-sparse recovery, used in the implementation of weight
% least squares solution of [1].
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
m = size(Phi,1);
Mat = ((fac.*(lambda./weight_op.S_c_eps+W_1_diag_c)).^(-1)).*Phi';
handle_action = @(y) matrixspace_to_tangspace(reshape(Mat*y,d1,d2),weight_op);
handle_matrixaction = @(Y) cell2mat(cellfun(handle_action,num2cell(Y,1),'UniformOutput',false));
Vmat = handle_matrixaction(speye(m));
end
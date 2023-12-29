function [C,Cinv,C_handle,Csecondpart,Cinv_gam_handle,Csecondpart_fast_handle,...
    C_handle_neg] = compute_Cmat_LRRS(Phi,W_1_small_c,W_1_diag_c,lambda,weight_op,weight_vec_c,n1,n2,fac)
%compute_Cmat_LRRS Compute an auxiliary matrix for IRLS for simultaneously
% low-rank and row-sparse recovery, used in the implementation of weight
% least squares solution of [1].
%
% Reference:
% [1] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.
Wvec = ((lambda).*(fac.*weight_vec_c-fac/weight_op.S_c_eps)).^(-1);
Bvec_sm = ((lambda./(weight_op.S_c_eps/fac)+fac.*W_1_small_c)).^(-1);

USigU = weight_op.U'*(Bvec_sm.*weight_op.U);
USigU_inv = inv(USigU);
r = size(weight_op.U,2);

Csecondpart = [];
Cinv_gam_handle  = [];
Csecondpart_fast_handle = @(gam) action_Csecondpart(gam,weight_op,USigU,USigU_inv,Bvec_sm,n1,n2,r);
C_handle = @(gam) Wvec.*gam+Csecondpart_fast_handle(gam);
C_handle_neg = [];
handle_matrixaction = @(Y) cell2mat(cellfun(C_handle,num2cell(Y,1),'UniformOutput',false));
C = handle_matrixaction(eye(length(weight_vec_c)));
Cinv = [];
end

function Csec_gam = action_Csecondpart(gam,weight_op,USigU,USigU_inv,Bvec_sm,d1,d2,r)

[~,Gam_1,Gam_3,Gam_2] = get_Tk_matrices(gam,weight_op);

Gam_2_tilde = USigU*Gam_2;
Tmp = weight_op.U'*Gam_3;
Gam_3_tilde = Bvec_sm.*(weight_op.U*Gam_1+Gam_3)-(Bvec_sm.*weight_op.U)*Tmp;
Gam_1_tilde = USigU*(Gam_1-Tmp)+weight_op.U'*(Bvec_sm.*Gam_3);
Csec_gam = zeros(length(gam),1);
Csec_gam(1:r^2)              = reshape(Gam_1_tilde,[r^2,1]);
Csec_gam((r^2+1):(r*(r+d1))) = reshape(Gam_3_tilde,[r*d1,1]);
Csec_gam((r*(r+d1)+1):end)   = reshape(Gam_2_tilde,[r*d2,1]); 
end
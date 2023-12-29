function [H,dH,Hminc] = weight_op_lowrank_prec(U,V,S,lambda,expo,...
    type_mean,rho,varargin)
%weight_op_lowrank_prec This precalculates some auxiliary matrices that
% are used in the application of the low-rank weight matrix as in defined in
% [1-2] and [3].
%
% References:
% [1] Christian Kuemmerle, "Understanding and Enhancing Data Recovery 
% Algorithms From Noise-Blind Sparse Recovery to Reweighted Methods for 
% Low-Rank Matrix Optimization", Ph.D. dissertation, Technical University 
% of Munich, 2019, https://mediatum.ub.tum.de/doc/1521436/1521436.pdf.
% [2] Christian Kuemmerle and Claudio Mayrink Verdun, "A scalable second 
% order method for ill-conditioned matrix completion from few samples", 
% ICML 2021, 2021,
% http://proceedings.mlr.press/v139/kummerle21a/kummerle21a-supp.pdf.
% [3] Christian Kuemmerle, Johannes Maly, "Recovering Simultaneously 
% Structured Data via Non-Convex Iteratively Reweighted Least Squares",
% NeurIPS 2023, 2023, see also arXiv:2306.04961.

%  Input:      U: (d1xR1) matrix with the R principal left singular vectors
%                 of the iterate X^n (only dimension R1 is used)
%              V: (d2xR2) matrix with the R principal right singular vectors
%                 of the iterate X^n (only dimension R2 is used)
%              S: (1x(R+1)) vector such that S(i) are the values that 
%                 define the Hadamard matrix H
%         lambda: Multiplicative factor in weight operator
%           expo: parameter that determines to which exponent
%                 (lambda.*W + rho.*Id)^(expo) of lambda.*W + rho.*Id
%                 the operator corresponds  
%      type_mean: Character string determining the type of the mean
%                   determining eigenvalues of weight operator
%                   corresponding to "off-diagonals".
%                   operator 
%                 type_mean == 'geometric': Geometric mean, used in [2-3]
%                   (optimal for non-convexity parameter p = 0)
%                 type_mean == 'qmean': q-power mean (optimal for
%                 non-convexity parameter 0 < p <=1), if is chosen as
%                 qmean_para = p/(p-2), cf. input in varargin.
%            rho: Parameter rho that corresponds to the regularization
%                 (lambda.*W+rho.*Id), if W is the weight operator.
%       varargin: Contains qmean_para for type_mean == 'qmean', if
%                 applicable.
% Output:     H = (1x4) cell such that
%                       H{1} corresponds to H_{R,R}
%                       H{2} corresponds to H_{R,R}-H_3
%                       H{3} corresponds to H_{R,R}-H_2
%                       H{4} corresponds to H_{R,R}-H_2-H_3+c*Id
%            dH = (1x2) cell such that
%                       dH{1}(i) = H(R+1,i) for i=1..R+1,
%                       dH{2}(i) = H(R+1,i) - H(R+1,R+1) for i=1..R.
H = cell(1,4);
dH= cell(1,2);
R1 = size(U,2);
R2 = size(V,2);
Slen=length(S);

for k=1:4
    H{k}=zeros(R1,R2);
end
H2_tmp=zeros(R1,R2);
H3_tmp=zeros(R1,R2);

if nargin >= 8
    qmean_para = varargin{1};
end
if nargin == 6
   rho = 0; 
end
if R1 > 0
    switch type_mean
        case 'left-sided'        
            for i=1:R1
                for j=1:R2
                    H{1}(i,j)   = ((lambda/(S(i)))+rho)^(expo);
                    H2_tmp(i,j) = ((lambda/(S(min(Slen,R1+1))))+rho)^(expo);
                    H3_tmp(i,j) = ((lambda/(S(i)))+rho)^(expo);
                end
            end 
        case 'harmonic'
            for i=1:R1
                for j=1:R2
                    H{1}(i,j)   =(2*lambda/(S(i)+S(j))+rho)^(expo);
                    H2_tmp(i,j) =(2*lambda/(S(j)+S(min(Slen,R1+1)))+rho)^(expo);
                    H3_tmp(i,j) =(2*lambda/(S(i)+S(min(Slen,R2+1)))+rho)^(expo);
                end
            end
        case 'qmean'
            for i=1:R1
                for j=1:R2
                    H{1}(i,j)   =(lambda*(2/(S(i)^(-qmean_para)+S(j)^(-qmean_para)))^(1/(-qmean_para))+rho)^(expo);
                    H2_tmp(i,j) =(lambda*(2/(S(j)^(-qmean_para)+S(min(Slen,R1+1))^(-qmean_para)))^(1/(-qmean_para))+rho)^(expo);
                    H3_tmp(i,j) =(lambda*(2/(S(i)^(-qmean_para)+S(min(Slen,R2+1))^(-qmean_para)))^(1/(-qmean_para))+rho)^(expo);
                end
            end
        case 'geometric'
            for i=1:R1
                for j=1:R2
                    H{1}(i,j)   =(lambda/sqrt(S(i)*S(j))+rho)^(expo);
                    H2_tmp(i,j) =(lambda/sqrt(S(j)*S(min(Slen,R1+1)))+rho)^(expo);
                    H3_tmp(i,j) =(lambda/sqrt(S(i)*S(min(Slen,R2+1)))+rho)^(expo);
                end
            end
        case 'arithmetic'
            for i=1:R1
                for j=1:R2
                    H{1}(i,j)   =(lambda*(1/S(i)+1/S(j))/2+rho)^(expo);
                    H2_tmp(i,j) =(lambda*(1/S(min(Slen,R1+1))+1/S(j))/2+rho)^(expo);
                    H3_tmp(i,j) =(lambda*(1/S(i)+1/S(min(Slen,R2+1)))/2+rho)^(expo);
                end
            end
        case 'min'
            for i=1:R1
                for j=1:R2
                    H{1}(i,j)   =(lambda/max(S(i),S(j))+rho)^(expo);
                    H2_tmp(i,j) =(lambda/max(S(j),S(min(Slen,R1+1)))+rho)^(expo);
                    H3_tmp(i,j) =(lambda/max(S(i),S(min(Slen,R2+1)))+rho)^(expo);
                end
            end
    end
end
if R1 > 0 && R1==R2 
    R=R1;
    dH{1}=zeros(R+1,1);
    dH{2}=zeros(R,1);
    dH{1}(1:R)=H3_tmp(1:R,1);
    dH{1}(min(Slen,R+1))=(lambda/S(min(Slen,R+1))+rho)^(expo);
    dH{2}(1:R)=H2_tmp(1,1:R);
    H{2}=H{1}-H3_tmp;
    H{3}=H{1}-H2_tmp;
    H{4}=H{2}-H2_tmp+(lambda/S(min(Slen,R+1))+rho)^(expo).*ones(R,R);
    Hminc=H{1}-(lambda/S(min(Slen,R+1))+rho)^(expo).*ones(R,R);
elseif R1 == 0
    dH{1} = (lambda/S(1)+rho)^(expo);
end
end


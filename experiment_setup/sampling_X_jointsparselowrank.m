function [U,S,V,Rowsparsity_indices] = sampling_X_jointsparselowrank(d1,d2,Kr,r,modeX0,complex,Kc,varargin)
%sampling_X_jointsparselowrank We sample a K-row sparse matrix X that
% has a additionally rank r. The entries are determined by i.i.d. normally
% distributed entries. It holds that X = U*S*V', if U,S,V are the output
% matrices. 
%       Input:  d1       = first dimension of X
%               d2       = second dimension of X
%               Kr      = row sparsity
%               r       = rank
%               modeX0: Chooses distribution of singular values (see below).
%               Kc      = column sparsity
%               complex = 1 for complex matrix and 0 for real matrix.
%       Output: U: Left singular vector matrix of X
%               S: Diagonal matrix with singular values of X
%               V: Right singular vector matrix of X
%               Rowsparsity_indices: Contains index set of row support of X

%%% Here, we sample a (d x d)- matrix A such that there are l0norm entries
%%% which are different from 0 in each row, which are independently
%%% N(0,1)-distributed.
U = zeros(d1,r);
V = zeros(d2,r);
Z = zeros(1,r);
I = randperm(d1);
Rowsparsity_indices = I(1:Kr);
% if nargin == 8
Colsparsity_indices = randperm(d2,Kc);
% end
if ischar(modeX0)
    cond_nr = varargin{1}; % contains the target condition number
    Usupp = randn(Kr,r);
    [Usupp,~,~]=svd(Usupp,'econ');
    U(Rowsparsity_indices,:) = Usupp;
    Vsupp = randn(Kc,r);
    [Vsupp,~,~]=svd(Vsupp,'econ');
    V(Colsparsity_indices,:) = Vsupp;
    if strcmp(modeX0,'condition_control_1/x2')
        fct = @(l) (cond_nr - (1-cond_nr/r^2)/(1-1/r^2))./[1:l].^2 + (1-cond_nr/r^2)/(1-1/r^2);
    elseif strcmp(modeX0,'condition_control_linear')
        fct = @(l) ((cond_nr*r-1)/(r-1))+((1-cond_nr)/(r-1)).*[1:l];
    elseif strcmp(modeX0,'condition_control_log')
        fct = @(l) cond_nr.*exp(-log(cond_nr).*([1:l]-1)./(r-1));
    elseif strcmp(modeX0,'condition_control_log_plateau')
        fct = @(l) cond_nr.*[(exp(-log(cond_nr).*(((3/2).*[1:l/3])-1)./(r-1))),...
            (exp(-log(cond_nr).*((r/2).*ones(1,2*r/3-r/3-1)-1)./(r-1))),...
            (exp(-log(cond_nr).*([r/2:3/2:l]-1)./(r-1)))];
    elseif strcmp(modeX0,'condition_control_log_plateau_end')
        fct = @(l) cond_nr.*[(exp(-log(cond_nr).*(((3/2).*[1:floor(2*l/3)])-1)./(r-1))),...
            (exp(-log(cond_nr).*(floor(r.*ones(1,r/3))-1)./(r-1)))];
    end
    Z = fct(r);
    S = diag(Z);
else
    for j=1:r
        if complex == 1
            U(Rowsparsity_indices,j) = randn(Kr,1)+1i.*randn(Kr,1);
        else
            U(Rowsparsity_indices,j) = randn(Kr,1);
        end
        if complex == 1
            V(Colsparsity_indices,j)     = randn(Kc,1)+1i*randn(Kc,1);
        else
            V(Colsparsity_indices,j)     = randn(Kc,1);
        end
        if modeX0 == 1
            if complex == 1
                Z(j)                     = randn(1,1) + 1i.*randn(1,1);
            else
                Z(j)                     = randn(1,1);
            end
        elseif modeX0 == 2
            Z(j)                     = 1;
        elseif modeX0 == 3

        end
    end
    S = diag(Z);
end
end



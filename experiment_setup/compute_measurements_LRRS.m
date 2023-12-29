function [meas,degs] = compute_measurements_LRRS(Example,ranks,...
    ms_vec,rho_min,rho_max,varargin)
% Given the problem parameters contained in the structure array 'Example'
% (number of rows, columns, and row sparsity), this function computes the
% resulting degrees of freedom of a simultaneously low-rank rand row-sparse
% matrix (entries of 'degs') if its rank is provided by different values as
% contained in 'ranks'. 
% Furthermore, the function calculates which measurement numbers provided
% in 'ms_vec' are compatible with recovering a matrix with degree of
% freedoms as in 'degs', and returns a cell array 'meas' containing these
% numbers in its cells. 'rho_min' and 'rho_max' serve as lower and upper
% oversampling factors that are admissible.
degs = zeros(1,length(ranks));
for ii = 1:length(ranks)
    r = ranks(ii);
    [~,~,df_combined,~,~,~,~,~,~] = degfreedom(Example.prob.n1,Example.prob.n2, ...
    Example.prob.K1,Example.prob.n2,r);
    degs(ii) = df_combined;
end
if isempty(ms_vec)
    meas=cell(1,length(ranks));
else
    if nargin > 5
        min_max_meas = varargin{1};
    else
        min_max_meas = 0;
    end
    meas=cell(1,length(ranks));
    for ii=1:length(ranks)
        ind_upper = max((ms_vec< rho_max*degs(ii)),(ms_vec <= min_max_meas));
        ind_lower = ms_vec>rho_min*degs(ii);
        ind = find(min(ind_lower,ind_upper));
        meas{ii} = ms_vec(ind);
    end
end
end
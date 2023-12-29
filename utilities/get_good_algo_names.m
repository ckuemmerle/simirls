function alg_name_out = get_good_algo_names(alg_name)
%get_good_algo_names This function defines appropriately spelled-out
%algorithmic names based on input strings.
alg_name_out = cell(1,length(alg_name));
for i=1:length(alg_name_out)
    if strcmp(alg_name{i},'IRLS-LRRS')
        alg_name_out{i} = 'IRLS-LowRankRowSparse';
    elseif strcmp(alg_name{i},'RiemannianIHT_adap')
        alg_name_out{i} = 'Riemannian Adaptive IHT';
    elseif strcmp(alg_name{i},'SparsePowerFactorization')
        alg_name_out{i} = 'Sparse Power Factorization';
    end
end
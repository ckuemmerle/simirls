function errors = ...
    error_general_LRJS(X0,opts,outs,alg_name,varargin)
%error_general_LRJS Calculates the relevant errors for the output of
%algorithms for recovery of simultaneously low-rank & row-sparse matrices
%% Report errors
nr_algos=length(alg_name);
errors = struct;
errors.fro          = cell(1,nr_algos);
errors.fro_rel      = cell(1,nr_algos);
for l=1:nr_algos
    if isfield(outs{l},'X') && iscell(outs{l}.X)
        N = length(outs{l}.X);
    else
        N = 1;
    end
    for k=1:N
        if isfield(outs{l},'X') && iscell(outs{l}.X)
            X_c = outs{l}.X{k};
        else
            X_c = outs{l}.X;
        end
        errors.fro{l}(k)=norm(X_c-X0,'fro');
        errors.fro_rel{l}(k)=errors.fro{l}(k)./norm(X0,'fro');
    end
    display(alg_name{l});
    if (iscell(opts) && isfield(opts{l},'verbose') && opts{l}.verbose) || (isfield(opts,'verbose') && opts.verbose)
        disp(['Frobenius norm error to X0:      ',num2str(errors.fro{l}(end))]);
        disp(['Relative Frob. error to X0:      ',num2str(errors.fro_rel{l}(end))]);
    end
end
end
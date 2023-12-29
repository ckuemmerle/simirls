function median_err = get_median_errors(err)
%get_median_errors Computes median of values in 'err'.
[nr_algos,parameter_nrs,~]=size(err);
median_err=zeros(nr_algos,parameter_nrs);
for k=1:nr_algos
    for j=1:parameter_nrs
        tmp =err(k,j);
	if iscell(tmp)
            median_err(k,j)=median(tmp{1}(:));
	else
	    median_err(k,j)=median(tmp);
    end
    end
end
end


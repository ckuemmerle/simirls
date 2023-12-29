function [prob,samplemodel,optsfct,opts,alg_name] = unzipExample(Example)
% Returns several key fields of structure array 'Example' describing the
% experimental/ algorithmic setup.
prob     = Example.prob;
samplemodel = Example.samplemodel;
optsfct  = Example.optsfct;
opts     = Example.opts;
alg_name = Example.alg_name;
end


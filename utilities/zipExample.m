function Example = zipExample(descr,prob,samplemodel,optsfct,opts,alg_name)
% Consolidates several key experimental/algorithmic parameters into
% structure array 'Example'.
Example         = struct;
Example.descr   = descr;
Example.prob    = prob;
Example.samplemodel = samplemodel;
Example.optsfct = optsfct;
Example.opts    = opts;
Example.alg_name = alg_name;
end


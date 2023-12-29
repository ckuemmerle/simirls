function ExampleIdx = SelectExample(Params,Examples) % formerly: SelectExample_GC
% This function loads example problem data for the reconstruction problem
% described within input 'Params' by checking against all possible examples
% given in 'Examples'. If no corresponding example description is provided 
% in 'Params', the user will be asked for keyboard input.
while true
  if ~isfield(Params,'ExampleName')
    fprintf('\n Examples:\n');
    for k = 1:length(Examples)
      fprintf('\n [%2d] %s',k,Examples{k}.descr);
    end
    fprintf('\n\n');    
    ExampleIdx = input('Pick an example to run:           ');
    try
      fprintf('\nRunning %s\n',Examples{ExampleIdx}.descr);
      break;
    catch
    end
  else
    ExampleIdx  = find(cellfun(@(x) strcmp(x.descr, Params.ExampleName), Examples));
    if isempty(ExampleIdx)
      error('SOD_Utils:SelectExample:exception', 'ExampleName in Params has no matching entry in all the pre-set examples!!');
    else
      fprintf('\nRunning %s\n', Examples{ExampleIdx}.descr);
      break;
    end
  end
end

return
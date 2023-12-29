% This script can be used to solve a low-rank and row-sparse recovery
% problem chosen among the problem setups contained in the folder
% 'Examples'. To run this script correctly, navigate to the main folder
% which contains 'Examples' as a subfolder (without entring 'Examples').
% Results are subsequently saved in subfolder 'experiments'.
%% Load example
Examples   = LoadExampleDefinitions;
ExampleIdx = SelectExample([],Examples);
Example    = Examples{ExampleIdx};
fprintf("Problem description: \n")
disp(Example.descr)
fprintf("\nExample.samplemodel: \n")
disp(Example.samplemodel)
fprintf("Example.prob: \n")
disp(Example.prob)
fprintf("Algorithms to be used: \n")
disp(Example.alg_name)
%% Run experiment
[yr,outs] = run_methods_LRRS(Example);
s1=convertCharsToStrings(Example.descr);
s3=convertCharsToStrings('.mat');
save(strcat('experiments/',strcat(s1,s3)),'Example','outs','yr');
%% Read result of the proposed algorithm for low-power feedforward NN
clc;    clear;

numBENCHMARK    = 4;
BENCHMARK_set   = {'LETTER', 'SPAM'};

for BENCHMARK_idx = 1:numel(BENCHMARK_set)
    filename    = strcat(BENCHMARK_set{BENCHMARK_idx},'_neuron.mat');
    temp        = load(filename, 'RESULT');
    RESULT      = temp.RESULT;
    
    BENCHMARK_set{BENCHMARK_idx}
    for idx = 1:length(RESULT)
        RESULT{idx}
        OUTPUT{BENCHMARK_idx}.history{idx} = RESULT{idx};
    end
end
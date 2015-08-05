function [ output ] = onehotEncode(labels)
%% This code provides desired output with one-hot encoding


output = zeros(10, length(labels));

for i = 1:length(labels)
    output(labels(i)+1, i) = 1;
end

end

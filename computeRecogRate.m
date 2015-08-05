function [ Q_lowP ] = computeRecogRate(predict, labels)
% Quality (recognition rate) computation w/ given approximation

range  = [1:50000];
Labels_one = labels(range);

[M I]		= max(predict);
pred 		= (I' - 1);
Q_lowP 	= mean(Labels_one(:) == pred(:));

end


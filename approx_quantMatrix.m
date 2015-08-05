function [ quantizedMat ] = approx_quantMatrix (inMat, prec_mat, approx_mat, prec)
% This code 
% 1. quantizes theta (weights) of MLP
% 2. insert error modeled by approximate multiplier for given precision

global recovery;



% TODO

%1. First Quantization
quantizedMat = zeros(size(inMat));
quantizedMat = quantizedMat + prec_mat.* float2fix(inMat, prec);



%2.  Add approximation error
[r, c] = size(inMat);
num_err= r*c;

% Bring error vector for given precision controlled 
[err_vec_with_prec] = err_vec_gen(num_err, recovery, prec(1));
err_mat_with_prec = reshape(err_vec_with_prec, size(inMat)).*approx_mat;

quantizedMat = quantizedMat + prec_mat .* err_mat_with_prec;
%prec    = [16 8; 16 8];         % precision for operand and weight


end


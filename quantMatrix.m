function [ quantizedMat ] = quantMatrix(inMat, prec_mat, prec)
% This code quantizes (approximates) theta (weights) of MLP


quantizedMat = prec_mat .* float2fix(inMat, prec);



end


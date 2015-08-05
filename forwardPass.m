function [cost,grad,hypothesis] = forwardPass(theta, inputSize, hiddenSize, outputSize, data, label)
                                   
                                              
% The input theta is a vector (because minFunc expects the parameters to be a vector). 
% We first convert theta to the (W1, W2, b1, b2) matrix/vector format, so that this 
% follows the notation convention of the lecture notes. 

% ex) theta: 3289 by 1 double vector (theta = [W1(:) ; W2(:) ; b1(:) ; b2(:)] : 1600 1600 25 64 )

% W1 : Weight matrix between input layer (64) - hidden layer (25)
global mat_size;	global N_layer;
range = cell(1,N_layer);

range{1}.w = [1 : inputSize*hiddenSize(1)];
range{2}.w = [length(range{1}.w)+1 : length(range{1}.w)+hiddenSize(1)*hiddenSize(2)];
range{3}.w = [length(range{1}.w)+length(range{2}.w)+1 : length(range{1}.w)+length(range{2}.w)+hiddenSize(2)*outputSize];

tmp_range = length(range{1}.w) + length(range{2}.w) + length(range{3}.w);
range{1}.b = [tmp_range+1 : tmp_range+hiddenSize(1)];
range{2}.b = [tmp_range+length(range{1}.b)+1 : tmp_range+length(range{1}.b)+hiddenSize(2)];
range{3}.b = [tmp_range+length(range{1}.b)+length(range{2}.b)+1 : tmp_range+length(range{1}.b)+length(range{2}.b)+outputSize]; 

% Cost and gradient variables (your code needs to compute these values). 
% Here, we initialize them to zeros.
% stacked vector to matrix conversion
cost = 0;
synapse = cell(1,N_layer);
for i = 1:N_layer
	synapse{i}.w = reshape(theta(range{i}.w), mat_size(i,1), mat_size(i,2));
	synapse{i}.b = theta(range{i}.b);

	synapse{i}.wgrad = zeros(size(synapse{i}.w));
	synapse{i}.bgrad = zeros(size(synapse{i}.b));
end


%  Instructions: Compute the cost/optimization objective J_sparse(W,b) for the Sparse Autoencoder,
%                and the corresponding gradients W1grad, W2grad, b1grad, b2grad.
%
% W1grad, W2grad, b1grad and b2grad should be computed using backpropagation.
% Note that W1grad has the same dimensions as W1, b1grad has the same dimensions as b1, etc.  
% Your code should set W1grad to be the partial derivative of J_sparse(W,b) with respect to W1. 
% I.e., W1grad(i,j) should be the partial derivative of J_sparse(W,b) with respect to the input parameter W1(i,j).
% Thus, W1grad should be equal to the term [(1/m) \Delta W^{(1)} + \lambda W^{(1)}] in the last block of pseudo-code in Section 2.2 
% of the lecture notes (and similarly for W2grad, b1grad, b2grad).
% 
% Stated differently, if we were using batch gradient descent to optimize the parameters,
% the gradient descent update to W1 would be W1 := W1 - alpha * W1grad, and similarly for W2, b1, b2. 

num_training   = size(data, 2);

%% Feedforward pass
x   = data;     y   = label;
a1 	= x;
z2  = synapse{1}.w * a1 + repmat(synapse{1}.b,1,num_training);      a2 = sigmoid(z2);	% input layer to 1st hidden layer
z3  = synapse{2}.w * a2 + repmat(synapse{2}.b,1,num_training);      a3 = sigmoid(z3);	% 1st hidden layer to 2nd hidden layer
z4  = synapse{3}.w * a3 + repmat(synapse{3}.b,1,num_training);      a4 = sigmoid(z4);	% 2nd hidden layer to output layer
hypothesis = a4;


%% Backpropagation: gradient computation
delta_4 = (a4 - y) .* deriv_sigmoid(z4);
J_W3_grad  = delta_4 * a3';
J_b3_grad  = delta_4;

delta_3 = (synapse{3}.w' * delta_4) .* deriv_sigmoid(z3);
J_W2_grad  = delta_3 * a2';
J_b2_grad  = delta_3;

delta_2 = (synapse{2}.w' * delta_3) .* deriv_sigmoid(z2);
J_W1_grad  = delta_2 * a1';
J_b1_grad  = delta_2;


% average over batch training set
synapse{1}.wgrad = (J_W1_grad)/num_training;      synapse{2}.wgrad = (J_W2_grad)/num_training;		synapse{3}.wgrad = (J_W3_grad)/num_training;
synapse{1}.bgrad = mean(J_b1_grad')';             synapse{2}.bgrad = mean(J_b2_grad')';				synapse{3}.bgrad = mean(J_b3_grad')';


%% Cost function (sum of squared error)
cost = mean(0.5 * sum((y - hypothesis) .^ 2)); 


%-------------------------------------------------------------------
% After computing the cost and gradient, we will convert the gradients back
% to a vector format (suitable for minFunc).  Specifically, we will unroll
% your gradient matrices into a vector.

grad = [synapse{1}.wgrad(:) ; synapse{2}.wgrad(:) ; synapse{3}.wgrad(:) ; ...
		synapse{1}.bgrad(:) ; synapse{2}.bgrad(:) ; synapse{3}.bgrad(:)];

end

%-------------------------------------------------------------------
% Here's an implementation of the sigmoid function, which you may find useful
% in your computation of the costs and the gradients.  This inputs a (row or
% column) vector (say (z1, z2, z3)) and returns (f(z1), f(z2), f(z3)). 

function sigm = sigmoid(x)

    sigm = 1 ./ (1 + exp(-x));
    
end

function deriv_sigm = deriv_sigmoid(x)

    deriv_sigm = sigmoid(x) .* (1-sigmoid(x));
    
end

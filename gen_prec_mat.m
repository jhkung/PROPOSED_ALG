function [ prec_mat ] = gen_prec_mat(prec_rate, IDX)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global network_arch;    global N_layer;     global APPRX_TYPE;
w_length    = network_arch.w_length;
inputSize   = network_arch.inputSize;
hiddenSize  = network_arch.hiddenSize;
outputSize  = network_arch.outputSize;

if sum(round(prec_rate*10)) ~= 10
    error('sum of prec_rate should be 1 !!');
end

% prec_rate = [rPrec of 32bit, rPrec of 16bit, rPrec of 8bit] 
num_prec_modes = length(prec_rate);
prev_rPrec = 0;

for prec_mode_index= num_prec_modes:-1:1 % start from low bit (rPrec of 8bit)
    rPrec = prec_rate(prec_mode_index);

    if (APPRX_TYPE == 1)
        stackedPrecMat = zeros(w_length,1);
        id_from = round(w_length*prev_rPrec)+1;
        id_to   = round(w_length*prev_rPrec)+round(w_length*rPrec);
        range = [id_from : id_to];
        length(range)/w_length;
        mask_IDX = IDX(range);
        stackedPrecMat(mask_IDX') = 1;
        rate = length(find(mask_IDX)==1)/w_length;
        Prec_mat_temp = unstackMat(stackedPrecMat);
    else
        stackedPrecMat      = zeros(w_length,1);
        Prec_mat_temp       = unstackMat(stackedPrecMat);
                
        numPrevNeurons      = [inputSize];
        for h_idx = 1:numel(hiddenSize)
            numPrevNeurons(h_idx+1)  = numPrevNeurons(h_idx) + hiddenSize(h_idx);
        end
        
        id_from = round(numPrevNeurons(end)*prev_rPrec)+1;
        id_to   = round(numPrevNeurons(end)*prev_rPrec)+round(numPrevNeurons(end)*rPrec);
        
        for i = id_from:id_to
            offset  = 0;
            if (IDX{i}(2) > 1)
                offset  = numPrevNeurons(IDX{i}(2)-1);
            end
            
            Prec_mat_temp{IDX{i}(2)}(:,IDX{i}(1)-offset) = 1;
        end
    end
    
    for layer_index=1:N_layer
        prec_mat{layer_index}.prec_mode{prec_mode_index} = Prec_mat_temp{layer_index}; %prec_mat{precision_mode_index}.prec_mode{number_of_layers}
        layer_index;
        size(Prec_mat_temp{layer_index});
    end
    
    prev_rPrec = prev_rPrec + rPrec;
end


% (length(find(prec_mat{1}.prec_mode{1}==1)) + length(find(prec_mat{2}.prec_mode{1}==1)) + length(find(prec_mat{3}.prec_mode{1}==1)))/w_length;
% (length(find(prec_mat{1}.prec_mode{2}==1)) + length(find(prec_mat{2}.prec_mode{2}==1)) + length(find(prec_mat{3}.prec_mode{2}==1)))/w_length;
% (length(find(prec_mat{1}.prec_mode{3}==1)) + length(find(prec_mat{2}.prec_mode{3}==1)) + length(find(prec_mat{3}.prec_mode{3}==1)))/w_length;



end


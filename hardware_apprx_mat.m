function [ apprx_mat, sortedGrad, IDX ] = hardware_apprx_mat(w_length, grad)
% outputs approximate matrix for hardware

global rApprox;
global APPRX_TYPE;
global network_arch;

inputSize   = network_arch.inputSize;
hiddenSize  = network_arch.hiddenSize;

if (APPRX_TYPE == 1)
    stackedApproxMat    = zeros(w_length,1);
    [sortedGrad, IDX]   = sort(abs(grad(1:w_length)));      % IDX represents index of each synapse
    mask_IDX            = IDX(1:round(w_length*rApprox));
    stackedApproxMat(mask_IDX') = 1;
    apprx_mat           = unstackMat(stackedApproxMat);
else
    temp_mat            = unstackMat(grad);    
    apprx_mat           = cell(1,numel(temp_mat));
    mean_arr            = [];
    for idx = 1:numel(temp_mat)
        apprx_mat{idx}  = zeros(size(temp_mat{idx}));
        mean_arr        = [mean_arr, abs(mean(temp_mat{idx}))];
    end
    
    [sortedGrad, tmp_IDX]   = sort(mean_arr);       % tmp_IDX represents index of each neuron
    
    numPrevNeurons      = [inputSize];
    for h_idx = 1:numel(hiddenSize)
        numPrevNeurons(h_idx+1)  = numPrevNeurons(h_idx) + hiddenSize(h_idx);
    end
    
    IDX     = {};    % IDX represents (index of each neuron, index of corresponding layer)
    for i = 1:numel(tmp_IDX)
        list        = find(numPrevNeurons >= tmp_IDX(i));
        layer_i     = list(1);
        IDX{i}      = [tmp_IDX(i), layer_i];
    end
    
    numApprxNeuron  = round(numPrevNeurons(end)*rApprox);
    for i = 1:numApprxNeuron
        offset  = 0;
        if (IDX{i}(2) > 1)
            offset  = numPrevNeurons(IDX{i}(2)-1);
        end
        
        apprx_mat{IDX{i}(2)}(:,IDX{i}(1)-offset) = 1;      % set certain neurons to be approximate
    end
end
    
    
end


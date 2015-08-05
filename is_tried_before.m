function [ output ] = is_tried_before(hist_arr, cur_prec)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes he
output = 0;
for id_prec = 1:length(hist_arr(:,1))
    if(hist_arr(id_prec,:)==cur_prec)
        output = 1;
    end
end

end


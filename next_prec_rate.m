function [ new_prec_rate_1 , new_prec_rate_2] = next_prec_rate( cur_prec_rate, beta )
% generate two different bit precision options

for index = length(cur_prec_rate):-1:1
    if round(cur_prec_rate(index)*10) > 0
        break
    end
end


new_prec_rate_1 = cur_prec_rate;
new_prec_rate_2 = cur_prec_rate;

if index > 2
    new_prec_rate_1(index)      = new_prec_rate_1(index) - beta;
    new_prec_rate_1(index-1)    = new_prec_rate_1(index-1) + beta;
    
    new_prec_rate_2(index)      = new_prec_rate_2(index) - beta;
    new_prec_rate_2(index-2)    = new_prec_rate_2(index-2) + beta;
elseif index > 1
    new_prec_rate_1(index)      = new_prec_rate_1(index) - beta;
    new_prec_rate_1(index-1)    = new_prec_rate_1(index-1) + beta;
    
    if (new_prec_rate_2(index) >= 2*beta)
        new_prec_rate_2(index)      = new_prec_rate_2(index) - 2*beta;
        new_prec_rate_2(index-1)    = new_prec_rate_2(index-1) + 2*beta;
    end
end


end


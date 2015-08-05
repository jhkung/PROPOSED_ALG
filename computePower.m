function [ Pcurr ] = computePower(prec_rate)
% This code computes the overall power consumption of MLP MAC units


global hw_info;
global rApprox;

apprx_pow_arr  = hw_info{1}.apprx_pow_arr;
acc_pow_arr    = hw_info{1}.acc_pow_arr;


Pcurr   = 0;
sum     = 0;

prec_rate
for i = length(prec_rate):-1:1
    if (sum + prec_rate(i) > rApprox)
        if sum < rApprox
            Pcurr = Pcurr + (rApprox-sum) * apprx_pow_arr(i);
            Pcurr = Pcurr + (prec_rate(i)-(rApprox-sum)) * acc_pow_arr(i);
        else
            Pcurr = Pcurr + prec_rate(i) * acc_pow_arr(i);
        end
    else
        Pcurr = Pcurr + prec_rate(i) * apprx_pow_arr(i);
    end
    sum = sum + prec_rate(i);
end



end


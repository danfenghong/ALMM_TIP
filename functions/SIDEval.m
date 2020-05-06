function SID = SIDEval(A_est, A_real)

%% measure SID for endmembers
% A_est : p * n (p is spectral band and n is the number of endmembers)

[m, n] = size(A_est);    
SID  =zeros(1, n);
for i = 1 : n
    a = A_est(:, i)/sum(A_est(:, i));
    b = A_real(:, i)/sum(A_real(:, i));
    SID(1, i) =hyperSid(a, b);
end
SID = mean(SID);
end
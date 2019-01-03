Q = 10;
alpha = 0.5;
b = 2;
var = 1;
n = 1000;


%%
Mdl = arima('AR',{-alpha},'Constant',0,'Variance',var*(b^2));
s = simulate(Mdl,n);

ToEstMdl = arima(Q,0,0);
EstMdl = estimate(ToEstMdl,s);
s_hat = simulate(EstMdl,n);

%%
t = 0.5;
count = 0;
for i = 1:1000
    if s(i) <= t
        count = count + 1;
    end
end
Fs_hat = count/1000;

%%
p_hat = zeros(n,1);
for i = 1:n
    p_hat(i) = sum((s_hat(1:i)-s(1:i)).^2)/i;
end

%%
R_s = zeros(21,1);
for i = 0:20
    R_s(i+1) = Get_R(i);
end

scatter(0:20, R_s, 100, 'filled');
title('R[m], m=0:20','FontSize', 24);
xlabel('m', 'FontSize', 24);
ylabel('R[m]', 'FontSize', 24);

function y = Get_R(n)
    A = [1 0.5; 0.5 1];
    b = [4 0];
    R_01 = A\b';
    if n<1
        if n == 0
            y = R_01(1);
        elseif n == 1
            y = R_01(2);
        end
    else
        y = -0.5*Get_R(n-1);
    end
end

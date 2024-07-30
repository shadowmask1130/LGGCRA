
%%
clear
clc
close all
addpath(genpath(pwd));
number = 5; % 选定优化函数，自行替换: F1，F3~F30，F2函数已被删除
% variables_no = 30; % 可选 2, 10, 30, 50, 100
[lower_bound, upper_bound, variables_no, fobj] = Get_Functions_cec2005(number);   % [lb,ub,D,y]：下界、上界、维度、目标函数表达式
pop_size = 30;                      % population members 
max_iter = 1000;                  % maximum number of iteration

%% GCRA
try
    [GCRA_Best_score, ~, GCRA_curve] = GCRA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj);
    display(['The best optimal value of the objective function found by GCRA for ' [num2str(number)],'  is : ', num2str(GCRA_Best_score)]);
    if isempty(GCRA_curve)
        disp('GCRA_curve is empty.');
    else
        disp(['Length of GCRA_curve: ', num2str(length(GCRA_curve))]);
    end
catch ME
    disp('Error in GCRA:');
    disp(ME.message);
    GCRA_curve = []; % Ensure GCRA_curve is defined even if GCRA fails
end

%% LGGCRA
try
    [LGGCRA_Best_score, ~, LGGCRA_curve] = LGGCRA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj);
    display(['The best optimal value of the objective function found by LGGCRA for ' [num2str(number)],'  is : ', num2str(LGGCRA_Best_score)]);
    if isempty(LGGCRA_curve)
        disp('LGGCRA_curve is empty.');
    else
        disp(['Length of LGGCRA_curve: ', num2str(length(LGGCRA_curve))]);
    end
catch ME
    disp('Error in LGGCRA:');
    disp(ME.message);
    LGGCRA_curve = []; % Ensure LGGCRA_curve is defined even if LGGCRA fails
end

%% Figure
figure
CNT = 40;
k = round(linspace(1, max_iter, CNT)); % 随机选CNT个点
% 注意：如果收敛曲线画出来的点很少，随机点很稀疏，说明点取少了，这时应增加取点的数量，100、200、300等，逐渐增加
% 相反，如果收敛曲线上的随机点非常密集，说明点取多了，此时要减少取点数量
iter = 1:1:max_iter;

if ~isempty(GCRA_curve)
    semilogy(iter(k), GCRA_curve(k), 'r-v', 'linewidth', 1);
    hold on
else
    disp('GCRA_curve is empty, skipping plot.');
end

if ~isempty(LGGCRA_curve)
    semilogy(iter(k), LGGCRA_curve(k), 'g-o', 'linewidth', 1);
    hold on
else
    disp('LGGCRA_curve is empty, skipping plot.');
end

grid on;
title('convergence curve')
xlabel('iterations count');
ylabel('fitness');
box on
legend('GCRA', 'LGGCRA')
set(gcf, 'position', [300 300 800 330])

rmpath(genpath(pwd))

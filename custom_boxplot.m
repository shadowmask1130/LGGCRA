% 清除工作空间和命令行窗口
clear;
clc;

% 算法参数
numRuns = 2; % 运行次数减少
Search_Agents = 5; % 搜索代理数量减少
Max_iterations = 50; % 迭代次数减少

% 需要运行的函数索引
functionsToRun = 15:23;

% 算法结果存储
resultsLGGCRA = zeros(numRuns, length(functionsToRun));
resultsGCRA = zeros(numRuns, length(functionsToRun));

% 多次运行算法
for idx = 1:length(functionsToRun)
    functionIndex = functionsToRun(idx);
    % 获取函数句柄和边界
    [fobj, lb, ub, dim] = CEC2005(functionIndex); 

    for run = 1:numRuns
        % LGGCRA算法运行
        [ScoreLGGCRA, ~, ~] = LGGCRA(Search_Agents, Max_iterations, lb, ub, dim, fobj);
        resultsLGGCRA(run, idx) = ScoreLGGCRA;

        % GCRA算法运行
        [ScoreGCRA, ~, ~] = GCRA(Search_Agents, Max_iterations, lb, ub, dim, fobj);
        resultsGCRA(run, idx) = ScoreGCRA;
    end
end

% 绘制箱线图并保存为jpg格式
for idx = 1:length(functionsToRun)
    figure;
    boxplot([resultsLGGCRA(:, idx), resultsGCRA(:, idx)], 'Labels', {'LGGCRA', 'GCRA'});
    title(['Performance Comparison on CEC2005 Function F' num2str(functionsToRun(idx))]);
    xlabel('Algorithms');
    ylabel('Objective Function Value');
    saveas(gcf, ['performance_comparison_F' num2str(functionsToRun(idx)) '.jpg']);
end
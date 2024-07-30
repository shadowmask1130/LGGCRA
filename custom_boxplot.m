% Clear workspace and command window
clear;
clc;

% Algorithm parameters
numRuns = 2; % Reduced number of runs
Search_Agents = 5; % Reduced number of search agents
Max_iterations = 50; % Reduced number of iterations

% Indices of functions to run
functionsToRun = 15:23;

% Storage for algorithm results
resultsLGGCRA = zeros(numRuns, length(functionsToRun));
resultsGCRA = zeros(numRuns, length(functionsToRun));

% Run the algorithms multiple times
for idx = 1:length(functionsToRun)
    functionIndex = functionsToRun(idx);
    % Get function handle and bounds
    [fobj, lb, ub, dim] = CEC2005(functionIndex); 

    for run = 1:numRuns
        % Run the LGGCRA algorithm
        [ScoreLGGCRA, ~, ~] = LGGCRA(Search_Agents, Max_iterations, lb, ub, dim, fobj);
        resultsLGGCRA(run, idx) = ScoreLGGCRA;

        % Run the GCRA algorithm
        [ScoreGCRA, ~, ~] = GCRA(Search_Agents, Max_iterations, lb, ub, dim, fobj);
        resultsGCRA(run, idx) = ScoreGCRA;
    end
end

% Plot boxplots and save as jpg
for idx = 1:length(functionsToRun)
    figure;
    boxplot([resultsLGGCRA(:, idx), resultsGCRA(:, idx)], 'Labels', {'LGGCRA', 'GCRA'});
    title(['Performance Comparison on CEC2005 Function F' num2str(functionsToRun(idx))]);
    xlabel('Algorithms');
    ylabel('Objective Function Value');
    saveas(gcf, ['performance_comparison_F' num2str(functionsToRun(idx)) '.jpg']);
end

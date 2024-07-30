% Main script to run LGGCRA on CEC2005 benchmark functions
% and compute Best, Worst, Mean, and Std values

% Add paths if necessary
% addpath('path_to_LGGCRA_algorithm');
% addpath('path_to_CEC2005_functions');

% List of CEC2005 functions
functions = {'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', ...
             'F11', 'F12', 'F13', 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', ...
             'F20', 'F21', 'F22', 'F23'};

% Parameters
Search_Agents = 30;
Max_iterations = 500;
num_runs = 30;

% Result storage
results = struct();

% Prepare cell array for Excel
results_table = cell(length(functions) + 1, 5);
results_table(1, :) = {'Function', 'Best', 'Worst', 'Mean', 'Std'};

for func_idx = 1:length(functions)
    func_name = functions{func_idx};
    [lowerbound, upperbound, dimension, objective] = fun_info(func_name);
    
    best_values = zeros(1, num_runs);
    
    for run = 1:num_runs
        [Score, ~, ~] = LGGCRA(Search_Agents, Max_iterations, lowerbound, upperbound, dimension, objective);
        best_values(run) = Score;
    end
    
    % Compute Best, Worst, Mean, Std
    best = min(best_values);
    worst = max(best_values);
    mean_val = mean(best_values);
    std_val = std(best_values);
    
    % Store results
    results.(func_name).Best = best;
    results.(func_name).Worst = worst;
    results.(func_name).Mean = mean_val;
    results.(func_name).Std = std_val;
    
    % Store results in table
    results_table{func_idx + 1, 1} = func_name;
    results_table{func_idx + 1, 2} = sprintf('%.2E', best);
    results_table{func_idx + 1, 3} = sprintf('%.2E', worst);
    results_table{func_idx + 1, 4} = sprintf('%.2E', mean_val);
    results_table{func_idx + 1, 5} = sprintf('%.2E', std_val);
    
    % Display results
    fprintf('Function: %s\n', func_name);
    fprintf('Best: %.2E\n', best);
    fprintf('Worst: %.2E\n', worst);
    fprintf('Mean: %.2E\n', mean_val);
    fprintf('Std: %.2E\n\n', std_val);
end

% Convert cell array to table
results_table = cell2table(results_table(2:end, :), 'VariableNames', results_table(1, :));

% Save results to a .mat file
save('LGGCRA_CEC2005_results.mat', 'results');

% Write results to Excel file with scientific notation format
filename = 'LGGCRA_CEC2005_results.xlsx';
writetable(results_table, filename);

% Adjust Excel file to use scientific notation
e = actxserver('Excel.Application');
eWorkbook = e.Workbooks.Open(fullfile(pwd, filename));
eSheets = eWorkbook.Sheets;
eSheet1 = eSheets.get('Item', 1);
eSheet1Range = eSheet1.Range('B2:E24'); % Adjust range according to the number of functions
eSheet1Range.NumberFormat = '0.00E+00';
eWorkbook.Save();
eWorkbook.Close();
e.Quit();
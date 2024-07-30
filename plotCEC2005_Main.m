%%
clear
clc
close all
addpath(genpath(pwd));
number = 5; % Select the optimization function, replace as needed: F1, F3~F30, F2 has been removed
% variables_no = 30; % Options: 2, 10, 30, 50, 100
[lower_bound, upper_bound, variables_no, fobj] = Get_Functions_cec2005(number); % [lb, ub, D, y]: lower bound, upper bound, dimensions, objective function
pop_size = 30; % Population members
max_iter = 1000; % Maximum number of iterations

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
k = round(linspace(1, max_iter, CNT)); % Randomly select CNT points
% Note: If the convergence curve shows very few points, and the random points are sparse, it indicates that too few points are selected. In this case, increase the number of selected points to 100, 200, 300, etc.
% Conversely, if the random points on the convergence curve are very dense, it indicates that too many points are selected. In this case, reduce the number of selected points.
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
title('Convergence Curve')
xlabel('Iterations Count');
ylabel('Fitness');
box on
legend('GCRA', 'LGGCRA')
set(gcf, 'position', [300 300 800 330])

rmpath(genpath(pwd))

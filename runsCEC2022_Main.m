clear
clc
close all
addpath(genpath(pwd));
pop_size = 30; % Population size
max_iter = 500; % Number of iterations

run = 30;
box_pp = 1; % Options: 1 or other values. If equal to 1, draw boxplot, otherwise do not draw
RESULT = []; % Store results for standard deviation, mean, best value, etc.
rank_sum_RESULT = []; % Store rank sum test results

F = [1 2 3 4 5 6 7 8 9 10 11 12];
variables_no = 10; % Options: 2, 10, 20
disp(['Calculating results for CEC2022 functions with dimension ', num2str(variables_no)])
if box_pp == 1
    figure('Name', 'Boxplot', 'Color', 'w', 'Position', [50 50 1400 700])
end

for func_num = 1:length(F)
    % Display the comprehensive results
    disp(['Results for function F', num2str(F(func_num)), ':'])
    num = F(func_num);
    [lower_bound, upper_bound, variables_no, fobj] = Get_Functions_cec2022(num, variables_no); % [lb, ub, D, y]: lower bound, upper bound, dimensions, objective function
    resu = []; % Store results for standard deviation, mean, best value, etc.
    rank_sum_resu = []; % Store rank sum test results
    box_plot = []; % Store boxplot results
    
    %% Run the LGGCRA algorithm for "run" times
    final_main = zeros(1, run);
    for nrun = 1:run
        [final, position, iter] = LGGCRA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj);
        final_main(nrun) = final;
        z1(nrun) = final;
    end
    box_plot = [box_plot; final_main]; % Store boxplot results
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    RESULT = [RESULT; zz']; % Append results to RESULT as rows (transposed)
    disp(['LGGCRA: Best value:', num2str(zz(1)), ' Std Dev:', num2str(zz(2)), ' Mean:', num2str(zz(3)), ' Median:', num2str(zz(4)), ' Worst value:', num2str(zz(5))]);
    
    %% Run the PSO algorithm for "run" times
    final_main = zeros(1, run);
    for nrun = 1:run
        [final, position, iter] = PSO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj);
        final_main(nrun) = final;
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; % Store boxplot results
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    RESULT = [RESULT; zz']; % Append results to RESULT as rows (transposed)
    rs = ranksum(z1, z2);
    if isnan(rs) % When z1 and z2 are identical, NaN may appear, although this is rare, we need to prevent errors
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; % Store rank sum test results for PSO
    disp(['PSO: Best value:', num2str(zz(1)), ' Std Dev:', num2str(zz(2)), ' Mean:', num2str(zz(3)), ' Median:', num2str(zz(4)), ' Worst value:', num2str(zz(5))])
    
    %% Run the GCRA algorithm for "run" times
    final_main = zeros(1, run);
    for nrun = 1:run
        [final, position, iter] = GCRA(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj);
        final_main(nrun) = final;
        z2(nrun) = final;
    end
    box_plot = [box_plot; final_main]; % Store boxplot results
    zz = [min(final_main); std(final_main); mean(final_main); median(final_main); max(final_main)];
    resu = [resu, zz];
    RESULT = [RESULT; zz']; % Append results to RESULT as rows (transposed)
    rs = ranksum(z1, z2);
    if isnan(rs) % When z1 and z2 are identical, NaN may appear, although this is rare, we need to prevent errors
        rs = 1;
    end
    rank_sum_resu = [rank_sum_resu, rs]; % Store rank sum test results for GCRA
    disp(['GCRA: Best value:', num2str(zz(1)), ' Std Dev:', num2str(zz(2)), ' Mean:', num2str(zz(3)), ' Median:', num2str(zz(4)), ' Worst value:', num2str(zz(5))])
    
    %% Draw boxplot
    if box_pp == 1 
        subplot(3, 4, func_num) % 4 rows and 6 columns
        mycolor = [
            0.862745098039216, 0.827450980392157, 0.117647058823529;
            0.705882352941177, 0.266666666666667, 0.423529411764706;
            0.949019607843137, 0.650980392156863, 0.121568627450980;
            0.956862745098039, 0.572549019607843, 0.474509803921569;
            0.231372549019608, 0.490196078431373, 0.717647058823529;
            0.655541222625894, 0.122226545135785, 0.325468941131211;
            0.766665984235466, 0.955154623456852, 0.755161564478523
        ]; % Set a color palette
        %% Start drawing
        % Parameters: data matrix, color settings, marker
        box_figure = boxplot(box_plot', 'color', [0 0 0], 'Symbol', 'o');
        % Set line width
        set(box_figure, 'LineWidth', 1.2);
        boxobj = findobj(gca, 'Tag', 'Box');
        for i = 1:3 % Since there are 3 algorithms in total, adjust according to the actual situation!
            patch(get(boxobj(i), 'XData'), get(boxobj(i), 'YData'), mycolor(i, :), 'FaceAlpha', 0.5, 'LineWidth', 0.7);
        end
        set(gca, 'XTickLabel', {'LGGCRA', 'PSO', 'GCRA'});
        title(['F', num2str(F(func_num))])
        hold on
    end 
end
if box_pp == 1 % Save boxplot
    saveas(gcf, 'Boxplot.png')
end

if exist('result.xls', 'file')
    delete('result.xls')
end

if exist('ranksumresult.xls', 'file')
    delete('ranksumresult.xls')
end

%% Write results for standard deviation, mean, best value, etc. into Excel
numFuncs = length(F);
numMetrics = 5; % min, std, avg, median, worse
numMethods = 3; % LGGCRA, PSO, GCRA

A = cell(numFuncs * numMetrics, 2 + numMethods); % Initialize A with correct dimensions
for i = 1:numFuncs
    str = ['F', num2str(F(i))];
    row_start = (i - 1) * numMetrics + 1;
    row_end = i * numMetrics;
    A(row_start:row_end, 1) = {str; str; str; str; str};
    A(row_start:row_end, 2) = {'min'; 'std'; 'avg'; 'median'; 'worse'};
end

% Append RESULTS
for i = 1:numFuncs
    row_start = (i - 1) * numMetrics + 1;
    row_end = i * numMetrics;
    A(row_start:row_end, 3:end) = num2cell(RESULT(row_start:row_end, :));
end

rmpath(genpath(pwd))

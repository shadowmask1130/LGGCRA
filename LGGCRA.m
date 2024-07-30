%_________________________________________________________________________%
% Greater Cane Rat Algorithm (GCRA)                                       %
%                                                                         %
%  Developed in MATLAB R2020b                                             %
%                                                                         %
%  Designed and Developed: Dr. Ovre Agushaka                              %
%                                                                         %
%         E-Mail: jo.agushaka@science.edu.ng                              %
%                 jefshak@gmail.com                                       %
%                                                                         %
%                                  
%                                                                         %
%  Published paper: Agushaka et al.                                       %
%          A novel algorithm for global optimization: Greater cane rat    %
%          algorithm                                                      %
%_________________________________________________________________________%

function [Score, Position, Convergence] = LGGCRA(Search_Agents, Max_iterations, Lower_bound, Upper_bound, dimension, objective)
    Position = zeros(1, dimension);
    Score = inf;

    Gcanerats = init(Search_Agents, dimension, Upper_bound, Lower_bound);
    Convergence = zeros(1, Max_iterations);
    Alpha_pos1 = Position;
    Alpha_score = Score;
    l = 1;

    for i = 1:size(Gcanerats, 1)
        Gcanerats(i,:) = boundCheck(Gcanerats(i,:), Lower_bound, Upper_bound);
        fitness = objective(Gcanerats(i,:));

        if fitness < Score 
            Score = fitness; 
            Position = Gcanerats(i,:);
            Alpha_pos1 = Position;
            Alpha_score = Score;
        end
    end

    while l <= Max_iterations
        Alpha_pos = Alpha_pos1; % Ensure Alpha_pos has the same size
        GR_m = randperm(Search_Agents - 1, 1); 
        GR_rho = 0.5;
        GR_r = Alpha_score - l * (Alpha_score / Max_iterations);

        % Use computeIntrinsicMean to calculate GR_mu
        Phi = @(x) x; % Replace this with the actual mapping function
        points = Gcanerats';
        GR_mu = computeIntrinsicMean(points, Phi);

        GR_c = rand;
        GR_alpha = 2 * GR_r * rand - GR_r;
        GR_beta = 2 * GR_r * GR_mu - GR_r;

        for i = 1:size(Gcanerats, 1)
            Gcanerats(i,:) = (Gcanerats(i,:) + Alpha_pos) / 2;
        end

        for i = 1:size(Gcanerats, 1)
            for j = 1:size(Gcanerats, 2)
                if rand < GR_rho
                    Gcanerats(i,j) = Gcanerats(i,j) + GR_c * (Alpha_pos(j) - GR_r * Gcanerats(i,j));
                    Gcanerats(i,:) = boundCheck(Gcanerats(i,:), Lower_bound, Upper_bound);
                    fitness = objective(Gcanerats(i,:));
                    if fitness < Score 
                        Score = fitness; 
                        Position = Gcanerats(i,:);
                    else
                        Gcanerats(i,j) = Gcanerats(i,j) + GR_c * (Gcanerats(i,j) - GR_alpha * Alpha_pos(j)); 
                        Gcanerats(i,:) = boundCheck(Gcanerats(i,:), Lower_bound, Upper_bound);
                        fitness = objective(Gcanerats(i,:));
                        if fitness < Score 
                            Score = fitness; 
                            Position = Gcanerats(i,:);
                        end
                    end
                else
                    Gcanerats(i,j) = Gcanerats(i,j) + GR_c * (Alpha_pos(j) - GR_mu * Gcanerats(GR_m,j));
                    Gcanerats(i,:) = boundCheck(Gcanerats(i,:), Lower_bound, Upper_bound);
                    fitness = objective(Gcanerats(i,:));
                    if fitness < Score 
                        Score = fitness; 
                        Position = Gcanerats(i,:);
                    else
                        Gcanerats(i,j) = Gcanerats(i,j) + GR_c * (Gcanerats(GR_m,j) - GR_beta * Alpha_pos(j)); 
                        Gcanerats(i,:) = boundCheck(Gcanerats(i,:), Lower_bound, Upper_bound);
                        fitness = objective(Gcanerats(i,:));
                        if fitness < Score 
                            Score = fitness; 
                            Position = Gcanerats(i,:);
                        end
                    end
                end
                Alpha_pos1 = Position;
                Alpha_score = Score;    
            end
        end
        Convergence(l) = Score;  
        l = l + 1;    
    end
end

function bounded = boundCheck(position, lower, upper)
    bounded = min(max(position, lower), upper);
end


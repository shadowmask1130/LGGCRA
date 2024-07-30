function mu = computeIntrinsicMean(points, Phi)
    % points: a matrix where each column is a point on the manifold
    % Phi: a function handle for the mapping from the manifold to the embedding space

    if isempty(points)
        error('Input points cannot be empty.');
    end

    % Initial guess for the mean (e.g., the first point)
    mu = points(:,1);

    % Tolerance and maximum number of iterations for convergence
    tol = 1e-6;
    maxIter = 100;

    for iter = 1:maxIter
        % Map the current mean and all points to the embedding space
        Phi_mu = Phi(mu);
        Phi_points = arrayfun(Phi, points, 'UniformOutput', false);
        Phi_points = cell2mat(Phi_points);

        % Compute the gradient of the cost function
        gradient = zeros(size(mu));
        for i = 1:size(points, 2)
            gradient = gradient + (Phi_mu - Phi_points(:,i));
        end

        % Update rule (gradient descent step)
        mu_new = mu - gradient / size(points, 2);

        % Check for convergence
        if norm(mu_new - mu) < tol
            mu = mu_new;
            break;
        end

        % Update mean
        mu = mu_new;
    end

    if iter == maxIter
        warning('Maximum number of iterations reached without convergence.');
    end

    % Return the first element as the scalar value
    mu = mu(1);
end

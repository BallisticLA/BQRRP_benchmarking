function[] = qrcp_reconstruction_issues_investigation()
    m = 1000;
    n = 50;
    I = eye(n, n);
    
    % A is filled with stacked copies of the identity matrix;
    A = repmat(I, m / n, 1);
    % B is an identity placed above the zero matrix
    B = [I; zeros(m - n, n)];
    % C is the same as B for now
    C = B;
    % D is also same as B for now
    D = B;
    % E is a staircase matrix
    E = gen_step_mat(m, n);
    
    % Select ranom m/2 rows to scale
    rows_to_scale = randperm(m, m / 2);
    % Scale half of rows of A, B and D
    A(rows_to_scale, :) = A(rows_to_scale, :) * 10^10;
    B(rows_to_scale, :) = B(rows_to_scale, :) * 10^10;
    D(rows_to_scale, :) = D(rows_to_scale, :) * 10^10;
    
    % Multiply A, B, C on the right by a random orthonormal factor
    S = orth(randn(n, n));
    A = A * S;
    B = B * S;
    C = C * S;
    
    % Perform QRCP
    [Q_A, R_A, P_A] = qr(A, 0);
    [Q_B, R_B, P_B] = qr(B, 0);
    [Q_C, R_C, P_C] = qr(C, 0);
    [Q_D, R_D, P_D] = qr(D, 0);
    [Q_E, R_E, P_E] = qr(E, 0);
    
    % Compute QRCP reconstruction errors
    reconstrruction_error_A = norm(A(:, P_A) - Q_A * R_A, 'fro');
    reconstrruction_error_B = norm(B(:, P_B) - Q_B * R_B, 'fro');
    reconstrruction_error_C = norm(C(:, P_C) - Q_C * R_C, 'fro');
    reconstrruction_error_D = norm(D(:, P_D) - Q_D * R_D, 'fro');
    reconstrruction_error_E = norm(E(:, P_E) - Q_E * R_E, 'fro');
    
    % If D is indeed high coherence, then this experiment contradicts the
    % assumption that high coherence matrices are generally difficult for QRCP.
    % Check the coherance (max leverage score)
    max_leverage_score_A = max(sum(Q_A.^2, 2));
    max_leverage_score_B = max(sum(Q_B.^2, 2));
    max_leverage_score_C = max(sum(Q_C.^2, 2));
    max_leverage_score_D = max(sum(Q_D.^2, 2));
    max_leverage_score_E = max(sum(Q_E.^2, 2));
    
    % By construction, we have
    % Matrix A - stacked identities, randomly scaled,
    % multiplied by an orthonromal from the right.
    %
    % Matrix B - identity on top of zeros, randomly scaled,
    % multiplied by an orthonromal from the right.
    %
    % Matrix C - identity on top of zeros, multiplied by an 
    % orthonromal from the right.
    %
    % Matrix D - identity on top of zeros, randomly scaled.
    
    fprintf("Coherance of A is %f; reconstruction error of A is %e\n", max_leverage_score_A, reconstrruction_error_A);
    fprintf("Coherance of B is %f; reconstruction error of B is %e\n", max_leverage_score_B, reconstrruction_error_B);
    fprintf("Coherance of C is %f; reconstruction error of C is %e\n", max_leverage_score_C, reconstrruction_error_C);
    fprintf("Coherance of D is %f; reconstruction error of D is %e\n", max_leverage_score_D, reconstrruction_error_D);
    fprintf("Coherance of E is %f; reconstruction error of E is %e\n", max_leverage_score_E, reconstrruction_error_E);
    % Judging by the results, matrices B, C, D all have high coherance, matrix
    % A has low coherance. 
end

function[E] = gen_step_mat(m, n)

    % Generate the staircase spectrum
    condval = 10^10;
    offset = floor(n / 4);
    s = zeros(n,1);
    s(1:offset)                 = 1.0;
    s(offset+1:2*offset)        = 8.0/condval;
    s(2*offset+1:3*offset)      = 4.0/condval;
    s(3*offset+1:n)             = 1.0/condval; 
    
    S = diag(s);
    U = orth(randn(m, n));
    V = orth(randn(n, n));

    E = U * S * V;
end
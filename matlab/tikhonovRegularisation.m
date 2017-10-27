function [rms, m_norm, m_ls, d_model, r_ls] = tikhonovRegularisation(G, d, N, M, alpha)
    % Preperation for calculations
    n = length(alpha);
    
    % Memory preallocation
    m_ls = zeros(M,n);
    d_model = zeros(N,n);
    rms = zeros(1,n);
    m_norm = zeros(1,n);

    for i=1:n
        % Model determination
        m_ls(:,i) = inv(G'*G + alpha(i)^2 * eye(M)) * G' * d;

        % Observed data
        d_model(:,i) = G * m_ls(:,i);

        % Residuals and RMS
        r_ls = d - d_model(:,i);
        rms(i) = sqrt(r_ls'*r_ls);

        % Model norm
        m_norm(i) = sqrt(m_ls(:,i)'*m_ls(:,i));
    end
end
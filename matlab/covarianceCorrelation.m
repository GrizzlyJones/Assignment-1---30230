function [C_m, rho_m, sigma] = covarianceCorrelation(G, d)
    % Assuming independent and equal data errors
    sigma = std(d);

    C_m = sigma^2 * inv(G'*G);

    rho_m = zeros(size(C_m));
    for i = 1:length(C_m)
        for j = 1:length(C_m)
            rho_m(i,j) = C_m(i,j)/sqrt(C_m(i,i) * C_m(j,j));
        end
    end
end
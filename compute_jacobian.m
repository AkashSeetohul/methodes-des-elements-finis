function jacob = compute_jacobian(vertices, dervals_psi)
  jacob = zeros(2, 2);

  % on applique la formule décrite dans la Page 3
  for k = 1:2
    for l = 1:2
      jacob(k, l) = sum(vertices(:, k).*dervals_psi(:,l));
    endfor
  endfor

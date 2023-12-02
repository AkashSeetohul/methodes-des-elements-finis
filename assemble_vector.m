function V = assemble_vector(str_integrand_test, str_fonction_l, mesh_geo, degree_EF, number)
  % str_fontion_1 est la fonction de l(v) - la forme linéaire dans les formulations Lax milgram
  % on retrouvera les commentaires nécessaires pour l'explication des étapes dans assemble_matrix.m
  coords = getfield(mesh_geo, 'coords');
  triangles = getfield(mesh_geo, 'triangles');

  V = zeros(size(coords,1), 1);
  [points, weights] = quadrature(number);

  for K = 1:size(triangles, 1)
    for q = 1:size(points, 1)

      [vals, dervals_psi] = shape_fcts(points(q, :), degree_EF);
      vertices = coords(triangles(K, :) , :);

      vals_courant = vals; % comme décrit en Page 3
      x_courant = [dot(vertices(:,1), vals) , dot(vertices(:,2), vals) ];

      jacobien = compute_jacobian(vertices, dervals_psi);
      inverse_jacobien = inv(jacobien);

      dervals_courant = zeros(size(dervals_psi));

      % calcule des dervals_phi_i de l'élément courant
      for I = 1:size(dervals_psi, 1)
        for l = 1:2
          dervals_courant(I, l) = dervals_psi(I, 1)*inverse_jacobien(1, l) + dervals_psi(I, 2)*inverse_jacobien(2, l) ;
        endfor
      endfor

      % ici, il nous faut parcourir que les noeuds une fois en boucle, puisque f est déjà connu. [\int f \phi_{i}]
      for i = 1:size(triangles(K, :), 2)
         numero_global_i = triangles(K, i);
         V(numero_global_i) = V(numero_global_i) + weights(q)*( feval(str_fonction_l,  x_courant(1), x_courant(2)) * diff_op(str_integrand_test, vals_courant(i), dervals_courant(i, :))) * abs(det((jacobien)));
      endfor
    endfor
  endfor

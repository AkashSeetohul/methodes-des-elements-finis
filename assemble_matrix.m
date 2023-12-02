function A = assemble_matrix(str_integrand_unknown, str_integrand_test, str_cofvar, mesh_geo, degree_EF, number)

  coords = getfield(mesh_geo, 'coords');
  triangles = getfield(mesh_geo, 'triangles');

  % on initialise la matrice A avec la taille de nombre_noeuds * nombre_noeuds, où nombre_noueds est aussi égale au nombres de fonctions de bases géométriques de l'espace d'approximation
  A = zeros(size(coords,1));

  [points, weights] = quadrature(number);

  % on parcourt les éléments (triangles) du maillage
  for K = 1:size(triangles, 1)
    % pour pouvoir utiliser la formule de quadrature, on parcourt les points du quadrature
    for q = 1:size(points, 1)

      [vals, dervals_psi] = shape_fcts(points(q, :), degree_EF); % on retrouve les points de la quadrature dans l'élément de référence
      vertices = coords(triangles(K, :) , :);

      vals_courant = vals; % comme décrit en Page 3

      % on applique la formule F_K(k) = \sum\limits_{i=1}^{n_geo} V_i \hat{varphi}(x) pour retrouver l'élément x courant
      % la fonction alpha est défini sur tout le maillage et ne prend pas (nécessairement) la même forme que dans l'élément de référence
      x_courant = [dot(vertices(:,1), vals) , dot(vertices(:,2), vals) ];

      % on effectue les calculs géométriques décrits sur la page 3
      jacobien = compute_jacobian(vertices, dervals_psi);
      inverse_jacobien = inv(jacobien);

      dervals_courant = zeros(size(dervals_psi));
      % calcule des dervals_phi_i de l'élément courant
      for I = 1:size(dervals_psi, 1)
        for l = 1:2
          dervals_courant(I, l) = dervals_psi(I, 1)*inverse_jacobien(1, l) + dervals_psi(I, 2)*inverse_jacobien(2, l) ;
        endfor
      endfor

      for i = 1:size(triangles(K, :), 2)
        numero_global_i = triangles(K, i);
        for j = 1:size(triangles(K, :), 2)
           numero_global_j = triangles(K, j);
           A(numero_global_i, numero_global_j) = A(numero_global_i, numero_global_j) + weights(q)*( feval(str_cofvar, x_courant(1), x_courant(2)) * diff_op(str_integrand_test, vals_courant(i), dervals_courant(i, :)) * diff_op(str_integrand_unknown, vals_courant(j), dervals_courant(j, :))) * abs(det((jacobien)));
        endfor
      endfor
    endfor
  endfor

% On explicite les résultats ci-dessous
%
%
% EXPLE 1
%
##coords_ = [0,0;1,0;0,1;1,1];
##triangles_ = [1,2,4;1,3,4];

##Mass =
##
##0.16667	0.041667	0.041667	0.083333
##0.041667	0.083333	0	0.041667
##0.041667	0	0.083333	0.041667
##0.083333	0.041667	0.041667	0.16667
##
##Rigid =
##
##1	-0.5	-0.5	0
##-0.5	1	0	-0.5
##-0.5	0	1	-0.5
##0	-0.5	-0.5	1
##
##coords_ = [0,0;1,0;0,1;1,1.3];
##triangles_ = [1,2,4;1,3,4];
##
##Mass =
##
##   0.1917   0.0542   0.0417   0.0958
##   0.0542   0.1083        0   0.0542
##   0.0417        0   0.0833   0.0417
##   0.0958   0.0542   0.0417   0.1917
##
##Rigid =
##
##   1.1950  -0.6500  -0.6950   0.1500
##  -0.6500   1.0346        0  -0.3846
##  -0.6950        0   1.3450  -0.6500
##   0.1500  -0.3846  -0.6500   0.8846
##
##coords_ = [0,0;0.5,0;1,0;0,0.5;0.5,0.5;1,0.5;0,1;0.5,1;1,1];
##triangles_ = [1,2,4;2,5,4;2,3,5;3,6,5;4,5,7;5,8,7;5,6,8;6,9,8];
##
##Mass =
##0.020833	0.010417	0	0.010417	0	0	0	0	0
##0.010417	0.0625	0.010417	0.020833	0.020833	0	0	0	0
##0	0.010417	0.041667	0	0.020833	0.010417	0	0	0
##0.010417	0.020833	0	0.0625	0.020833	0	0.010417	0	0
##0	0.020833	0.020833	0.020833	0.125	0.020833	0.020833	0.020833	0
##0	0	0.010417	0	0.020833	0.0625	0	0.020833	0.010417
##0	0	0	0.010417	0.020833	0	0.041667	0.010417	0
##0	0	0	0	0.020833	0.020833	0.010417	0.0625	0.010417
##0	0	0	0	0	0.010417	0	0.010417	0.020833
##
##Rigid =
##
##   1.0000  -0.5000        0  -0.5000        0        0        0        0        0
##  -0.5000   2.0000  -0.5000        0  -1.0000        0        0        0        0
##        0  -0.5000   1.0000        0        0  -0.5000        0        0        0
##  -0.5000        0        0   2.0000  -1.0000        0  -0.5000        0        0
##        0  -1.0000        0  -1.0000   4.0000  -1.0000        0  -1.0000        0
##        0        0  -0.5000        0  -1.0000   2.0000        0        0  -0.5000
##        0        0        0  -0.5000        0        0   1.0000  -0.5000        0
##        0        0        0        0  -1.0000        0  -0.5000   2.0000  -0.5000
##        0        0        0        0        0  -0.5000        0  -0.5000   1.0000
##
##coords_ = [1,0;0,1;0,0];     %  triangle de reference
##triangles_ = [1,2,3];
##
##Mass =
##
##   0.083333   0.041667   0.041667
##   0.041667   0.083333   0.041667
##   0.041667   0.041667   0.083333
##
##Rigid =
##
##   0.5000        0  -0.5000
##        0   0.5000  -0.5000
##  -0.5000  -0.5000   1.0000
##
##coords_ = [0.5,0;0,0.5;0,0];  %  triangle (0,0 ; 0.5,0 ; 0,0.5)
##triangles_ = [1,2,3];
##
##Mass =
##
##   0.020833   0.010417   0.010417
##   0.010417   0.020833   0.010417
##   0.010417   0.010417   0.020833
##
##Rigid =
##
##   0.5000        0  -0.5000
##        0   0.5000  -0.5000
##  -0.5000  -0.5000   1.0000
##
##coords_ = [-0.5,0;0.5,0;0,0.5*sqrt(3)];     %  triangle equilateral
##triangles_ = [1,2,3];                       %  triangle equilateral
##
##Mass =
##
##   0.072169   0.036084   0.036084
##   0.036084   0.072169   0.036084
##   0.036084   0.036084   0.072169
##
##Rigid =
##
##   0.5774  -0.2887  -0.2887
##  -0.2887   0.5774  -0.2887
##  -0.2887  -0.2887   0.5774
##
##ccx = 0.5; ccy = 0.5*sqrt(3);
##coords_ = [-ccx,-ccy;ccx,-ccy;-1,0;0,0;1,0;-ccx,ccy;ccx,ccy];  %  test disc6
##triangles_ = [1,2,4 ;2,5,4 ; 5,7,4; 7,6,4; 6,3,4; 3,1,4];      %  test disc6
##
##Mass =
##
##   0.1443   0.0361   0.0361   0.0722        0        0        0
##   0.0361   0.1443        0   0.0722   0.0361        0        0
##   0.0361        0   0.1443   0.0722        0   0.0361        0
##   0.0722   0.0722   0.0722   0.4330   0.0722   0.0722   0.0722
##        0   0.0361        0   0.0722   0.1443        0   0.0361
##        0        0   0.0361   0.0722        0   0.1443   0.0361
##        0        0        0   0.0722   0.0361   0.0361   0.1443
##
##Rigid =
##
##   1.1547  -0.2887  -0.2887  -0.5774        0        0        0
##  -0.2887   1.1547        0  -0.5774  -0.2887        0        0
##  -0.2887        0   1.1547  -0.5774        0  -0.2887        0
##  -0.5774  -0.5774  -0.5774   3.4641  -0.5774  -0.5774  -0.5774
##        0  -0.2887        0  -0.5774   1.1547        0  -0.2887
##        0        0  -0.2887  -0.5774        0   1.1547  -0.2887
##        0        0        0  -0.5774  -0.2887  -0.2887   1.1547
##
##
##my_mesh = mesh_new('TheCurrentTest',coords_,triangles_);
##Mass = assemble_matrix('Id', 'Id', 'f_one', my_mesh, 1, 2)
##Rigid1 = assemble_matrix('D1', 'D1', 'f_one', my_mesh, 1, 1);
##Rigid2 = assemble_matrix('D2', 'D2', 'f_one', my_mesh, 1, 1);
##Rigid = Rigid1 + Rigid2

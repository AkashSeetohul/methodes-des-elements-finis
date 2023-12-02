function quality = mesh_quality(mesh)
  triangles = getfield(mesh, 'triangles');
  coords = getfield(mesh, 'coords');

  quality = 0; % initialisation

  % on parcourt tous les triangles pour trouver la plus grande rapport
  for i=1:size(triangles,1)
    triangle_coor = [coords(triangles(i,1), :); coords(triangles(i,2), :); coords(triangles(i, 3), :)];

    if (roundness(triangle_coor)> quality)
      quality=roundness(triangle_coor);
    endif
  endfor

% Les résultats sont incluts dans la programmation de mesh_optimize

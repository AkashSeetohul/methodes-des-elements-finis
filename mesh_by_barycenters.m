function mesh_out = mesh_by_barycenters(boundary_vertices, mesh_size)
  coords = [];

  % on discrétise la frontière de taille (mesh_size/2) pour l'initialisation
  for i=1:size(boundary_vertices, 1)
      % les sommets de départ et de la fin
      % on va ajouter consecutivement des sommets espacés de taille mesh_size/2 entre deux sommets sommet_depart et sommet_fin du maillage
      sommet_depart = boundary_vertices(i, :);
      coords = [coords; sommet_depart];

      sommet_fin = boundary_vertices( mod(i,size(boundary_vertices,1))+1, :);
      nombre_de_step = ceil( norm(sommet_fin - sommet_depart)/(mesh_size/2));

      % maintenant on ajoute les sommets successivement
      boundary_vertices_ajoute = sommet_depart; % initialisation
      for j = 1:(nombre_de_step-1)
          boundary_vertices_ajoute = boundary_vertices_ajoute + (sommet_fin - sommet_depart)*(mesh_size/2);
          coords = [coords; boundary_vertices_ajoute];
      endfor
  endfor

  % On stocke les sommets du domaine
  sommets_domaine = coords;

  % on construit une triangle initiale avec la subdivision de la frontière utilisant delaunay
  triangles = delaunay(coords(:, 1), coords(:, 2));
  mesh_intermediaire = mesh_new('mesh par barycentres', coords, triangles);

  max_distance_arete = 100000;
  while (max_distance_arete > mesh_size)
      % on initialise un nouveau maillage
      [no_triangle_mauvaise, max_distance_arete] = find_worth_triangle(mesh_intermediaire);

      % on calcule le centre du cercle circonsrit de la "mauvaise" triangle
      [circumcenter, circumradius] = circumcircle([coords(triangles(no_triangle_mauvaise, 1), :); coords(triangles(no_triangle_mauvaise, 2), :); coords(triangles(no_triangle_mauvaise, 3), :)]);

      % Si le centre du cercle circonstrit est dans le domaine, on l'ajoute à notre nouveau maillage.
      % sinon on ajoute le milieu de du segement le plus grant
      % on utilise la commande/fonction inpolygon de Matlab/GNU Octave pour vérifier si le point est dans le domaine
      if (inpolygon(circumcenter(1), circumcenter(2),  sommets_domaine(:,1), sommets_domaine(:,2)) == 1)
        coords = [coords; circumcenter];
      else
        % on trouve le segment le plus grand
        for j = 1:3
          j_considere = j ; j_prochain = mod(j,3) + 1;
          distance_arete = norm( coords(triangles(no_triangle_mauvaise, j_considere), :) - coords(triangles(no_triangle_mauvaise, j_prochain), :) );

          % on vérifie si l'arete est le plus grand et on stocke les coordonées de ses sommets
          if (distance_arete == max_distance_arete)
            sommet_du_milieu = 0.5 * (coords(triangles(no_triangle_mauvaise, j_considere), :) + coords(triangles(no_triangle_mauvaise,j_prochain),:));
          endif
        endfor

        % on ajoute alors le milieu le plus grand à notre maillage
        coords = [coords; sommet_du_milieu];
      endif

      triangles = delaunay(coords(:, 1), coords(:,2));
      mesh_intermediaire = mesh_new('mesh par barycentres', coords, triangles);
  endwhile

  mesh_out = mesh_new('mesh par barycentres', coords, triangles);

##coords = [0,0; 1,0; 1, 1; 0,1; .5, .5];
##triangles = [1 2 5; 2 3 5; 5 4 3; 1 5 4];
##
##my_mesh = mesh_by_barycenters(coords, 0.20);
##
##mesh_plot(my_mesh, true

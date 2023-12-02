function mesh_out = mesh_optimize(mesh_in)
  triangles = getfield(mesh_in, 'triangles');
  coords = getfield(mesh_in, 'coords');

  % on inititialize une vecteur colonne de taille i*1 où i est le nombre de coordonées/sommets avec des zéros.
  % On changera l'entrée par rapport à leur position dans le domaine ou sur la frontière.
  % Si l'entrée à la i-ème ligne est égale à un, alors le i-ème coordonnée/sommet se trouve sur la frontière.
  coords_test = zeros(size(coords, 1), 1);

  [edges, edges_triangles] = build_edge_connectivity(mesh_in);
  % on parcourt les arêtes pour déterminer lesquelles sont sur la frontière.
  % une arête est sur la frontière si et seulement si elle n'est pas partagée par deux triangles
  % Alors ses sommets sont sur la frontière
  for i = 1:size(edges,1)
    if (size(edges_triangles{i}, 1) == 1) % l'arête est sur la frontière
      coords_test(edges(i,1),1)=1;
      coords_test(edges(i,2),1)=1;
    endif
  endfor

  % On poursuit l'algorithme d'optimisation maintenant
  % on commence par parcourir les sommets des triangles
  for i=1:size(triangles,1)
    for j=1:3
      voisins = []; % un array qui stockera l'indice les coordonées des voisins

      % on vérifie si ce sommet est un sommet d'intérieur
      if (coords_test(triangles(i,j), 1) == 0)
        % on cherche les voisins de ce sommet
        % pour cela, on parcourt edges pour trouver si c'est un des sommets d'une arête
        % alors, l'autre sommet serait son voisin
        for arete = 1:size(edges,1)
            if (edges(arete, 1) == triangles(i, j))
              voisins = [voisins; coords(edges(arete, 2),:)];
            elseif (edges(arete, 2) == triangles(i, j))
              voisins = [voisins; coords(edges(arete, 1),:)];
            endif
        endfor
      % on remplace le coordonées de ce sommet par l'isobarycentre de ces voisins
      coords(triangles(i,j),:) = mean(voisins);
      endif
    endfor
  endfor

  mesh_out = mesh_new('', coords, triangles);

% On affiche nos résultats ci-dessus:
%
##coords = [0,0; 1,0; 1, 1; 0,1; .5, .5];
##triangles = [1 2 5; 2 3 5; 5 4 3; 1 5 4];
##
##my_mesh = mesh_by_barycenters(coords, 0.20);
##
##qualite_avant = mesh_quality(my_mesh)
##my_mesh1 = mesh_optimize(my_mesh);
##qualite_apre = mesh_quality(my_mesh1)
##
##mesh_plot(my_mesh1, true);
##
##qualite_avant = 6.2261
##qualite_apre = 4.0789

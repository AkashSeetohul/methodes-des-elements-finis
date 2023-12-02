function [edges, edges_triangles] = build_edge_connectivity(mesh)
  triangles = getfield(mesh, 'triangles');
  edges = [];

  % on parcourt tous les triangles pour pouvoir définir les arête à l'aide de ses sommets
  for i = 1:size(triangles, 1)
    % pour chaque triangle, on prend un pair de sommets pour caractériser une arête
    for j = 1:3
      j_considere = j; j_prochain = mod(j, 3)+1;

      % on va stocker les sommets des arêtes de manière décroissant : une arête = [min_sommet, max_sommet]
      min_sommet = min(triangles(i, j_considere), triangles(i, j_prochain));
      max_sommet = max(triangles(i, j_considere), triangles(i, j_prochain));

      visited = false; % une variable du type BOOLEAN qui sera TRUE si l'arête a déjà été visitée ou FALSE sinon

      % si l'array edges est vide jusqu'ici, aucune arête a été visitée. On ajoute la première arête à l'array edges
      if (size(edges,1) == 0)
        edges = [edges; [min_sommet, max_sommet]];
      else
        % sinon, il faut vérifier si l'arête en question [min_sommet, max_sommet] a déjà été ajoutée à edges où pas
        % pou cela, on parcours les arêtes déjà ajoutées à l'array edges et on compare avec l'arête en question
        for ligne_arete = 1:size(edges, 1)
          if (isequal([min_sommet max_sommet], [edges(ligne_arete, 1), edges(ligne_arete,2)]))
            visited = true; % variable qui est égale à true si l'arête a déjà été visitée ou false sinon
          endif
        endfor
        % si l'arête n'a pas été ajoutée à l'array edges, on l'ajoute.
        if (visited == false)
           edges = [edges; [min_sommet max_sommet]];
        endif
      endif
    endfor
  endfor

  edges_triangles = cell(1, size(edges, 1));

  % Maintenant qu'on a établit l'array edges, on parcourt le parcourt pour trouver les triangles qui partagent les arêtes
  for numero_arete = 1: size(edges, 1)
    edges_triangle{numero_arete} = [];
    % on cherche les triangles (maximum 2) qui partagent les deux sommets de l'arête numero_arete -ième
    for i = 1:size(triangles, 1)
      for j = 1:3
        j_considere = j; j_prochain = mod(j, 3)+1;

        % On réarrange les arêtes des triangles puisque celle dans l'array edges sont stockées avec leurs sommets décroissants
        min_sommet = min(triangles(i, j_considere), triangles(i, j_prochain));
        max_sommet = max(triangles(i, j_considere), triangles(i, j_prochain));

        if (isequal([min_sommet max_sommet], [edges(numero_arete,1) edges(numero_arete, 2)]))
          % on ajoute ce triangle et le coordonné locale de sommet 1 dans la liste de edges_triangles
          edges_triangles{numero_arete} = [[i, j_considere]; edges_triangles{numero_arete}];
        endif
      endfor
    endfor
  endfor

% on affiche les résultats provenant du maillage de base (Page 2 TP 1) sur le carré unité:
##coords = [0,0; 1,0; 1, 1; 0,1; .5, .5];
##triangles = [1 2 5; 2 3 5; 5 4 3; 1 5 4];
##
##my_mesh = mesh_new('', coords, triangles);
##[edges, edges_triangles] = build_edge_connectivity(my_mesh);
##
##edges =
##
##   1   2
##   2   5
##   1   5
##   2   3
##   3   5
##   4   5
##   3   4
##   1   4
##
##edges_triangles =
##{
##  [1,1] =
##
##     1   1
##
##  [1,2] =
##
##     2   3
##     1   2
##
##  [1,3] =
##
##     4   1
##     1   3
##
##  [1,4] =
##
##     2   1
##
##  [1,5] =
##
##     3   3
##     2   2
##
##  [1,6] =
##
##     4   2
##     3   1
##
##  [1,7] =
##
##     3   2
##
##  [1,8] =
##
##     4   3
##
##}

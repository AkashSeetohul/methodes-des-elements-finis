function [aretes_sur_frontiere] = aretes_frontieres(mesh)
  % fontion du TP 2 Section 6 Exercise 5
  % on retrouvera une partie de ce programme dans mesh_optimize aussi, utilisé à déterminer si un noeud est sur la frontière ou pas.
  aretes_sur_frontiere = [];
  [edges, edges_triangles] = build_edge_connectivity(mesh);

  % on parcourt les arêtes pour déterminer lesquelles sont sur la frontière.
  % une arête est sur la frontière si et seulement si elle n'est pas partagée par deux triangles
  % Alors ses sommets sont sur la frontière
  for i = 1:size(edges,1)
    if (size(edges_triangles{i}, 1) == 1) % l'arête est sur la frontière
        aretes_sur_frontiere = [aretes_sur_frontiere; edges(i, :)];
    endif
  endfor

% On démontre un résultat ci-dessous:
##coords = [0,0; 1,0; 1, 1; 0,1; .5, .5];
##triangles = [1 2 5; 2 3 5; 5 4 3; 1 5 4];
##
##my_mesh = mesh_by_barycenters(coords, 0.20);
##aretes_sur_frontiere = aretes_frontieres(my_mesh)
##mesh_plot(my_mesh, true);
##
##aretes_sur_frontiere =
##
##   30   31
##   31   73
##    6    7
##   50   73
##    1   71
##    1    2
##   29   30
##   47   70
##   47   72
##   50   72
##    4    5
##   13   14
##   10   11
##   11   12
##    7    8
##    8    9
##   16   17
##   15   16
##   24   25
##   23   24
##   22   23
##   19   20
##   20   21
##   21   22
##   51   70
##    3    4
##    2    3
##   51   71
##    5    6
##   14   15
##    9   10
##   12   13
##   18   19
##   17   18
##   25   26
##   27   28
##   28   29
##   26

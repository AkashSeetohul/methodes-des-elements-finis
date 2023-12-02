function [Aout, Bout] = Dirichlet_elimination(Ain, Bin, boundary_nodes)
  % fontion du TP 2 Section 6 Exercise 6
  % on parcourt les noeuds de la frontières de boundary_nodes
  for I = boundary_nodes
    % on parcourt chaque colonne de la ligne I de la matrice Ain
    % si j = I, on se retrouve dans le diagonale - cette entrée de la matrice est exclue de l'annulation
    for j = 1:size(Ain(I, :), 2)
      if not(j == I)
        Ain(I,j) = 0;
      endif
    endfor

    % pour le vecteur B_in, il suffira d'annuler les entrées du vecteur à l'indice I
    Bin(I, 1) = 0;
  endfor
Aout = Ain; Bout = Bin;

##coords_ = [0,0;0.5,0;1,0;0,0.5;0.5,0.5;1,0.5;0,1;0.5,1;1,1];
##triangles_ = [1,2,4;2,5,4;2,3,5;3,6,5;4,5,7;5,8,7;5,6,8;6,9,8];
##
##my_mesh = mesh_new('', coords_, triangles_);
##mesh_plot(my_mesh,true);
##
##aretes_sur_frontiere = aretes_frontieres(my_mesh);
##
##boundary_nodes = [];
##
##% La liste des noeuds sur la frontière sont données par ceux qui définissent les arêtes sur la frontière
##% On parcourt ces noeuds
##for i = 1:size(aretes_sur_frontiere,1)
##  for k = 1:2
##    % si le sommet n'a pas déjà été ajouté, on l'ajoute à boundary_nodes
##    if not(ismember(aretes_sur_frontiere(i,k), boundary_nodes))
##      boundary_nodes = [boundary_nodes, aretes_sur_frontiere(i,k)];
##    endif
##  endfor
##endfor
##
##Mass = assemble_matrix('Id', 'Id', 'f_one', my_mesh, 1, 2)
##B = assemble_vector('Id', 'fonction_f', my_mesh, 1, 2)
##[Aout, Bout] = Dirichlet_elimination(Mass, B, boundary_nodes)
##
##Mass =
##
##   0.0208   0.0104        0   0.0104        0        0        0        0        0
##   0.0104   0.0625   0.0104   0.0208   0.0208        0        0        0        0
##        0   0.0104   0.0417        0   0.0208   0.0104        0        0        0
##   0.0104   0.0208        0   0.0625   0.0208        0   0.0104        0        0
##        0   0.0208   0.0208   0.0208   0.1250   0.0208   0.0208   0.0208        0
##        0        0   0.0104        0   0.0208   0.0625        0   0.0208   0.0104
##        0        0        0   0.0104   0.0208        0   0.0417   0.0104        0
##        0        0        0        0   0.0208   0.0208   0.0104   0.0625   0.0104
##        0        0        0        0        0   0.0104        0   0.0104   0.0208
##
##B =
##
##   0.3489
##   0.2061
##  -0.5310
##   0.2061
##  -0.4323
##   0.2061
##  -0.5310
##   0.2061
##   0.3489
##
##Aout =
##
##   0.0208        0        0        0        0        0        0        0        0
##        0   0.0625        0        0        0        0        0        0        0
##        0        0   0.0417        0        0        0        0        0        0
##        0        0        0   0.0625        0        0        0        0        0
##        0   0.0208   0.0208   0.0208   0.1250   0.0208   0.0208   0.0208        0
##        0        0        0        0        0   0.0625        0        0        0
##        0        0        0        0        0        0   0.0417        0        0
##        0        0        0        0        0        0        0   0.0625        0
##        0        0        0        0        0        0        0        0   0.0208
##
##Bout =
##
##        0
##        0
##        0
##        0
##  -0.4323
##        0
##        0
##        0
##

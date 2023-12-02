function [approximation_u, noeuds_maillage]= resoudre_edp(h, degree_EF)
  % une fonction qui prend comme paramètre la taille du discrétisation du maillage h et le degré du maillage

  % on commence par créer le maillage pour le carré [0,1]*[0,1]
  boundary_vertices = [0,0; 1,0; 1,1; 0,1];
  my_mesh = mesh_by_barycenters(boundary_vertices, h);

  % mesh_by_barycenters rend un maillage qui contient que les noeuds d'un élément finis P2
  % on utilise la fonction P1_to_P2 pour transformer le maillage de degré 1 à un maillage de degré 2
  if (degree_EF == 2)
    my_mesh = P1_to_P2(my_mesh);
  endif

  noeuds_maillage = getfield(my_mesh, 'coords');

  % on construit maintenant la matrice A_{i,j}
  % La théorie et les calculs suient les théories du cour
  % on utilise le degré de quadrature 1 pour la matrice de rigidité puisqu'on approxime des fontions constantes
  % Pour la matrice de masse et le vecteur b, on utilise le degré 2 puisqu'on approxime des fonctions polynomiales et trigonométriques.
  Mass = assemble_matrix('Id', 'Id', 'f_one', my_mesh, degree_EF, 2);
  Rigid1 = assemble_matrix('D1', 'D1', 'f_one', my_mesh, degree_EF, 1);
  Rigid2 = assemble_matrix('D2', 'D2', 'f_one', my_mesh, degree_EF, 1);
  A_ij = Rigid1 + Rigid2 + Mass;

  % on construit aussi le vecteur b
  b_ij = assemble_vector('Id', 'fonction_f', my_mesh, degree_EF, 2);

  approximation_u = A_ij\b_ij;

##  % affichage de la fonction u approximée
##  triangles = getfield(my_mesh, 'triangles');
##  coords = getfield(my_mesh, 'coords');
##  trisurf(triangles, coords(:, 1), coords(:, 2), approximation_u);

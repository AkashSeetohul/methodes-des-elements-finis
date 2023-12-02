function mesh_P2 = P1_to_P2 (mesh_P1)

coords = getfield(mesh_P1, 'coords');
triangles = getfield(mesh_P1, 'triangles');
original_size = size(coords, 1);

% on fait une copie de la matrice triangle avec des lignes allogées i.e. [a b c 0 0 0] afin de pouvoir ajouter les
% coordonées
triangles = [triangles, zeros(size(triangles, 1), 3)];

[edges, edges_triangles] = build_edge_connectivity(mesh_P1);
% pour chaque arete dans la liste edge, il nous faut ajouter un nouveau
% noeud au milieu
for i = 1:size(edges, 1)
    % on calcule un noeud entre les deux sommets de edges
    % celui-ci est le milieu de chaque arete
    nouveau_noeud = [(coords(edges(i, 1), 1) + coords(edges(i,2), 1))/2 , (coords(edges(i, 1), 2) + coords(edges(i,2), 2))/2];
    coords = [coords; nouveau_noeud];
endfor

% Maintenant, on parcourt les triangles originaux maintenant pour pouvoir identifier les
% numérotations locales
for i=1:size(triangles, 1)
    % pour chaque triangle, on prend un pair de sommets pour caractériser une arête
    for j = 1:3
      j_considere = j; j_prochain = mod(j, 3)+1;

      % on va considérer les sommets des arêtes de manière décroissants pour pouvoir les comparer avec les arêtes dans l'array edges
      min_sommet = min(triangles(i, j_considere), triangles(i, j_prochain));
      max_sommet = max(triangles(i, j_considere), triangles(i, j_prochain));

      % on regarde à quelle indice i l'arete [min, max] étaient stocké; les coordonées du noeud du milieu ajouté est alors à l'indice original_size+i de coords
      for numero_arete = 1: size(edges,1)
        if edges(numero_arete, :) == [min_sommet, max_sommet]
            indice = numero_arete;
        endif
      endfor

      % maintenant, on ajoute cette coordonée (indice original_size +
      % numero_arete) à l'indice j+3 du triangles
      triangles(i, j+3) = original_size+indice;
    endfor
endfor

mesh_P2 = mesh_new('Mesh P2' ,coords, triangles) ;

##coords = [0,0; 1,0; 1, 1; 0,1; .5, .5];
##triangles = [1 2 5; 2 3 5; 5 4 3; 1 5 4];
##
##my_mesh = mesh_new('', coords, triangles);
##
##mesh_plot(my_mesh, true);
##pause
##
##mesh_P2 = P1_to_P2(my_mesh);
##mesh_plot(mesh_P2, true

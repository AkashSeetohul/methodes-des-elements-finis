function [triangle_number, max_edge_size] = find_worth_triangle(mesh)
triangles = getfield(mesh, 'triangles');
coords = getfield(mesh, 'coords');

% initialisation des variables
triangle_number = 0;
max_edge_size = -100000;

% on parcourt les triangles du maillage
for i = 1:size(triangles, 1)
    % on parcourt alors leurs aretes pour pouvoir caractériser les arêtes
    for j = 1:3
        j_considere = j ; j_prochain = mod(j,3) + 1;
        distance_arete = norm( coords(triangles(i, j_considere), :) - coords(triangles(i, j_prochain), :) );

        % on vérifie si l'arete est plus grand que le maximum
        if distance_arete > max_edge_size
            % on met à jour nos variables
            max_edge_size = distance_arete;
            triangle_number = i;
        endif
    endfor
endfor

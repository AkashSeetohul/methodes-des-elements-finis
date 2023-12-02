function sigma = roundness(triangle_coor)
  % Pour calculer le rayon du circle inscrit, on utilise la formule rayon = aire/(la moitié du périmètre)
  % on commence par calculer l'aire du triangle qui est donné par 0.5 *|A||B|*sqrt(1 - cos(theta)) où theta est l'angle entre les arêtes A et B
  module_A = norm(triangle_coor(1,:) - triangle_coor(2,:)); module_B = norm(triangle_coor(1,:) - triangle_coor(3,:));

  % on utilise le fait que A.B = |A||B|cos(theta) pour calculer cos(theta)
  cos_theta = dot(triangle_coor(1,:) - triangle_coor(2,:), triangle_coor(1,:) - triangle_coor(3,:)) / (module_A*module_B);
  aire_triangle = 0.5 * module_A * module_B * sqrt(1 - cos_theta);

  moitie_perimetre = 0.5 * (module_A + module_B + norm(triangle_coor(2,:) - triangle_coor(3,:)));

  rayon_inscrit = aire_triangle/moitie_perimetre;

  % on utilise la fonction circumcircle pour avoir le rayon du cercle circonscrit
  [circumcenter, circumradius] = circumcircle(triangle_coor);

  sigma = circumradius/rayon_inscrit;

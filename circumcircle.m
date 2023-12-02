function [circumcenter, circumradius] = circumcircle(triangle_coor)
% On résoud l'équation |AO|=|BO|=|CO| pour A,B,C les sommets de la triangle et O le barycentre
% Pour cela, on est ramené à une système linéaire AO=B
A = [(-2*triangle_coor(1,1) + 2*triangle_coor(2,1)), (-2*triangle_coor(1,2) + 2*triangle_coor(2,2)); (-2*triangle_coor(2,1) + 2*triangle_coor(3,1)), (-2*triangle_coor(2,2) + 2*triangle_coor(3,2)) ];
B = [(triangle_coor(2,1)^2 - triangle_coor(1,1)^2) + (triangle_coor(2,2)^2 - triangle_coor(1,2)^2); (triangle_coor(3,1)^2 - triangle_coor(2,1)^2) + (triangle_coor(3,2)^2 - triangle_coor(2,2)^2) ];
circumcenter = (inv(A)*B).';
circumradius = norm(circumcenter - triangle_coor(1,:));

##coords = [1,4; -2,3; 5, 2];
##triangles = [1 2 3];
##%Avec des calculs à la main, le circumcenter est égale à (1, -1) et le circumradius est égale à 5
##[circumcenter, circumradius] = circumcircle(coords);
##
##
##circumcenter =
##
##   1  -1
##
##circumradius = 5

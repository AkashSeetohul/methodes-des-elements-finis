function [points, weights] = quadrature(number)
  % la formule de quadrature varie dépendent de number
  if (number == 1)
    points = [1,0 ; 0,1 ; 0,0];
    weights = [(1/6); (1/6); (1/6)];
  elseif (number == 2)
    points = [1,0 ; 0,1 ; 0,0 ; 0.5, 0.5 ; 0, 0.5 ; 0.5, 0; mean([1,0 ; 0,1 ; 0,0 ; 0.5, 0.5 ; 0, 0.5 ; 0.5, 0])];
    weights = [(1/40); (1/40); (1/40); (1/15); (1/15); (1/15); (9/40)];
  endif


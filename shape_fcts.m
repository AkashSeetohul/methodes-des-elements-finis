function [vals, dervals] = shape_fcts(xh, k)
  vals = [];
  dervals = [];
  if (k == 1)
    vals(1, 1) = xh(1);
    vals(2, 1) = xh(2);
    vals(3, 1) = 1 - xh(1) - xh(2);
    dervals(1,1) = 1; dervals(1,2) = 0;
    dervals(2,1) = 0; dervals(2,2) = 1;
    dervals(3,1) = -1; dervals(3,2) = -1;
  elseif (k == 2)
    vals(1, 1) = xh(1);
    vals(2, 1) = xh(2);
    vals(3, 1) = 1 - xh(1) - xh(2);
    vals(4, 1) = 4 * xh(1) * xh(2);
    vals(5, 1) = 4 * xh(2) * (1 - xh(1) - xh(2));
    vals(6, 1) = 4 * (1 - xh(1) - xh(2)) * xh(1);
    dervals(1,1) = 1; dervals(1,2) = 0;
    dervals(2,1) = 0; dervals(2,2) = 1;
    dervals(3,1) = -1; dervals(3,2) = -1;
    dervals(4,1) = 4 * xh(2); dervals(4,2) = 4 * xh(1);
    dervals(5,1) = - 4 * xh(2); dervals(5,2) = 4 - 4*xh(1) -8*xh(2);
    dervals(6,1) = 4 - 8*xh(1) - 4*xh(2); dervals(6,2) = - 4 * xh(1);
  endif

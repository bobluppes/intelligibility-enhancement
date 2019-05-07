function y = dsided(x, dim)

if nargin == 1
    if size(x, 1)<size(x,2)
        y = [x conj(x((end-1):-1:2))];
    else
        y = [x; conj(x((end-1):-1:2))];
    end
else
    if dim == 1
        y = [x conj(x((end-1):-1:2, :))];
    elseif dim == 2
        y = [x conj(x(:, (end-1):-1:2))];
    else
       error('Not a valid dimension, should be either 1 or 2')
    end
end
% Returns the first 0:(N/2+1) terms of the fourier transform
%
% y = ssided(x, dim)
% x is the input vector of length N with the fourier coefficients and dim
% the dimension (1 or 2) along which the function must be applied to in
% case of a matrix

function y = ssided(x, dim)

if nargin == 1
    y = x(1:(round(length(x)/2)+1));
else
    if dim == 1
        y = x(1:(size(x, dim)/2+1), :);
    elseif dim == 2
        y = x(:, 1:(size(x, dim)/2+1));
    else
       error('Not a valid dimension, should be either 1 or 2')
    end
end


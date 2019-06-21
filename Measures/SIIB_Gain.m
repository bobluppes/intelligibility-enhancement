function [g convergence error] = SIIB_Gain(x, n, fs_signal, bits)
% Find the necessary gain to achieve a SIIB_Gauss of bits
% 1 <= G <= 10

a = 1;
b = 10;

converge = [];
err = [];

% Check if necessary gain is contained in the interval
a_v = difference(a, x, n, fs_signal, bits);
b_v = difference(b, x, n, fs_signal, bits);
if ((a_v * b_v) >= 0)
    if (a_v < 0)
        g = 1;
        convergence = [];
        error = [];
        return;
    else
        g = 10;
        convergence = [];
        error = [];
        return;
    end
end

% Tolerance in bits
e = 5;

i = 1;
while(1)
    % Calculate midpoint
    c = (a + b) / 2;
    converge(i) = c;
    c_v = difference(c, x, n, fs_signal, bits)
    err(i) = abs(c_v);
    
    if (abs(c_v) <= e)
        if (c_v <= 0)
            break;
        end
    elseif (c > 9.9)
        c = 10;
        break;
    elseif (c < 1.1)
        c = 1;
    end
    
    if (1 ~= 0)
        a_v = difference(a, x, n, fs_signal, bits);
        b_v = difference(b, x, n, fs_signal, bits);
    end
    
    if ((a_v * c_v) < 0)
        b = c;
    elseif ((b_v * c_v) < 0)
        a = c;
    else
        error('gain not in interval');
    end
    
    i = i + 1;
end

fprintf('Gain computed in %d iterations', i);
g = c;
convergence = converge;
error = err;

function d = difference(f, x, n, fs_signal, bits)
d = bits - SIIB_Gauss(f*x, f*x+n, fs_signal);
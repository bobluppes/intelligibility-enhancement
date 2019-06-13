function g = SIIB_Gain(x, n, fs_signal, bits)
% Find the necessary gain to achieve a SIIB_Gauss of bits
% 1 <= G <= 100

a = 1;
b = 100;

% Check if necessary gain is contained in the interval
a_v = difference(a, x, n, fs_signal, bits);
b_v = difference(b, x, n, fs_signal, bits);
if ((a_v * b_v) >= 0)
    error('optimal gain not contained in interval');
end

% Tolerance in bits
e = 5;

i = 0;
while(1)
    % Calculate midpoint
    c = (a + b) / 2;
    c_v = difference(c, x, n, fs_signal, bits)
    
    if (abs(c_v) <= e)
        break
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

function d = difference(f, x, n, fs_signal, bits)
d = bits - SIIB_Gauss(f*x, f*x+n, fs_signal);
function g = SIIB_Gain(x, n, fs_signal, bits)

a = 0.001;
b = 100;
e = 5;

while(1)
    c = (a + b) / 2;
    c_v = difference(c, x, n, fs_signal, bits);
    
    if (c <= e)
        break
    end
    
    a_v = difference(a, x, n, fs_signal, bits);
    b_v = difference(b, x, n, fs_signal, bits);
    
    if ((a_v * c_v) < 0)
        b = c;
    elseif ((b_v * c_v) < 0)
        a = c;
    else
        error('gain not in interval');
    end
end

g = c;

function d = difference(f, x, n, fs_signal, bits)
d = bits - SIIB_Gauss(f*x, f*x+n, fs_signal);
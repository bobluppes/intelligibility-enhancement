function tfplot(x, y, tf, style)

% x(end+1, :)     = zeros(1, size(x, 2));
% x(:, end+1)     = zeros(size(x, 1), 1);

if nargin==1
    tf      = x;
    x       = (1:size(tf, 2))-.5;
    y       = (1:size(tf, 1))-.5;
    style   = 'lin'; 
end

if nargin==3;
	style = 'lin'; 
end

% tf(1, 1) = 0;
% tf(end, end) = 1;

if strcmp(style, 'lin')
    p = pcolor(x, y, tf); set(p, 'linestyle', 'none'); colorbar;
elseif strcmp(style, 'log')
    p = pcolor(y, x, 20*log10(tf)); set(p, 'linestyle', 'none'); colorbar;
else
    disp('unknown style')
end
box on;
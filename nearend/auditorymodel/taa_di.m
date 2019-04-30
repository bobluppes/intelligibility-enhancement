function [dii xrms Xhs]    = taa_di(x, dat, p)

x       = [x(:); zeros(p.N - length(x), 1)];

Xh      = zeros(p.M, length(x));

if p.cutoff==0
    h_s    = [1 zeros(1, p.N-1)];
else
    k           = 0:(p.N/2);
    a           = -exp(-2*pi*(p.cutoff/p.fs));
    h_s         = dsided((1+a)./sqrt(1+a^2+2*a*cos(2*pi*k/p.N)));
end


for i = 1:p.M
    Xh(i, :)    = ifft(p.h(i, :).'.*fft(x), p.N); 
end

Xhs  	= ifft(fft(abs(Xh).^2, p.N, 2).*repmat(h_s, [p.M 1]), p.N, 2);  	% apply smoothing filter
dii  	= sum(dat.W'./Xhs, 2);
xrms  	= sqrt(mean((Xh').^2));
% rms(Xh') 

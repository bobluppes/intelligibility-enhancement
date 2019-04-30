function xrms = getTF(x, N, K, p)

frames      = 1:K:(length(x)-N);
w           = hanning(N);
xrms    	= zeros(length(frames), p.M);

for i = 1:length(frames)
    ii  	= frames(i):(frames(i)+N-1);
  	xf   	= x(ii).*w;
    
    for j = 1:p.M
        xrms(i, j)    = rms(ifft(p.h(j, :).'.*fft(xf), p.N));
    end
end
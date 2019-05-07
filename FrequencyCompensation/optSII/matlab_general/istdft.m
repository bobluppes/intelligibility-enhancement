function x = istdft(x_stdft, N, K)
% function x = istdft(x_stdft, N, K)

frames      = 1:K:((size(x_stdft, 1)-1)*K+N);
x           = zeros(1, ((size(x_stdft, 1)-1)*K+N));
w           = sqrt(hanning(N))';

for i = 1:size(x_stdft, 1)
    ii    	= frames(i):(frames(i)+N-1);
	fr      = ifft(x_stdft(i, :));
    x(ii) 	= x(ii) + fr(1:N).*w;
end
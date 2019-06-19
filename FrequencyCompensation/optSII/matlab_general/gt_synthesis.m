function y  = gt_synthesis(X, x, H, N_frame)

%%
K               = (size(H, 2)-1)*2
x_hat           = stdft(x, N_frame, N_frame/2, K); 	% apply short-time DFT to clean speech
x_hat           = x_hat(:, 1:(K/2+1)).';         	% take clean single-sided spectrum
y_hat           = zeros(size(x_hat));
size(x_hat)
%%
for m = 1:size(x_hat, 2)
    for k = 1:size(H, 1)
        Xm          = x_hat(:, m).*H(k, :).';
        Ym          = Xm*X(k, m)/norm(Xm);
        y_hat(:, m)	= y_hat(:, m) + Ym;
    end
end

%%
y 	= istdft(dsided(y_hat.', 2), N_frame, N_frame/2);
y   = [y zeros(1, N_frame*4)];
y   = y(1:length(x));

if ~isequal(size(x), size(y))
    y = y.';
end
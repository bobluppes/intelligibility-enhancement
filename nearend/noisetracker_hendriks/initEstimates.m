function dat = initEstimates(w, N, p)

%%
W           = zeros(N, p.M);
Wn          = zeros(p.M, 1);

for i = 1:size(p.h, 1)
    W(:, i)     = ifft(fft(ifft(p.h(i, :)').^2).*fft(w.^2).*p.h_s.');
    Wn(i)       = sum(W(:, i)); % this term is not affected by p.h_s{ii} in the previous line, since h_s(1)=1;
end

dat.W   = W;
dat.Wn  = Wn;
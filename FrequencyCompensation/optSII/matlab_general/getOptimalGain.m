function a = getOptimalGain(sig_x, sig_e, w)

sig_x   = sig_x(:);
sig_e   = sig_e(:);
w       = w(:);

% Remove frequency band weights
for i = 1:length(w)
    w(i) = 1/length(w);
end

msk_old = false(size(sig_x));

t1      = sig_e.*sqrt(w)./sig_x.^2;
t2      = sig_e.^2./sig_x.^2;
nu      = (sum(sqrt(w).*sig_e)./(sum(sig_x.^2)+sum(sig_e.^2))).^2;

a       = sqrt(t1/sqrt(nu)-t2);
msk     = ~(a.^2>0);

while ~isequal(msk, msk_old)
    nu      = (sum(sqrt(w(~msk)).*sig_e(~msk))./(sum(sig_x.^2)+sum(sig_e(~msk).^2))).^2;
    a       = sqrt(t1/sqrt(nu)-t2);
    msk_old = msk;
    msk     = ~(a.^2>0); 
end

a(msk)  = 0;
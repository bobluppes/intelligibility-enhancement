fs      = 20000;
N_frame = 256;

x       = getTimit('train', 1, fs);
[H cf]  = gt_getfb(0, fs/2, fs, 512, 128);

X       = gt_analysis(x, H, N_frame);
Y1      = X.*repmat([ones(32, 1); zeros(96, 1)], [1 size(X, 2)]);
y       = gt_synthesis(Y1, x, H, N_frame);
Y2    	= gt_analysis(y, H, N_frame);

subplot(3, 1, 1); tfplot(X);
subplot(3, 1, 2); tfplot(Y1);
subplot(3, 1, 3); tfplot(Y2);
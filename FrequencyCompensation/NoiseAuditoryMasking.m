clear all
f = 2000;
fs = 8000;
n = 8000*47;
t = [0 :1/fs: 47-1/fs];
fas = pi*[-1 : 2/n : 1-1/n]*fs/(2*pi);
noise = sqrt(600)*sin(f*(2*pi)*t);
%plot(t, noise)

%sound(noise,fs);

G = transpose(gausswin(8000*47, 8000/600));
plot(G)
H = fftshift(fft(noise)).*G;
h = ifft(H);
figure
plot(fas,abs(H))
figure;
plot(t,h)
%sound(abs(h),fs);
%% process speech
clear all

[x fs]  	= audioread('SA1.wav');
x       	= x(:);
y           = genSSN(x, -5); % add some speech-shaped noise
n           = y-x;
[xn si so]  = sii_opt(x, n, fs);

%soundsc(x+n, fs);   % play before processing
%soundsc(xn+n, fs);  % play after processing

disp([si so]); % SII before and after processing (last one should be higher)

O = fftshift(fft(x));
I = fftshift(fft(xn));
n = length(I);
t = linspace(0, (n/fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);

figure;
subplot(2,2,1);
plot(x);
title('original');
subplot(2,2,2);
plot(xn);
title('improved');
subplot(2,2,3);
plot(f, abs(O));
subplot(2,2,4);
plot(f, abs(I));

sii_old = [];
sii_new = [];
snr = [];
for i = 1:10
    n = (y - x) ./ i;
    
    snr(i) = sum(abs(n));
    
    [xn si so]  = sii_opt(x, n, fs);
    
    sii_old(i) = si;
    sii_new(i) = so;
end

figure;
plot(sii_old);
hold on;
plot(sii_new);
legend('original', 'improved');


%% process speech
clear all

[x fs]  	= wavread('SA1.wav');
x       	= x(:);
y           = genSSN(x, -5); % add some speech-shaped noise
n           = y-x;
[xn si so]  = sii_opt(x, n, fs);

soundsc(x+n, fs);   % play before processing
soundsc(xn+n, fs);  % play after processing

disp([si so]); % SII before and after processing (last one should be higher)
clear all;
close all;

% Load audio signal
[x,fs] = audioread('Sounds/maleVoice.wav');
[n, fst] = audioread('Sounds/Train-noise.wav');

n = resample(n, fs, fst);
n = n(:,1);

amp = linspace(2,0,20);
noise = [];
for i = 1:length(amp)
    noise(:,i) = [n; zeros((length(x)-length(n)), 1)] .* amp(i);
end

siib_y = [];
snr = [];
amplification = linspace(0, 40, 80);
band = 350;
trans = transient_process(x, fs, band);

bar = waitbar(0,'Calculating SIIB');
for i = 1:length(amplification)
    waitbar((i/length(amplification)), bar, 'Calculating SIIB');
    
    y = transient_amplify(x, trans, amplification(i));
    Y = fftshift(fft(y));
    Py = sum(abs(Y));
    
    for j = 1:size(noise, 2)
        siib_y(i,j) = SIIB_Gauss(y, y+noise(:,j), fs);
        
        if (i == 1)
            N = fftshift(fft(noise(:,j)));
            Pn = sum(abs(N));
            snr(j) = 10*log(Py/Pn);
        end
    end
end
delete(bar);

figure;
surf(snr, amplification, siib_y);
title('SIIB amplification vs snr');
xlabel('SNR [dB]');
ylabel('Amplification');
zlabel('SIIB [bits/s]');




[original,Fs] = audioread('Noorderlicht.wav');
original = original(:,1);
stretched_ola = WSOLAEllen(original, 0.5, hann(500), 1.2, 0);
stretched_delta = WSOLAEllen(original, 0.5, hann(500), 1.2, 100);

soundsc(stretched_delta,Fs)
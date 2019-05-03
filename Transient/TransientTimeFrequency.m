clear all;
close all;

% Variables
timeInt = 0.1; % 100ms
bw = 300;

% Load audio signal
[original,Fs] = audioread('Sounds/maleVoice.wav');
[train, Fst] = audioread('Sounds/Train-noise.wav');
Fn = Fs/2;
n = length(original);

% Train noise
train = resample(train, Fs, Fst);
train = train(:,1);
m = length(train);
train = [train; zeros((n-m), 1)];
train = train .* 0.9;

% Samples in interval
sampleInt = timeInt * Fs;
steps = round(n/sampleInt);

% High pass filter original signal
[hps, hpf] = highpass(original,700,Fs,'Steepness',0.95);

% Fourrier transform
O = fft(original);
O = fftshift(O);
H = fft(hps);
H = fftshift(H);

% Compute frequency axis
n = sampleInt;
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Loop time segments
figure;
trans = [];
for i = 0:(steps - 2)
    % Take timeframe
    x = hps((i*sampleInt)+1:(i+1)*sampleInt,end);
    
    X = fftshift(fft(x));
    Smooth = smooth(f, abs(X), 0.1, 'rloess');
    [peaks, locations] = findpeaks(Smooth, f, 'MinPeakDistance', 500, 'NPeaks', 6, 'MinPeakHeight', 0.07);
    
    if length(locations) == 6
        t = x;
        
        if locations(4) > 0
            q1 = bandpass(x, [max((locations(4) - (bw/2)), 0) (locations(4) + (bw/2))], Fs);
            t = t - q1;
        end
        if locations(5) > 0
            q2 = bandpass(x, [max((locations(5) - (bw/2)), 0) (locations(5) + (bw/2))], Fs);
            t = t - q2;
        end
        if locations(6) > 0
            q3 = bandpass(x, [max((locations(6) - (bw/2)), 0) (locations(6) + (bw/2))], Fs);
            t = t - q3;
        end
    else
        t = x;
    end
    trans = [trans; t];
end

trans = trans * 12;
improved = original + trans;

I = fftshift(fft(improved));

% Compute frequency axis
n = length(improved);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(f, abs(I));





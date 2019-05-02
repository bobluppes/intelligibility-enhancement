clear all;
close all;

% Load audio signal
[original,Fs] = audioread('maleVoice.wav');
[train, Fst] = audioread('Train-noise.wav');
Fn = Fs/2;
n = length(original);

O = fft(original);
O = fftshift(O);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

high = highpass(original,1650,Fs);
mid = bandpass(original,[500 1650],Fs) .* 0.5;
low = lowpass(original,500,Fs) .* 0.2;

improved = low + mid + high;
improved = original;

Fc = 50;                                 % Desired Output Frequency   
carrier = sin(2*pi*(Fc)*t);               % Generate Carrier 
sm = transpose(improved) .* carrier;                          % Modulate (Produces Upper & Lower Sidebands
Fn = Fs/2;                                  % Design High-Pass Filter To Eliminate Lower Sideband
Wp = Fc/Fn;
Ws = Wp*0.8;
[n,Wn] = buttord(Wp, Ws, 1, 10);
[b,a] = butter(n,Wn,'high');
[sos,g] = tf2sos(b,a);
improved = 2*filtfilt(sos,g,sm);

I = fft(improved);
I = fftshift(I);

% Normalize the improved signal power
Po = sum(abs(O));
Pi = sum(abs(I));
a = Po / Pi;
improved = improved .* a;

figure;
plot(f, abs(I));

sound(improved, Fs);
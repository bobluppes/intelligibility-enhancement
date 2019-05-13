function improved = spectral_tilt(improved, Fs)

[f0, f1, f2, f3] = formants(improved, Fs, 900);

n = length(improved);
t = linspace(0, (n/Fs), n);
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*Fs/(2*pi);

Fc = 500;                                 % Desired Output Frequency   
carrier = sin(2*pi*(Fc)*t);               % Generate Carrier 
sm = transpose(f0) .* carrier;             % Modulate (Produces Upper & Lower Sidebands
Fn = Fs/2;                                  % Design High-Pass Filter To Eliminate Lower Sideband
Wp = Fc/Fn;
Ws = Wp*0.8;
[n,Wn] = buttord(Wp, Ws, 1, 10);
[b,a] = butter(n,Wn,'high');
[sos,g] = tf2sos(b,a);
f0 = transpose(2*filtfilt(sos,g,sm));

%Spectral tilting
improved = f0 * 0.1 + f1 * 0.3 + f2 * 0.7 + f3 * 0.8;
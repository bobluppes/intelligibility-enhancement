function trans = transient_process (x, fs, bw)
% Make the input signal x more intelligible by increasing the power in the
% transient parts in frequency domain.

% Parameters
timeInt = 0.1;              % 100ms
%bw = 700;                   % Bandwidth of formant bandpass filters
%amplification = 12.5;        % The amplification of the transient part
                            % This should be calculated from snr

% Input signal parameters
n = length(x);              % Sample length of input signal
duration = n/fs;            % Duration of input signal in seconds

% Calculate sample interval
sampleInt = timeInt * fs;   % Samples in interval
steps = ceil(n/sampleInt);  % Number of steps rounded up

% High pass filter the input signal
% Low intelligibility in frequencies < 700Hz
original = x;
x = highpass(x,700,fs,'Steepness',0.95);

% Compute frequency axis for sample interval
n = sampleInt;
Omega = pi*[-1 : 2/n : 1-1/n];
f = Omega*fs/(2*pi);

% Loop through time segments x_t
% x_t is modified in frequency domain to obtain the transient part of x_t
% These parts are appended to 'trans' which will become the transient part
% of x
trans = [];
for i = 1:steps
    % Take x_t
    start_index = (i-1) * sampleInt + 1;
    % Check if this is the last segment
    if i == steps
        % Last segment
        end_index = length(x);
        % Recompute f vector
        n = end_index - start_index + 1;
        Omega = pi*[-1 : 2/n : 1-1/n];
        f = Omega*fs/(2*pi);
    else
        % Not the last segment
        end_index = start_index + sampleInt - 1;
    end
    x_t = x(start_index:end_index);
    
    % Decompose into assumed formants
    f1 = bandpass(x_t, [720 1980], fs);
    f2 = bandpass(x_t, [2020 2980], fs);
    f3 = bandpass(x_t, [3020 3980], fs);
    
    % Calculate power per bin and determine center frequency
    k = linspace(720, 1980, 10);
    for l = 1:(length(k) - 1)
        ff = bandpass(x, [k(l) k(l+1)], fs);
        power(l) = sum(abs(ff));
    end
    [M index] = max(power);
    center1 = (k(index) + k(index+1))/2;
    k = linspace(2020, 2980, 10);
    for l = 1:(length(k) - 1)
        ff = bandpass(x, [k(l) k(l+1)], fs);
        power(l) = sum(abs(ff));
    end
    [M index] = max(power);
    center2 = (k(index) + k(index+1))/2;
    k = linspace(3020, 3980, 10);
    for l = 1:(length(k) - 1)
        ff = bandpass(x, [k(l) k(l+1)], fs);
        power(l) = sum(abs(ff));
    end
    [M index] = max(power);
    center3 = (k(index) + k(index+1))/2;
    
    % Initialize transient part
    t = x_t;
    
    q1 = bandpass(x_t, [max((center1 - (bw/2)), 50) (center1 + (bw/2))], fs);
    q2 = bandpass(x_t, [max((center2 - (bw/2)), 50) (center2 + (bw/2))], fs);
    q3 = bandpass(x_t, [max((center3 - (bw/2)), 50) (center3 + (bw/2))], fs);
    
    t = t - q1 - q2 - q3;
    
    % Append transient part to trans signal
    trans = [trans; t];
end
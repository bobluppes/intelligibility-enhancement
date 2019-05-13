function trans = transient_process (x, fs)
% Make the input signal x more intelligible by increasing the power in the
% transient parts in frequency domain.

% Parameters
timeInt = 0.1;              % 100ms
bw = 300;                   % Bandwidth of formant bandpass filters
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
    
    % Calculate formant center frequencies
    X_t = fftshift(fft(x_t));
    Smooth = smooth(f, abs(X_t), 0.1, 'rloess');
    % Check if there are peaks to be detected
    max_data = max(Smooth);
    locations = [];
    if max_data >= 0.07
        [peaks, locations] = findpeaks(Smooth, f, 'MinPeakDistance', 500, 'NPeaks', 6, 'MinPeakHeight', 0.07);
    end
    
    % Initialize transient part
    t = x_t;
    % Check if all the right peaks are detected
    if length(locations) == 6
        
        if locations(4) > 0
            q1 = bandpass(x_t, [max((locations(4) - (bw/2)), 50) (locations(4) + (bw/2))], fs);
            t = t - q1;
        end
        if locations(5) > 0
            q2 = bandpass(x_t, [max((locations(5) - (bw/2)), 50) (locations(5) + (bw/2))], fs);
            t = t - q2;
        end
        if locations(6) > 0
            q3 = bandpass(x_t, [max((locations(6) - (bw/2)), 50) (locations(6) + (bw/2))], fs);
            t = t - q3;
        end
        
    end
    
    % Append transient part to trans signal
    trans = [trans; t];
end
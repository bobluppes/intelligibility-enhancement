function trans = transient_process (x, fs, bw)
% Make the input signal x more intelligible by increasing the power in the
% transient parts in frequency domain.

bPlot = true;

% Parameters
timeInt = 0.5;              % 100ms
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
progress = waitbar(0,'Time Decomposition');
for i = 1:steps
    
    waitbar((i/steps), progress, 'Time Decomposition');
    
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
    timeLength = end_index - start_index + 1;
    
    X_t = fftshift(fft(x_t));
    df = timeLength/fs;
    
    mask1 = [zeros(round(720*df)+round(length(X_t)/2),1); ones(round((1980-720)*df), 1)];
    mask1 = [mask1; zeros(length(X_t) - length(mask1),1)];
    start1 = round(720*df)+round(length(X_t)/2);
    stop1 = round(1980*df)+round(length(X_t)/2);
    
    mask2 = [zeros(round(2020*df)+round(length(X_t)/2),1); ones(round((2980-2020)*df), 1)];
    mask2 = [mask2; zeros(length(X_t) - length(mask2),1)];
    start2 = round(2020*df)+round(length(X_t)/2);
    stop2 = round(2980*df)+round(length(X_t)/2);
    
    mask3 = [zeros(round(3020*df)+round(length(X_t)/2),1); ones(round((3980-3020)*df), 1)];
    mask3 = [mask3; zeros(length(X_t) - length(mask3),1)];
    start3 = round(3020*df)+round(length(X_t)/2);
    stop3 = round(3980*df)+round(length(X_t)/2);
    
    F1 = X_t .* mask1;
    F2 = X_t .* mask2;
    F3 = X_t .* mask3;
    
    d = linspace(start1, stop1, 6);
    power = [];
    for k = 1:5
        ff = F1(round(d(k)):round(d(k+1)));
        power(k) = sum(abs(ff));
    end
    [M index] = max(power);
    center1 = f(round((d(index) + d(index+1))/2));
    
    d = linspace(start2, stop2, 6);
    power = [];
    for k = 1:5
        ff = F2(round(d(k)):round(d(k+1)));
        power(k) = sum(abs(ff));
    end
    [M index] = max(power);
    center2 = f(round((d(index) + d(index+1))/2));
    
    d = linspace(start3, stop3, 6);
    power = [];
    for k = 1:5
        ff = F3(round(d(k)):round(d(k+1)));
        power(k) = sum(abs(ff));
    end
    [M index] = max(power);
    center3 = f(round((d(index) + d(index+1))/2));
    
    t = x_t;
    start1 = max((center1 - (bw/2)), 50);
    stop1 = max(min((center1 + (bw/2)), 3980),100);
    start2 = max((center2 - (bw/2)), stop1+5);
    stop2 = max(min((center2 + (bw/2)), 3980),stop1+20);
    start3 = max((center3 - (bw/2)), stop2+5);
    stop3 = max(min((center3 + (bw/2)), 3999),stop2 + 20);
    q1 = bandpass(x_t, [start1 stop1], fs);
    q2 = bandpass(x_t, [start2 stop2], fs);
    q3 = bandpass(x_t, [start3 stop3], fs);
    t = t - q1 - q2 - q3;
    
    % Plot to validate
    if (bPlot == true)
        figure('units','normalized','outerposition',[0 0 1 1]);
        
        subplot(2,1,1);
        plot(f, abs(X_t));
        xlim([0 4000]);
        hold on;
        line([start1 stop1], [-0.5 -0.5], 'Color', 'red');
        line([start2 stop2], [-0.4 -0.4], 'Color', 'green');
        line([start3 stop3], [-0.5 -0.5], 'Color', 'cyan');
        yl = ylim;
        line([center1 center1], [yl(1)-0.2 yl(2)], 'Color', 'red', 'LineStyle', '--');
        line([center2 center2], [yl(1)-0.2 yl(2)], 'Color', 'green', 'LineStyle', '--');
        line([center3 center3], [yl(1)-0.2 yl(2)], 'Color', 'cyan', 'LineStyle', '--');
        title('Formant Estimation Speech');
        xlabel('Frequency [Hz]');
        ylabel('Amplitude');
        
        subplot(2,1,2);
        plot(t);
        title('Estimated Transient Component');
        xlabel('Sample [n]');
        ylabel('Amplitude');
        
        soundsc(x_t, fs);
        pause;
        soundsc(t, fs);
    
        pause;
        close all;
    end
    
    % Append transient part to trans signal
    trans = [trans; t];
end

delete(progress);
function enhanced = SIIB_Opt_Gain(x, y, fs_signal)

if length(x)~=length(y)
    error('x and y should have the same length');
end

% initialization
fs = 16000;                             % sample rate of acoustic signals
window_length = 400;                    % 25 ms analysis window
step_size = 400/2;                      % 50% overlap
delta_dB = 40;                          % VAD threshold
R = 1/(step_size/fs);                   % frames/second
y = y(:)/std(x);                        % received speech
x = x(:)/std(x);                        % clean speech

% resample signals to fs
if fs_signal ~= fs
  x = resample(x, fs, fs_signal);
  y = resample(y, fs, fs_signal);
end

% get |STFT|^2
x_hat = stft(x, window_length, step_size, window_length); % apply short-time DFT to speech
y_hat = stft(y, window_length, step_size, window_length); 
x_hat       = ( abs( x_hat(:, 1:(window_length/2+1)) ).^2 )'; % single-sided spectrum, spectra as columns
y_hat       = ( abs( y_hat(:, 1:(window_length/2+1)) ).^2 )';

% VAD
vad_index_x = getVAD(x, window_length, step_size, delta_dB);
x_hat = x_hat(:,vad_index_x);
y_hat = y_hat(:,vad_index_x);

if size(x_hat,2)/R < 20 % check that the duration (after removing silence) is at least 20 s
    error('stimuli must have at least 20 seconds of speech');
end

% ERB gammatone filterbank
mn = 100;   % minimum center frequency
mx = 6500;  % maximum center frequency
J = round(21.4*log10(1+0.00437*mx)-21.4*log10(1+0.00437*mn)); % number of filters
[G, f_erb] = gammatone(fs, window_length, J, mn, mx);
X = log(G.^2*x_hat + eps); % equation (2) in [1]
Y = log(G.^2*y_hat + eps);

% forward temporal masking (see Rhebergen et al., 2006)
T0=1;
Tf = floor(0.2*R); % 200 ms
for j=1:J
    E_tf = min(X(j,:)); % 'hearing threshold' replacement (dB)
    Xfmf = zeros(1,size(X,2))-inf; % initialize forward masking function
    Yfmf = zeros(1,size(X,2))-inf;
    
    % overlap max (similar to overlap add)
    for i=1:size(X,2)
        ii = min( i:i+Tf-1, size(X,2)); % frame indices
        frame = X(j,ii);
        frame = frame(T0) - ( log((T0:Tf)/T0) ./ log(Tf/T0) )*(frame(T0)-E_tf); % forward masking function [Rhebergen et al., 2006]
        Xfmf(ii) = max(Xfmf(ii),frame); % max between clean signal and masking function
        
        frame = Y(j,ii);
        frame = frame(T0) - ( log((T0:Tf)/T0) ./ log(Tf/T0) )*(frame(T0)-E_tf);
        Yfmf(ii) = max(Yfmf(ii),frame);
    end
    
    X(j,:) = Xfmf;
    Y(j,:) = Yfmf;
end

% remove mean (for KLT)
X=X-repmat(mean(X,2),1,size(X,2));
Y=Y-repmat(mean(Y,2),1,size(Y,2));

% stack spectra
K = 15; % number of stacked vectors
temp  = X(:)';
X  = temp( bsxfun(@plus, [0:J*K-1]', 1:J:length(temp)-J*K) ); % equation (12) in [1]
temp  = Y(:)';
Y  = temp( bsxfun(@plus, [0:J*K-1]', 1:J:length(temp)-J*K) );

% KLT
[U, ~] = eig(cov(X'));
X = U'*X;
Y = U'*Y;

% Estimate mutual information using the capacity of a Gaussian channel
X = X';
Y = Y';

VAD     = 10*log10(mean(X.^2))>(max(10*log10(mean(X.^2)))-60);
sig_x   = sqrt(mean(X(:, VAD).^2, 2));
sig_e   = sqrt(mean(Y(:, VAD).^2, 2));
w = 0.75 * ones(length(sig_x), 1);
alphas = getOptimalGain(sig_x, sig_e, w);
%alphas = repmat(alphas, [1 size(X, 2)]);
Xh = X .* alphas;
Xh = Xh / U;
enhanced      = Xh;

rho_p_squared = 0.75^2;                                   % production noise correlation coefficient
rho_squared = mean(X.*Y).^2./(mean(X.^2).*mean(Y.^2));    % long-time squared correlation coefficient for the environmental channel
I = -0.5*R/K*sum(log2(1-rho_p_squared*rho_squared));      % Gaussian capacity (bits/s) (equation (1) in [2])
I = max(0,I);


%%
function x_stft = stft(x, N, K, N_fft)
% short-time Fourier transform of x. The rows and columns of x_stft
% denote the frame-index and dft-bin index, respectively.
x = x(:);
frames = 1:K:(length(x)-N);
x_stft = zeros(length(frames), N_fft);
w = hann(N,'periodic');

for i = 1:length(frames)
  ii = frames(i):(frames(i)+N-1);
  x_stft(i, :) = fft(w.*x(ii), N_fft);
end

%%
function vad_ind = getVAD(x, N, K, range)
% returns the indices of voice active frames 
frames = 1:K:(length(x)-N);
w = hann(N,'periodic');

x_dB = zeros(size(frames));
for i = 1:length(frames)
  ii = frames(i):(frames(i)+N-1); % indices of current frame
  x_dB(i) = 10*log10( mean((w.*x(ii)).^2) + eps ); % compute the power (dB) of each frame
end

x_dB_sort = sort(x_dB);
max_x = x_dB_sort(round(length(x_dB)*0.999)); % find the 99.9 percentile
vad_ind = find(x_dB>max_x - range);

%%
function  [A, cf] = gammatone(fs, N_fft, numBands, cf_min, cf_max)
% gammatone filterbank
erbminmax 	= 21.4*log10(4.37*([cf_min cf_max]./1000) + 1);        % convert to erbs
cf_erb      = linspace(erbminmax(1), erbminmax(2), numBands);      % linspace M filters on ERB-scale
cf          = (10.^(cf_erb./21.4)-1)./4.37*1000;                   % obtain center frequency in Hz
cf=cf(:);

order = 4;
a = factorial(order-1)^2/(pi*factorial(2*order-2)*2^-(2*order-2)); % Normalisation factor that ensures the gammatone filter has the correct ERB [Holdsworth & Patterson 1988].
b = a * 24.7.*(4.37.*cf./1000+1); % bandwidth

% frequency vector (Hz)
f = linspace(0, fs, N_fft+1);
f = f(1:(N_fft/2+1));

% filter bank
A = zeros(numBands, length(f));
for i=1:numBands
    temp = 1./(b(i)^2+(f-cf(i)).^2).^(order/2);    % gammatone magnitude response
    A(i,:) = temp/max(temp);                       % normalise the maximum value    
end
cf=cf(:);
A(A<0.001) = 0;

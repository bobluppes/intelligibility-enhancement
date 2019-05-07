function gX = OptMI(x,n,fs)
% Copyright 2017: Steven Van Kuyk
% This program comes WITHOUT ANY WARRANTY.
%
% This algorithm implements the speech enhancement algorithm described in [1].
% This implementation was written by Steven Van Kuyk and is not exactly the same
% as the implementation used for the listening test in [1].
% 
% Inputs: x is the clean speech, n is the noise signal, fs is the sampling rate.
% Output: gX is the clean speech that has been optimally filtered to maximize the mutual information 
% Parameters: rho can be changed to adjust the amount of production noise.
% rho = 1 will result in a water-filling algorithm.
% 
% If used in your research, please cite [1] and include Steven Van Kuyk in the
% acknowledgements.
%
% References:
%   [1] A simple model of speech communication and its application to
%   intelligibility enhancement, Bastiaan Kleijn and Richard Hendriks, 2015

% set up
K = mean(x.^2); % normalization factor
x=x(:)/sqrt(K);
n=n(:)/sqrt(K);
B = mean(x.^2); % power constraint (should be 1)
rho = 0.5; % production noise correlation coefficient (must be between 0 and 1)

% 1/3 octave band filterbank from ANSI Speech Intelligibility Index Table 3
mid_band = [160;200;250;315;400;500;630;800;1000;1250;1600;2000;2500;3150;4000;5000;6300;8000];
lower_band_limit = mid_band/(2^(1/6));
upper_band_limit = mid_band*(2^(1/6));

% apply the bandpass filterbank using sinc functions
for i=1:length(mid_band)
    X(i,:) = SINCFILTER(x,upper_band_limit(i)/(fs/2),200,'low');
    X(i,:) = SINCFILTER(X(i,:),lower_band_limit(i)/(fs/2),200,'high');
    
    N(i,:) = SINCFILTER(n,upper_band_limit(i)/(fs/2),200,'low');
    N(i,:) = SINCFILTER(N(i,:),lower_band_limit(i)/(fs/2),200,'high');
end
sigma2_x = mean(X.^2,2); % speech power
sigma2_n = mean(N.^2,2); % noise power

% bi-section algorithm
max_lambda = 0; % may need to change these parameters if the algorithm doesn't converge
min_lambda = -1e14;
threshold = 1e-6;
error = inf; 
fprintf 'Solving optimization problem... '
while error>threshold
    lambda = (max_lambda+min_lambda)/2;
    mu = 0;
    gamma = 0.5*rho.^2.*sigma2_x.*sigma2_n + (lambda*sigma2_x+mu).*sigma2_n.^2;
    beta = (lambda*sigma2_x+mu).*(2-rho.^2).*sigma2_x.*sigma2_n;
    alpha = (lambda*sigma2_x+mu).*(1-rho.^2).*sigma2_x.^2;
    
    b=[];
    for k = 1:length(gamma)
        b(k) = max( roots([alpha(k) beta(k) gamma(k)]) );
    end
    b(find(b<0)) = 0;
    
    gX = sum(bsxfun(@times,X,sqrt(b)'))'; % synthesize enhanced speech
    error = abs( mean(gX.^2) - B ); % check power constraint

    if mean(gX.^2)>B
        max_lambda = lambda;
    else
        min_lambda = lambda;
    end
end
fprintf 'Finished.\n'
gX = sum(bsxfun(@times,X,sqrt(b)'))'; % synthesize enhanced speech
gX = sqrt(K)*gX; % adjust power level

% check that MI increased
I_original = sum( -0.5*log2( ((1-rho^2)*(sigma2_x./sigma2_n)+1) ./ (sigma2_x./sigma2_n+1) ) );
I_enhanced = sum( -0.5*log2( ((1-rho^2)*(b'.*sigma2_x./sigma2_n)+1) ./ (b'.*sigma2_x./sigma2_n+1) ) );

fprintf('Mutual information increased from %.2f to %.2f bits per sample.\n', I_original, I_enhanced)
fprintf('Power of x is %.2f dB.\n', pow2db(K))
fprintf('Power of gX is %.2f dB.\n', pow2db(mean(gX.^2)))


function y = SINCFILTER(x,wc,N,type)
% convolves x with a FIR sinc filter with length 2n+1 and normalised cuttoff
% frequency wc. wc must be between 0 and 1 where 1 corresponds to fs/2
n=(-N:N)';
switch type
    case 'low'
        h = sinc(wc*n);
    case 'high'
        wc = 1-wc;
        h = sinc(wc*n).*(-1).^n;
end
h= h.*hann(2*N+1); % smooth window function to reduce gibbs effect and reduce the minimum gain
h = h / sqrt(sum(h.^2)/wc); % normalisation so that gain = 1;
y=conv(x,h,'same');
y = real(y);
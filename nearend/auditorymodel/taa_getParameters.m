function p = taa_getParameters(fs, cutoff, M, N)

%%
p.fs            = fs;
p.N             = N;
p.M             = M;

%% prepare smoothing filter
p.cutoff      	= cutoff;

if p.cutoff==0
    p.h_s       = [1 zeros(1, p.N-1)];
else
    k           = 0:(p.N/2);
    a           = -exp(-2*pi*(p.cutoff/p.fs));
    p.h_s       = dsided((1+a)./sqrt(1+a^2+2*a*cos(2*pi*k/p.N)));
end

%% get auditory filterbank response
[p.h p.cf]  = getFBR(p.fs, p.N, p.M);

function [h cf] = getFBR(fs, N, M)

%% prepare auditory filters
f           = (0:(N/2))/N*fs;
f_min   	= 150;                                                          % minimum center frequency
f_max     	= min(8000, fs/2);                                                         % maximum center frequency
erbminmax 	= 21.4*log10(4.37*([f_min f_max]./1000) + 1);                   % convert to erbs
cf_erb      = linspace(erbminmax(1), erbminmax(2), M);                      % linspace M filters on ERB-scale
cf          = (10.^(cf_erb./21.4)-1)./4.37*1000;                            % obtain center frequency in Hz
order       = 4;                                                            % order of gammatone filters
h           = realgammatone(f(1:(N/2+1)), cf, order);                       % auditory filter responses
h           = h./mean(sum(h(:, round(1+f_min/fs*N):round(1+f_max/fs*N))));  % normalize such that total power is 1 over the spectrum
h           = dsided(h, 2);
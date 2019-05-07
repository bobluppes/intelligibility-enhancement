function [H cf] = gt_getfb(f_min, f_max, fs, N, M)


% get auditory filterbank response
[H cf]  = getFBR(f_min, f_max, fs, N, M);
% H     	= dsided(H, 2);

function [h cf] = getFBR(f_min, f_max, fs, N, M)

% prepare auditory filters
f           = (0:(N/2))/N*fs;
erbminmax 	= 21.4*log10(4.37*([f_min f_max]./1000) + 1); 	% convert to erbs
cf_erb      = linspace(erbminmax(1), erbminmax(2), M);      % linspace M filters on ERB-scale
cf          = (10.^(cf_erb./21.4)-1)./4.37*1000;            % obtain center frequency in Hz
order       = 4;                                            % order of gammatone filters
h           = realgammatone(f(1:(N/2+1)), cf, order);       % auditory filter responses
h           = h./mean(sum(h(:, round(1+f_min/fs*N):round(1+f_max/fs*N))));

function h = realgammatone(f, f0, order)

h   = zeros(length(f0), length(f));

for i =1:length(f0)
    k       = (2^(order-1)*factorial(order-1)) / (pi*dfactorial(2*order-3));
    h(i, :) = (1 + ((f-f0(i)) ./ (k.*ftoerb(f0(i)))).^2).^(-order/2);
end

function erb = ftoerb(f)
erb = 24.7 * (4.37*(f/1000) + 1);
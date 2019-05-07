%   X  = onethird_analysis(x, N_frame, K, fs) 
%   applies DFT-based gammatone filter bank
%   inputs:
%       x:          audio 
%       N_frame:	Frame size
%       K:          FFT Size
%       fs:         sample rate
%   outputs:
%       X:          filter output

function [X H]  = gt_analysis(x, H, N_frame, K_frame, K)

if nargin==3
    K_frame     = N_frame/2; 
    K           = (size(H, 2)-1)*2; 
end

if nargin==4
    K       = (size(H, 2)-1)*2;   
end


J               = size(H, 1);
x_hat           = stdft(x, N_frame, K_frame, K); 	% apply short-time DFT to clean speech
x_hat           = x_hat(:, 1:(K/2+1)).';         	% take clean single-sided spectrum
X               = zeros(J, size(x_hat, 2));         % init memory for clean speech 1/3 octave band TF-representation 

for j = 1:size(x_hat, 2)
    X(:, j)	= sqrt(H.^2*abs(x_hat(:, j)).^2);          % apply 1/3 octave bands as described in Eq.(1)
end
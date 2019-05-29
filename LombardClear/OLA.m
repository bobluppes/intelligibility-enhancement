function y_out = OLA(x, o, w, tau)
% OLA algorithm as described by J. Driedger 2011

% INPUT
% x - input speech signal
% w - window function
% o - overlap factor
% tau - time-stretch function

% OUTPUT
% y_out - time-scale modified version of x
y = zeros(floor(length(x)*tau),1);

% Compute vector of output window positions gamma
offset = (1 - o) * length(w);
gamma(1) = 1;
for i = 2:(length(y)/offset)
    gamma(i) = gamma(i-1) + offset;
end

% Compute vector of input window positions sigma
sigma = [];
for i = 1:length(gamma)
    sigma(i) = round((1/tau)*gamma(i));
end

% Zero padd input and output signal
x = [zeros(length(w)/2, 1); x; zeros(length(w)/2, 1)];
y = [zeros(length(w)/2, 1); y; zeros(length(w)/2, 1)];

% Overlap and add
for i = 1:length(sigma)
    % Offset sigma and gamma by zero padd
    sigma(i) = sigma(i) + length(w)/2;
    gamma(i) = gamma(i) + length(w)/2;
    
    b_s = round(sigma(i) - (length(w)-1)/2);       % Beginning of sigma frame
    e_s = round(sigma(i) + length(w)/2);           % End of sigma frame
    frame = x(b_s:e_s).*w;                         % Calculate frame
    
    b_g = round(gamma(i) - (length(w)-1)/2);       % Beginning of gamma frame
    e_g = round(gamma(i) + length(w)/2);           % End of gamma frame
    y(b_g:e_g) = y(b_g:e_g) + frame;               % Overlap add
end

% Adjust possible amplitude modulations

% Cutt off zero padd
y_out = y(length(w)/2:end-length(w)/2);
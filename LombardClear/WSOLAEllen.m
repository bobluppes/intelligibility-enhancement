function y_out = WSOLAEllen(x, o, w, tau, deltamax)
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
length(w)/2;
% Zero padd input and output signal
x = [zeros(length(w)/2, 1); x; zeros(length(w)/2, 1)];
y = [zeros(length(w)/2, 1); y; zeros(length(w)/2, 1)];

delta = 0;                                % Shift of the current analysis window position
% volgens mij moet het eerste frame nog apart > loop begint bij 2

% Overlap and add
for i = 2:length(sigma)
    % Offset sigma and gamma by zero padd
    sigma(i) = sigma(i) + length(w)/2;
    gamma(i) = gamma(i) + length(w)/2;
    
    b_s_next = round(sigma(i) - (length(w)-1)/2 - deltamax);       % Beginning of sigma frame
    e_s_next = round(sigma(i) + length(w)/2 + deltamax);           % End of sigma frame
    frame_next = x(b_s_next:e_s_next);                         % Calculate frame
    sigmaaccent = sigma(i-1)+delta+offset;
    frame_adj = x(sigmaaccent - (length(w)-1)/2: sigmaaccent + length(w)/2);
    
    cc = conv(frame_adj(length(frame_adj):-1:1),frame_next);

    % restrict the cross correlation result to just the relevant values.
    % Values outside of this range are related to deltas bigger or smaller
    % than our tolerance allows
    cc = cc(length(w):end - length(w) + 1);
    [~,maxIndex]= max(cc);
    
    delta = deltamax - maxIndex + 1;
    b_s = round(sigma(i) + delta - (length(w)-1)/2);       % Beginning of sigma frame
    e_s = round(sigma(i) + delta + length(w)/2); 
    frame = x(b_s : e_s);
    b_g = round(gamma(i) - (length(w)-1)/2);       % Beginning of gamma frame
    e_g = round(gamma(i) + length(w)/2);           % End of gamma frame
    y(b_g:e_g) = y(b_g:e_g) + frame;               % Overlap add
end

% Adjust possible amplitude modulation

% Cutt off zero padd
y_out = y(length(w)/2:end-length(w)/2);
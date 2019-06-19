% ======================================================================
function [vtf] = vowels_spectral_flatness (X, f_s)
    winlength = 20 *f_s/1000; % samples
    overlap = 0.5;
    frame = buffer(X, winlength, winlength*overlap); %size = winlength*3611
    %%%% ???? Met fft of met timedomain signal?
    %%% Spectral flatness
    frame = frame.^2;
    vtf = geomean(abs(frame))./mean(abs(frame)); 

end

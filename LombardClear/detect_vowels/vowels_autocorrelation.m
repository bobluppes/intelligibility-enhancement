% ======================================================================
function [vtf] = vowels_autocorrelation (X, f_s)
    winlength = 20 *f_s/1000; % samples
    overlap = 0.5;
    frame = buffer(X, winlength, winlength*overlap); %size = winlength*3611
        
    %%% Autocorrelation
    vtf = [];
    for j = 1:size(frame,2)
        [vtf(j,:), lags] = autocorr(frame(:,j),'NumLags',1);
    end
end

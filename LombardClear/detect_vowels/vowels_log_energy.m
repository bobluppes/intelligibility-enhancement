function [vtf] = vowels_log_energy (X, f_s)
    winlength = 20 *f_s/1000; % samples
    overlap = 0.5;
    frame = buffer(X, winlength, winlength*overlap); 
    frame = frame.^2; % energy
    
    %%% log energy
    vtf = log(1/winlength*sum(frame,1)); 
end
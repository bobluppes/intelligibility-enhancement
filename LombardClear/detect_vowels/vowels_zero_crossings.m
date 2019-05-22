function [vtf] = vowels_zero_crossings (X, f_s)
    winlength = 20 *f_s/1000; % samples
    overlap = 0.5;
    frame = buffer(X, winlength, winlength*overlap); %size = winlength*3611

    %%% Zero crossings
    vtf = zeros(size(frame,2));
    for j = 1:size(frame,2)
        for i = 2:winlength
            if (frame(i, j)*frame(i-1,j) < 0)
                vtf(j) = vtf(j) + 1;
            end
        end
    end
end

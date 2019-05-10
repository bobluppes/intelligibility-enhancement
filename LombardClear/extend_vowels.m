function improved = extend_vowels(original, Fs, extension, sampleInt, thres, steps)
improved = [];
for i = 0:(steps - 2)
    % Take timeframe
    x = original(round((i*sampleInt)+1):round((i+1)*sampleInt));
    % Find power in timeframe
    pow = sum(abs(x));
    
    if pow > thres
        % Vowel --> extend
        sound = transpose(slow(x, Fs, extension));
    else
        % Consonant --> keep normal
        sound = x;
    end
    improved = [improved; sound];
end

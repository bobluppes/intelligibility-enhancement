function improved = extend_vowels(original, Fs, extension)
% extension is 1/alpha 
improved = [];
alpha = 1/extension; % delay
nleng = round(5*Fs/1000); %samples
nshift = round(1.25*Fs/1000); %samples
wtype = 1; % Hamming
deltamax = 1.5; %ms

ipause = -1; % >=0 is plot for debug
%% find vowels >> move to vowels_log_energy?
sfn = vowels_log_energy(original, Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i)+6.5)<0) % threshold = -6.5
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;
    end   
end
% vowels is vector with 1 if vowel, 0 if consonant
i=1;
improved = [];
while i <= length(vowels)-1
    section = [];
    is_vowel = vowels(i);
    % make section with all subsequent vowels/consonants
    while (i <= length(vowels)-1) && (vowels(i) == vowels(i+1)) 
        section = [section; original(i)];
        i = i+1;
    end
    % stretch if vowel and append
    if is_vowel == 1
        S = fftshift(fft(section));
        %longer_vowel = wsola_analysis(section,Fs,alpha,nleng,nshift,wtype,deltamax,ipause);
        longer_vowel = OLA(section, 0.5, hann(100), extension);
        L = fftshift(fft(longer_vowel));
        %longer_vowel = longer_vowel*sum(abs(S))/sum(abs(L));
        improved = [improved; longer_vowel];
    % append if consonant
    else
        improved = [improved; section];
    end
    i=i+1;
end

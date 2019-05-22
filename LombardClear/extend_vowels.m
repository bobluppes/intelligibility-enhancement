function improved = extend_vowels(original, Fs, extension, sampleInt, thres, steps)
% extension is 1/alpha 
improved = [];
alpha = 0.8;
nleng = round(5*Fs/1000); %samples
nshift = round(1.25*Fs/1000); %samples
wtype = 1; % Hamming
deltamax = 1.5;%ms

ipause = -1; % >=0 is plot for debug
%% find vowels >> move to vowels_log_energy?
sfn = vowels_log_energy(original, Fs);
vowels = zeros(length(original),1);
frame = round(length(original)/length(sfn));
for i = 1:(length(sfn)-1)
    if ((sfn(i)+6.5)<0)
        vowels((i-1)*frame+1:(i)*frame) = 0;
    else
        vowels((i-1)*frame+1:(i)*frame) = 1;
    end   
end
i=1;
improved = [];
while i <= length(vowels)-1
    section = [];
    is_vowel = vowels(i);
    while (i <= length(vowels)-1) && (vowels(i) == vowels(i+1)) 
        section = [section; original(i)];
        i = i+1;
    end
    if is_vowel == 1
        S = fftshift(fft(section));
        longer_vowel = wsola_analysis(section,Fs,alpha,nleng,nshift,wtype,deltamax,ipause);
        L = fftshift(fft(longer_vowel));
        longer_vowel = longer_vowel*sum(abs(S))/sum(abs(L));
        improved = [improved; longer_vowel];
    else
        improved = [improved; section];
    end
    i=i+1;
end

% for i = 0:(steps - 2)
%     % Take timeframe
%     x = original(round((i*sampleInt)+1):round((i+1)*sampleInt));
%     % Find power in timeframe
%     pow = sum(abs(x));
%     
%     if pow > thres
%         % Vowel --> extend
%         %sound = transpose(slow(x,Fs,extension));
%         sound = wsola_analysis(x,Fs,alpha,nleng,nshift,wtype,deltamax,ipause);
%         I = fftshift(fft(sound));
%         O = fftshift(fft(x));
%         Po = sum(abs(O));
%         Pi = sum(abs(I));
%         a = Po / Pi;
%         sound = sound .* a;
%     else
%         % Consonant --> keep normal
%         sound = x;
%     end
%     improved = [improved; sound];
% end

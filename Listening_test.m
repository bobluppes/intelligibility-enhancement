clear all;
close all

[x,fs] = audioread('maleVoice.wav');
noisepower = 0.07;
noise1 = noisepower*randn(3*length(x), 1);
noise2 = noisepower*zeros(3*length(x),1);
% all test cases
% 1 = vowelstretch
% 2 = Spectral tilt
% 3 = DRC
% 2 noisetypes
% unshuffled = [0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3;
%     1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 ;
%     0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 3 6 9 12 15 18 21 24 27 30 0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 3 6 9 12 15 18 21 24 27 30];
%             
% 
% cols = size(unshuffled,2);
% P = randperm(cols);
% shuffled = unshuffled(:,P);
load('Listening_test_variables.mat')

i=1; 

while i <= length(shuffled)
    if shuffled(1,i) == 0
        sound = x;
    elseif shuffled(1,i) == 1
        sound = extend_vowels(x, fs, shuffled(3,i));
    elseif shuffled(1,i) == 2
        sound = spectral_tilt(x, shuffled(3,i));
    elseif shuffled(1,i) == 3
        sound = compress(x, shuffled(3,i));
    end
    
    if (shuffled(2,i) == 1)
        n = noise1;
    elseif (shuffled(2,i) == 2)
        n = noise2;   
    end
    
    soundsc(sound+n(1:length(sound)),fs);
    i
    figure
    c = uicontrol('Style','pushbutton','String','Option 1','Callback', 'i=i-1');
    uicontrol(c)
    pause;

%         function ButtonPushed(src,event)
%             i=i-1;
%         end

    i = i+1;
%     noise = 0.07*randn(length(Il), 1);
%     ext(i)
%     siib_lombard(i) = SIIB_Gauss(Il, Il+noise, fs)
%     soundsc(Il + noise, fs);
%     pause;
%     if (i ~= 0)
%         duration = length(Il)/fs;
%         answer = inputdlg(prompt);
%         mod(i) = (str2num(answer{1})/duration + str2num(answer{2})/duration)/2;
%     end
end

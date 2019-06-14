clear all;
close all

% Parameters
noisepower = 0.06;
stretch = linspace(1, 3, 20);
tilt = linspace(0, 1, 20);
compression = linspace(0, 30, 20);   

[x,fs] = audioread('F1_b1_w1_orig.wav');

% Create noise
non_fluctuating_noise = noisepower*randn(3*length(x), 1);
fluctuating_noise = [];
for i = 1:length(non_fluctuating_noise)
    fluctuating_noise(i) = (sin(i/5000)) * noisepower*randn(1,1);
end
noise = non_fluctuating_noise(1:length(x));

% Vowel duration NF
lombard_nf_audio = [];
for i = 1:length(stretch)
    j = randi([1 6]);
    lombard_nf_audio(i) = j;
    [x,fs] = audioread(strcat('F1_b1_w',num2str(j),'_orig.wav'));
    
    enhanced = Lombard(x, fs, 10, stretch(i), 0, 0);
    noise = non_fluctuating_noise(1:length(enhanced)); 
    soundsc(enhanced+noise, fs);
    
    figure;
    a = uicontrol('Style', 'text', 'String', 'VOWEL STRETCHING NF');
    a.Position = [100 200 200 20];
    b = uicontrol('Style', 'text', 'String', strcat(num2str(i),'/20'));
    b.Position = [100 180 100 20];
    c = uicontrol('Style','pushbutton','String','Repeat','Callback', 'soundsc(enhanced+noise, fs);');
    c.Position = [100 140 50 20];
    pause;
    close all;
end

% Tilting NF
tilt_nf_audio = [];
for i = 1:length(tilt)
    j = randi([1 6]);
    tilt_nf_audio(i) = j;
    [x,fs] = audioread(strcat('F1_b2_w',num2str(j),'_orig.wav'));
    
    enhanced = Lombard(x, fs, 10, 1, tilt(i), 0);
    noise = non_fluctuating_noise(1:length(enhanced)); 
    soundsc(enhanced+noise, fs);
    
    figure;
    a = uicontrol('Style', 'text', 'String', 'SPECTRAL TILTING NF');
    a.Position = [100 200 200 20];
    b = uicontrol('Style', 'text', 'String', strcat(num2str(i),'/20'));
    b.Position = [100 180 100 20];
    c = uicontrol('Style','pushbutton','String','Repeat','Callback', 'soundsc(enhanced+noise, fs);');
    c.Position = [100 140 50 20];
    pause;
    close all;
end

% Compression NF
compress_nf_audio = [];
for i = 1:length(compression)
    j = randi([1 6]);
    compress_nf_audio(i) = j;
    [x,fs] = audioread(strcat('F1_b3_w',num2str(j),'_orig.wav'));
    
    enhanced = Lombard(x, fs, 10, 1, 0, compression(i));
    noise = non_fluctuating_noise(1:length(enhanced)); 
    soundsc(enhanced+noise, fs);
    
    figure;
    a = uicontrol('Style', 'text', 'String', 'COMPRESSION NF');
    a.Position = [100 200 200 20];
    b = uicontrol('Style', 'text', 'String', strcat(num2str(i),'/20'));
    b.Position = [100 180 100 20];
    c = uicontrol('Style','pushbutton','String','Repeat','Callback', 'soundsc(enhanced+noise, fs);');
    c.Position = [100 140 50 20];
    pause;
    close all;
end

% Vowel duration F
lombard_f_audio = [];
for i = 1:length(stretch)
    j = randi([1 6]);
    lombard_f_audio(i) = j;
    [x,fs] = audioread(strcat('F1_b4_w',num2str(j),'_orig.wav'));
    
    enhanced = Lombard(x, fs, 10, stretch(i), 0, 0);
    noise = transpose(fluctuating_noise(1:length(enhanced))); 
    soundsc(enhanced+noise, fs);
    
    figure;
    a = uicontrol('Style', 'text', 'String', 'VOWEL STRETCHING F');
    a.Position = [100 200 200 20];
    b = uicontrol('Style', 'text', 'String', strcat(num2str(i),'/20'));
    b.Position = [100 180 100 20];
    c = uicontrol('Style','pushbutton','String','Repeat','Callback', 'soundsc(enhanced+noise, fs);');
    c.Position = [100 140 50 20];
    pause;
    close all;
end

% Tilting F
tilt_f_audio = [];
for i = 1:length(tilt)
    j = randi([1 6]);
    tilt_f_audio(i) = j;
    [x,fs] = audioread(strcat('F1_b5_w',num2str(j),'_orig.wav'));
    
    enhanced = Lombard(x, fs, 10, 1, tilt(i), 0);
    noise = transpose(fluctuating_noise(1:length(enhanced))); 
    soundsc(enhanced+noise, fs);
    
    figure;
    a = uicontrol('Style', 'text', 'String', 'SPECTRAL TILTING F');
    a.Position = [100 200 200 20];
    b = uicontrol('Style', 'text', 'String', strcat(num2str(i),'/20'));
    b.Position = [100 180 100 20];
    c = uicontrol('Style','pushbutton','String','Repeat','Callback', 'soundsc(enhanced+noise, fs);');
    c.Position = [100 140 50 20];
    pause;
    close all;
end

% Compression F
compress_f_audio = [];
for i = 1:length(compression)
    j = randi([1 6]);
    compress_f_audio(i) = j;
    [x,fs] = audioread(strcat('F1_b6_w',num2str(j),'_orig.wav'));
    
    enhanced = Lombard(x, fs, 10, 1, 0, compression(i));
    noise = transpose(fluctuating_noise(1:length(enhanced))); 
    soundsc(enhanced+noise, fs);
    
    figure;
    a = uicontrol('Style', 'text', 'String', 'COMPRESSION F');
    a.Position = [100 200 200 20];
    b = uicontrol('Style', 'text', 'String', strcat(num2str(i),'/20'));
    b.Position = [100 180 100 20];
    c = uicontrol('Style','pushbutton','String','Repeat','Callback', 'soundsc(enhanced+noise, fs);');
    c.Position = [100 140 50 20];
    pause;
    close all;
end

return; 

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

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
Pn = sqrt(sum(non_fluctuating_noise.^2));
Pf = sqrt(sum(fluctuating_noise.^2));
a = Pn ./ Pf;
fluctuating_noise = fluctuating_noise .* a;

[example,fs] = audioread('B1.wav');
soundsc(example, fs);
pause;
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

[example,fs] = audioread('B2.wav');
soundsc(example, fs);
pause;
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

[example,fs] = audioread('B3.wav');
soundsc(example, fs);
pause;
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

[example,fs] = audioread('B4.wav');
soundsc(example, fs);
pause;
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

[example,fs] = audioread('B5.wav');
soundsc(example, fs);
pause;
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

[example,fs] = audioread('B6.wav');
soundsc(example, fs);
pause;
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

[music, fs] = audioread('Noorderlicht.wav');
soundsc(music, fs);
pause;

[example,fs] = audioread('B4.wav');
soundsc(example, fs);
pause;
% Vowel duration NF
lombard_nf_audio2 = [];
for i = 1:length(stretch)
    j = randi([1 6]);
    lombard_nf_audio2(i) = j;
    [x,fs] = audioread(strcat('F1_b4_w',num2str(j),'_orig.wav'));
    
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

[example,fs] = audioread('B5.wav');
soundsc(example, fs);
pause;
% Tilting NF
tilt_nf_audio2 = [];
for i = 1:length(tilt)
    j = randi([1 6]);
    tilt_nf_audio2(i) = j;
    [x,fs] = audioread(strcat('F1_b5_w',num2str(j),'_orig.wav'));
    
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

[example,fs] = audioread('B6.wav');
soundsc(example, fs);
pause;
% Compression NF
compress_nf_audio2 = [];
for i = 1:length(compression)
    j = randi([1 6]);
    compress_nf_audio2(i) = j;
    [x,fs] = audioread(strcat('F1_b6_w',num2str(j),'_orig.wav'));
    
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

[example,fs] = audioread('B1.wav');
soundsc(example, fs);
pause;
% Vowel duration F
lombard_f_audio2 = [];
for i = 1:length(stretch)
    j = randi([1 6]);
    lombard_f_audio2(i) = j;
    [x,fs] = audioread(strcat('F1_b1_w',num2str(j),'_orig.wav'));
    
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

[example,fs] = audioread('B2.wav');
soundsc(example, fs);
pause;
% Tilting F
tilt_f_audio2 = [];
for i = 1:length(tilt)
    j = randi([1 6]);
    tilt_f_audio2(i) = j;
    [x,fs] = audioread(strcat('F1_b2_w',num2str(j),'_orig.wav'));
    
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

[example,fs] = audioread('B3.wav');
soundsc(example, fs);
pause;
% Compression F
compress_f_audio2 = [];
for i = 1:length(compression)
    j = randi([1 6]);
    compress_f_audio2(i) = j;
    [x,fs] = audioread(strcat('F1_b3_w',num2str(j),'_orig.wav'));
    
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

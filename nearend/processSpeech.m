function xn = processSpeech(x, y, fs, dly)

%   xn = processSpeech(x, y, fs, dly) applies a speech pre-processing 
%   strategy to improve the speech intelligibility in noise for the 
%   near-end listener. The algorithm improves the intelligibility by 
%   optimally redistributing the speech energy over time and frequency for
%   a perceptual distortion measure, which is based on a spectro-temporal
%   auditory model.
%
%      Taal, C. H., R. C. Hendriks, and R. Heusdens, "A Speech 
%      Preprocessing Strategy For Intelligibility Improvement In Noise 
%      Based On A Perceptual Distortion Measure", ICASSP 2012, Kyoto, 
%      Japan.
%
%   Copyright 2012: Cees Taal. The software is free for non-commercial use. 
%   This program comes WITHOUT ANY WARRANTY.

%% add paths relevant for spectro-temporal distortion measure and noise tracker
addpath('auditorymodel');
addpath('general');
addpath(genpath('noisetracker_hendriks'));

%% make sure we work with column vectors
N_original      = length(x);            % processed speech length will be quantized to frame time-scale, will be changed to original length
x               = x(:);
y               = y(:);
n               = y-x;

%% initialize algorithm parameters
gamma           = 0.9;  % smoothing parameter
range           = 25;   % dynamic range of voice activity detector

%% frame overlap parameters
N1            	= round(32/1000*fs/2)*2;    % frame length in samples corresponding to 32 ms
K1            	= N1/2;                     % 50% overlap
w1              = hanning(N1);              % analysis window
frames1        	= 1:K1:(length(x)-N1+1);    % index used in looping all short-time frames

%% block overlap parameters
if dly == -1                                                % PROP1
    N2              = length(frames1);
    K2              = N2/2;
    w2              = ones(N2*K1+K1, 1);
    frames2         = length(frames1);
elseif dly == -2                                            % PROP2
    N2              = 1;
    K2              = 1;
    w2              = ones(N2*K1+K1, 1);
    frames2         = N2:K2:length(frames1);
else                                                        % variable block length
    N2              = round(((dly*fs/1000)/K1-1)/2)*2;
    K2              = N2/2;
    w2              = hanning(N2*K1+K1);
    frames2         = N2:K2:length(frames1);
end


%% init perceptual model
cutoff          = 125;                                  % cutoff frequency of auditory model
M               = 40;                                   % number of auditory filters
p               = taa_getParameters(fs, cutoff, M, N1);

%% init voice activity detector
xrms_te      	= getTF(x, N1, K1, p);
mx              = max(xrms_te).';

%% init noise tracker
dat             = initEstimates(w1, N1, p);
pnn             = mean(noise_psd_tracker(x, y, fs, N1, K1, N1), 2)/norm(sqrt(hanning(N1)))^2;
sigma_hend   	= p.h.^2*dsided(pnn)./sum(p.h.^2, 2);
data.noise_psd 	= init_noise_tracker_ideal_vad(y, N1, N1, K1, w1); % This function computes the initial noise PSD estimate.
data.min_mat  	= zeros(N1/2+1,floor(0.8*fs/K1));

%% start processing
xn              = zeros(size(x));
xrms            = zeros(M, length(frames1));
d               = zeros(M, length(frames1));
vad             = false(M, length(frames1));
j               = 1;
i_cnt           = 1;
a_old_block     = ones(M, 1);

for i = 1:length(frames1)
    %-- index range for current time-frame
    ii                          = frames1(i):(frames1(i)+N1-1);  
    
    %-- obtain average distortions for unprocessed speech
    [d(:, i) xrms(:, i)]  	= taa_di(x(ii).*w1, dat, p);
    d(:, i)                 = d(:, i).*sigma_hend;
    
    %-- apply voice activity detector
    vad(:, i)                   = xrms(:, i)./mx > 10^(-range/20);
    
    %-- process block
	if i==frames2(j)
        jj  = (frames2(j)-N2+1):frames2(j);
        
        %-- obtain alpha
        a_b         = ones(M, N2);
        xrms_b      = xrms(:, jj);
        d_b         = d(:, jj);
        vad_b       = vad(:, jj);
        numFr       = sum(vad_b(:));
        r           = numFr.*rms(xrms_b(vad_b)).^2;    
        beta        = (d_b(vad_b)./xrms_b(vad_b).^2).^(1/4);
        a_b(vad_b)	= sqrt(r.*beta.^2./sum(beta.^2.*xrms_b(vad_b).^2));

        a_          = a_b;
   
        %-- synthesise block of speech
        jjj         = frames1(i-N2+1):(frames1(i)+N1-1);
        xb          = x(jjj);
        nb          = n(jjj);
        xnb         = zeros(size(xb));
        frames3   	= 1:K1:(length(xb)-N1+1);
        
        a_old       = a_old_block;

        for k = 1:length(frames3)
            %- apply smoothing
            a_new       = a_old*gamma+a_(:, k)*(1-gamma);
            a_old       = a_new;
            kk          = frames3(k):(frames3(k)+N1-1);
            xbf         = xb(kk).*sqrt(w1);
            xbrf     	= taa_synth(xbf, a_new, p);
            xnb(kk)     = xnb(kk)+sqrt(w1).*xbrf;
            
            
            if k<=(K2+1)
                a_old_block             = a_old;
                data.I                  = i_cnt;
                data                    = noise_psd_tracker_frame(xb(kk).*sqrt(w1), nb(kk).*sqrt(w1), fs, N1, K1, N1, data);
                sigma_hend2(:, i_cnt)	= p.h.^2*dsided(data.noise_psd./norm(sqrt(hanning(N1)))^2)./sum(p.h.^2, 2);
                a__(:, i_cnt)           = a_new;
                i_cnt                   = i_cnt+1;
            end      
        end
        
        sigma_hend  = sigma_hend2(:, i_cnt-1);
        
        
        %-- overlap-add block
        if rms(xb)
            xnb         = xnb./norm(xnb)*norm(xb);
        end
        xn(jjj)     = xn(jjj) + xnb.*w2;
        
        %-- increment to next block
        j = j+1;
    end
    
    if j>length(frames2)
        break
    end
end

%- normalize signals to original length and rms
x   = x(1:N_original);
xn  = xn(1:N_original);
xn 	= xn./norm(xn)*norm(x);
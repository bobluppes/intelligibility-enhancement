function [ noise_psd_mat]=noise_psd_tracker(clean, noisy, fs, N, K, N_fft)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file containes an implementation of the noise PSD tracker
%%%%presented in the article: "MMSE BASED NOISE PSD TRACKING WITH LOW COMPLEXITY", by R. C.  Hendriks, R. Heusdens and J. Jensen published at the 
%%%%IEEE International Conference on Acoustics, Speech and Signal
%%%%Processing, 03/2010, Dallas, TX, p.4266-4269, (2010).
%%%%Input parameters:   noisy:  noisy signal
%%%%                    fs:     sampling frequency
%%%%                   
%%%%Output parameters:  noise_psd_mat:  matrix with estimated noise PSD for
%%%%                    each frame
%%%%                    clean_est:      estimated clean signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%copyright: Delft university of Technology
%%%%%%%%%%%%%%%%%%%%%
% addpath(fullfile(cd,filesep,'TabGenGam',filesep));
MIN_GAIN                = eps;
gamma                   = 1;
nu                      = 0.6;
[g_dft,g_mag,g_mag2]    = Tabulate_gain_functions(gamma,nu); %% tabulate the gain function used laater on
%%
%%%%%%%%%addpath:::
ORDIR                   = cd;
ALPHA                   = 0.98; %% this is the smoothing factor used in the decision directed approach
SNR_LOW_LIM             = eps;
clean_est_dft_frame     = [];
 

% fr_size     = 256*fs/8000;  % frame size
% hop         = fr_size/2;        % hop size
% fft_size    = fr_size;

fr_size     = N;
hop         = K;
fft_size    = N_fft;
M           = floor((length(noisy) - 2*fr_size)/hop); % number of frames

%%%%%%%%%inital noise estimate;
 
window      = sqrt(hanning(fr_size)); %analysis and synthesis window
 
noise_psd   = init_noise_tracker_ideal_vad(noisy, fr_size, fft_size, hop, window); % This function computes the initial noise PSD estimate. It is assumed
                                                                                    % that the first 5 time-frames are noise-only.    
noise_psd_mat(:,1)  = noise_psd;
min_mat             = zeros(fft_size/2+1,floor(0.8*fs/hop));

for I=1:M
    indices                             =  (I-1)*hop+1:(I-1)*hop+fr_size;
    noisy_frame                         = window.*noisy(indices);
    noisy_dft_frame                     = fft(noisy_frame,fft_size);
    noisy_dft_frame                     = noisy_dft_frame(1:fft_size/2+1);
    
    speech_psd                          = abs(fft(window.*clean(indices))).^2;
    speech_psd                          = speech_psd(1:fft_size/2+1);
    
    [a_post_snr_bias a_priori_snr_bias] = estimate_snrs_bias(noisy_dft_frame,fft_size ,noise_psd, SNR_LOW_LIM,  ALPHA  ,I,clean_est_dft_frame)   ;
%     speech_psd                          = a_priori_snr_bias.*noise_psd;
    [noise_psd ]                        = noise_psdest(noisy_dft_frame, I, speech_psd,noise_psd);

    dump_vec                            = abs(  noisy_dft_frame).^2;
    min_mat                             = [min_mat(:,end-floor(0.8*fs/hop)+2:end), dump_vec(1:fft_size/2+1)    ];
    noise_psd                           = max(noise_psd,min(min_mat,[],2));
	noise_psd_mat(:,I)                  = noise_psd;
    [a_post_snr, a_priori_snr]          = estimate_snrs(noisy_dft_frame,fft_size, noise_psd,SNR_LOW_LIM,  ALPHA   ,I,clean_est_dft_frame)   ;
    [gain]                              = lookup_gain_in_table(g_mag,a_post_snr,a_priori_snr,-40:1:50,-40:1:50,1);
    gain                                = max(gain,MIN_GAIN);
	clean_est_dft_frame                 = gain.*noisy_dft_frame(1:fft_size/2+1);
end



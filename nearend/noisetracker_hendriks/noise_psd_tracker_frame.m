function data_out = noise_psd_tracker_frame(enh_frame, noisy_frame, fs, N, K, N_fft, data)
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

noise_psd               = data.noise_psd;
min_mat                 = data.min_mat;
I                       = data.I;

% fr_size     = 256*fs/8000;  % frame size
% hop         = fr_size/2;        % hop size
% fft_size    = fr_size;

fr_size     = N;
hop         = K;
fft_size    = N_fft;

%inital noise estimate;
noisy_dft_frame   	= fft(noisy_frame,fft_size);
noisy_dft_frame   	= noisy_dft_frame(1:fft_size/2+1);

speech_psd       	= abs(fft(enh_frame)).^2;
speech_psd      	= speech_psd(1:fft_size/2+1);
[noise_psd ]        = noise_psdest(noisy_dft_frame, I, speech_psd,noise_psd);

dump_vec         	= abs(noisy_dft_frame).^2;
min_mat             = [min_mat(:,end-floor(0.8*fs/hop)+2:end), dump_vec(1:fft_size/2+1)];
noise_psd          	= max(noise_psd,min(min_mat,[],2));

data_out.noise_psd	= noise_psd;
data_out.min_mat 	= min_mat;
function        [a_post_snr_bias,a_priori_snr_bias]=estimate_snrs_bias(noisy_dft_frame,fft_size ,noise_psd, SNR_LOW_LIM,  ALPHA  ,I,clean_est_dft_frame)   ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file estimates the a priori SNR before bias compensation
%%%%
%%%%Input parameters:   noisy_dft_frame:    noisy DFT frame
%%%%                    fft_size:           fft size 
%%%%                    noise_psd:          estimated noise PSD of previous frame, 
%%%%                    SNR_LOW_LIM:        Lower limit of the a priori SNR
%%%%                    ALPHA:              smoothing parameter in dd approach ,
%%%%                    I:                  frame number 
%%%%                    clean_est_dft_frame:estimated clean frame of frame
%%%%                                         I-1
%%%%                   
%%%%Output parameters:  a_post_snr_bias:    a posteriori SNR before bias
%%%%                                        compensation
%%%%                    a_priori_snr_bias: estimated a priori SNR before bias
%%%%                    compensation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%copyright: Delft university of Technology
%%%%%%%%%%%%%%%%%%%%%
 a_post_snr_bias =  noisy_dft_frame(1:fft_size/2+1).*conj(noisy_dft_frame(1:fft_size/2+1))./(noise_psd(1:fft_size/2+1));%a posteriori SNR
if I==1,
    % Initial estimation of apriori SNR (first frame)
    % =================================
   
                  a_priori_snr_bias=max( a_post_snr_bias-1,SNR_LOW_LIM);
else
    % Estimation of apriori SNR
    %       =========================
       a_priori_snr_bias=max(ALPHA*(abs(  clean_est_dft_frame(1:fft_size/2+1)).^2)./(   noise_psd(1:fft_size/2+1))+(1-ALPHA)*(a_post_snr_bias-1),SNR_LOW_LIM);
end
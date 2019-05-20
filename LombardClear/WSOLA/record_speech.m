function [y,yn]=record_speech(fs,nsec)
% record speech file of a given duration (nsec) and a given sampling rate
% (fs)
%
% Inputs:
%   fs=sampling frequency in Hz
%   nsec=number of seconds of recording
% Outputs:
%   y=speech samples normalized to 32767
%   yn=speech samples normalized to 1

% N is the number of samples in each speech file
% ch is the number of channels in the recording
        N=fs*nsec;
        ch=1;
        y=wavrecord(N,fs,ch,'double');
        fprintf('recording complete: \n');
        
% play out recorded waveform
        soundsc(y,fs);
        
% calculate dc offset and correct
        offset=sum(y(N-999:N))/1000;
        y=y-offset;
        % fprintf('offset: %f \n',offset);
        yn=y/max(max(y),-min(y));
end
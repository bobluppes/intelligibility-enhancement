% pathnew_matlab_central
%

% path-to-speech: starting directory definition
path-to-speech='C:\data\matlab_central_speech'

% paths to GUI toolkit
path(strcat(path-to-speech,'\gui_lite_2.6\GUI Lite v2.6'),path);

% paths to speech toolkit
path(strcat(path-to-speech,'\functions_lrr'),path);
path(strcat(path-to-speech,'\speech_files'),path);

% path to highpass filter mat files
path(strcat(path-to-speech,'\highpass_filter_signal'),path);

% path to cepstral coefficient training files
path(strcat(path-to-speech,'\VQ'),path);

% path to cepstral coefficients
path(strcat(path-to-speech,'\cepstral coefficients'),path);

% path to lrr isolated digit files set for training and testing
path(strcat(path-to-speech,'\isolated_digit_files\testing set'),path);
path(strcat(path-to-speech,'\isolated_digit_files\training set'),path);
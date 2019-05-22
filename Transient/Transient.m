function AudioOut = Transient(x, fs)

% Parameters
amplification = 12;
band = 216;

trans = transient_process(x, fs, band);
AudioOut = transient_amplify(x, trans, amplification);


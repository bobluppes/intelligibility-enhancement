function y = transient_optimal(x, fs)

band = 216;
amplification = 12;

trans = transient_process(x, fs, band);
y = transient_amplify(x, trans, amplification);
function AudioOut = transient_amplify(original, trans, amplification)
% Amplify transient signal and add to original
trans = trans * amplification;
improved = original + trans;

% Normalize energy
Po = sqrt(sum(original.^2));
Pi = sqrt(sum(improved.^2));
a = Po ./ Pi;
AudioOut = improved .* a;
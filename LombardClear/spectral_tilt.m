function [Pv_old, Pv_t, y] = spectral_tilt(x, fs)
% Based on Jokinen et al.

% Parameters
FrameRate = 10e-3;

% Time decomposition
Duration = length(x)/fs;
Frames = floor(Duration / FrameRate) + 1;
Samples = round(FrameRate * fs);

%frequency response of a filter with differencial equation  y[n]=x[n]-0.95*x[x-1]
h=[1 -0.95]; 

% Zero crossings function
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);

Pv_t = [];
improved = [];
for i = 1:Frames
   % Take timeframes
   start = (i-1)*Samples+1;
   stop = i*Samples;
   if stop > length(x)
       stop = length(x);
   end
   x_t = x(start:stop); 
   
   % Probability of voicing
   rms_t = rms(x_t);
   zero_crossings = length(zci(x_t));
   if zero_crossings == 0
       zero_crossings = 1;
   end
   Pv_t(i) = rms_t / zero_crossings;
   
   % Pre-emphasis filter
   y_t = filter(h,1,x_t);
   improved = [improved; y_t];
end

% Normalize probability of voicing
Pv_old = Pv_t;
alpha = 1/max(Pv_t);
Pv_t = Pv_t .* alpha;

% Normalize power
Po = sum(abs(x));
Pi = sum(abs(improved));
a = Po / Pi;
improved = improved .* a;

y = improved;


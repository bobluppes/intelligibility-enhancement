function y = spectral_tilt(x, a)

%frequency response of a filter with differential equation  y[n]=x[n]-a*x[n-1]
h=[1 -a]; 

improved = filter(h,1,x);

% Normalize power
Po = sum(abs(x));
Pi = sum(abs(improved));
a = Po / Pi;
y = improved .* a;


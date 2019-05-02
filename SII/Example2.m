% Example 2
%
% Consider the following communication situation:
% A talker and a listener face each other and are 1m appart. There is a
% background of white noise and the talker shouts. 
% Calculate the SII for this communicaiton situation as a function of
% noise level when the listener wears hearing protection and when he
% does not wear hearing protection.
%
% Assumptions:
% Attenuation of Elvex Blue (TM) Foam Ear Plugs as listed on the companie's 
% web site (interpolated onto standard 1/3 oct band frequencies) 

A = [36.1 37.0 38.0 37.7 37.4 37.2 37.0 36.9 36.7 36.4 36.1 35.8, ...
     38.0 40.3 40.7 41.0 41.5 42.5]; % dB

% relative spectral density level of white noise (a flat spectrum):
N = zeros(1,18);
% Absolute spectral density level
AbsLev = [0:2:80];
   
% binaural listening.
b = 2;

S = []; Sp = [];
for k = 1:length(AbsLev)
    
    % No hearing protection
    [En,Nn] = Input_5p1('E','shout','b',b,'N',N+AbsLev(k));
    S(k)    = SII('E',En,'N',Nn);

    % With hearing protection
    [Ep,Np] = Input_5p1('E','shout','b',b,'N',N+AbsLev(k),'G',-A);
    Sp(k)   = SII('E',Ep,'N',Np);

end

plot(AbsLev,S,'o-b',AbsLev,Sp,'x-r');
grid on
title('SII in noise with and w/o hearing protection')
xlabel('Spectral Density Level of White Noise [dB]')
ylabel('SII')
legend('No hearing protection','Foam Ear Plugs','Location','SouthWest')
axis([0 80 0 1])

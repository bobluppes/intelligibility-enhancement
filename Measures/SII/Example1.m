% Example 1: 
%
% Talker and listener are facing each other in a free field. There is no
% background noise. Calculate the SII as a function of the distance between
% the talker and the listener. 
%
% Assumptions:
% Talking effort: "normal" and "shouted" speech
% Importance function of "average speech" (default) 
% Hearing threshold is 0dB HL (normal hearing -- default)
b = 2;                  % binaural listening
d = [0.5:0.5:20];       % distances from 0.5m to 20m (0.5m increments)

Sn = []; Ss = [];       
for k = 1:length(d)
    
    % Normal vocal effort
    [En,Nn,Tn] = Input_5p1('E','normal','b',b,'d',d(k));
    Sn(k) = SII('E',En,'N',Nn,'T',Tn);
    
    % Shouted speech
    [Es,Ns,Ts] = Input_5p1('E','shout','b',b,'d',d(k));
    Ss(k) = SII('E',Es,'N',Ns,'T',Ts);
end

plot(d,Sn,'o-b',d,Ss,'x-r');
grid on
title('SII in quiet free-field')
xlabel('Distance between talker and listener [m]')
ylabel('SII')
legend('normal vocal effort','shouted speech','Location','SouthWest')
axis([0.4 20.1 0 1])

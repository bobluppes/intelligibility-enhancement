function [E,N,T] = Input_5p1(varargin);

% Implementation of Section 5.1 of ANSI S3.5-1997
% "Determination of equivalent speech, noise, and threshold spectrum levels: method
% based on the direct measurement/estimation of noise and speech spectrum levels
% at the listener's position."
%
% The output produced by this function is intended to be passed to the script "sii.m".
%
% Parameters are passed to the procedure through pairs of "identifier" and corresponding "argument"
% Identifiesrs are always strings. Possible identifiers are:
%
%     'E' Speech Spectrum Level [dB SPL] (see details below, Section 3.6)
%     'N' Noise Spectrum Level at the listener's position [dB SPL] (Section 3.13 and Section 5.1.4)
%     'G' Insertion Gain [dB] (Section 3.28)
%     'd' Distance from the speech source to the listener's head [meters] (Section 3.32 and Eq 16)
%     'T' Hearing Threshold Level [dB HL] (Section 3.22)
%     'b' Monaural Listening? b = 1 --> monaural, b = 2 --> Binaural
%
%
% Except for 'E', which must be specified, all parameters are optional. If an identifier is not specified a default value will be used. 
% Paires of identifier and argument can occur in any order. However, if an identifier is listed, it must be followed immediately by its argument.
%
%
% Possible arguments for the identifiers are:
%
%   Arguments for 'E': 
%       (a) String arguments use the "standard speech spectrum level for the stated vocal effort" as
%           defined in Table 3 of the standard.
%                       'normal'
%                       'raised'
%                       'loud'
%                       'shout'
%           These levels assume the reference communication condition (talker 1 meter in front of listener). 
%           Use the parameter 'd' to specify different distantces.
%
%       (b) A row or column vector with 18 numbers stating the speech spectrum levels in dB SPL at the listener's position in bands 1 through 18.
%           The parameter 'd', if specified, will be ignored and a warning message is printed.
%
%   Arguments for 'N': 
%           A row or column vector with 18 numbers stating the Noise Spectrum Levels in dB SPL at the listener's position in bands 1 through 18.
%           If this identifier is omitted, a default Equivalent Noise Spectrum Level of -50 dB is assumed in all 18 bands (see note in Section 4.2).
%
%   Arguments for 'T': 
%           A row or column vector with 18 numbers stating the Hearing Threshold Levels in dBHL in bands 1 through 18.
%           If this identifier is omitted, a default Equivalent Hearing Threshold Level of 0 dBHL is assumed in all 18 bands .
%
%   Arguments for 'G': 
%           A row or column vector with 18 numbers stating the Insertion Gain in dB in bands 1 through 18.
%           If this identifier is omitted, a default Insertion Gain of 0 dB is assumed in all 18 bands.
% 
%   Arguments for 'd': 
%           A positive scalar, stating the distance between the sound source and the listener's head (meters). If omitted the distance for 
%           the reference communication situation (1 meter) is assumed. This parameter is valid only when 'E' is specified as the "standard speech
%           spectrum level for the stated vocal effort", i.e., according to clause (a) in the specification of "E"; it will be ignored otherwise.
%
%   Arguments for 'b': 
%           A scalar, having a value of either 1 or 2, indicating the listening mode: b = 1 --> monaural listening, b = 2 --> binaural listening
%           If this identifier is omitted, monaural listening is assumed.
%
% Hannes Muesch, 2003 - 2005

[x,Nvar] = size(varargin);
CharCount = 0;
Ident = [];
for k = 1:Nvar
    if ischar(varargin{k})&(length(varargin{k})==1)
        CharCount = CharCount + 1;
        Ident = [Ident; k];
    end
end
if Nvar/CharCount ~= 2
    error('Every input must be preceeded by an identifying string')
else
    for n = 1:length(Ident)
        if upper(varargin{Ident(n)}) == 'N'     % Noise Spectrum Level at the listener's position (3.15)
            N = varargin{Ident(n)+1};
        elseif upper(varargin{Ident(n)}) == 'E' % Speech Spectrum Level (3.6)
            E = varargin{Ident(n)+1};
        elseif upper(varargin{Ident(n)}) == 'D' % Distance between source and listener
            d = varargin{Ident(n)+1};
        elseif upper(varargin{Ident(n)}) == 'G' % Insertion Gain
            G = varargin{Ident(n)+1};
        elseif upper(varargin{Ident(n)}) == 'T' % Hearing Threshold Level
            T = varargin{Ident(n)+1};
        elseif upper(varargin{Ident(n)}) == 'B' % Monaural (1) or Binaural (2) listening ?
            M = varargin{Ident(n)+1};
        else
            error('Only ''E'', ''N'', ''G'', ''T'', ''b'', and ''d'' are valid identifiers');
        end;
    end;
end;


% DERIVE EQUIVALENT SPEECH SPECTRUM LEVEL
if isempty(who('E'))
    error('The Speech Spectrum Level, ''E'', must be specified')
end

if ischar(E) 
    E = SpeechSptr(E);                      % Standard spectra are used
    if isempty(who('d'))
        d = 1;                              % Reference communication situation assumed
    end
    if isempty(who('G'))
        G = zeros(1,18);
    else
        G = G(:)';
    end
    E = E - 20*log10(d) + G;                % Eq. 16
else
    E = E(:)';                              % Speech Spectrum directly measured at listener's head
    if isempty(who('G'))
        G = zeros(1,18);
    else
        G = G(:)';
    end
    E = E + G;                              % Eq. 17
    if ~isempty(who('d'))
        disp('WARNING: Distance parameter is inappropriately specified and was ignored!');
    end
    
end;

% DERIVE EQUIVALENT NOISE SPECTRUM LEVEL
if isempty(who('N'))
    N = -50*ones(1,18);
else
    N = N(:)' + G;                          % Eq. 18
end

% DERIVE EQUIVALENT HEARING THRESHOLD LEVEL
if isempty(who('T'))
    T = zeros(1,18);
end

if isempty(who('M'))
    M = 1;                                  % Default to monaural listening
else
    if ~((M==1)|(M==2))
        error('Invalid value of ''M'' specified!')
    end
end

if M==2                                     % Binaural listening
    T = T - 1.7;                            % Section 5.1.5
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                           PRIVATE FUNCTIONS                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function E = SpeechSptr(VclEfrt);
% This function returns the standard speech spectrum level from Table 3

Ei=[32.41	33.81	35.29	30.77;
    34.48	33.92	37.76	36.65;
    34.75	38.98	41.55	42.5;
    33.98	38.57	43.78	46.51;
    34.59	39.11	43.3	47.4;
    34.27	40.15	44.85	49.24;
    32.06	38.78	45.55	51.21;
    28.3	36.37	44.05	51.44;
    25.01	33.86	42.16	51.31;
    23		31.89	40.53	49.63;
    20.15	28.58	37.7	47.65;
    17.32	25.32	34.39	44.32;
    13.18	22.35	30.98	40.8;
    11.55	20.15	28.21	38.13;
    9.33	16.78	25.41	34.41;
    5.31	11.47	18.35	28.24;
    2.59	7.67	13.87	23.45;
    1.13	5.07	11.39	20.72];

switch lower(VclEfrt)
case 'normal', E = Ei(:,1)';
case 'raised', E = Ei(:,2)';
case 'loud',   E = Ei(:,3)';
case 'shout',  E = Ei(:,4)';
otherwise, error('Identifyer string to ''E'' not recognized')
end;

% EOF

function WSOLA_GUI25
% Modifiable runGUI file
clc;
clear all;

% USER - ENTER FILENAME
fileName = 'WSOLA.mat';    
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

% %SENSE COMPUTER AND SET FILE DELIMITER
% switch(computer)				
%     case 'MACI64',		char= '/';
%     case 'GLNX86',  char='/';
%     case 'PCWIN',	char= '\';
%     case 'PCWIN64', char='\';
%     case 'GLNXA64', char='/';
% end

% % find speech files directory by going up one level and down one level
% % on the directory chain; as follows:
%     dir_cur=pwd; % this is the current Matlab exercise directory path 
%     s=regexp(dir_cur,char); % find the last '\' for the current directory
%     s1=s(length(s)); % find last '\' character; this marks upper level directory
%     dir_fin=strcat(dir_cur(1:s1),'speech_files'); % create new directory
%     start_path=dir_fin; % save new directory for speech files location

% USER - ENTER PROPER CALLBACK FILE
Callbacks_WSOLA_GUI25(f,temp);    
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% GUI Lite 2.5 for WSOLA_LRR
% 2 Panels
%   #1 - input parameters
%   #2 - graphics displays
% 3 Graphic Panels
%   #1 - debug waveforms
%   #2 - original speech
%   #3 - speeded-up or slowed-down speech
% 1 TitleBox
% 14 Buttons
%   #1 - pushbutton - Speech Directory
%   #2 - popupmenu - Speech Files
%   #3 - editable button - nsec: number of seconds to record
%   #4 - editable button - fsr: recording sampling rate
%   #5 - pushbutton - Record Speech
%   #6 - editable button - Lm: analysis frame length in msec
%   #7 - editable button - Rm: analysis frame shift in msec
%   #8 - editable button - deltamax: maximum frame deviation in msec for match
%   #9 - popupmenu - window type (HW/Triangular/RW)
%   #10 - editable button - ipause: -1 for normal operation, 0 for debug
%   #11 - editable button - alpha: speed-up for alpha > 1; slowdown for
%   alpha < 1
%   #12 - pushbutton - Run WSOLA
%   #13 - pushbutton - Play Original/WSOLA/Original
%   #14 - pushbutton - Close GUI
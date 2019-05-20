function Callbacks_WSOLA_GUI25(f,C)


%SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=C{1,1};
y=C{1,2};
a=C{1,3};
b=C{1,4};
u=C{1,5};
v=C{1,6};
m=C{1,7};
n=C{1,8};
lengthbutton=C{1,9};
widthbutton=C{1,10};
enterType=C{1,11};
enterString=C{1,12};
enterLabel=C{1,13};
noPanels=C{1,14};
noGraphicPanels=C{1,15};
noButtons=C{1,16};
labelDist=C{1,17};%distance that the label is below the button
noTitles=C{1,18};
buttonTextSize=C{1,19};
labelTextSize=C{1,20};
textboxFont=C{1,21};
textboxString=C{1,22};
textboxWeight=C{1,23};
textboxAngle=C{1,24};
labelHeight=C{1,25};
fileName=C{1,26};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %PANELS
% for j=0:noPanels-1
% uipanel('Parent',f,...
% 'Units','Normalized',...
% 'Position',[x(1+4*j) y(1+4*j) x(2+4*j)-x(1+4*j) y(3+4*j)-y(2+4*j)]);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GRAPHIC PANELS
for i=0:noGraphicPanels-1
switch (i+1)
case 1
graphicPanel1 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
case 2
graphicPanel2 = axes('parent',f,...
'Units','Normalized',...
'Position',[a(1+4*i) b(1+4*i) a(2+4*i)-a(1+4*i) b(3+4*i)-b(2+4*i)],...
'GridLineStyle','--');
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TITLE BOXES
for k=0:noTitles-1
switch (k+1)
case 1
titleBox1 = uicontrol('parent',f,...
'Units','Normalized',...
'Position',[u(1+4*k) v(1+4*k) u(2+4*k)-u(1+4*k) v(3+4*k)-v(2+4*k)],...
'Style','text',...
'FontSize',textboxFont{k+1},...
'String',textboxString(k+1),...
'FontWeight',textboxWeight{k+1},...
'FontAngle',textboxAngle{k+1});
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BUTTONS
for i=0:(noButtons-1)
enterColor='w';
if strcmp(enterType{i+1},'pushbutton')==1 ||strcmp(enterType{i+1},'text')==1
enterColor='default';
end
if (strcmp(enterLabel{1,(i+1)},'')==0 &&...
        strcmp(enterLabel{1,(i+1)},'...')==0) %i.e. there is a label
%creating a label for some buttons
uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i)-labelDist-labelHeight(i+1) ...
(m(2+2*i)-m(1+2*i)) labelHeight(i+1)],...
'Style','text',...
'String',enterLabel{i+1},...
'FontSize', labelTextSize(i+1),...
'HorizontalAlignment','center');
end
switch (i+1)
case 1
button1=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button1Callback);
case 2
button2=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button2Callback);
case 3
button3=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button3Callback);
case 4
button4=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button4Callback);
case 5
button5=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button5Callback);
case 6
button6=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button6Callback);
case 7
button7=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button7Callback);
case 8
button8=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button8Callback);
case 9
button9=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button9Callback);
case 10
button10=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button10Callback);
case 11
button11=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button11Callback);
case 12
button12=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button12Callback);
case 13
button13=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button13Callback);
case 14
button14=uicontrol('Parent',f,...
'Units','Normalized',...
'Position',[m(1+2*i) n(1+2*i) (m(2+2*i)-m(1+2*i)) (n(2+2*i)-n(1+2*i))],...
'Style',enterType{i+1},...
'String',enterString{i+1},...
'FontSize', buttonTextSize(1+i),...
'BackgroundColor',enterColor,...
'HorizontalAlignment','center',...
'Callback',@button14Callback);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%USER CODE FOR THE VARIABLES AND CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize Variables
    curr_file=1;
    fs=8000;
    fsr=10000;
    nsec=4;
    directory_name='abcd';
    wav_file_names='abce';
    fin_path='filename';
    fname='output';
    nsamp=1;
    filename='rec_file';
    xin=[];
    y=[];
    yn=[];
    Lm=40;
    Rm=10;
    deltamax=5;
    wtype=1;
    ipause=-1;
    alpha=0.8;
    xlong=[];

% Name the GUI
    set(f,'Name','WSOLA');

% CALLBACKS
% Callback for button1 -- Get Speech Files Directory
 function button1Callback(h,eventdata)
 %% ***** modified below **************************************************************************
     if isempty(getpref('SpeechApps'))
         url = sprintf('%s%s',...
             'http://www.mathworks.com/matlabcentral/fileexchange/',...
             'submissions/45293/v/1/download/zip');
         [saveloc, ~, ~] = fileparts(pwd); %save to one level up from current folder
         % Create a waitbar during download
         h = waitbar(0.35,'This may take several minutes...',...
             'Name','Downloading Speech Files...');
         % Download the zipped file
         [filestr,status] = urlwrite(url,[saveloc filesep 'speech_files.zip'],...
             'Timeout',10);
         if status
             delete(h);
             hh1= helpdlg('Downloaded. Select a location to UNZIP the speech files.');
             uiwait(hh1);
             unziploc = uigetdir(saveloc,'Select a location to unzip the speech files');
             h2 = waitbar(0.2,'This may take a minute...',...
                 'Name','Unzipping the Speech Files to Location Selected...');
             unzip(filestr,unziploc);
             delete(h2)
             addpref('SpeechApps','path',unziploc);
             hh2= helpdlg('Ready. Select the speech_files folder in the next window');
             uiwait(hh2);
         else
             warndlg('No Internet Connection to MATLAB Central!');
         end
         
     else
     end
     directory_name = uigetdir(getpref('SpeechApps','path'));
%% ***** modified above *******************************************    
     
     A=strvcat(strcat((directory_name),[char,'*.wav']));
     struct_filenames=dir(A);
     wav_file_names={struct_filenames.name};
     set(button2,'String',wav_file_names);
     
% once the popupmenu/drop down menu is created, by default, the first
% selection from the popupmenu/drop down menu id not called
    indexOfDrpDwnMenu=1;
    
% by default first option from the popupmenu/dropdown menu will be loaded
    [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
 end

% Callback for button2 -- Choose speech file for play and plot
 function button2Callback(h,eventdata)
     indexOfDrpDwnMenu=get(button2,'val');
     [curr_file,fs]=loadSelection(directory_name,wav_file_names,indexOfDrpDwnMenu);
 end

%*************************************************************************
% function -- load selection from designated directory and file
%
function [curr_file,fs]=loadSelection(directory_name,wav_file_names,...
    indexOfDrpDwnMenu);
%
% read in speech/audio file
% fin_path is the complete path of the .wav file that is selected
    fin_path=strcat(directory_name,char,strvcat(wav_file_names(indexOfDrpDwnMenu)));

% clear speech/audio file
    clear curr_file;
    clear fs;
    
% read in speech/audio signal into curr_file; sampling rate is fs 
    [curr_file,fs]=wavread(fin_path);
    y=curr_file;
    yn=y/max(max(y),-min(y));
    
% create title information with file, sampling rate, number of samples
    fname=wav_file_names(indexOfDrpDwnMenu);
    FS=num2str(fs);
    nsamp=num2str(length(curr_file));
    file_info_string=strcat('  file: ',fname,', fs: ',FS,' Hz, nsamp:',nsamp);
    fname=wav_file_names{indexOfDrpDwnMenu};
end

% Callback for button3 -- nsec: length of recording in samples
 function button3Callback(h,eventdata)
     nsec=str2num(get(button3,'string'));
     if (nsec < 1 || nsec > 5)
         waitfor(errordlg('The length of the recording must be between 1 to 5 seconds'));
         return;
     end
 end

% Callback for button4 -- fsr: recorded speech sampling rate
 function button4Callback(h,eventdata)
     %fsr=str2num(get(button4,'string'));
     Index=get(button4,'val');
     a = [16000 6000 8000 10000 16000 20000];
     fsr = a(Index); 
 end

% Callback for button5 -- Record Speech File
 function button5Callback(h,eventdata)
     
% check editable buttons for changes
    button4Callback(h,eventdata);
    button3Callback(h,eventdata);
    
% Begin recording after hitting OK on msg box
    uiwait(msgbox('Ready to Record -- Hit OK to Begin','Record','modal'));
    
% record speech file with fs=fsr and nsec duration
%    [y,yn]=record_speech(fsr,nsec);
recobj=audiorecorder(fsr,16,1);
recordblocking(recobj,nsec);
y=getaudiodata(recobj);
    yfilt=highpass_filter(y,fsr);
    y=yfilt;
    ymax=max(abs(y));
    yn=y/ymax;
    fs=fsr;
    fname='rec_file';
    soundsc(y,fsr);
 end

% Callback for button6 -- Lm: analysis frame length in msec
 function button6Callback(h,eventdata)
     Lm=str2num(get(button6,'string'));
     if (Lm < 1 || Lm > 100)
         waitfor(errordlg('The frame length must be between 1 and 100'));
         return;
     end
 end

% Callback for button7 -- Rm: analysis frame shift in msec
 function button7Callback(h,eventdata)
     Rm=str2num(get(button7,'string'));
     if (Rm < 1 || Rm > 100)
         waitfor(errordlg('The frame shift must be between 1 and 100'));
         return;
     end
 end

% Callback for button8 -- deltamax: maximum frame offset in msec
 function button8Callback(h,eventdata)
     deltamax=str2num(get(button8,'string'));
     if (deltamax < 3 || deltamax > (Rm -1))
         waitfor(errordlg(strcat(['The maximum frame offset must be a positive integer between 3 and ', num2str(Rm -1), ' (Rm -1}'])));
         return;
     end
 end

% Callback for button9 -- wtype: window type (1:Rectangular, 2:Hamming,
%3:Triangular)
 function button9Callback(h,eventdata)
     wtype=get(button9,'val')-1;
 end

% Callback for button10 -- ipause: pause between frames for debug; set to -1
%   for no debug and no pause; set to 0 for all frames analysis; set to +1
%   for pause between frames
 function button10Callback(h,eventdata)
     ipause=get(button10,'val')-2;
 end

% Callback for button11 -- alpha: speedup/slowdown ratio (<1 for slowdown,
% >1 for speedup)
 function button11Callback(h,eventdata)
     alpha=str2num(get(button11,'string'));
     if (alpha < 0.25 || alpha > 4)
         waitfor(errordlg('The speed-up/slowdown ratio must be between 0.25 and 4'));
         return;
     end
 end

% Callback for button12 -- Run WSOLA
 function button12Callback(h,eventdata)
     
% check editable buttons for changes
    button6Callback(h,eventdata);
    button7Callback(h,eventdata);
    button8Callback(h,eventdata);
    button9Callback(h,eventdata);
    button10Callback(h,eventdata);
    button11Callback(h,eventdata);
    
% setup wsola run
    setup_wsola(y,fs,Lm,Rm,deltamax,wtype,ipause,alpha,fname);
 end

    function setup_wsola(y,fs,Lm,Rm,deltamax,wtype,ipause,alpha,filename)
%       
% speech speed-up/slow-down by variable factor, alpha, using wsola 
% (Waveform Synchronous Overlap Add) method

% Inputs:
%   y: input speech/audio file
%   fs: input speech sampling rate
%   Lm: analysis frame length in msec
%   Rm: analysis frame shift in msec
%   deltamax: maximum shift between alignment frames in msec
%   wtype: window type (1:Rectangular, 2:Hamming, 3:Triangular)
%   ipause: pause in seconds for debugging frames
%   alphav: speedup/slowdown factor (<1 speedup, >1 slowdown)
%   filename: speech filename

% convert Lm from msec to nleng samples at the current sampling rate, fs
% convert Rm from msec to nshift samples at the current sampling rate, fs
    nleng=round(Lm*fs/1000);
    nshift=round(Rm*fs/1000);
    
[youts,youtn]=wsola_analysis_GUI(y,fs,alpha,nleng,nshift,wtype,deltamax,ipause);

% create array with original -- wsola -- original
        xlong=[yn;  youtn;  yn];
    end

function [youts,youtn]=wsola_analysis_GUI(y,fs,alpha,nleng,nshift,...
        wtype,deltamax,ipause);

% wsola analysis of speech file
%
% Inputs:
%   y=input speech (normalized to 32767)
%   fs=input speech sampling rate
%   alpha=speed up/slow down factor (0.5 <= alpha <= 3.0)
%   nleng=length of analysis frame in samples
%   nshift=shift of analysis frame in samples
%   wtype=window type (1=Hamming, 0=rectangular, 2=triangular)
%   deltamax=maximum number of samples to search for best alignment
%   ipause=plotting option for debug
%
% Outputs:
%   youts=time scaled signal, scaled to 32767
%   youtn=time scaled signal, scaled to 1

% create appropriate window based on wtype parameter
    if (wtype == 1)
        win=hamming(nleng);
    elseif (wtype == 0)
        win=ones(nleng,1);
    elseif (wtype == 2)
        win(1:nleng/2)=(.5:1:nleng/2)/(nleng/2);
        win(nleng/2+1:nleng)=(nleng/2-.5:-1:0)/(nleng/2);
        win=win';
    end
    
% create search region based on deltamax parameter
    deltas=round(deltamax*fs/1000);
    
% initialize overlap add with first frame
    nideal=1+nshift;
    nalpha=1;
    nlin=1;
    nsamp=length(y);
    yout=zeros(floor(nsamp/alpha+nleng+0.5),1);
    yout(1:nleng)=y(1:nleng).*win(1:nleng);
    fno=2; % frame number
    
% full wsola processing
    while (nideal+nleng <= nsamp & nalpha+nleng+deltas+alpha*nshift <= nsamp)
        xideal=y(nideal:nideal+nleng-1);
        nalpha=nalpha+round(alpha*nshift);
        indexl=max(nalpha-deltas,1);
        xreal=y(indexl:nalpha+nleng-1+deltas);
        nlin=nlin+nshift;
 
% correlate pair of frames and find optimal matching point
        c=xcorr(xreal,xideal);
        
% compensate for xcorr shift by length of xreal; 
% find peak of length compensated cs        
        lxreal=length(xreal);
        cs(1:2*deltas+1)=c(lxreal:lxreal+2*deltas);
        maxind=find(cs == max(cs));

% plot results -- debugging mode if ipause >=0
        if (ipause >= 0)
            axes(graphicPanel2);
            stitle=sprintf('nideal,nalpha,nlin: %d %d %d, maxind: %d',...
                nideal,nalpha,nlin,maxind);
            ind1=nideal:nideal+nleng-1;
            
% plot(ind1,xideal,'r','LineWidth',2);
            plot(xideal,'r','LineWidth',2);
            xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
                xlabel(xpp),ylabel('xideal/x-aligned');grid on;
            hold on;
            
            ind2=nalpha-deltas+maxind-1:nalpha-deltas+maxind+nleng-2;
% plot(ind2,y(nalpha-deltas+maxind-1:nalpha-deltas+...
% maxind+nleng-2),'b','LineWidth',2);
            plot(y(nalpha-deltas+maxind-1:nalpha-deltas+...
                maxind+nleng-2),'b','LineWidth',2);
            title(stitle);
            % legend('xideal','x-aligned');
            hold off;
            
            % axes(graphicPanel2);
            % ind3=indexl:nalpha+nleng-1+deltas;
            % plot(ind3,xreal,'r','LineWidth',2),...
            % xlabel(xpp),ylabel('xreal');grid on;
            % legend('xreal');
            axes(graphicPanel1);
            ind4=1:2*deltas+1;
            csmax=max(max(cs),-min(cs));
            csn=cs/csmax;
            plot(ind4,csn,'r','LineWidth',2),...
                xlabel(xpp),ylabel('Correlation');grid on;
            % legend('correlation');
            if (length(maxind) == 1) 
                hold on, plot([maxind maxind],[-1 1],'b--','LineWidth',2);
            end
            
            jpause=get(button10,'val');

            if (jpause == 2)
                pause(0.01)
            elseif (jpause == 3)
                pause(0.5);
            end
            
            hold off;
        end
        
% title GUI plot in titleBox1
        stitle1=strcat('WSOLA');
        set(titleBox1,'string',stitle1);
        set(titleBox1,'FontSize',15);
        
% overlap add the best match
        xadd=y(nalpha-deltas+maxind-1:nalpha-deltas+maxind+nleng-2).*win(1:nleng);
        yout(nlin:nlin+nleng-1)=yout(nlin:nlin+nleng-1)+xadd;
        
% debug printing
    iprint=0;
    if (iprint == 1)
    fprintf('frame:%d, xideal:%d %d, xreal:%d %d, xadd:%d %d, yout:%d %d maxind: %d \n',...
        fno,nideal,nideal+nleng-1,indexl,nalpha+nleng-1+deltas,...
        nalpha-deltas+maxind-1,nalpha-deltas+maxind+nleng-2,nlin,nlin+nleng-1,maxind);
    fno=fno+1;
    end
        
% update indices
        nideal=nalpha-deltas+maxind-1+nshift;
    end
    
% play out time-altered sound
    youtn=yout/max(max(yout),-min(yout));
    
% save output file
    youts=youtn*32700;
    
% plot input and output
    stitle=sprintf(' file:%s, fs:%d, alpha:%4.2f, nleng:%d, nshift:%d, deltas:%d',...
        fname,fs,alpha,nleng,nshift,deltas);

% initialize graphics Panel 2
        % reset(graphicPanel2);
        axes(graphicPanel2);
        % cla;
        
% plot original signal in graphics Panel 2
        maxl=max(length(y),length(youtn))-1;
        plot(y,'r','LineWidth',2),grid on;
        xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
        xlabel(xpp),ylabel('Amplitude'),axis([0 maxl min(y) max(y)]);
        legend('original signal');
        
% title GUI plot in titleBox1
        stitle1=strcat('WSOLA -- ',stitle);
        set(titleBox1,'string',stitle1);
        set(titleBox1,'FontSize',15);
        
% clear graphics Panel 1
        % reset(graphicPanel1);
        axes(graphicPanel1);
        % cla;

% plot speeded-up or slowed-down signal in graphics Panel 1
        plot(youtn,'b','LineWidth',2),grid on;
        xlabel(xpp),ylabel('Amplitude'),axis([0 maxl min(youtn) max(youtn)]);
        legend('WSOLA run');
        
% play out time-changed signal
    soundsc(youtn,fs);
end

% Callback for button13 -- play out xlong
 function button13Callback(h,eventdata)
    soundsc(xlong,fs);
 end

% Callback for button14 -- Close GUI
 function button14Callback(h,eventdata)
     fclose('all');
     close(gcf);
 end
end
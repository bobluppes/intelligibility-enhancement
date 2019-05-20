function [youts,youtn]=wsola_analysis(y,fs,alpha,nleng,nshift,wtype,deltamax,ipause);

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
    
    fprintf('nleng:%d, nshift:%d, deltas:%d, fs:%d \n',nleng,nshift,deltas,fs);
    
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
        
% compensate for xcorr shift by length of xreal; find peak of length compensated cs        
        lxreal=length(xreal);
        cs(1:2*deltas+1)=c(lxreal:lxreal+2*deltas);
        maxind=find(cs == max(cs));
            
% plot results -- debugging mode if ipause >=0
        if (ipause >= 0)
            figure(1);
            stitle=sprintf('nideal,nalpha,nlin: %d %d %d, maxind: %d',...
                nideal,nalpha,nlin,maxind);
            ind1=nideal:nideal+nleng-1;
            subplot(3,1,1),plot(ind1,xideal,'r','LineWidth',2),...
                xlabel('time in samples'),ylabel('xideal');
            hold on;
            ind2=nalpha-deltas+maxind-1:nalpha-deltas+maxind+nleng-2;
            plot(ind2,y(nalpha-deltas+maxind-1:nalpha-deltas+maxind+nleng-2),'b','LineWidth',2);
            title(stitle),hold off;
            ind3=indexl:nalpha+nleng-1+deltas;
            subplot(3,1,2),plot(ind3,xreal,'r','LineWidth',2),...
                xlabel('time in samples'),ylabel('xreal');
            ind4=1:2*deltas+1;
            csmax=max(max(cs),-min(cs));
            csn=cs/csmax;
            subplot(3,1,3),plot(ind4,csn,'r','LineWidth',2),...
                xlabel('time in samples'),ylabel('correlation');
            if (length(maxind) == 1) 
                hold on, plot([maxind maxind],[-1 1],'b--','LineWidth',2);
            end
            if (ipause > 0) pause %(pauses);
            end
            hold off;
        end
        
% overlap add the best match
        xadd=y(nalpha-deltas+maxind-1:nalpha-deltas+maxind+nleng-2).*win(1:nleng);
        yout(nlin:nlin+nleng-1)=yout(nlin:nlin+nleng-1)+xadd;
        
% debug printing
    xx=1;
    if (xx == 0)
    fprintf('frame:%d, xideal:%d %d, xreal:%d %d, xadd:%d %d, yout:%d %d maxind: %d \n',...
        fno,nideal,nideal+nleng-1,indexl,nalpha+nleng-1+deltas,...
        nalpha-deltas+maxind-1,nalpha-deltas+maxind+nleng-2,nlin,nlin+nleng-1,maxind);
    fno=fno+1;
    pause
    end
        
% update indices
        nideal=nalpha-deltas+maxind-1+nshift;
    end
    
% play out time-altered sound
    youtn=yout/max(max(yout),-min(yout));
    % sound(youtn,fs);
    
% save output file
    youts=youtn*32700;
    
% plot input and output
    stitle=sprintf('fs:%d, alpha:%4.2f, nleng:%d, nshift:%d, deltamax:%d',...
        fs,alpha,nleng,nshift,deltamax);
    figure(2);
    orient landscape;
    subplot(211),plot(y,'r','LineWidth',2),...
        xlabel('time in samples'),ylabel('amplitude'),axis tight;
        title(stitle);
    subplot(212),plot(youtn,'b','LineWidth',2),...
        xlabel('time in samples'),ylabel('amplitude'),axis tight;
end
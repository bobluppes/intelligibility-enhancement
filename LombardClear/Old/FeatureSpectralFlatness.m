%> @brief computes the spectral flatness from the magnitude spectrum
%> called by ::ComputeFeature
%>
%> @param X: spectrogram (dimension FFTLength X Observations)
%> @param f_s: sample rate of audio data (unused)
%>
%> @retval vtf spectral flatness
% ======================================================================
function [vtf] = FeatureSpectralFlatness (X, f_s)
    winlength = 20 *f_s/1000; % samples
    overlap = 0.5;
    %win=hamming(winlength);
    frame = buffer(X, winlength, winlength*overlap); %size = winlength*3611
    %frame = frame.^2;
    
    %vtf = log(1/winlength*sum(frame,1)); % log energy
%     vtf = zeros(size(frame,2));%% Zero crossings
%     for j = 1:size(frame,2)
%         for i = 2:winlength
%             if (frame(i, j)*frame(i-1,j) < 0)
%                 vtf(j) = vtf(j) + 1;
%             end
%         end
%     end
    %vtf = geomean(frame)./mean(frame); % spectral flatness
    vtf = [];
    for j = 1:size(frame,2)
        
        [vtf(j,:), lags] = autocorr(frame(:,j),'NumLags',1);
    end
    

end

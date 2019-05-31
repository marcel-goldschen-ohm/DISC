function computeSNR(histplot)
global data p

% allocate
SNR = zeros(length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit)),1);

for ii = 1:length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit))
    mu(1) = data.rois(ii, p.currentChannelIdx).disc_fit.components(1,2);
    st(1) = data.rois(ii, p.currentChannelIdx).disc_fit.components(1,3);
    for jj = 2:length(data.rois(ii, p.currentChannelIdx).disc_fit.components(:,2))
        mu(jj) = data.rois(ii, p.currentChannelIdx).disc_fit.components(jj,2);
        st(jj) = data.rois(ii, p.currentChannelIdx).disc_fit.components(jj,3);
        snr_trace(jj-1) = (mu(jj) - mu(jj-1))/st(jj-1);
    end
    SNR(ii) = mean(snr_trace);
end

if histplot == 1
    figure();
    histogram(SNR);
    title('SNR Histogram')
    xlabel('SNR')
    ylabel('Count')
end
end
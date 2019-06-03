function computeSNR(histplot)
global data p

idx = zeros(length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit)),1);
for ii = 1:length(data.rois)
    if ~isempty(data.rois(ii,p.currentChannelIdx).disc_fit)
        idx(ii) = ii;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

for ii = idx'
    mu(1) = data.rois(ii, p.currentChannelIdx).disc_fit.components(1,2);
    st(1) = data.rois(ii, p.currentChannelIdx).disc_fit.components(1,3);
    for jj = 2:length(data.rois(ii, p.currentChannelIdx).disc_fit.components(:,2))
        mu(jj) = data.rois(ii, p.currentChannelIdx).disc_fit.components(jj,2);
        st(jj) = data.rois(ii, p.currentChannelIdx).disc_fit.components(jj,3);
        snr_trace(jj-1) = (mu(jj) - mu(jj-1))/st(jj-1);
    end
    data.rois(ii, p.currentChannelIdx).SNR = mean(snr_trace);
end

if histplot == 1
    figure();
    histogram(vertcat(data.rois(:,p.currentChannelIdx).SNR));
    title('SNR Histogram')
    xlabel('SNR')
    ylabel('Count')
end
end
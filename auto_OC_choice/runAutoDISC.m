function results = runAutoDISC(timeseries, disc_input)
%%  Optimized OC DISC
%   Author: Argha Bandyopadhyay
%   Contact: argha.bandyopadhyay@utexas.edu
%   
%   Published in:
%   Bandyopadhyay and Goldschen-Ohm, 2021
%   -----------------------------------
%   **Overview:**
%   Idealizes SM time series using the DISC algorithm (see
%   White et al., 2020 for details) run with an optimal OC
%   based on the SNR and number of samples in the time
%   series. Allows for per-molecule idealization of 
%   heterogeneous datasets generated by high-throughput 
%   SM fluorescence imaging experiments.
%   
%   Workflow:
%       1. BIC_RSS Idealization: DISC idealizes the
%       time-series with BIC_RSS in order to catch all
%       (reasonably) possible state transitions in the time
%       series
%       2. SNR Estimation: Using qualities from the BIC_RSS
%       idealization to estimate the state-separation to
%       noise ratio of the time series (see estimateSNR.m
%       for more details)
%       3. Decision Boundary: Based on the estimated SNR and
%       length the time series, the optimal choice of either
%       BIC_RSS or BIC_GMM is made according to a
%       linear decision boundary (see chooseOC.m for more
%       details)
%       4. Optimal Idealization: if BIC_RSS is found to
%       be optimal, then the results from 1. are returned.
%       If BIC_GMM is found to be optimal, then DISC
%       re-idealizes the time series with BIC_GMM
%   -----------------------------------
%   **Requirements:**
%   DISC-master
%   MATLAB Statistics and Machine Learning Toolbox
%   -----------------------------------
%   **I/O:**
%   Inputs:
%       1. timeseries: vector of data to be analyzed with
%       size [N,1] where N >= 5
%       2. disc_input: struct input for runDISC - see initDISC.m 
%       for details
%   Outputs:
%       1. results: struct output by runDISC - see runDISC.m
%       for details
%   -----------------------------------

%%  1. BIC_RSS Idealization
disc_input.divisive = "BIC_RSS";
disc_input.agglomerative = "BIC_RSS";

results = runDISC(timeseries, disc_input);
rss_idealization = results.ideal;

if length(unique(rss_idealization)) == 1
    return
end

%%  2. SNR Estimation
estimated_SNR = estimateSNR(timeseries, rss_idealization);

%%  3. Decision Boundary
%   based on SNR and length of the time series
numsamples = length(timeseries);
slope = disc_input.dbslope;
intercept = disc_input.dbintercept;
optimal_OC = chooseOC(estimated_SNR, numsamples, slope, intercept);

%%  4. Optimal Idealization
%   only need to change results if optimal is BIC_GMM
if optimal_OC == "BIC_GMM"
    disc_input.divisive = "BIC_GMM";
    disc_input.agglomerative = "BIC_GMM";
    
    results = runDISC(timeseries, disc_input);
end
end

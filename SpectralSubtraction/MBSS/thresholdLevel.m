%%% To determine the threshold level of noise

function [threshold] = thresholdLevel(avgMatrixSquared)

sizeFrame = size(avgMatrixSquared);
powerNoise = sum(avgMatrixSquared(:,1))/sizeFrame(1);
powerSpeechSignal = sum(sum(avgMatrixSquared(:,2:11)))/(10*sizeFrame(1));
threshold = 10*log10(powerSpeechSignal) - 10*log10(powerNoise);  % gives the estimation of noise present in the speech signal
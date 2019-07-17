%%%%%%%%%%%Function to implement Weighted spectral average for 5 frames.

function [avgMatrixSquared] = weightedSpectralAVG(fftSegmMatrix)

% avgVector = [0.09 0.25 0.32 0.25 0.09];                
% Weights determined empirically
sizeFftSegmMatrix = size(fftSegmMatrix);
absFFTSegmMAtrix = abs(fftSegmMatrix);
avgMatrix = absFFTSegmMAtrix;

% spectral averaging
for n=1:sizeFftSegmMatrix(2)-4
    avgMatrix(:,n+2) = 0.09*absFFTSegmMAtrix(:,n) + 0.25*absFFTSegmMAtrix(:,n+1) + 0.32*absFFTSegmMAtrix(:,n+2) + 0.25*absFFTSegmMAtrix(:,n+3) + 0.09*absFFTSegmMAtrix(:,n+4);
end

avgMatrixSquared = avgMatrix.^2;   





%%%%To implement Overlap Add Function for signal Reconstruction %%%%%%

function [recoveredSpeechSignal] = overlapAddFunction(FFTMatrix,windowSize,overlappingNumber,phaseMatrix)

% Original Phase addition (Enhanced FFT Matrix) %
newFFTMatrix = FFTMatrix.*exp(j*phaseMatrix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Output initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sizeNewFFTMatrix = size(newFFTMatrix);
nFrames = sizeNewFFTMatrix(2);
recoveredSpeechSignal = zeros(1,(nFrames-1)*overlappingNumber + windowSize);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Overlap Add Method %
for n=1:nFrames
    index = (n-1)*overlappingNumber + 1;
    recoveredSpeechSignal(index:index + windowSize -1) = recoveredSpeechSignal(index:index + windowSize -1) + real(ifft(newFFTMatrix(:,n),windowSize))';
end
%%%


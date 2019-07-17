%%%To floor the samples if negative values of it are found in the signal.
function [newFFTEnhacedFrame] = floorEnhaced(FFTEnhacedFrame,noiseVector,beta)
substractVector = FFTEnhacedFrame - noiseVector'.*beta;  
negativeVector = (substractVector < 0);    %%% check if negative
indexVector = find(negativeVector);
newFFTEnhacedFrame = FFTEnhacedFrame;
newFFTEnhacedFrame(indexVector) = noiseVector(indexVector).*beta;   %%% update the floored values with the set Beta.
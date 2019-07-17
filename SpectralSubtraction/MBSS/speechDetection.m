%%% Speech Detection%%%
%%% to detect wheather most of the vector contains speech or noise and
%%% returns a flag of 1 for speech and 0 for noise.
function [speechFlag,snrValue,newNoiseSquaredVector] = speechDetection(avgVectorSquared,noiseSquaredVector,threshold)

snrValue = 10*log10(sum(avgVectorSquared)) - 10*log10(sum(noiseSquaredVector));  %%% Calculation of SNR Value..Speech to Noise Ratio.
newNoiseSquaredVector = noiseSquaredVector;
speechFlag = 0;

if snrValue > threshold     
    speechFlag = 1;
else
    newNoiseSquaredVector = avgVectorSquared';
end


% To determine the band subtraction factor beta%
function [deltaVector] = deltaFunction(fftVectorSize,samplingFreq,nBands)

upperBandFrequenciesVector = zeros(1,nBands);
upperBandFrequenciesVector(1) = samplingFreq*(1/nBands);
for n=2:nBands
    upperBandFrequenciesVector(1,n) = samplingFreq*(n/nBands);
end
sFreq = samplingFreq;
nSamplesBand = floor(fftVectorSize/(2*nBands));
deltaTemp1Vector = zeros(1,nSamplesBand*nBands);
deltaVector = 1.5.*ones(1,fftVectorSize);

deltaTempVector = upperBandFrequenciesVector<=1000;
deltaTempVector = deltaTempVector + 2.5.*((1000 < upperBandFrequenciesVector).*(upperBandFrequenciesVector <= sFreq/2-2000));
deltaTempVector = deltaTempVector + 1.5*((sFreq/2-2000<upperBandFrequenciesVector));

for n=1:nBands
    for m = 1:nSamplesBand
        deltaTemp1Vector((n-1)*nSamplesBand+m) = deltaTempVector(n); 
    end
end

deltaVector(1:nBands*nSamplesBand) = deltaTemp1Vector;
deltaVector(end-(nBands*nSamplesBand-1):end) = flipdim(deltaTemp1Vector,2);


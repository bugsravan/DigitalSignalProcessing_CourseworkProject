%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  CODE FOR Power SPECTRAL SUBTRACTION METHOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;

% % Input Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 audioName = input('Introduce the audio file name (between ''): ');
% [audioVector, samplingFreq] = wavread(audioName);
 overlapPercentage = input('Introduce the overlap percentage: ')/100;
% hammingSize = input('Introduce the Hamming Window Size (in seconds): ');
% threshold = input('Introduce threshold (on dB): ');
% noiseAverage = input('Introduce the number of noise frames considered: ');
% beta = input('Introduce beta parameter (0 ~ 0.01): ');
% sound(audioVector,samplingFreq)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% audioName = 'noisyy_2.wav';
% audioName = 'noisecut.wav';
[audioVector, samplingFreq] = wavread(audioName);
% overlapPercentage = 40/100;
hammingSize = 0.01;
threshold = 0;
noiseAverage = 10;
beta = 0.002;
nBands = 16;
 sound(audioVector,samplingFreq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the used Hamming Window %%%%%%%%%%%%%%%
hammingSize = floor(samplingFreq*hammingSize);
hammVector = hamming(hammingSize);
%%%%%%%%%%%%%%%%%

% Segmentation of the audio signal + Hamming Window %%%%
sizeAudio = length(audioVector);
overlappingNumber = floor(overlapPercentage*hammingSize);
numberOfSegments = floor((sizeAudio-hammingSize)/overlappingNumber) + 1;
matrixIndex = repmat((1:hammingSize)',1,numberOfSegments);
matrixIndex1 = repmat((0:overlappingNumber:(numberOfSegments-1)*overlappingNumber),hammingSize,1); 
matrixIndex = matrixIndex + matrixIndex1;
hammingMatrix = repmat(hammVector,1,numberOfSegments);
segmMatrix = audioVector(matrixIndex).*hammingMatrix;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fftSegmMatrix = fft(segmMatrix,hammingSize);
fftSegmMatrixPhase = angle(fftSegmMatrix);
fftMSize = size(fftSegmMatrix);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Weighted Spectral Average %%%%%%%%%%%%%%%%%%%%%%%%%%%
[avgMatrixSquared] = weightedSpectralAVG(fftSegmMatrix);
% avgMatrixSquared = abs(fftSegmMatrix).^2;
outputAvgMatrixSquared = avgMatrixSquared;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Enhacement %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
noiseSquaredVector = avgMatrixSquared(:,1)';
counter = 0;
for n=2:fftMSize(2)
    [speechFlag,snrValue,newNoiseSquaredVector] = speechDetection(avgMatrixSquared(:,n),noiseSquaredVector,threshold);
    if speechFlag == 1
        [alphaValue] = alphaFunction(snrValue);
        outputAvgMatrixSquared(:,n) =  avgMatrixSquared(:,n) - 0.95.*(alphaValue.*noiseSquaredVector)';
        outputAvgMatrixSquared(:,n) = floorEnhaced(outputAvgMatrixSquared(:,n),noiseSquaredVector,beta);
    else
        [alphaValue] = alphaFunction(snrValue);
        noiseSquaredVector = ((noiseAverage-1)/noiseAverage).*noiseSquaredVector + (1/noiseAverage).*newNoiseSquaredVector;
        outputAvgMatrixSquared(:,n) =  avgMatrixSquared(:,n) - 0.95.*(alphaValue.*noiseSquaredVector)';
        outputAvgMatrixSquared(:,n) = floorEnhaced(outputAvgMatrixSquared(:,n),noiseSquaredVector,beta);
        counter = counter + 1
        plot(noiseSquaredVector);
        hold on;
    end
end
%%%

% Signal Reconstrunction %
[recoveredSpeechSignal] = overlapAddFunction(sqrt(outputAvgMatrixSquared),hammingSize,overlappingNumber,fftSegmMatrixPhase);
  sound(recoveredSpeechSignal,samplingFreq)
wavwrite(recoveredSpeechSignal,samplingFreq,'testPSS.wav');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Smoothed Original Spectrum &  Smoothed Enhaced Spectrum %
sizeBands = floor(sizeAudio/nBands)
plot(abs(fftSegmMatrix(:,floor(fftMSize(2)/2))),'-r');
hold on;
plot(sqrt(outputAvgMatrixSquared(:,floor(fftMSize(2)/2))));
figure;
spectrogram(audioVector,sizeBands,0,sizeBands,samplingFreq);
figure;
spectrogram(recoveredSpeechSignal,sizeBands,0,sizeBands,samplingFreq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

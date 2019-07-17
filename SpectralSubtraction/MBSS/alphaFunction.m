% to determine over subtraction factor alpha%%%%%%%%%%%%%%%%%%%%%%
function [alphaValue] = alphaFunction(snrInput)

snrCoef = snrInput;                % takes snr value as an input to caluculate over subtraction factor%
if snrInput<(-5)
    snrCoef = (-5);
else 
    if snrInput>20
        snrCoef = 20;
    end
end

alphaValue = 4-snrCoef*(3/20);
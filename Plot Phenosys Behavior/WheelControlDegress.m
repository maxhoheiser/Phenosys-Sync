function WheelControlDegress(CWDegrees,CCWDegrees)

s = daq.createSession('ni');
addAnalogInputChannel(s, 'Dev2', 0, 'Voltage');
ch1 = addCounterInputChannel(s,'Dev2',0,'Position')
addDigitalChannel(s,'Dev2','Port1/Line0','OutputOnly')
counterNBits = 32;
signedThreshold = 2^(counterNBits-1);
enconderCPR = 1024;
ch1.ZResetValue = 0;
CWDegrees = CWDegrees*-1;
while enconderCPR == 1024
    %encoderPosition = inputSingleScan(s);
    signedData= inputSingleScan(s);
    signedData=signedData(2);
    signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^counterNBits;
    signedData = signedData * 360/enconderCPR
    if signedData <= CWDegrees
        outputSingleScan(s,[1])
        pause(2)
        outputSingleScan(s,[0])
        ch1.ZResetValue = 0;
    elseif signedData >= CCWDegrees
        outputSingleScan(s,[1])
        pause(2)
        outputSingleScan(s,[0])
        ch1.ZResetValue = 0;
        
    end
        
    %encoderPositionDeg = encoderPosition * 360/enconderCPR
end
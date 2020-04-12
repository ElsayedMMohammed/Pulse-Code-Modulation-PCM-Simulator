function decodedOut = Decoder(input,time,L,fs,mp,encodingMethod,quantizationMethod,mu)
%function inputs: 1.input: 1D array representing signal amplitudes in volts e
%                 2.timeAxis: 1D array represents time in seconds at which  
%                 each sample is pesent.timeAxis(i) represents when input(i)
%                 is present.
%                 3. L: The number of quantizer's levels.
%                 4. fs: Sampling frequancy by which the encoded signal is
%                 sampled.
%                 5. mp: The maximum amplitude of the quantizer.
%                 6. encodingMethod: numeric value represents the chosen
%                 encdoing method (1,2 or 3). 1 for Unipolar NRZ signaling,
%                 2 for %Polar NRZ signaling , 3 for Manchester signaling.
%                 7. quantizationMethod: numeric value represents the chosen
%                 Quantizarion method (1 or 2). 1 for Uniform mid-rise quantization,
%                 2 Non-Uniform µ-Law quantization.
%                 8. mu: µ at the µ-Law for non-uniform quantization. mu =
%                 0 is the same as uniform quantization.

%function outputs: 
%                  1.decodedOut: 1D array represents the amplitude of the
%                  decoded signal in volts.
%% calculations
R = ceil(log2(L)); % bit/sample
bitRate = fs*R; %bit/sec
ts = 1/bitRate;
%% Decoding
outputIndex = 1;
time = (time - time(1))./ts;
outputLength = ceil(time(end));
output = zeros(1,outputLength);

if encodingMethod == 1 % Unipolar NRZ signaling
    for i = 1:length(input)
        if abs(mod(vpa(time(i)),vpa(1))) < 1e-5 % Starting a new bit
            if input(i)>0
                output(outputIndex) = 1;
            elseif input(i) == 0
                output(outputIndex) = 0;
            end
            outputIndex = outputIndex + 1;
        end
    end
elseif encodingMethod == 2 %Polar NRZ signaling
    for i = 1:length(input)
        if abs(mod(vpa(time(i)),vpa(1))) < 1e-5 % Starting a new bit
            if input(i)>0
                output(outputIndex) = 1;
            elseif input(i) < 0
                output(outputIndex) = 0;
            end
            outputIndex = outputIndex + 1;
        end
    end
elseif encodingMethod == 3 %Manchester signaling
    for i = 1:length(input)
        if abs(mod(vpa(time(i)),vpa(1))) < 1e-5 % Starting a new bit
            firstHalfIndex = i;
            i = i+1;
            while(abs(mod(vpa(time(i)),vpa(0.5))) > 1e-5)
                i = i+1;
            end
            secondHalfIndex = i;
            if (input(firstHalfIndex) > 0 && input(secondHalfIndex) < 0)
                output(outputIndex) = 1;
            elseif (input(firstHalfIndex) < 0 && input(secondHalfIndex) > 0)
                output(outputIndex) = 0;
            end
            outputIndex = outputIndex + 1;
            
        end
    end
end

%%binary mapped to volt 
decodedOutLength = outputLength/R;
decodedOut = zeros(1,decodedOutLength);
index = 1;
for i = 1:R: length(output)
    decodedOut(index) = bi2de(output(i:i+R-1),'left-msb');
    index = index +1;
end
delta = 2*mp/L;
decodedOut = (decodedOut.*delta - mp + delta/2);
if quantizationMethod == 2 && mu ~= 0 %non uniform quantization
    %decodedOut = (decodedOut +mp)/(2*mp);
    for i = 1: decodedOutLength        
    decodedOut(i) = sign(decodedOut(i))*((1+mu)^abs(decodedOut(i)) -1)*(mp/mu);
    end
   % decodedOut =  decodedOut*2 - mp;
end
end
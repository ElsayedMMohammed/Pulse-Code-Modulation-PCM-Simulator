function [output,time] = Encoder(input,timeAxis,encodingMethod)
%function inputs: 1.input: 2D matrix each row represents 1 sample represents
%                 by n,# of columns, bits.
%                 2.timeAxis: 1D array represents time in seconds at which  
%                 each sample is pesent.timeAxis(i) represents when input(i,:)
%                 is present.
%                 3.encodingMethod: numeric value represents the chosen
%                 encdoing method (1,2 or 3). 1 for Unipolar NRZ signaling,
%                 2 for %Polar NRZ signaling , 3 for Manchester signaling.

%function outputs: waveform encoded with input by the chosen encodedMethod
%                  1.output: 1D array represents the amplitude of the waveform
%                  in volts
%                  2.time: 1D array represnets the time in seconds when each
%                  instance of output is present. time(i) represents when 
%

%% calculations
fs = 1/(timeAxis(2)-timeAxis(1)); %Hz
R = size(input,2); % bit/sample
bitRate = fs*R; %bit/sec
%% reshaping input
input = reshape(input.',1,[]);
%% encoding
nTimeStepsPerBit = 4; % to generate the continuous wave form, should be even number
A = 5; 
output = zeros(1,length(input)*nTimeStepsPerBit);
time = zeros(1,length(input)*nTimeStepsPerBit);
timeStep = 1/(bitRate*nTimeStepsPerBit);
currentTime = 0;
if encodingMethod == 1 % Unipolar NRZ signaling
    for i = 1:length(input)
        if input(i) == 0
            for j = 1:nTimeStepsPerBit
                output((i-1)*nTimeStepsPerBit + j) = 0;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime + 1;%timeStep;
            end
        elseif input(i) == 1
            for j = 1:nTimeStepsPerBit
                output((i-1)*nTimeStepsPerBit + j) = A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime + 1;%timeStep;
            end
        end
    end
elseif encodingMethod == 2 %Polar NRZ signaling
    for i = 1:length(input)
        if input(i) == 0
            for j = 1:nTimeStepsPerBit
                output((i-1)*nTimeStepsPerBit + j) = - A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime +1;% timeStep;
            end
        elseif input(i) == 1
            for j = 1:nTimeStepsPerBit
                output((i-1)*nTimeStepsPerBit + j) = A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime +1; %timeStep;
            end
        end
    end
    
   
elseif encodingMethod == 3 %Manchester signaling
    for i = 1:length(input)
        if input(i) == 0
            for j = 1:nTimeStepsPerBit/2
                output((i-1)*nTimeStepsPerBit + j) = - A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime + 1;% timeStep;
            end
            for j = nTimeStepsPerBit/2 + 1:nTimeStepsPerBit
                output((i-1)*nTimeStepsPerBit + j) = A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime +1;% timeStep;
            end
        elseif input(i) == 1
            for j = 1:nTimeStepsPerBit/2
                output((i-1)*nTimeStepsPerBit + j) =  A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime + 1;% timeStep;
            end
            for j = nTimeStepsPerBit/2 + 1:nTimeStepsPerBit
                output((i-1)*nTimeStepsPerBit + j) = - A;
                time((i-1)*nTimeStepsPerBit + j) = currentTime;
                currentTime = currentTime +1;% timeStep;
            end
        end
    end
end
time = time.*timeStep + timeAxis(1);
% figure
% plot(time,output);
% output(i)is present.
end



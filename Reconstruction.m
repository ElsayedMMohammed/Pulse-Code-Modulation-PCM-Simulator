% function Signal= Reconstruction(t,x,Fs)
% %Inputs are:
%       t : the time array (not used)
%       x: the sampled signal to be reconstructed
%       Fs: the sampling frequency
% %Outputs are:
%       Signal: the reconstructed signal

t2=-5:5;

%%This function simulates a low pass filter to reconstruct the sampled
%%signal

% %Assuming that the filter bandwidth is half the sampling frequency
B=Fs/2;
filter=sinc(2*B*pi*t2);

Signal=conv(x,filter,'same');
end
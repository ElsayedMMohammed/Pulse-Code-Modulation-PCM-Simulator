function [time_disc,x_disc]=Sampler(t,x,fs)
%Sampler : Function that takes a signal -x- and it length in time -t- and
%the required sampling frequency and return a sampled version of signal -x-
%with sampling frequency fs

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculating the original signal sampling frequency 
nature_ts= t(2)-t(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculating ts 
ts=1/fs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creating the new (sampled time index)
time_disc=t(1):1/fs:t(length(t));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Computing the new discrete signal 
x_disc=x(1:(ts/nature_ts):length(x));
end
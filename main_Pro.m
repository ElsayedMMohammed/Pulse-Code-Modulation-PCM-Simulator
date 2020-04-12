t1= input("Please enter time array\n");
x1= input("Please enter the corresponding signal\n");
fs= input("Please enter the desired sampling frequency\n");
L= input("Please enter the Number of levels of the Quantizer\n");
mp=input("please enter the maximun range of the Quantizer [mp]\n");
type_QNR=input("Chosse the qunatinzation type\n u) Uniform          n) Non-uniform\n",'s');

while (~(type_QNR(1)== 'u'||type_QNR(1)== 'U'||type_QNR(1)== 'N'||type_QNR(1)== 'n'))
type_QNR=input("Invalid, Please enter a valid choice\n",'s');
end

if (type_QNR== 'U'||type_QNR== 'u')
    disp("Uniform choosed\n");
    meu=0;
    qtype=1;
else
     disp("Non-uniform choosed\n");
    meu = input("Please enter the u-Law parameter\n");
    qtype=2;
end 

type_Encoder= input("Please choose the type of the Encoder/Decoder\n1)Unipolar NRZ \n2) Polar NRZ\n3)Manchester\n ");
while (~(type_Encoder(1)== 1 ||type_Encoder(1)== 3 ||type_Encoder(1)== 2))
type_QNR=input("Invalid, Please enter a valid choice\n",'s');
end 

%% Sampler
[t,x]= Sampler(t1,x1,fs);
figure(1);
subplot(2,1,1);plot(t1,x1); title('The Actual Signal');
subplot(2,1,2);stem(t,x);title('The Sampled Signal');

%% Quantizer
%%uniform Quantizer
if (type_QNR== 'U'||type_QNR== 'u')
    [t,qX,pX] = UQuantizer(t,x,L,mp);
    figure(2);
%     subplot(2,1,1) ;stem(t,x); title('The Sampled Signal');
%     subplot(2,1,2); stem(t,qX); title('The uniformly quantized Signal after shifting');
%%non Uniform Quantizer
else
    [t,qX,pX] = NUQuantizer(t,x,L,mp,meu);
    figure(2);
%     subplot(2,1,1) ;stem(t,x); title('The Sampled Signal');
%     subplot(2,1,2); stem(t,qX); title('The non uniformly quantized Signal after shifting');
end
%% Encoder and Decoder

[EncodedSignal,t2] = Encoder(pX,t,type_Encoder);
figure(4);
plot(t2,EncodedSignal); title('Encoded Signal');

%% Decoder
DecodedSignal = Decoder(EncodedSignal,t2,L,fs,mp,type_Encoder,qtype,meu);
%figure(3);
%stem(t,DecodedSignal);
%% Reconstruction Filter
FinalSignal=Reconstruction(t,DecodedSignal,fs);
figure(5);
subplot(2,1,1);plot(t1,x1); title('The Actual Signal');
subplot(2,1,2);plot(t,FinalSignal);title('Pulse Code deModulated Signal');

%% Frequency representation
Fs_original= 1/(t1(2)-t1(1));
FAxis_Original =Fs_original/2*linspace(-1,1,Fs_original);
FreqOriginal = abs(fftshift(fft(x1)));

figure(6);
subplot(3,1,1); plot(FAxis_Original,FreqOriginal);title('Frequency Representation of the original signal');

FreqSampled = abs(fft(x));
% F2=-fs*(time(length(time))/2):1:fs*(time(length(time))/2);
FAxis_Sampled = fs*linspace(0,1,fs);
subplot(3,1,2); plot(FAxis_Sampled,FreqSampled);title('Frequency Representation of the sampled signal');

FreqFinalSignal= abs(fft(FinalSignal));
subplot(3,1,3); plot(FAxis_Sampled,FreqFinalSignal);title('Frequency Representation of the Output signal');
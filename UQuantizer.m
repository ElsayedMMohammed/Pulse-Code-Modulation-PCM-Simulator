function [t,qX,bX] = UQuantizer(t,X,L,mp)
%% Uniform Quantizer
% Inputs:
   % (1) t ---> Vector represents time values of the signal
   % (2) X ---> Vector represents amplitudes of the signal
   % (3) L ---> The number of quantizer's levels.
   % (4) mp ---> The maximum amplitude of the quantizer.

delta = 2*mp/L;

qX = zeros(1,length(X));
for i = 1:length(X)
    if X(1,i)>=mp 
        qX(1,i)=mp-delta/2;
    elseif X(1,i)<=-1*mp
            qX(1,i)=-1*mp+delta/2;
    else
        if X(1,i)>=0
               qX(1,i)=(round(X(1,i)/delta)*delta)-(delta/2); %Minus (delta/2) because it's mid-rise 
              if qX(1,i)==-delta/2
                  qX(1,i)= delta/2;
              end
            else 
                qX(1,i)=(round(X(1,i)/delta)*delta)+(delta/2);
                if qX(1,i)==-delta/2
                  qX(1,i)= -delta/2;
                end
            end
        end
end

figure(2);
subplot(2,1,1); stem(t,X);  title('The original sampled Signal');
subplot(2,1,2); stem(t,qX); title('The quantized Signal before shifting');


    qX = (qX + mp - delta/2)/delta; % Shift it all to positive amplitudes


n = ceil(log2(L));


bX= de2bi(round(qX),n,'left-msb');

%    subplot(3,1,3); stem(t,qX); title('The quantized Signal after shifting');
end

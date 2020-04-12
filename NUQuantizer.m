function [t,qX,bX] = NUQuantizer(t,X,L,mp,MU)

%% Non-Uniform MU Quantizer

%(1) Clip if possible
for i = 1:length(X)
    if abs(X(1,i))>mp 
        X(1,i)=sign(X(1,i))*mp; %so the values ranges from 0 --> mp
    end
end

mX=zeros(1,length(X));    
%(2) Apply the mu-law
if MU==0
    mX = X;
else
 for i = 1:length(X)   
       mX(1,i)=sign(X(1,i))*log(1+MU*abs(X(1,i))/mp)/log(1+MU);
 end
end
%(3) apply the Uniform Quanztizer
[t,qX,bX] = UQuantizer(t,mX,L,mp);
end
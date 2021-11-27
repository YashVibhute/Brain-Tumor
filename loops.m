clc
clear all
close all 
%% Accessing Content
cd 
ds = imageDatastore('brain_tumor_dataset','IncludeSubfolders',1,'LabelSource','Foldernames');
for counter = 1:253
    img = readimage(ds,counter);
    if(size(img,3)~=1)
    img = rgb2gray(img);
    img=uint8(img);
    end
    
%RSESIHEoutput=RS_ESIHE_ALGO(img);

%RESIHEoutput=R_ESIHE_ALGO(img); % For r=2


%% Histogram Calculation
L=256;
x=[0:1:L-1];
[m,n]=size(img); 
len=m*n;
y=reshape(img,len,1);   
xpdf=hist(y,[0:L-1]); 

%% Clipping Process
Xo=mean(mean(img))
Tc=mean(xpdf);  % mean pixels for gray levels
Tc=round(Tc);
u=0;
Ihist=zeros(1,256);   % intermediate histogram for clipping
 for i=1:256
     if xpdf(i)>Tc
     Ihist(i)=Tc;
     elseif xpdf(i)==0
         u=u+1;
         Ihist(i)=xpdf(i);
     else
         Ihist(i)=xpdf(i);
     end     
 end
%% R-ESIHE
exposure=sum(xpdf.*x)/sum(xpdf)/(L);
aNorm=(1-exposure);
a=round(L*aNorm);
RESIHEoutput=BHE(img,Ihist,a);
for u=1:2
[m,n]=size(RESIHEoutput); 
len=m*n;
y1=reshape(RESIHEoutput,len,1);   % m X N array into mn X 1
xpdf1=hist(y1,[0:L-1]); % pdf, 1 x L
Xo1=round(mean(mean(RESIHEoutput)));
Tc=mean(xpdf1);  % mean pixels for gray levels
Tc=round(Tc);
Ihist=zeros(1,256);   % intermediate histogram for clipping
 for i=1:256
     if xpdf1(i)>Tc
     Ihist1(i)=Tc;
     elseif xpdf1(i)==0
         Ihist(i)=xpdf1(i);
     else
         Ihist1(i)=xpdf1(i);
     end     
 end
exposure=sum(xpdf1.*x)/sum(xpdf1)/(L);
aNorm=(1-exposure);
a=round(L*aNorm);
RESIHEoutput=BHE(RESIHEoutput,Ihist1,a);
end



%% entropy
R_ESIHE_entropy = entropy(RESIHEoutput)
%RS_ESIHE_entropy = entropy(RSESIHEoutput)

Re(counter)= R_ESIHE_entropy
%RSe(i)= RS_ESIHE_entropy

%% NIQE
R_ESIHE_niqe = niqe(RESIHEoutput);
%RS_ESIHE_niqe = niqe(RSESIHEoutput);

Rn(counter)= R_ESIHE_niqe
%RSn(i)= RS_ESIHE_niqe

%% PIQE
R_ESIHE_piqe = piqe(RESIHEoutput);
%RS_ESIHE_piqe = piqe(RSESIHEoutput);

Rp(counter)= R_ESIHE_piqe
%RSp(i)= RS_ESIHE_piqe

%% Brisque
R_ESIHE_brisque = brisque(RESIHEoutput);
%RS_ESIHE_brisque = brisque(RSESIHEoutput);

Rb(counter)= R_ESIHE_brisque
%RSb(i)= RS_ESIHE_brisque

    
    
    

end



%% Bi-Histogram Equalization
function [ BHEoutput ] =BHE( i,X,Xm ) %inputs: image,histogram,mean
[w,l]=size(i);

BHEoutput=zeros(size(i));          
C_L=zeros(1,Xm+1);
C_U=zeros(1,(256-(Xm+1)));
n_L=sum(X(1:Xm+1));
n_U=sum(X(Xm+2:256));
P_L=X(1:Xm+1)/n_L;
P_U=X(Xm+2:256)/n_U;
C_L(1)=P_L(1);
for r=2:length(P_L)
    C_L(r)=P_L(r)+C_L(r-1);
end
C_U(1)=P_U(1);
for r=2:(length(P_U))
    C_U(r)=P_U(r)+C_U(r-1);
end
for r=1:w                           %to obtain the histogram 
    for s=1:l
        if i(r,s)<(Xm+1)
            f=Xm*C_L(i(r,s)+1);
            BHEoutput(r,s)=round(f);
        else
            f=(Xm+1)+(255-Xm)*C_U((i(r,s)-(Xm+1))+1);
            BHEoutput(r,s)=round(f);
        end
    end
end
if strcmp(class(i),'uint8')
    BHEoutput = uint8(BHEoutput);
elseif strcmp(class(i),'uint16')
     BHEoutput = uint16(BHEoutput);
elseif strcmp(class(i),'int16')
     BHEoutput = int16(BHEoutput);
elseif strcmp(class(i),'single')
     BHEoutput = single(BHEoutput);
end
end
  
    
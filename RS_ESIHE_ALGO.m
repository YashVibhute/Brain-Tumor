function [ RSESIHEoutput ] = RS_ESIHE_ALGO( img )
%% Recursively Separated Exposure based Sub Image Histogram Equalization(RS-ESIHE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All rights reserved.
% This work should only be used for nonprofit purposes.
% Please cite the paper when you use this code:
% Kuldeep Singh, Rajiv Kapoor, and Sanjeev Kr Sinha, "Enhancement of low exposure images via recursive 
% histogram equalization algorithms,"Optik, vol. 126, pp. 2619–2625, 2015.
%
% AUTHOR:
%     Kuldeep Singh,Scientist , Central Research Lab, Bharat Electronics Ltd, India,
%     email:kuldeep.er@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Histogram Calculation
L=256;
x=[0:1:L-1];
[m,n]=size(img); 
len=m*n;
y=reshape(img,len,1);   
xpdf=hist(y,[0:L-1]); 
%% RS-ESIHE
exposure=sum(xpdf.*x)/sum(xpdf)/(L);
aNorm=(1-exposure);
Xm=round(L*aNorm);
x=[1:1:Xm];
y=[Xm+1:1:256];
expl=sum(xpdf(1:Xm).*x)/sum(xpdf(1:Xm))/(L);
expu=sum(xpdf(Xm+1:256).*y)/sum(xpdf(Xm+1:256))/(L);

aNorml=(Xm/L-expl);
Xml=round(L*aNorml);
aNormu=(1-expu+Xm/L);
Xmu=round(L*aNormu);
if Xm==Xmu
    Xm=Xm-1;
end;
RSESIHEoutput=RHE(img,xpdf,Xm,Xml,Xmu);
end
%% Recursive Histogram Equalization
function [ RMSoutput ] = RHE(i,X,Xm,Xml,Xmu ) %inputs: image,histogram,mean.mean1,mean2
[w,l]=size(i);
RMSoutput=zeros(size(i));          %RMS output
C_Ll=zeros(1,Xml);
C_Ul=zeros(1,(Xm-Xml));
n_Ll=sum(X(1:Xml));
n_Ul=sum(X(Xml+1:Xm));
P_Ll=X(1:Xml+1)/n_Ll;
P_Ul=X(Xml+1:Xm)/n_Ul;
C_Ll(1)=P_Ll(1);
for r=2:length(P_Ll)
    C_Ll(r)=P_Ll(r)+C_Ll(r-1);
end
C_Ul(1)=P_Ul(1);
for r=2:(length(P_Ul))
    C_Ul(r)=P_Ul(r)+C_Ul(r-1);
end
C_Lu=zeros(1,Xmu-Xm);
C_Uu=zeros(1,(256-Xmu));
n_Lu=sum(X(Xm+1:Xmu));
n_Uu=sum(X(Xmu+1:256));
P_Lu=X(Xm+1:Xmu)/n_Lu;
P_Uu=X(Xmu+1:256)/n_Uu;
C_Lu(1)=P_Lu(1);
for r=2:length(P_Lu)
    C_Lu(r)=P_Lu(r)+C_Lu(r-1);
end
C_Uu(1)=P_Uu(1);
for r=2:(length(P_Uu))
    C_Uu(r)=P_Uu(r)+C_Uu(r-1);
end
for r=1:w                           %to obtain the 4 Equalized histograms 
    for s=1:l
        if i(r,s)<(Xml+1)
            f=Xml*C_Ll(i(r,s)+1);
            RMSoutput(r,s)=round(f);
        else
            if (i(r,s)>=(Xml+1))&&(i(r,s)<(Xm+1))
                f=(Xml+1)+(Xm-Xml)*C_Ul((i(r,s)-(Xml+1))+1);
                RMSoutput(r,s)=round(f);
         
        else
            if (i(r,s)>=Xm+1)&&(i(r,s)<(Xmu+1))
            f=(Xm+1)+(Xmu-Xm)*C_Lu((i(r,s)-(Xm+1))+1);
                RMSoutput(r,s)=round(f);
            
        else
            f=(Xmu+1)+(255-Xmu)*C_Uu((i(r,s)-(Xmu+1))+1);
            RMSoutput(r,s)=round(f);
            end
            end
        end
    end
end
end


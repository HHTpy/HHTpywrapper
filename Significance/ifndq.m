% function omega = ifndq(vimf, dt)
%
%
% INPUT:   
%          vimf:        an IMF;
%          dt:          time interval of the imputted data
% OUTPUT:
%          omega:       instantanesous frequency, which is 2*PI/T, where T
%                       is the period of an ascillation
% NOTE:
%     this is a function to calculate instantaneous based on EMD method--
%     normalize the absolute values and find maximum envelope for 5 times
%     then calculate the Quadrature ,Phase angle,then take difference to them
%     finally,the instantaneous frequency values of an IMF is found. 
%
%Reference:  
%
%
%  code writer:Zhaohua Wu,mailbox:zhwu@cola.iges.org
%  footnote:S.C.Su 2009/05/14
%
% 1.set initial parameters
% 2.find absolute values
% 3.find the spline envelope for AM,take those out-loop start
%   4.Normalize the envelope out (for 5 times)
% 3.find the spline envelope for AM,take those out-loop end 
% 5.flip back those negative values after AM been removed    
% 6.Calculate the quadrature values
% 7.Calculate the differece of the phase angle and give +/- sign
% 8.create a algorithm to remove those outliner
% 9.remove those marked outliner
%10.use cubic spline to smooth the instantaneous frequency values 
%11.return the values back
%
%
% Association:  those procedure of HHT need this code
%1.EMD 
%2.EEMD
%
% Concerned function: no
%
%

function omega = ifndq(vimf, dt)
%
%1.set initial parameters
 Nnormal=5;%number of spline envelope normalization for AM
 rangetop=0.90; %the threshold of outliner remove for instantaneous frequency values
 vlength = max( size(vimf) );
 vlength_1 = vlength -1;

%2.find absolute values
 for i=1:vlength,
     abs_vimf(i)=vimf(i);
     if abs_vimf(i) < 0
         abs_vimf(i)=-vimf(i);
     end
 end

%3.find the spline envelope for AM,take those out-loop start
 for jj=1:Nnormal,
     [spmax, spmin, flag]=extrema(abs_vimf);
     dd=1:1:vlength;
     upper= spline(spmax(:,1),spmax(:,2),dd);
 
%4.Normalize the envelope out 
     for i=1:vlength,
         abs_vimf(i)=abs_vimf(i)/upper(i);
     end
 end
%3.find the spline envelope for AM,take those out-loop end 

%5.flip back those negative values after AM been removed
 for i=1:vlength,
     nvimf(i)=abs_vimf(i);
     if vimf(i) < 0;
         nvimf(i)=-abs_vimf(i);
     end
 end

%6.Calculate the quadrature values
 for i=1:vlength,
     dq(i)=sqrt(1-nvimf(i)*nvimf(i));
 end

%7.Calculate the differece of the phase angle and give +/- sign
 for i=2:vlength_1,
     devi(i)=nvimf(i+1)-nvimf(i-1);
     if devi(i)>0 & nvimf(i)<1
         dq(i)=-dq(i);
     end
 end

%8.create a algorithm to remove those outliner
rangebot=-rangetop;     
 for i=2:(vlength-1),
     if nvimf(i)>rangebot & nvimf(i) < rangetop
        %good original value,direct calculate instantaneous frequency  
         omgcos(i)=abs(nvimf(i+1)-nvimf(i-1))*0.5/sqrt(1-nvimf(i)*nvimf(i));
     else
        %bad original value,direct set -9999,mark them 
         omgcos(i)=-9999;
     end
 end
 omgcos(1)=-9999;
 omgcos(vlength)=-9999;

%9.remove those marked outliner
 jj=1;
 for i=1:vlength,
     if omgcos(i)>-1000
         ddd(jj)=i;
         temp(jj)=omgcos(i);
         jj=jj+1;
     end
 end

%10.use cubic spline to smooth the instantaneous frequency values 
 temp2=spline(ddd,temp,dd); 
 omgcos=temp2;

%11.return the values back
 for i=1:vlength,
     omega(i)=omgcos(i);
 end
 pi2=pi*2;
 omega=omega/dt;
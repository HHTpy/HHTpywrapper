%function [f,a] = FAcosfor(data, dt)
%
% The function FAcosfor generates a  frequency and amplitude 
% of previously normalized data(n,k) using cosine formula method,
% where n is the length of the time series and k is the number of IMF components.
% 
% FAcosfor finds the frequency by applying
% the cosine-angle-sum identity to the normalized data.
% The special point of this method is "no trigonometric function value is calculated"
% the sample rate of the data must be high enough---this is the assumption
%
% Calling sequence-
% [f,a] = FAcosfor(data, dt)
%
% Input-
%	  data	- 2-D matrix of IMF components 
%	  dt	    - time increment per point
% Output-
%	  f	    - 2-D matrix f(n,k) that specifies frequency
%	  a	    - 2-D matrix a(n,k) that specifies amplitude
%Note:
% Used by- 
%	FA
%Reference:  
%
%written by 
% Zhaohua Wu (NCU RCADA)	Summer 2007, Initial
% adapted by S.C.Su and Men-Tzung Lo
%footnote: S.C.Su (2009/09/12)
%
%1.read the data,check input matrix
%2.Do the normalization  for an IMF ---loop A start
%   3.compute the phase angle by arc-cosine function   
%   4.take difference for the phase angle 
%2.Do the normalization  for an IMF ---loop A end
%

function [f,a] = FAcosfor(data, dt)

disp('WARNING: Sample rate must high enough for this method.');

%1.read the data,check input matrix
    %----- Get dimensions
    [npts,nimf] = size(data);
    
    %----- Flip data if necessary
    flipped=0;
    if (npts < nimf)
        flipped=1;
        data=data';
        [npts,nimf] = size(data);
    end
    
    %----- Input is normalized, so assume that amplitude is always 1
    a = ones(npts,nimf);
    
    
%2.Do the calculation  for an IMF ---loop A start
    %----- Process each IMF
    for c=1:nimf
                
%3.compute the phase angle by cosine formula method
     rangetop=0.90;
     rangebot=-rangetop;     
       for i=2:npts-1
           if data(i,c)>rangebot & data(i,c) < rangetop
               omgcos(i)=abs(data(i+1,c)-data(i-1,c))*0.5/sqrt(1-data(i,c).*data(i,c));
           else
               omgcos(i)=-9999;
           end
       end
       omgcos(1)=-9999;
       omgcos(npts)=-9999;
       
%9.remove those marked outliner           
       jj=1;
       for i=1:npts
           if omgcos(i)>-1000
               ddd(jj)=i;
               temp(jj)=omgcos(i);
               jj=jj+1;
           end
       end
       
%10.use cubic spline to smooth the instantaneous frequency values
       dd=1:1:npts;        
       temp2=spline(ddd,temp,dd); 
       omgcos=temp2;
       clear ddd temp dd temp2
       %clear syntax is important for this kind of algorithm-S.C.Su
       %choose some value with out clear makes chaos
       
%11.return the values back       
       for i=1:npts,
           omega(i)=omgcos(i);
       end
       
       pi2=pi*2;
       f(:,c)=omega/dt/pi2;    
                  
%2.Do the normalization  for an IMF ---loop A end
    end 

%----- Flip again if data was flipped at the beginning
if (flipped)
    f=f';
    a=a';
end
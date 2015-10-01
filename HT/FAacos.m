%function [f,a] = FAacos(data, dt)
%
% The function FAacos generates an arccosine frequency and amplitude 
% of previously normalized data(n,k), where n is the length of the
% time series and k is the number of IMF components.
% 
% FAacos finds the frequency by applying
% the arc-cosine function to the normalized data and
% checking the points where the slope of arc-cosine phase changes.
% Nature of the procedure suggests not to use the function
% to process the residue component.
%
% Calling sequence-
% [f,a] = FAacos(data, dt)
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
% Kenneth Arnold (NASA GSFC)	Summer 2003, Initial
%footnote: S.C.Su (2009/09/12)
%
%1.read the data,check input matrix
%2.Do the normalization  for an IMF ---loop A start
%   3.compute the phase angle by arc-cosine function   
%   4.take difference for the phase angle 
%2.Do the normalization  for an IMF ---loop A end
%

function [f,a] = FAacos(data, dt)

disp('WARNING: Applying the function to the residue can cause an error.');

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
    
    %----- Mark points that are above 1 as invalid (Not a Number)
    data(find(abs(data)>1)) = NaN;

%2.Do the normalization  for an IMF ---loop A start
    %----- Process each IMF
    for c=1:nimf
        %----- Compute "phase" by arc-cosine function 
        acphase = acos(data(:,c));
        
%3.compute the phase angle by arc-cosine function
    %----- Mark points where slope of arccosine phase changes as invalid
    %after difference the arc-cosine function will be discontinuous at those points 
      for i=2:npts-1
          prev = data(i-1,c);%value of 'i-1' position
          cur = data(i,c);   %value of  'i'  position
          next = data(i+1,c);%value of 'i+1' position
          
          %Check for local max and local min, set them as NaN
          if (prev < cur & cur > next) | (prev > cur & cur < next)
              acphase(i) = NaN;
              
          end
      end
           
      clear prev cur next
       %clear syntax is important for this kind of algorithm-S.C.Su
       %choose some value with out clear makes chaos
%4.take difference for the phase angle                                  
    %----- Get phase differential frequency--calculate I.F. values
    acfreq = abs(diff(acphase))/(2*pi*dt);
    
    %----- Mark points with negative frequency as invalid
    acfreq(find(acfreq<0)) = NaN;
    
    %----- Fill in invalid points using a spline
    legit = find(~isnan(acfreq));%legit=allvalues-NaN
      %interpolate for NaN positions  
      if (length(legit) < npts)
        f(:,c) = spline(legit, acfreq(legit), 1:npts)';
      else
        f(:,c) = acfreq;
      end
%2.Do the normalization  for an IMF ---loop A end
    end

%----- Flip again if data was flipped at the beginning
if (flipped)
    f=f';
    a=a';
end

%function [allx, ally] = findcriticalpoints(datay)
%
%
% Input-
%	     datay	- input vector of values
% Output-
%	     allx	  - vector that specifies the coordinates of max, min
%		             and zero crossing values in the order found
%	     ally	  - corresponding max, min and zero values
%
%Note:
%     The function FINDCRITICALPOINTS returns max, min and zero crossing values
%     and their coordinates in the order found in datay(n),
%     where n specifies the dimension of array datay.
%     The value datay(i) is considered to have a local minimum in i,
%     if datay(i-1) > datay(i) < datay(i+1);
%     The value datay(i) is considered to have a local maximum in i,
%     if datay(i-1) < datay(i) > datay(i+1);
%     The value datay(i) is considered to have a zero crossing, if
%     datay(i) and datay(i+1) have different signs. The coordinate
%     of datay(i) is linearly interpolated.
%
%
%Reference:  
%
%
%  code writer:Karin Blank (NASA GSFC)	March 26, 2003  Initial
% Jelena Marshak (NASA GSFC)	July 16, 2004 Modified
%	(Replaced '&&' by '&' in zero-crossing calculation section.)
%	(Corrected zero-crossing calculation.)
% footnote:S.C.Su 2009/05/14
% 
%1.checking point by point----loop start 
%    ----- Find local maximum 
%    ----- Find local minimum 
%    ----- Find zero crossings
%1.checking point by point----loop end%
%             
% Association:   
%                    
% Concerned function:
%
% Notes-
% Used by FAZ, FAZPLUS
%
% Calling sequence-

function [allx, ally] = findcriticalpoints(datay)

%----- Initialize values
allx = [];
ally = [];
Ymax = 0;
Ymin = 0;
Xmax = 0;
Xmin = 0;
flagmax = 0;
flagmin = 0;

%1.checking point by point----loop start
  for i=2:length(datay)-1;
    %----- Find local maximum
     if ((datay(i) > datay(i-1)) & (flagmax == 0))
         flagmax = 1;
         
         Xmax = i;
         Ymax = datay(i);
     end
     
     if((datay(i) < datay(i+1)) & (flagmax == 1))
         flagmax = 0;
     end
     
     if((datay(i) > datay(i+1)) & (flagmax == 1))
         flagmax = 0;
          
         ally = [ally, Ymax];
         
         allx = [allx, Xmax];
     end
     
    %----- Find local minimum
     if((datay(i) < datay(i-1)) & (flagmin == 0))
         flagmin = 1;
         Xmin = i;
         Ymin = datay(i);
     end
     
     if((datay(i) > datay(i+1)) & (flagmin == 1))
         flagmin = 0;
     end
     
     if((datay(i) < datay(i+1)) & (flagmin == 1))
         flagmin = 0;
        
         allx = [allx, Xmin];
         ally = [ally, Ymin];
     end
     
    %----- Find zero crossings
     if(((datay(i) > 0) & (datay(i+1) < 0)) | ((datay(i) < 0) & (datay(i+1) > 0)))
         %----- Estimate where zero crossing actually occurs
         slope = (datay(i+1) - datay(i)); %(delta x = 1)
         b = datay(i+1) - (slope * (i+1));
         x = -b/slope;
         
         allx = [allx, x];
         ally = [ally, 0];
     elseif(datay(i) == 0.)
         x=i;
         allx = [allx, x];
         ally = [ally, 0];
%         zero_cross = [zero_cross2, i];
     end
 end
%1.checking point by point----loop end 
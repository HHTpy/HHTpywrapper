%function  [f,a]=FAquadrature(data,dt)
%
% The function FAquadrature generates a frequency and amplitude using Quadrature method 
% applied to data(n,k), where n specifies the length of time series, 
% and k is the number of IMFs.
% Non MATLAB Library routine used in the function is: FINDCRITICALPOINTS.
%
% Calling sequence-
% [f,a]=faquadrature(data,dt)
%
% Input-
%	  data	- 2-D matrix of IMF components 
%	  dt	    - time increment per point
% Output-
%	  f	    - 2-D matrix f(n,k) that specifies frequency
%	  a	    - 2-D matrix a(n,k) that specifies amplitude
%
%Note:
% Used by- 
%	FA
%Reference:  
% fa.m code modification by Xianyao Chen (RCADA, FIO)
% Discussion result about fa.m in 2009 HHT class with Norden E. Huang 
%written by 
% S.C.Su    Sep. 2009(NCU Rcada)combine noh.m and calcqf.m together
%           as a new mfile FAquadrature.m  
%  in order to integrate all m file in a group type         
%footnote: S.C.Su (2009/09/07)
%
% 1. Two extra normalization before quad
% 2.use function noh to form the analytical signal with quadratrue formula
% 3.use function calcqf to calculate the Instantaneous frequency
%

function  [f,a]=FAquadrature(data,dt)

%1. Two extra normalization before quad 
%before calculate I.F with quadrature mathod 
%    Normalize twice to make sure the values lie between +1~-1
    [data,a1]=pchipnormalize(data);
    [nIMF,a2]=pchipnormalize(data);
    a=a1.*a2;

%2.use function noh to form the analytical signal with quadratrue formula
quadrature = noh(nIMF);

%3.use function calcqf to calculate the Instantaneous frequency
smooth=5;
instfreq = calcqf(quadrature, dt);
f=instfreq;


% the following are functions used in the above code
%#########################################################################
%function quadrature = noh(nIMF)
%
% INPUT:
%       nIMF     - normalized IMFs to calculate analytical signal on
%                  (an 1D data) 
%
% OUTPUT:
%       quadrature  -the analytical signal
%                    A complex array with actual data stored in real part 
%                    and  the phase-shifted equivalent in the imaginary part
%
% NOTE: 
%       Quadrature- a new method to calculate instantaneous frequency propose by Norden E. Huang
%                   There are 3 steps .
%                    1.normalize the IMF, this helps IMF become AM/FM disjointed 
%                    2.form the analytical signal,the normalized-IMF(x), be the real part
%                                                 the quadrature of normalized-IMF(x)- sqrt(1-xx) , be the imaginary part
%                    3.calculate the nstantaneous frequency,use real/imaginary part to find phase angle,and the time derivative is I.F
%       this code is some part of the quadrature calculations
%
%       noh.m------use Normalized IMF to compose the analytical signal using quadrature calculation
%       noh() - creates the quadtrature signal without the Hilbert transform
%
% References:   
%  N. E Huang (2008),NCU hht class lecture 
%  6 Instantaneous Frequency.ppt
%
% code writer: Karin Blank (karin.blank@nasa.gov) for Norden Huang (5/6/05),code originally from nfame.m
% footnote:S.C.Su 2009/04/18
%
% There are only one loop in this code dealing with 1D IMF.
%  1.check input,flip signal if necessary
%  2.Calculate the quadrature value--loop start 
%     3.add mask-for positive/negative signal  
%     4.the calculation of quadrature value   
%     5.multiplying by mask flips data in 3rd & 4th quadrature   
%  2.Calculate the quadrature value--loop end      
%     
%     
% Association: no
% 1. this function ususally used for calculation for I.F
%    the second part-form the analytical signal
%    this code only dealing with forming analytical signal
% 
% Concerned function: epnormal,calcqf
%                     the others are matlab functions.  
% 
function quadrature = noh(nIMF)

%1.check input,flip signal if necessary
%----- Get the dimension
[npt,ncol] = size(nIMF);

%----- Initialize and flip data if needed 
flipped=0;
if (ncol > npt)
    flipped=1;
    data=data';
    [npt,ncol] = size(data);
end

%2.Calculate the quadrature value--loop start
 
 
for i=1:ncol;
        data = nIMF(:,i);
       
%3.add mask-for positive/negative signal    
        %creates a mask for the signal 
        %the 1st & 2nd Q = 1 
        %and the 3rd & 4th Q = -1
        mask = ((diff(data)>0) .* -2) + 1;
        mask(end+1) = mask(end);
    
%4.the calculation of quadrature value
        y = real(sqrt(1-data.^2));
    
%5.multiplying by mask flips data in 3rd & 4th quadrature
        q = y .* mask;
        quadrature(:,i) = complex(data, q);
        clear mask y q
end
 if flipped==1
    quadrature = quadrature';
    end
%2.Calculate the quadrature value--loop end
%end of noh.m   

%#########################################################################

%function instfreq = calcqf(quadrature, dt, smooth)
%
%
% INPUT:
%        quadrature  - is the complex quadrature signal
%        dt          - is the time increment of the data
%        smooth      - the number of digital values to do median smooth
% OUTPUT: 
%        instfreq    - is the instantaneous frequency of the quadrature signal
%
% NOTE: 
%     this code calculates the instantaneous frequency from the analytic signal
%       Quadrature- a new method to calculate instantaneous frequency propose by Norden E. Huang
%                   There are 3 steps .
%                    1.normalize the IMF, this helps IMF become AM/FM disjointed 
%                    2.form the analytical signal,the normalized-IMF(x), be the real part
%                                                 the quadrature of normalized-IMF(x)- sqrt(1-xx) , be the imaginary part
%                    3.calculate the nstantaneous frequency,use real/imaginary part to find phase angle,and the time derivative is I.F
%       this code is some part of the quadrature calculations
%
% References:   
%  N. E Huang (2008),NCU hht class lecture 
%  6 Instantaneous Frequency.ppt
%
% code writer: Karin Blank (karin.blank@nasa.gov) for Norden Huang (5/6/05)
% footnote:S.C.Su 2009/04/18
%
%
% There are only one loop in this code dealing with 1D IMF.
%  1.check input,flip signal if necessary
%  %2.Calculate the phase and it's derivative  value--loop start
%     3.add median filter to smooth the value
%  %2.Calculate the phase and it's derivative  value--loop end   
%     
%     
% Association: no
% 1. this function ususally used for calculation for I.F
%    the second part-form the analytical signal
%    this code only dealing with forming analytical signal
% 
% Concerned function: epnormal,noh
%                     the others are matlab functions.  
%
function instfreq = calcqf(quadrature, dt)
%

%1.check input,flip signal if necessary
%----- Get the dimension
[npt,ncol] = size(quadrature);

%----- Initialize and flip data if needed 
flip=0;
if (ncol > npt)
    flip=1;
    data=data';
    [npt,ncol] = size(data);
end


%2.Calculate the phase and it's derivative  value--loop start
for i=1:ncol
    f = diff(unwrap(angle(quadrature(:,i))))./(2*pi*dt);

    f(end+1) = f(end);
    
%     s_diff = floor(smooth/2);
%     
% %3.add median filter to smooth the value --this paragragh is removed when in fa.m
% there is already a median filter in fa.m
disp('Look! median filter in FAquadrature.m is been closed,fa.m already with median filter!!') 
%     if(smooth > 1)
%         for(j=s_diff+1:(length(f)-s_diff))
%             f(j) = median(f(j-s_diff:j+s_diff));
%         end
%     end
    
    instfreq(:,i) = f;
 end
%2.Calculate the phase and it's derivative  value--loop end
if flip ==1
  quadrature = quadrature';  
end    
%end of calcqf.m
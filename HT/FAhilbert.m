%function [f, a] = FAhilbert(data,dt)

% The function FAhilbert calculates an improved Hilbert frequency and amplitude
% of data(n,k), where n specifies the length of time series, and 
% k is the number of IMF components.
% Regular Hilbert transform is used to perform a Hilbert transform.
%
% Non MATLAB Library routine used in the function is: HILBTM.
% Note: FAH allows the instantaneous frequency to be negative. 
%
% Calling sequence-
% [f,a] = fah(data,dt)
%
% Input-
%   data	- 2-D matrix data(n,k) of IMF components 
%	dt	    - sampling period in seconds
% Output-
%	f	    - 2-D matrix f(n,k) that specifies the Hilbert frequency in Hz
%	a	    - 2-D matrix a(n,k) that specifies the Hilbert amplitude
%
% Used by-
% 	FA, NSPABMUN.
%
%written by  
% Norden Huang (NASA GSFC) Junw 2,2002 :Initial
% Xianyao Chen, september, 2008 : modified
% S.C.Su ,Sep ,2009, rename all the functions
%
function [f, a] = FAhilbert(data,dt)

%----- Get the dimension
%[n,m] = size(data);            
[nIMF,npt] = size(data);  
flip=0;
if nIMF>npt
    data=data';
    [nIMF,npt] = size(data);
    flip=1;
end   


%h=hilbert(data);%NG here

%----- Apply improved Hilbert transform
%----- Get the instantaneous frequency

f(1:nIMF,1:npt)=0;
 for j1=1:nIMF
    h1=hilbert(data(j1,:));
 temp=diff(unwrap(angle(h1)))./(2*pi*dt);

%----- Duplicate last points to make dimensions equal
 tta=[temp temp(end)];
 f(j1,1:npt)=tta(1:npt);
 a(j1,1:npt)=abs(h1);
clear tta temp h1
end

%----- Get the amplitude

if flip ==1
    f=f';
    a=a';
end    

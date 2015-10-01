%function [ndata,a]=hilbertnormalize(data)

% The function HILBERTNORMALIZE normalizes data using its own Hilbert transformation.
% 
% Non MATLAB Library function used is: HILBTM
% First argument is required. If not passed, second argument defaults to 0.
% If flipping of data is desired r should be set to 1.
%
% Calling sequence-
% [ndata,a]=hilbertnormalize(data)
%
% Input-
%	data	- 2-D matrix data(n,m) that specifies the IMF components 
% 
% Output-
%	ndata	- 2-D normalized data (FM)
%	   a	- 2-D Hilbert envelope(AM) 
%
% Used by-
% 	FA

%written by  
% Kenneth Arnold (NASA GSFC)	Summer 2003 Initial
% NEH replaced HILBT with HILBTM  23 March 2005
% S.C.Su-change some syntax (for the footnote only)2009
%footnote: S.C.Su (2009/09/01)
%  1.read the data,check input matrix
%  2.Do the normalization using NEH hilbert code-AM
%  3.normalize the IMF,AM been devided out
%
function [ndata,a]=hilbertnormalize(data)

%  1.read the data,check input matrix
%----- Get the dimension
[n,m] = size(data);

%----- Initialize and flip data if needed 
flipped=0;
if (n<m)
    flipped=1;
    data=data';
    [n,m]=size(data);
end

%2.Do the normalization using NEH hilbert code-AM
%----- Apply modified Hilbert transform to get an envelope
a=abs(hilbtm(data));

%3.normalize the IMF,AM been devided out
%----- Normalize data by Hilbert envelope
ndata = data ./ a;

%add a sentence for trend result for the hilbert-normalize
  for c=1:m
     if (isinf(ndata(1,c)) & isinf(ndata(2,c)) & isinf(ndata(3,c)))
      disp('there is a trend been put into hilbert normalize')   
      ndata(1:n,c)=0;
     end
  end  

%----- Flip data back if needed
if (flipped)
    ndata=ndata';
    a=a';
end

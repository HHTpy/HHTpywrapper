function r = ratio1(c)

% The function RATIO1 calculates the non-orthogonal leakage of components,
% where r is calculated according to the following rule being applied
% to the case when c is the 2-D array.
%	r= c(1)*c(2)+...+c(k-1)*c(k)) / ( c(1)+...c(k) )^2.
%
% Calling sequence-
% r=ratio1(c)
%
% Input-
%	c	- 2-D matrix c(n,k) of IMF components
%		 excluding the trend component.
% Output-
%	r	- value of the ratio
%

%----- Get dimensions and initialize

[npt,knb] = size(c);
a1=0;

%----- Calculate the ratio
for i=1:knb-1,
   for j=i+1:knb,
      a1=a1+sum(c(:,i).*c(:,j));
   end
end
fprintf('%f\n',a1);

c=sum(rot90(c));
c=c.*c;
a2=sum(c);
r=a1/a2;

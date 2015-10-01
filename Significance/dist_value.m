%   function PDF = dist_value(yPos, yBar, nDof)
%
%   INPUT:
%          yPos: An input array at which PDF values are calculated---y value
%                yPos is an 1D 5000 pt matrix for y value in interval-[yUpper,yLower]
%	         yBar: The mean value of y ---------------------------exp(yBar)=E-bar
%	         nDof: The number of degree of freedom----------------Ndof=Npt
%   OUTPUT:
%           PDF: a normalized output array -about the PDF distribution     
%
%   NOTE:   This is a utility program being called by "confidenceLine.m".
%            this code calculate PDF value under yPos range 
%            within the mean value of y(y-bar) of a chi-square distribution
%            here main job is calculating equation(3.4)--PDF formula from the reference paper
%
% References:            
%        'A study of the characteristics of white noise using the empirical mode decomposition method' 
%        Zhaohua,Wu and Norden E. Huang
%        Proc. R. Soc. Lond. A (2004) 460,1597-1611
%
% code writer: zhwu@cola.iges.org
% footnote:S.C.Su 2009/05/31
%
%   1.start to form equation(3.4)--PDF formula
%   2.calculate PDF value for every y value
%   3.to ensure the converge of the calculation,divide by rscale
%
% Association: 
%   this function is called by confidenceLine.m 
%    calculate the PDF value  for 'sigline' 
%
% Concerned function: confidenceLine.m 
%                     the others are matlab functions.  
%

function PDF = dist_value(yPos, yBar, nDof)

ylen = length(yPos);

%1.start to form equation(3.4)--PDF formula
eBar = exp(yBar);%E-bar
evalue=exp(yPos);%E

%2.calculate PDF value for every y value 
for i=1:ylen,
    tmp1 = evalue(i)/eBar-yPos(i);%calculate---tmp1=(E/E-bar)-y
    tmp2 = -tmp1*nDof*eBar/2;%calculate--------tmp2=(-1/2)*E-bar*Ndof*tmp1
    tmp3(i) = 0.5*nDof*eBar*log(nDof) + tmp2;
end

%3.to ensure the converge of the calculation,divide by rscale
%   because the PDF is a relative value,not a absolute value
rscale = max(tmp3);

tmp4 = tmp3 - rscale;%minus means divide,after we take expontial 
PDF= exp(tmp4);
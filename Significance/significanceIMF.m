%   function logep = significanceIMF(imfs)
%
%   INPUT:
%       imfs:     a 2D (Npts,Nimf)IMF matrix after EMD or EEMD(Wu's suggestion) processed.
%                  The first IMF must be included for it is used to obtain the relative mean
%                 energy for other 1IMFs. The trend is not included.
%   OUTPUT:
%       logep:    a 2D , with the first column the natural
%                 logarithm of mean period, and the second column the
%                 natural logarithm of mean energy for all IMFs
%
%   NOTE:     this code calculate [lnE,lnT] value for IMFs
%
% References:            
%        'A study of the characteristics of white noise using the empirical mode decomposition method' 
%        Zhaohua,Wu and Norden E. Huang
%        Proc. R. Soc. Lond. A (2004) 460,1597-1611
%
% code writer: zhwu@cola.iges.org
% code writer: S.C.Su-separate significance.m into 3 parts.2009/05/31
%              this part is to calculate [lnE,lnT] value for IMFs
% footnote:S.C.Su 2009/05/31
%
% Concerned function: ifndq.m ,extrema.m
%                     the others are matlab functions.  
%

function logep = significanceIMF(imfs)

nDof = length(imfs(:,1));%number of data points=degree of freedom

%calculating (lnE,lnT) values
%the energy of IMF--sum(square of the data/Ndof)
%1.start to calculate the energy for every IMF
  columns=length(imfs(1,:));
  for i=1:columns,
      logep(i,2)=0;
      logep(i,1)=0;
      for j=1:nDof,
          logep(i,2)=logep(i,2)+imfs(j,i)*imfs(j,i);
      end
      logep(i,2)=logep(i,2)/nDof;
    
  end

%set the first IMF as a whiteNoise,set it as sfactor ,to be the beginning point
  sfactor=logep(1,2);
  for i=1:columns,
      logep(i,2)=0.5636*logep(i,2)/sfactor;  % 0.6441
  end

%2.start to calculate the period for every IMF
%  for IMF1~IMF3,direct count extrema number-Nextrema
%  lnT=Ndof/Nextrema
   for i=1:3,
       [spmax, spmin, flag]= extrema(imfs(:,i));
       temp=length(spmax(:,1))-1;
       logep(i,1)=nDof/temp;
   end

% for IMF4~end,calculate the IFvalue,determine how many rounds rotated already
   for i=4:columns,
       omega=ifndq(imfs(:,i),1);
       sumomega=0;
       for j=1:nDof,
           sumomega=sumomega+omega(j);
       end
       logep(i,1)=nDof*2*pi/sumomega;
   end

%multiply the translation coeifficient ,1.4427=log(e)/log(2)   
  logep=1.4427*log(logep);
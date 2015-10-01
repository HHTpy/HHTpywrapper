%   function sigline= confidenceLine(percenta,Npt)
%
%   INPUT:
%	    percenta: a parameter having a value between 0.0 ~ 1.0, e.g., 0.05 
%                 represents 95% confidence level (upper bound); and 0.95 
%                 represents 5% confidence level (lower bound) 
%          Npt: the data point number of original data 
%                 Npt means the degree of freedom (Ndof)of the timeseries.
%   OUTPUT:
%       sigline:  a two column matrix, with the first column the natural
%                 logarithm of mean period, and the second column the
%                 natural logarithm of mean energy for significance line
%                 For this program to work well, the minimum Npt is 36
%
%   NOTE: 
%	        this code is used to obtain the "percenta" line based on Wu and Huang (2004).
%	        1.from the reference paper,our goal is to recognize the statistical meanings of IMF copoment.  
%           First,they investigate into WhiteNoise signal about the PDF distribution on lnE-lnT plan.
%           When the IMF (lnT,lnE) values been plot with the whiteNoise values,we can say that
%           some IMFs have the same pattern with WhiteNoise,those IMFs might be meaningless signals.
%         2.WhiteNoise distribution on lnE-lnT plan is calsulated in this code.Here we calculate all
%           the values from log(1)~log(Ndof) ----the x axis values.
%         3.Use the principle of  'slope=-1' for  lnE-lnT value,y-bar=-x
%           upper and lower bound of y value for the chi-square distribution for every x-axis values.
%           the yUpper=0,yLower=-3-xx,between those upper and lower-[y range],the line been devided into 5000 segments. 
%           then [y range,y-bar,Ndof]be the parameter to calculate the probability density function use dist_value.m
%         4.after knowing the PDF for every y,under every x,we can think that's z--the PDF
%         5.connect the PDF for the confidence level,that's the answer.
%           percenta-it's the width coefficients of the PDF confidence limit.
%
% References:            
%        'A study of the characteristics of white noise using the empirical mode decomposition method' 
%        Zhaohua,Wu and Norden E. Huang
%        Proc. R. Soc. Lond. A (2004) 460,1597-1611
%
%
% code writer: zhwu@cola.iges.org
% code writer: S.C.Su-separate significance.m into 3 parts.2009/05/31
%              this part is use Npt to form WhiteNoise confidence limt curve.
% footnote:S.C.Su 2009/05/31
%
%    1.use input parameter to initialize
%    2.form x axis(lnT)
%    3.form y axis(lnE),by y=-x relationship
%    4.because y value is chi-square distributed,form [yUpper,yLower] for every x value
%    5.calculate the confidence limit position with each x value-loop start
%      6.determine the percenta values by interpolation
%    5.calculate the confidence limit position with each x value-loop end
%     
% Association: 
% 1. this function only calculate confidence curve under Ndof on the lnT-lnE plane.
%    the result 'sigline' is a 2D matrix --the [x,y] coordinate values for the curve
% 2. there should be another codes,finding [lnT,lnE] values of the IMF
% 3. plot 1. and 2. values together ,determine the statistical meaning of IMF
%
% Concerned function: dist_value,
%                     the others are matlab functions.  
%

function sigline= confidenceLine(percenta,Npt)

%1.use input parameter to initialize
nDof = Npt;%Degree of freedom=number of data points
pdMax = fix(log(nDof))+1;%pdMax-max X axis value
%
%2.form x axis(lnT)
pdIntv = linspace(1,pdMax,100);%divide [1~pdMaxX] into 100 segments,form the whole x axis values
%3.form y axis(lnE),by y=-x relationship
yBar = -pdIntv;%determine y-bar by slpoe,yBar=-x
%4.because y value is chi-square distributed,form [yUpper,yLower] for every x value
for i=1:100,
    %for every x value,define [yUpper,yLower] by chi-square 
    yUpper(i)=0;%chi-square start from 0
    yLower(i)= -3-pdIntv(i)*pdIntv(i);%chi-square decayed to zero,Wu use -3-xx as lower bound
end

%5.calculate the confidence limit position with each x value---loop start
for i=1:100,
    sigline(i,1)=pdIntv(i);%x-dir values assign to the line
    % divide [yUpper,yLowe] into 5000segments as the domain to investigate PDF for WhiteNoise
    yPos=linspace(yUpper(i),yLower(i),5000);
    dyPos=yPos(1)-yPos(2);
    yPDF=dist_value(yPos,yBar(i),nDof);%Call dist_value.m to calculate exact PDF distribution in y-dir
    
    %6.determine the percenta values by interpolation
    
        %determine the sum of PDF
        sum = 0.0;
        for jj=1:5000,
            sum = sum + yPDF(jj);%total accumulated PDF value
        end
        
        %inorder to find percenta--for some accurate value
        %but the [yUpper,yLower] is changing with x value
        %so it needs interpolation
        jj1=0;
        jj2=1;
        psum1=0.0;
        psum2=yPDF(1);
        pratio1=psum1/sum;
        pratio2=psum2/sum;
        
        %interpolate
        while pratio2 < percenta,
            jj1=jj1+1;
            jj2=jj2+1;
            psum1=psum1+yPDF(jj1);
            psum2=psum2+yPDF(jj2);
            pratio1=psum1/sum;
            pratio2=psum2/sum;
            yref=yPos(jj1);
        end
        sigline(i,2) = yref + dyPos*(pratio2-percenta)/(pratio2-pratio1);%the interpolation result
        %the values are extra modified to more accurate position by Dr.Wu
        sigline(i,2) = sigline(i,2) + 0.066*pdIntv(i) + 0.12;
        %confidence values assign to the line  
end
%5.calculate the confidence limit position with each x value-loop end

sigline=1.4427*sigline; %multiply the translation coeifficient ,1.4427=log(e)/log(2)
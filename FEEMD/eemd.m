function [allmode] = eemd(Y, NoiseLevel, NE, numImf, varargin)
% fast EMD/EEMD/CEEMD code:
%  Copyright (C) RCADA, National Central University; 2013
%  ***** For Educational and Academic Purposes Only ********* 
%  Author : Yung-Hung Wang, RCADA, NCU
%
% Please Cite: 
% Y. H. Wang, C. H. Yeh, H. W. V. Young, K. Hu and M. T. Lo,
% "On the computational complexity of the empirical mode decomposition
% algorithm"
% Physica A: Statistical Mechanics and its Applications, vol. 400,Issue 15, pp. 159-167, 2014
%
% Usage: 
% (A) [allmode]=eemd(Y, NoiseLevel, NE, numImf)
% (B) [allmode]=eemd(x,NoiseLevel,NE,numImf,runCEEMD,maxSift,typeSpline,toModifyBC,randType,seedNo,checkInput);
%---------------------------------------------------------------
% INPUTS : 
%        Y: input signal
%        NoiseLevel: noise level
%        NE: ensemble number; if NE=1 and NoiseLevel = 0, then run EMD [2]
%        numImf: number of prescribed imf; if it is less than zero,it will be log2(n), n=data length 
% 
%-------------Additional Input Properties-----------------------------------------
% runCEEMD: default=0; 0: run EEMD [3]; 1: CEEMD [4], add anti-phase noise, so input signal is reconstructed; 
% maxSift:default = 10; sifting iteration number; 
% typeSpline: default=2; 1: clamped spline; 2: not a knot spline; 3: natural cubic spline;
% toModifyBC: default=1; 0: None ; 1: modified linear extrapolation; 2: Mirror Boundary
% randType: fefault=2; 1: uniformly distributed random noise; 2: gaussian white noise
% seedNo: default=1; random seed number in generating white noise; The seed number must be an integer between 0 and 2^32 - 1
% checkSignal: default=1;  0=> dont check  the input signal;  1: check there is any  NaN or Infinity in input;
%
% OUTPUTS :
%  allmode[m][t]: returned imfs; m=imf index, t=time index
%
% References
%    [1] Y. H. Wang, C. H. Yeh, H. W. V. Young, K. Hu and M. T. Lo, 
%        "On the computational complexity of the empirical mode decomposition algorithm"
%        Physica A: Statistical Mechanics and its Applications, vol. 400, Issue 15, pp. 159-167, 2014
%    [2] N. E. Huang, Z. Shen, S. R. Long, M. L. Wu, H. H. Shih, Q. Zheng, N. C. Yen, C. C. Tung, and H. H. Liu, 
%        "The Empirical Mode Decomposition and Hilbert spectrum for nonlinear and non-stationary time series analysis,"
%        Proc. Roy. Soc. London A, Vol. 454, pp. 903�V995, 1998.
%    [3] Z. Wu and N. E. Huang, "Ensemble Empirical Mode Decomposition: A
%        Noise-Assisted Data Analysis Method," Advances in Adaptive Data Analysis, vol. 1, pp. 1-41, 2009.
%    [4] J. R. Yeh, J. S. Shieh and N. E. Huang, "Complementary ensemble empirical
%        mode decomposition: A novel noise enhanced data analysis method," 
%        Advances in Adaptive Data Analysis, vol. 2, Issue 2, pp. 135�V156, 2010.
%
%


%fprintf('Copyright (C) RCADA, NCU, Taiwan.\n');

allmode = [];
%verifyCode = 20041017; % For verification of emd

[Y,NoiseLevel,NE,numImf,runCEEMD,maxSift,typeSpline,toModifyBC,randType,seedNo,IsInputOkay] = parse_checkProperty(Y, NoiseLevel, NE, numImf, varargin);

if(~IsInputOkay)
    fprintf('ERROR : The process is not executed.\n');
    return;
end

if (NoiseLevel == 0)
    allmode = emd(Y, toModifyBC, typeSpline, numImf, maxSift);
    allmode = allmode';
    return;
end

xsize = size(Y,2);
Ystd = std(Y);	

allmode = zeros(xsize,numImf);

savedState = set_seed(seedNo);	
if (runCEEMD)
   NE = 2*NE; % YHW0202_2011: flip noise to balance the perturbed noise
end

for iii=1:NE  % ensemble loop    
    if (runCEEMD)
        if (mod(iii,2) ~= 0)
            if (randType == 1) % White Noise
               temp = ((2*rand(1,xsize)-1)*NoiseLevel).*Ystd; 
            elseif (randType == 2) % Gaussian Noise
               temp = (randn(1,xsize)*NoiseLevel).*Ystd; 
            end
         else % Even number
           temp = -temp;
        end
    else % runCEEMD = 0
        if (randType == 1)
            temp = (2*rand(1,xsize)-1)*NoiseLevel.*Ystd; % temp is Ystd*[0 1]	 
        elseif (randType == 2)
            temp = randn(1,xsize)*NoiseLevel.*Ystd; % temp is Ystd*[0 1]
        end 
    end
    xend =  Y + temp;
    imf = emd(xend, toModifyBC, typeSpline, numImf, maxSift);
    allmode = allmode + imf; 
end % iii: ensemble loop

return_seed(savedState);
allmode = allmode/NE;

allmode = allmode'; % 0318_2014
return; % end eemd

end

function savedState = set_seed(seedNo)
%defaultStream = RandStream.getDefaultStream;
globalStream = RandStream.getGlobalStream;
%savedState = defaultStream.State;
savedState = globalStream.State;
rand('seed',seedNo);
randn('seed',seedNo);

end

function return_seed(savedState)
%RandStream.getDefaultStream.State = savedState;
RandStream.getGlobalStream.State = savedState;
end

function [Y, NoiseLevel, NE, numImf, runCEEMD, maxSift, typeSpline,toModifyBC,randType,seedNo, IsInputOkay] = parse_checkProperty(Y, NoiseLevel, NE, numImf, varargin)
% Default Parameters
runCEEMD = 0; % Original EEMD
maxSift = 10; % maxSift = 10
typeSpline = 2;
toModifyBC = 1;
randType = 2;
seedNo = 1; % now
checkSignal = 0;
IsInputOkay = true;

if(~isempty(varargin{1}))

for iArg = 1 : length(varargin{1});
    
if(iArg == 1)
   runCEEMD = varargin{1}{iArg};
   if(runCEEMD ~= 0 && runCEEMD ~= 1)
    fprintf('ERROR : runCEEMD must be 0 (Off) or 1 (On).\n');
    IsInputOkay = false;
    return;
   end
end
if(iArg == 2)
   maxSift = varargin{1}{iArg};
   if(maxSift < 1 || (mod(maxSift, 1) ~= 0))
    fprintf('ERROR : Number of Iteration must be an integer more than 0.\n');
    IsInputOkay = false;
    return;
   end
end
if(iArg == 3)
    typeSpline = varargin{1}{iArg};
    if(typeSpline ~= 1 && typeSpline ~= 2 && typeSpline ~= 3)
    fprintf('ERROR : typeSpline must be 1 (clamped spline); 2 (not a knot spline).\n');
    IsInputOkay = false;
    return;
    end
end
if(iArg == 4)
    toModifyBC = varargin{1}{iArg};
    if(toModifyBC ~= 0 && toModifyBC ~= 1 && toModifyBC ~= 2)
    fprintf('ERROR : toModifyBC must be 0 (None) ; 1 (modified linear extrapolation); 2 (Mirror Boundary)\n');
    IsInputOkay = false;
    return;
    end
end
if(iArg == 5)
    randType = varargin{1}{iArg};
    if(randType ~= 1 && randType ~= 2)
    fprintf('ERROR : randType must be 1 (uniformly distributed white noise) ; 2 (gaussian white noise).\n');
    IsInputOkay = false;
    return;
    end
end
if(iArg == 6)
    seedNo = varargin{1}{iArg};
    if(seedNo < 0 || seedNo >  2^32-1 || (mod(seedNo, 1) ~= 0))
    fprintf('ERROR : The value of seed must be an integer between 0 and 2^32 - 1. \n');
    IsInputOkay = false;
    return;
    end
end
if(iArg == 7)
    checkSignal = varargin{1}{iArg};
    if(checkSignal ~= 0 && checkSignal ~= 1)
    fprintf('ERROR : Number of checksignal must be 1 (Yes) or 0 (No).\n');
    IsInputOkay = false;
    return;
    end
end

end

end

if(NoiseLevel == 0)
    %fprintf('If NoiseLevel is ZERO, EEMD algorithm will be changed to EMD algorithm.\n');
end
if ((NE < 1) || (mod(NE, 1) ~= 0))
    fprintf('ERROR : Number of Ensemble must be integer more than 0.\n');
    IsInputOkay = false;
    return;
end


[m,n] = size(Y);
if(m ~= 1)
    if((n ~= 1))
       fprintf('ERROR : EMD could not input matrix array !\n');
       IsInputOkay = false;
       return;
    else
        Y =Y';
        xsize = m;
    end
else
    xsize = n;
end

if (checkSignal == 1)
    if((any(isinf(Y(:)) == 1)) || (any(isnan(Y(:)) == 1)))
        fprintf('ERROR : The input signal has NaN or Infinity elements.\n');
        IsInputOkay = false;
        return;
    end
end

if(mod(numImf, 1) ~= 0)
    fprintf('ERROR : numImf must be an integer more than 0. \n');
    IsInputOkay = false;
    return;
end

if (numImf <= 0) % automatic estimating number of imf 
    numImf=fix(log2(xsize));
end

end

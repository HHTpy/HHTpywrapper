%function [f,a]=FAzc(data,dt)
%
% The function FAzc generates a frequency and amplitude using zero-crossing method 
% applied to data(n,k), where n specifies the length of time series, 
% and k is the number of IMFs.
% Non MATLAB Library routine used in the function is: FINDCRITICALPOINTS.
%
% Calling sequence-
% [f,a]=fazc(data,dt)
%
% Input-
%	data	- 2-D matrix of IMF components 
%	dt	    - time increment per point
% Output-
%	f	    - 2-D matrix f(n,k) that specifies frequency
%	a	    - 2-D matrix a(n,k) that specifies amplitude
%
% Used by- 
%	FA
% See also-
% 	FAZPLUS, which in addition to frequency and amplitude, outputs
%	other fields.

%written by 
% Kenneth Arnold (NASA GSFC)	Summer 2003, Modified
% Xianyao Chen     Sep. 20 created following the splinenormalize.m
% S.C.Su Sep. 2009(NCU Rcada)rename faz.m as fazc.m
%  in order to integrate all m file in a group type         
%%footnote: S.C.Su (2009/09/07)
%
% There are two loops in this code ,it's dealing with IMF by IMF .checking wave by wave
%  0. set the default value and initialize
%  1. process IMF by IMF ---loop A start
%    2. Find all critical points (max,min,zeros) in an IMF 
%    3. integrate those information from previous waveform  
%    4. calculate by zero-crossing method----loop B start
%            4.1 estimate for the quarter waves(weighting coefficients included already)
%            4.2 estimate for the half waves(weighting coefficients included already)
%            4.3 estimate for the whole waves(weighting coefficients included already)
%            5. add-in those information from previous waveform   
%            6. calculate current frequency and amplitude 
%            7. pass current information to next waveform calculation  
%    4. calculate by zero-crossing method----loop B end 
%  1. process IMF by IMF ---loop A end
%
%

function [f,a]=FAzc(data,dt) 
 
% 0. set the default value and initialize
  %----- Get dimensions
  [nPoints, nIMF] = size(data);
  
  %----- Flip data if necessary
  flipped=0;
  if nPoints < nIMF
      %----- Flip data set
      data = data';
      [nPoints, nIMF] = size(data);
      flipped=1;
  end
  
  %----- Inverse dt
  idt = 1/dt;
  
  %----- Preallocate arrays
  f = zeros(nPoints,nIMF);
  a = f;
  
%1. process IMF by IMF ---loop A start
%----- Process each IMF
for c=1:nIMF   %loop A--start 

%2. Find all critical points (max,min,zeros) in an IMF
    %The function FINDCRITICALPOINTS returns max, min and zero crossing values and their coordinates in the order found
    [allX, allY] = findcriticalpoints(data(:,c));
    nCrit = length(allX); %number of critical points
    
    if nCrit <= 1
        %----- Too few critical points; keep looping
        continue;
    end

%3. integrate those information from previous waveform    
    %----- Initialize previous calculated frequencies
    f2prev1 = NaN;
    f4prev1 = NaN;
    f4prev2 = NaN;
    f4prev3 = NaN;

    %----- Initialize previous calculated amplitudes
    a2prev1 = NaN;
    a4prev1 = NaN;
    a4prev2 = NaN;
    a4prev3 = NaN;
   
%4. calculate by zero-crossing method----loop B start    
  %start to calculate the zero-crossing frequency and amplitude 
  %exam them position by position 
    for i=1:nCrit-1  
            
      %----- Estimate current frequency
        cx = allX(i); %current value at i position of critical points
       
%4.1 estimate for the quarter waves(weighting coefficients included already) 
        f1 = idt / (allX(i+1)-cx);  %f1 is the frequency calculated by quarter wave 
        a1 = 4*max(abs(allY(i:i+1))); %a1 is the amplitude calculated by quarter wave 
        npt = 4;
        ftotal = f1;
        atotal = a1;
       
%4.2 estimate for the half waves(weighting coefficients included already) 
        if i+2<=nCrit
            f2cur = idt / (allX(i+2)-cx);   %f2cur is the frequency calculated by half wave 
            range = allY(i:i+2);
            ext = range(range~=0);  %findout position index for the max or min value       
            a2cur = 2*mean(abs(ext)); %a2cur is the amplitude calculated by half wave
            npt = npt+2;              %jump to next half wave
            ftotal = ftotal+f2cur;
            atotal = atotal+a2cur;
        else
            f2cur=NaN;
        end
        
%4.3 estimate for the whole waves(weighting coefficients included already)
        if i+4<=nCrit
            f4cur = idt / (allX(i+4)-cx);  %f4cur is the frequency calculated by whole wave 
            range = allY(i:i+4);
            ext = range(range~=0);  %findout position index for the max or min value   
            a4cur = mean(abs(ext)); %a4cur is the amplitude calculated by whole wave
            npt = npt+1;            %jump to next whole wave
            ftotal = ftotal+f4cur;
            atotal=atotal+a4cur;
        else
            f4cur=NaN;
        end

%5. add-in those information from previous waveform           
        %----- Add previous points if they are valid
        if ~isnan(f2prev1)
            npt=npt+2;
            ftotal=ftotal+f2prev1;
            atotal=atotal+a2prev1;
        end
        if ~isnan(f4prev1)
            npt=npt+1;
            ftotal=ftotal+f4prev1;
            atotal=atotal+a4prev1;
        end
        if ~isnan(f4prev2)
            npt=npt+1;
            ftotal=ftotal+f4prev2;
            atotal=atotal+a4prev2;
        end
        if ~isnan(f4prev3)
            npt=npt+1;
            ftotal=ftotal+f4prev3;
            atotal=atotal+a4prev3;
        end
    
%6. calculate current frequency and amplitude
        %total npt times wave been included ,so divided by npt   
        %General formula for frequency and amplitude when using zero-crossing method
        f(ceil(allX(i)):floor(allX(i+1)),c) = ftotal/npt;
        a(ceil(allX(i)):floor(allX(i+1)),c) = atotal/npt;

%7. pass current information to next waveform calculation           
        %assign the frequency values for next position calculation
        f2prev1=f2cur;
        f4prev3=f4prev2;
        f4prev2=f4prev1;
        f4prev1=f4cur;
        
        a2prev1=a2cur;
        a4prev3=a4prev2;
        a4prev2=a4prev1;
        a4prev1=a4cur;
    
    %exam them position by position----loop B end 
    end
%4. calculate by zero-crossing method----loop B end 
    
    %----- Fill in ends for amplitude anbd frequency
    f(1:ceil(allX(1))-1,c) = f(ceil(allX(1)),c);
    f(floor(allX(nCrit))+1:nPoints,c) = f(floor(allX(nCrit)),c);

    a(1:ceil(allX(1))-1,c) = a(ceil(allX(1)),c);
    a(floor(allX(nCrit))+1:nPoints,c) = a(floor(allX(nCrit)),c);

%loop A--end
end
%1. process IMF by IMF ---loop A end

%----- Flip again if data was flipped at the beginning
if (flipped)
    f=f';
    a=a';
end

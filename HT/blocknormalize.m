%function [ndata,a]=blocknormalize(data)

% The function BLOCKNORMALIZE normalizes each block of the input signal, 
% as defined by zero crossings, to have a maximum amplitude of 1.
%
% Suggestion: if the routine is needed than use it with caution.
disp('Using block-normalize ,are you sure?!')
disp('Slope discontinuous will happen in left and right side about a zero')
pause(2);    
%
% Calling sequence-
% [ndata,a]=blocknormalize(data)
%
% Input-
%	data	- 2-D matrix data(npt,ncol) 
% Output-
%	ndata	- 2-D matrix of normalized data (FM)
%	   a	- 2-D matrix of envelope        (AM)
%
% Used by-
% 	FA

%written by 
% Kenneth Arnold (NASA GSFC)    Summer 2003 Initial
% Kenneth Arnold (NASA GSFC) June 6, 2004 Tweaked
%footnote: S.C.Su (2009/09/01)
%this code is with complex structure,but easy meanings
%just remember about some easy sentences
%"Blocks are defined as those segments between the  zero-crossing points"
%"Finding the extreme value in each block,the value is the amplitude of this block"
%
%1.read the data,check input matrix
%2.Do the normalization  for an IMF ---loop A start
  %3.checking each data value from the beginning point of each block----loop B start
    %4.read the sign (+,-,0) form starting of every block 
    %5. make judgement block by block,start from point 1-----loop C start 
      %6.judge the value about its sign,different sign means the end of this block
      %7.judge the value about its sign,the same sign means still in the same block
    %5. make judgement block by block,start from point 1-----loop C end 
  %3.checking each data value from the beginning point of each block----loop B end
%2.Do the normalization  for an IMF ---loop A end    
%
function [ndata,a]=blocknormalize(data)

%1.read the data,check input matrix
%----- Get the dimension
[npt,ncol] = size(data);

%----- Flip data if needed
flipped=0;
if (ncol > npt)
    data=data';
    [npt,ncol] = size(data);
    flipped=1;
end

%----- Initialize amplitude matrix
a = ones(npt,ncol);

%2.Do the normalization  for an IMF ---loop A start
%----- Process each column of data
for col=1:ncol
 
    i=1;
%3.checking each data value from the beginning point of each block----loop B start
    while (i<=npt)  
%4.read the sign (+,-,0) form starting of every block      
        blockSign = sign(data(i,col)); %get blocksign : + or -,or 0,find it first
       
        % when zero is meet,use right-hand side sign as the blocksign for it
        while (blockSign == 0 & i < npt) % handle zero case 
            i=i+1;
            blockSign = sign(data(i,col));
        end
    
       
	  if (i==npt)
	   break; %after all values are checked,this if help to stop "while"
   	end
   	
%5. make judgement block by block,start from point 1-----loop C start 
        blockExtr = 0; % extreme value (maximum or minimum)
        
        
        %----- Find the end of this block and its extreme value
        for (j=i:npt) %this block from (i~j)
            j; %the jth value is the value that we are checking now
            cur = data(j,col);
            
%6.judge the value about its sign,different sign means the end of this block
            if (sign(cur) ~= blockSign)
                j=j-1;
                break; % jump out,because meet next block
            end
            
%7.judge the value about its sign,the same sign means still in the same block
            if ((blockSign == 1 & cur > blockExtr) | (blockSign == -1 & cur < blockExtr))
                blockExtr = cur; %stay in,because still in the same block
                %collect  the biggest or smallest value for this block 
            end
        end
%5. make judgement block by block,start from point 1-----loop C end         
        if (blockExtr ~= 0)
            %normalize this block with its own extreme value
            ndata(i:j,col) = data(i:j,col) / blockExtr * blockSign;
            a(i:j,col) = a(i:j,col) * blockExtr * blockSign;
        end
        
        i=j+1; %return this block endding position 
               %go back to while loop
               %next block start from last endding position
    end
%3.checking each data value from the beginning point of each block----loop B end    
end
%2.Do the normalization  for an IMF ---loop A end

%----- Flip data back if needed
if (flipped)
    ndata=ndata';
    a=a';
end
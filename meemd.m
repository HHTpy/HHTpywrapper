function rsltf=meemd(filename, N, Nstd, NE, numImf, runCEEMD, maxSift, typeSpline, toModifyBC, randType, seedNo, checksignal)
% 2D fast EEMD code
%  Author : Yi-Hao Su, IANCU
%  This code is a modified vesion of the code from Research Center for Adaptive Data Analysis

img = imread(filename);
data  = im2double(img);

% decomposition in the first dimension and arrange the output
for i=1:N,
    temp=data(i,:);
     [imf1] = eemd(temp, Nstd, NE, numImf, runCEEMD, maxSift, typeSpline, toModifyBC, randType, seedNo, checksignal);
     rslt= imf1';
    for j=1:N,
        for k=1:numImf,
            rsltd1(i,j,k)=rslt(j,k);
        end
    end
end

% decomposition in the second direction
for k=1:numImf,
    for j=1:N,
        temp2=rsltd1(:,j,k);
         [imf2] = eemd(temp2,Nstd,NE,numImf,runCEEMD,maxSift,typeSpline,toModifyBC,randType,seedNo,checksignal);
         rslt =  imf2';
        for i=1:N,
            for kk=1:numImf,
                rslt2d(i,j,k,kk)=rslt(i,kk);
            end
        end
    end
end

% combine modes
for i=1:N
    for j=1:N,
        for m=1:numImf,
            rsltf(i,j,m)=0;
            for k=m:numImf,
                rsltf(i,j,m)=rsltf(i,j,m)+rslt2d(i,j,k,m);
                rsltf(i,j,m)=rsltf(i,j,m)+rslt2d(i,j,m,k);
            end
            rsltf(i,j,m)=rsltf(i,j,m)-rslt2d(i,j,m,m);
        end
    end
end

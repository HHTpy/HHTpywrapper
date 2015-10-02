function allmode2=feemd_post_pro(Y,Nstd,NE,numImf,runCEEMD,maxSift,typeSpline,toModifyBC,randType,seedNo,checksignal)
% Post-processing of fast EMD/EEMD/CEEMD code
%  Author : Yi-Hao Su, IANCU

[imf] = eemd(Y,Nstd,NE,numImf,runCEEMD,maxSift,typeSpline,toModifyBC,randType,seedNo,checksignal);
allmode = imf';

xsize=length(Y);

for kk=1:1:numImf,
    for ii=1:1:xsize,
        allmode2(ii,kk)=0.0;
    end
end

remainder=0;
for i=1:numImf-1,
    [imf2] = eemd(allmode(:,i)+remainder,0,1,numImf);
    allmode2_temp=imf2';
    allmode2(:,i)=allmode2_temp(:,1);
    remainder=allmode(:,i)+remainder-allmode2(:,i);
end
   allmode2(:,numImf)=remainder+allmode(:,numImf);

%function signiplotIMF(IMF,saveplotvalue)
%
%
%input
%     IMF- an 2D data,matrix form:[Npt,Nimf],should be the result of EEMD or EMD
%     saveplotvalue-when the value=1,plot results and save it in User's foler
%
%output
%     Show figure on the screen
%     if user set saveplotvalue=1,save values and figure in User's folder
%
%Note:
%     this code is the user interface of Significance Plot
%     Combine White-Noise confidence Curve and IMF significance 
%     2 cofidence limit 90% and 95% curves are plot as default value
%     this code help user Plot those on the lnE-lnT plan
%
% References:   
%  Wu, Z., and N. E Huang (2008), 
%  Ensemble Empirical Mode Decomposition: a noise-assisted data analysis method. 
%   Advances in Adaptive Data Analysis. Vol.1, No.1. 1-41.  
%
% code writer: Zhaohua Wu.
% modified and restructrue S.C.Su 2009/06/08
% footnote:S.C.Su 2009/03/08
%
%The structure of this code:
%1.read data
%2.check input data
%3.find significance values for each IMF
%4.find WhiteNoise confidence range curve for 95% and 90%
%5.plot 3 & 4 together on the lnT-lnE plan
%6.save data or not 
%
% Association: no
% this function ususally used for understanding the significance of IMF components
%
% Concerned function: confidenceLine.m,dist_value.m,significanceIMF.m
%                     above mentioned m file must be put together 
%

function signiplotIMF(IMF,saveplotvalue)  

%   
%1.read data
[Npt,Nimf]=size(IMF);
%2.check input data
if Npt< Nimf
    IMF=IMF';
    [Npt,Nimf]=size(IMF);
end   
%3.find significance values for each IMF    
logep = significanceIMF(IMF(:,1:end-1));

%4.find WhiteNoise confidence range curve for 95% and 90%
sigline95= confidenceLine(0.05,Npt);
sigline90= confidenceLine(0.10,Npt);
%5.plot 3 & 4 together on the lnT-lnE plan
         h3=figure(3);
         set(h3,'Visible','on');
         set(h3,'PaperUnits','inches');
         set(h3,'PaperPosition',[0 0 11 8.5]);
         set(h3,'PaperSize',[11 8.5]);
         set(h3,'PaperType','a4letter');
         plot(sigline90(:,1),sigline90(:,2),'r',sigline95(:,1),sigline95(:,2),'b');legend('90% significance','95% significance','Location', 'SouthWest');hold on
         plot(logep(:,1),logep(:,2),'g*');xlabel('Log-T ,Period of the IMF(log)','FontSize',8,'VerticalAlignment','middle');ylabel('log-E ,Energy of the IMF(log)','FontSize',8);
         title('Significance of IMFs');
%6.save data or not         
if saveplotvalue==1
    destpath=input('Please give output folder path \n','s');
    filename1=[destpath,'\IMFsigValue.csv'];
    csvwrite(filename1,logep);
    filename2=[destpath,'\signifi-IMF.jpg'];
    saveas(h3,filename2);
    close (h3);
end
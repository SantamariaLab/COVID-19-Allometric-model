function out=fitData(totalt0,d2f,range2f,region,caseTh,dateV,alpha)
t=1:length(totalt0);
%allometric 
fa=fittype('((gamma/beta)*(1-exp((b-1)*beta*x))+x0.^(1-b)*exp((b-1)*beta*x))^(1/(1-b))','problem',{'x0','b'});
ga=fitoptions(fa);
ga.Lower=[ 0 0  ];
ga.Upper=[ Inf Inf ];

%fit for logarithmic transform
f=fittype('a*x+b');
g=fitoptions(f);


%log
thisT2f=d2f+[0:range2f];
dummy=[log10(thisT2f') log10(totalt0(thisT2f'))];
dTb=array2table(dummy,'variablenames',{'time','I'});
lmf0=fitlme(dTb,'I~1 +time');


g.StartPoint=[2.34 100];
[f0,gof0]=fit(log10(thisT2f'),log10(totalt0(thisT2f')),f,g);



%exponential
dummy=[(thisT2f') log10(totalt0(thisT2f'))];
dTbe=array2table(dummy,'variablenames',{'time','I'});
lmf2=fitlme(dTbe,'I~1 + time');
 g.StartPoint=[5 100];
 [f2,gof2]=fit(thisT2f',log10(totalt0(thisT2f')),f,g);

%allometric
thisT2fa=d2f+[0:range2f];
ga.StartPoint=[ 0.00045 diff(totalt0([1 5]))/5 ];
[fa0,gofa0]=fit(thisT2f(1:end)'-thisT2f(1),totalt0(thisT2f(1:end)'),...
    fa,ga,'problem',{totalt0(thisT2f(1)),1-1/alpha});


r1=compare(lmf0,lmf2,'nsim',100);
bestfit='';
    lGOF=gof0;
    eGOF=gof2;
    aGOF=gofa0;
    if (lGOF.rmse<eGOF.rmse) && (lGOF.rsquare>0.97)
        disp(['PowerLaw is better '])
        disp(['    PL alpha: ',num2str(f0.a),'  Allo alpha: ',num2str(1./(1-fa0.b))])
        %plotFits(allR(a).FitsTotal,'up')
        %subplot(2,3,1)
        %text(1,3,'Power Law')
        bestfit='PowerLaw';
    elseif (eGOF.rmse<lGOF.rmse) && (eGOF.rsquare>0.97)
        disp('Exponential is better')
        %plotFits(allR(a).FitsTotal,'down')
        bestfit='Exp';
    else
        disp('None is good')
        %plotFits(allR(a).FitsTotal,'down')
        bestfit='None';
    end
    
% if  round(100*gof0.adjrsquare)>round(100*gof2.adjrsquare) %(r1.pValue(2)>0.05) %gof0.adjrsquare>gof2.adjrsquare
%     if round(100*gof0.adjrsquare)>99 %at least 80 % of variance explained and better than Exp
%         disp([region ' Power-Law better than exp ']);%,num2str(gof0.adjrsquare),' ',...
%         %num2str(gof2.adjrsquare),' ',num2str(gofa0.adjrsquare)])
%         disp(['Values of alpha ',num2str(lmf0.Coefficients.Estimate(2)),' ',num2str(1./(1-fa0.b))]);
%         bestfit='PowerLaw';
%     else
%         bestfit='Exp';
%         disp([region ' Exponential is better ']);
%     end
% else
%     bestfit='Exp';
%     disp([region ' Exponential is better ']);
% end

out.Region=region;
out.LogLog.Fit=f0;
out.LogLog.GoF=gof0;
out.Exp.Fit=f2;
out.Exp.GoF=gof2;
out.Allo.Fit=fa0;
out.Allo.GoF=gofa0;
out.FittedData=[thisT2f' totalt0(thisT2f')];
out.AllData=[t' totalt0];
out.caseTh=caseTh;
out.StartFit=d2f;
out.Days2Fit=range2f;
out.BestFit=bestfit;
out.StartFitDate=dateV;

function worldT=givemeTable(allR)
c=1;c2=1;
for a=1:length(allR)
    %if strcmpi(allR(a).FitsTotal.BestFit,'PowerLaw')
        thisFit=allR(a).FitsTotal;
        alphaW(c)=thisFit.LogLog.Fit.a;
        gofr2(c)=thisFit.LogLog.GoF.rsquare;
        bW(c)=thisFit.Allo.Fit.b;
        betaW(c)=thisFit.Allo.Fit.beta;
        gammaW(c)=thisFit.Allo.Fit.gamma;
        tauW(c)=1./thisFit.Exp.Fit.a;
        bestfit{c}=thisFit.BestFit;
        region{c}=thisFit.Region;
        num(c)=a;
        date1{c}=thisFit.StartFitDate(2:end);
        %onlyplR(c)=allR(a);
        c=c+1;
    %else
    %    onlyexpR(c2)=allR(a);
    %    c2=c2+1;
    %end
end
worldT=table(region',alphaW',bW',betaW',gammaW',tauW',bestfit',num',date1',...
    'VariableNames',{'Region','alpha','b','beta','gamma','tau','BestFit','allRPos','Date'});

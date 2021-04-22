function out=plotFits(in,st)
if strcmpi(st,'UP')
    clf
    plv=[1 2 3];
else
    plv=[4 5 6];
end

t=in.AllData(:,1);
totalt0=in.AllData(:,2);
thisT2f=in.FittedData(:,1);
f0=in.LogLog.Fit;
f2=in.Exp.Fit;
fa0=in.Allo.Fit;

   
    subplot(2,3,plv(1))
    plot(log10(t),log10(totalt0)) 
    hold on
    plot(log10(thisT2f),f0(log10(thisT2f)))
    plot(log10(thisT2f),log10(totalt0(thisT2f)),'o')
    box off
    title(in.Region);%.Country_Region{1})
    xlabel(['Log_{10} (Days)']);
    ylabel('Log_{10} (cases)')

    subplot(2,3,plv(2))
    plot(t,log10(totalt0),'b',thisT2f',log10(totalt0(thisT2f')),'r',thisT2f',f2(thisT2f'),'g')
    title('Exp fit')
    xlabel(['Days']);
    ylabel('Log_{10} (cases)')
    xlim([0 50])
    box off

    subplot(2,3,plv(3)) %allometric comparison
    fullT2f=t(1:in.StartFit+in.Days2Fit);
    loglog(t,totalt0,'k',fullT2f,fa0(fullT2f-thisT2f(1)),'g');%,...   fa0
    title('Allometric fit')
    drawnow
    
    out=[t,totalt0];

end

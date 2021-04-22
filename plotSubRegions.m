function alpha=plotSubRegions(thisC)
c=1;
for a=1:length(thisC.SubRegion)
    subplot(8,4,c)
    region=thisC.SubRegion{a};
    fT=thisC.FitRegion{a};
    t0=thisC.t0(a);
    cases=thisC.Numbers(t0:end,a);
    t=1:length(cases);
    plot(log10(t),log10(cases),'k')
    text(log10(t(end)),log10(cases(end)),region);
    eTGOF=thisC.SubRegionFitExp{a}{2};
    fTGOF=thisC.SubRegionFit{a}{2};
    
    fT=thisC.SubRegionFit{a}{1};
    t2=thisC.SubRegionFit{a}{3};
    
    if (fTGOF.sse<eTGOF.sse)
        [fTGOF.sse eTGOF.sse]
        plot(log10(t),log10(cases),'k',log10(t2),fT(log10(t2)),'r');
        hold on
        %text(log10(t(end)),log10(cases(end)),region);
        text(log10(10),log10(20),region);
        drawnow
        box off
        xlim([0 2])
        alpha(c).V=fT.a;
        alpha(c).R=region;
        c=c+1;
        %input('r')
    end
end

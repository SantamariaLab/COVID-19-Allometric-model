function alpha=plotUS(thisC)
c=1;

for a=1:length(thisC)
    subplot(10,5,c)
    region=thisC(a).Region;
    fT=thisC(a).FitTotal;
    fTGOF=thisC(a).FitTotalGOF;
    fTD=thisC(a).DataFit;
    fTT0=thisC(a).DataT0;
   
    eTGOF=thisC(a).ExpFitTotalGOF;
    if (fTGOF.sse<eTGOF.sse)
        figure(5)
        [fTGOF.sse eTGOF.sse]
        plot(log10(fTT0(:,1)),log10(fTT0(:,2)),'k',log10(fTD(:,1)),fT(log10(fTD(:,1))),'r');
        hold on
        %title(region{1})
        text(log10(1),log10(5000),region{1});
        drawnow 
        %input('r')
        alpha(c).V=fT.a;
        alpha(c).R=region;
        c=c+1;
    else
        figure(2)
        [fTGOF.sse eTGOF.sse]
        plot(log10(fTT0(:,1)),log10(fTT0(:,2)),'k',log10(fTD(:,1)),fT(log10(fTD(:,1))),'r');
        hold on
        %title(region{1})
        text(log10(1),log10(5000),region{1});
        drawnow 
        %input('r')
        %alpha(c).V=fT.a;
        %alpha(c).R=region;
        %c=c+1;
    end
    box off
    ylim([1 5])
end
alpha=struct2table(alpha);

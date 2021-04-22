function [alpha,allo]=plotAreas(thisC)
c=1;
alpha=[];
allo=[];
for a=1:length(thisC)
    region=thisC(a).Region;
    fT=thisC(a).FitTotal;
    fTGOF=thisC(a).FitTotalGOF;
    fTD=thisC(a).DataFit;
    fTT0=thisC(a).DataT0;
    
    eTGOF=thisC(a).ExpFitTotalGOF;
    if (fTGOF.sse<eTGOF.sse)
        figure(1)
        [fTGOF.sse eTGOF.sse];
        plot(log10(fTT0(:,1)),log10(fTT0(:,2)),'k',log10(fTD(:,1)),fT(log10(fTD(:,1))),'r');
        hold on
        ht=text(log10(fTT0(end,1)),log10(fTT0(end,2)),region{1});
        ht.FontSize=5;
        drawnow 
        %input([region{1}])
        alpha(c).V=fT.a;
        alpha(c).R=region;
        allo(c).Model=[thisC(a).FitAllometric.b thisC(a).FitAllometric.beta thisC(a).FitAllometric.gamma];
        c=c+1;
    else
        figure(2)
        [fTGOF.sse eTGOF.sse];
        plot(log10(fTT0(:,1)),log10(fTT0(:,2)),'k',log10(fTD(:,1)),fT(log10(fTD(:,1))),'r');
        hold on
        ht=text(log10(fTT0(end,1)),log10(fTT0(end,2)),region{1});
        ht.FontSize=5;
        drawnow 
    end
    
end

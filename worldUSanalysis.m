clear
load worldAnalysis.mat
load UScities
load USstates

worldT=givemeTable(allR);

alphaUS=givemeTable(usC);
alphaUS=addvars(alphaUS,NaN*(1:length(alphaUS.Region))');
alphaUS.Properties.VariableNames(end)={'AirPass'};
alphaUS=addvars(alphaUS,NaN*(1:length(alphaUS.Region))');
alphaUS.Properties.VariableNames(end)={'UrbanMiles'};
alphaUS=addvars(alphaUS,NaN*(1:length(alphaUS.Region))');
alphaUS.Properties.VariableNames(end)={'SuburbanMiles'};
alphaUS=addvars(alphaUS,NaN*(1:length(alphaUS.Region))');
alphaUS.Properties.VariableNames(end)={'RuralMiles'};

%%

%% get the data of the initial date and average days fitted and so on


for a=1:length(allR)
    casesDay1(a)=allR(a).FitsTotal.caseTh;
    startFit(a)=allR(a).FitsTotal.StartFit;
    days2Fit(a)=allR(a).FitsTotal.Days2Fit;
end
[mean(casesDay1) std(casesDay1)/sqrt(68); 
    mean(startFit) std(startFit)/sqrt(68);
    mean(days2Fit) std(days2Fit)/sqrt(68)]

%%
clear  tauRegion
tauV=[];nanV=[];thisRV=[];thisSV=[];
tauBestT=worldT(logical(strcmpi(worldT.BestFit,'Exp')),:);
noneBestT=worldT(logical(strcmpi(worldT.BestFit,'None')),:);
alphaT=worldT(logical(strcmpi(worldT.BestFit,'PowerLaw')),:);

c=1;
figure(10)
clf
clear rData yn rDataV rawDataV
for a=1:length(allR)
    %plotFits(onlyexpR(a).FitsTotal,'up')
    thisFit=allR(a).FitsTotal;
    if strcmpi(thisFit.BestFit,'Exp')
        subplot 231
        thisData=thisFit.AllData;
        rawData=thisData(1:50,2);
        rawDataV(:,c)=rawData;
        logData=log10(thisData(1:50,2));
        rData=logData-logData(1);
        rDataV(:,c)=rData;
        plot(thisData(1:50,1),rData,'k')
        hold on
        %plot(1:80,thisFit.Exp.Fit(1:80),'r')
        xlim([0 50])
        
        subplot 232
        plot(thisData(1:50,1),rawData,'k')
        hold on
        subplot 233
        plot(thisData(1:50,1),rData/max(rData(30)),'k')
        hold on
        c=c+1;
    end
end

%% present averages of all the countries that follow PL
figure(1)
clf
region=[];outM=[];outE=[];regionE=[];bestfit=[];
c=1;
for a=1:length(allR)
    thisFit=allR(a).FitsTotal;
    if ~strcmpi(thisFit.BestFit,'None')
        if max(thisFit.AllData(:,1))>100
            %out=plotFits(thisFit,'up');
            out=thisFit.AllData;
            outM(:,c)=out(1:100,2);
            region{c}=thisFit.Region;
            bestfit{c}=thisFit.BestFit;
            %input('r')
            clf
            c=c+1;
        end
    end
end
worldTraces=table([region'],[outM'],bestfit','VariableNames',{'Region','Data','BestFit'});

onlplTraces=worldTraces(logical(strcmpi(worldTraces.BestFit,'PowerLaw')),:);
figure(1)
clf
subplot 321
cla
plot(log10(1:100),log10(onlplTraces.Data'),'Color',0*[1 1 1],'LineWidth',1)
hold on
%plot(log10(1:100),log10(mean(onlplTraces2.Var2)),'ko-','LineWidth',3)
m1=log10(mean(onlplTraces.Data));
fitmean=fit(log10(1:100)',m1','poly1');
%plot(log10(1:99),fitmean(log10(1:100)),'Color',0.8*[1 1 1],'LineWidth',1)
box off
set(gca,'Clipping','on')
ylim([2 6])
xlim(log10([0 100]))
plotCornerNames(log10(50*ones(size(onlplTraces,1),1)),log10(onlplTraces.Data(:,50)),onlplTraces.Region)
%plotCornerNames(log10(10*ones(size(onlplTraces2,1),1)),log10(onlplTraces2.Var2(:,10)),onlplTraces2.Var1)


subplot 322
cla
plot((1:100),log10(onlplTraces.Data'),'Color',[0.5 0.5 0.5])
hold on
plot((1:100),log10(mean(onlplTraces.Data)),'o-k','LineWidth',3)
box off
ylim([2 5.5])
xlim([0 100])
plotCornerNames((50*ones(size(onlplTraces,1),1)),log10(onlplTraces.Data(:,50)),onlplTraces.Region)
%plotCornerNames((10*ones(37,1)),log10(onlplTraces2.Var2(:,10)),onlplTraces2.Var1)

subplot 323
cla
relN=(onlplTraces.Data)-(onlplTraces.Data(:,1));
plot(log10([0:99]),log10(relN),'k','LineWidth',1), 
mlogR=mean(log10(relN),1);
fitmean=fit(log10(10:99)',mlogR(11:100)','poly1');
hold on
plot(log10(1:99),fitmean(log10(1:99)),'Color',0.8*[1 1 1],'LineWidth',2)
box off
set(gca,'Clipping','on')
ylim([0 6])
xlim(log10([0 100]))
plotCornerNames(log10(50*ones(size(onlplTraces,1),1)),log10(onlplTraces.Data(:,50)),onlplTraces.Region)


set(1,'WindowStyle','normal')
exportgraphics(gcf,'allWordl.eps')
set(1,'WindowStyle','docked')


%% Australia
thisR=allR(7);
%thisR=reprocessSubReg(allR(7));

figure(3)
clf
clear alphaC regionC
c2=1;
for r2f=1:length(thisR.FitsRegions)
    thisR.FitsRegions(r2f)
    if strcmpi(thisR.FitsRegions(r2f).BestFit,'PowerLaw')
        thisA=thisR.FitsRegions(r2f).Allo.Fit;
        thisP=thisR.FitsRegions(r2f).LogLog.Fit;
        t=thisR.FitsRegions(r2f).AllData(:,1);
        totalt0=thisR.FitsRegions(r2f).AllData(:,2);
        thisT2f=thisR.FitsRegions(r2f).FittedData(:,1);
        subplot(4,5,c2)
        plot(log10(t),log10(totalt0),'LineWidth',3,'Color',0.8*[1 1 1])
        hold on
        plot(log10(t),(thisP(log10(t))),'Color',0.5*[1 1 1])
        plot(log10(thisT2f([1 end])),...
            log10(totalt0((thisT2f([1 end])))),'o','Color',0*[1 1 1],'MarkerSize',2)
        box off
        title(thisR.FitsRegions(r2f).Region)
        xlim(log10([1 100]))
        ylim([2 4])
        set(gca,'Clipping','on')
        alphaC(c2)=thisP.a;
        regionC{c2}=thisR.FitsRegions(r2f).Region;
        c2=c2+1;
    end
end
alphaAus=givemeTableSR(allR(7));
filename = 'Australiaanalysis.xlsx';
writetable(alphaAus,filename,'Sheet',1,'Range','D1')


filename = 'USanalysis.xlsx';
writetable(alphaUS,filename,'Sheet',1,'Range','D1')

set(3,'WindowStyle','normal')
exportgraphics(gcf,'allAutralia.eps')
set(3,'WindowStyle','docked')

%% Canada
thisR=allR(22);
figure(3)
clf
clear alphaC regionC
c2=1;
for r2f=1:length(thisR.FitsRegions)
    thisR.FitsRegions(r2f)
    if strcmpi(thisR.FitsRegions(r2f).BestFit,'PowerLaw')
        thisA=thisR.FitsRegions(r2f).Allo.Fit;
        thisP=thisR.FitsRegions(r2f).LogLog.Fit;
        t=thisR.FitsRegions(r2f).AllData(:,1);
        totalt0=thisR.FitsRegions(r2f).AllData(:,2);
        thisT2f=thisR.FitsRegions(r2f).FittedData(:,1);
        subplot(4,5,c2)
        plot(log10(t),log10(totalt0),'LineWidth',3,'Color',0.8*[1 1 1])
        hold on
        plot(log10(t),(thisP(log10(t))),'Color',0.5*[1 1 1])
        plot(log10(thisT2f([1 end])),...
            log10(totalt0((thisT2f([1 end])))),'o','Color',0*[1 1 1],'MarkerSize',2)
        box off
        title(thisR.FitsRegions(r2f).Region)
        xlim(log10([1 100]))
        ylim([1 6])
        set(gca,'Clipping','on')
        alphaC(c2)=thisP.a;
        regionC{c2}=thisR.FitsRegions(r2f).Region;
        c2=c2+1;
    end
end
alphaCan=givemeTableSR(allR(22));
filename = 'Canadaanalysis.xlsx';
writetable(alphaCan,filename,'Sheet',1,'Range','D1')

set(3,'WindowStyle','normal')
exportgraphics(gcf,'allCanada.eps')
set(3,'WindowStyle','docked')

%% show all China provinces that have PL
thisR=allR(26);
figure(4)
clf
clear alphaC regionC
c2=1;
for r2f=1:length(thisR.FitsRegions)
    thisR.FitsRegions(r2f)
    if strcmpi(thisR.FitsRegions(r2f).BestFit,'PowerLaw')
        thisA=thisR.FitsRegions(r2f).Allo.Fit;
        thisP=thisR.FitsRegions(r2f).LogLog.Fit;
        t=thisR.FitsRegions(r2f).AllData(:,1);
        totalt0=thisR.FitsRegions(r2f).AllData(:,2);
        thisT2f=thisR.FitsRegions(r2f).FittedData(:,1);
        subplot(4,5,c2)
        plot(log10(t),log10(totalt0),'LineWidth',3,'Color',0.8*[1 1 1])
        hold on
        plot(log10(t),(thisP(log10(t))),'Color',0.5*[1 1 1])
        plot(log10(thisT2f([1 end])),...
            log10(totalt0((thisT2f([1 end])))),'o','Color',0*[1 1 1],'MarkerSize',2)
        box off
        title(thisR.FitsRegions(r2f).Region)
        xlim(log10([1 100]))
        ylim([2 6])
        set(gca,'Clipping','on')
        alphaC(c2)=thisP.a;
        regionC{c2}=thisR.FitsRegions(r2f).Region;
        c2=c2+1;
    end
end
set(4,'WindowStyle','normal')
exportgraphics(gcf,'allChina.eps')
set(4,'WindowStyle','docked')

alphaChina=givemeTableSR(allR(26));
filename = 'Chinaanalysis.xlsx';
writetable(alphaChina,filename,'Sheet',1,'Range','D1')


%subplot 337
%ylim([4.9 5])
%% show all US states with PL


% figure(5)
% clf
% alphaUS=plotUS(usC);
% for a=1:47
%     subplot(10,8,a)
%     ylim([1 5])
%     xlim([0 2])
%     h=gca;
%     if a<42
%     h.XTickLabel={};
%     end
%     h.TickLength=[0.01 0.04];
%     h.Position(4)=0.08;
% end
%%
thisR=usC;
figure(5)
clf
clear alphaC regionC
c2=1;
for r2f=1:length(thisR)
    thisR(r2f).Region
    if strcmpi(thisR(r2f).FitsTotal.BestFit,'PowerLaw')
        thisA=thisR(r2f).FitsTotal.Allo.Fit;
        thisP=thisR(r2f).FitsTotal.LogLog.Fit;
        t=thisR(r2f).FitsTotal.AllData(:,1);
        totalt0=thisR(r2f).FitsTotal.AllData(:,2);
        thisT2f=thisR(r2f).FitsTotal.FittedData(:,1);
        subplot(7,5,c2)
        plot(log10(t),log10(totalt0),'LineWidth',3,'Color',0.8*[1 1 1])
        hold on
        plot(log10(t),(thisP(log10(t))),'Color',0.5*[1 1 1])
        plot(log10(thisT2f([1 end])),...
            log10(totalt0((thisT2f([1 end])))),'o','Color',0*[1 1 1],'MarkerSize',2)
        box off
        title(thisR(r2f).Region)
        xlim(log10([1 100]))
        ylim([1 5])
        set(gca,'Clipping','on')
        alphaC(c2)=thisP.a;
        regionC{c2}=thisR(r2f).Region;
        c2=c2+1;
    end
end

for a=1:33
    subplot(7,5,a)
    ylim([1 5])
    xlim(log10([1 100]))
    h=gca;
    if a<29
    h.XTickLabel={};
    end
    h.TickLength=[0.01 0.04];
    h.Position(4)=0.08;
end


alphaUS(logical(strcmpi(alphaUS.BestFit,'PowerLaw')),:)
USpl=alphaUS(logical(strcmpi(alphaUS.BestFit,'PowerLaw')),:);
USexp=alphaUS(logical(strcmpi(alphaUS.BestFit,'Exp')),:);

box off

set(5,'WindowStyle','normal')
exportgraphics(gcf,'allUS.eps')
set(5,'WindowStyle','docked')

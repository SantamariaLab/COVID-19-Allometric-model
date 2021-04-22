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
worldTpl=worldT(logical(strcmpi(worldT.BestFit,'PowerLaw')),:)

%%
% clear allRallo
% c=1;
% for a=1:length(allR)
%     thisR=allR(a);
%     casesTotal=thisR.Data;
%     caseTh0=500;%10
%     d2f=1;%10
%     range2f=30;%20
%     [caseTh,dRbool]=checkdata(casesTotal,caseTh0,d2f,range2f,21,2);
%     boolCases=(casesTotal>=caseTh);
%     firstD=find(diff(boolCases))+1;
%     if isempty(firstD)
%         firstD=1;
%     end
%     totalt0=casesTotal(logical(boolCases));
%     if length(totalt0)>(d2f+range2f)
%         dummyR=fitDataAllo(totalt0,d2f,range2f,thisR.Region,caseTh,thisR.Dates{firstD(1)},thisR.FitsTotal.LogLog.Fit.a);
%         allRallo(c)=allR(a);
%         allRallo(c).FitsTotal=dummyR;
%         allRallo(c).FitsTotal.BestFit=thisR.FitsTotal.BestFit;%just to keep the original classification
%         plotFits(allRallo(c).FitsTotal,'up');
%         c=c+1;
%     end
% end
% alloT=givemeTable(allRallo);
% alloTpl=alloT(logical(strcmpi(alloT.BestFit,'PowerLaw')),:);
% 
% %
% figure(7)
% dinFuture=100;
% 
% for a=1:length(allRallo)
% [ratio2a,ratio2e,ratio2p,ratio1a,ratio1e,ratio1p]=analyzeModels(allRallo,dinFuture,a);
% input('r')
% end
% subplot(2,3,5)
% scatter(alloTpl.alpha,1./(1-alloTpl.b))
% set(7,'WindowStyle','normal')
% exportgraphics(gcf,'errorCompWorldAllo.eps')
% set(7,'WindowStyle','docked')

%% Check allometric and compare
%% Show examples of allometric fits and show that extrapolation is better than Exp fit.
c=1;
for a=1:length(allR)
    if strcmpi(allR(a).FitsTotal.BestFit,'PowerLaw')
        allRpl(c)=allR(a);
        c=c+1;
    end
end

figure(5)
clf
dinFuture=100;
[ratio2a,ratio2e,ratio2p,ratio1a,ratio1e,ratio1p]=analyzeModels(allR,dinFuture,50);
for a=1:3
    subplot(2,4,a)
    ylim([2 6])
    xlim(log10([1 100]))
    set(gca,'Clipping','on')
end
subplot 243
xlim(([1 100]))
subplot 244
ylim([-10 20])


set(5,'WindowStyle','normal')
exportgraphics(gcf,'errorCompWorld.eps')
set(5,'WindowStyle','docked')
%%
%% do the same with the US
c=1;
for a=1:length(usC)
    if strcmpi(usC(a).FitsTotal.BestFit,'PowerLaw')
        usCpl(c)=usC(a);
        c=c+1;
    end
end

%%
figure(6)
clf
dinFuture=100;
[ratio2a,ratio2e,ratio2p]=analyzeModels(usCpl,dinFuture,20);


% % 
% % subplot 235
% % cla
% % subplot 236
% % cla
%  for a=1:length(usCpl)
%      thisR=usCpl(a);
%      thisA=thisR.FitsTotal.Allo.Fit;
%      thisE=thisR.FitsTotal.Exp.Fit;
%      thisP=thisR.FitsTotal.LogLog.Fit;
%      t=thisR.FitsTotal.AllData(:,1);
%      totalt0=thisR.FitsTotal.AllData(:,2);
%      thisT2f=thisR.FitsTotal.FittedData(:,1);
%      dataref=totalt0-totalt0(1);
%      t=t-t(1);
%      subplot 235
% 
%      plot(log10(t),log10(dataref),'LineWidth',2,'Color',0.8*[1 1 1])
%      hold on
%      subplot 236
%      logd=log10(dataref);
%      dateN=logd./max(logd);
%      plot(t,dateN,'LineWidth',2,'Color',0.8*[1 1 1])
% hold on
%      
%  end
%  subplot 235
%  box off
% xlim([0 2])
% ylim([0 6])
%  subplot 236
%  box off
%  xlim([0 150])
%  ylim([0 1])
 
for a=1:3
    subplot(2,4,a)
    ylim([0 5])
    xlim(log10([1 100]))
    set(gca,'Clipping','on')
end
subplot 243
xlim(([1 100]))
subplot 244
ylim([-10 20])
 
 
 
set(6,'WindowStyle','normal')
exportgraphics(gcf,'errorCompUS.eps')
set(6,'WindowStyle','docked')


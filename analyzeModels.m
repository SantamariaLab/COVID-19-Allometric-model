function [ratio2a,ratio2e,ratio2p,ratio1a,ratio1e,ratio1p]=analyzeModels(allR,dinFuture,exN)
thisR=allR(exN)
thisA=thisR.FitsTotal.Allo.Fit;
thisP=thisR.FitsTotal.LogLog.Fit;
t=thisR.FitsTotal.AllData(:,1);
totalt0=thisR.FitsTotal.AllData(:,2);
thisT2f=thisR.FitsTotal.FittedData(:,1);
clf
subplot 241
plot(log10(t),log10(totalt0),'LineWidth',3,'Color',0.8*[1 1 1])
hold on
plot(log10(t),(thisP(log10(t))),'Color',0.5*[1 1 1])
plot(log10(thisT2f([1 end])),...
    log10(totalt0((thisT2f([1 end])))),'o','Color',0*[1 1 1],'MarkerSize',2)
box off
xlim(log10([1 160]))
ylim([2 6])
title(thisR.Region)
xlabel('Log_{10}(Days)')
ylabel('Log_{10}(Cumlative cases) (I)') 

subplot 242
cla
plot(log10(t),log10(totalt0),'LineWidth',3,'Color',0.8*[1 1 1])
hold on
plot(log10(t),log10(thisA((t-thisT2f(1)))),'Color',0.5*[1 1 1])
plot(log10(thisT2f([1 end])),log10(totalt0((thisT2f([1 end])))),'o','Color',0*[1 1 1],'MarkerSize',2)
xlim((log10([1 160])))
ylim([2 6])
box off
xlabel('Log_{10}(Days)')
ylabel('Log_{10}(Cumlative cases) (I)') 



subplot 243
cla

c3=1;
for a=1:length(allR)
    thisR=allR(a);
    if strcmpi(thisR.FitsTotal.BestFit,'PowerLaw') % || strcmpi(thisR.FitsTotal.BestFit,'Exp')
        thisA=thisR.FitsTotal.Allo.Fit;
        thisE=thisR.FitsTotal.Exp.Fit;
        thisP=thisR.FitsTotal.LogLog.Fit;
        t=thisR.FitsTotal.AllData(:,1);
        totalt0=thisR.FitsTotal.AllData(:,2);
        thisT2f=thisR.FitsTotal.FittedData(:,1);
        startFit=thisR.FitsTotal.StartFit;
        if length(totalt0)>(thisT2f(end)+dinFuture)
            %plot((t),log10(totalt0),'LineWidth',1,'Color',0.8*[1 1 1])
            %hold on
            %plot((t),log10(thisA((t-thisT2f(1)))),'LineWidth',1,'Color',0.5*[1 1 1])
            
            fitM(:,c3)=thisA((t(1:100)-thisT2f(1)));
            dataM(:,c3)=totalt0(1:100);
            %plot(log10(thisT2f(1:3:end)),log10(thisA((thisT2f(1:3:end)-thisT2f(1)))),'o','Color',0*[1 1 1])
            %plot(log10(t),(thisE(t)),'Color',[1 0 0]);
            %xlim(([1 160]))
            %hold on
            if isnan(thisA(-startFit)-totalt0(1))
                thisAv=0;
            else
                thisAv=thisA(-startFit);
            end
            %if ~(thisT2f(1)==t(1))
            ratio1a(c3)=100*(thisAv-totalt0(1))./totalt0(1);
            ratio1e(c3)=100*(10.^thisE(1)-(totalt0(1)))./(totalt0(1));
            ratio1p(c3)=100*(10.^thisP(log10(1))-(totalt0(1)))./(totalt0(1));
            
            
            ltref=log10(totalt0(thisT2f(end)+[0:dinFuture]));
            ratio2a(c3,:)=100*(log10(thisA(thisT2f(end)-thisT2f(1)+[0:dinFuture]))-ltref)./ltref;
            ratio2e(c3,:)=100*(thisE((thisT2f(end)+[0:dinFuture]))-ltref)./ltref;
            ratio2p(c3,:)=100*(thisP(log10(thisT2f(end)+[0:dinFuture]))-ltref)./ltref;
            thisRV{c3}=thisR.Region;
            c3=c3+1;
        end
    end
end

subplot 243
cla
plot(1:100,log10(fitM(:,1:5:end)),'LineWidth',1,'Color',0.8*[1 1 1])
hold on
plot((1:100),log10(dataM(:,1:5:end)),'LineWidth',1,'Color',0.5*[1 1 1])
plotCornerNames(100*ones(size(log10(dataM(end,1:5:end)))),log10(dataM(end,1:5:end)),thisRV(1:5:end))


 box off
 ylim([0 7])
set(gca,'Clipping','on')
xlabel('Days')
ylabel('Log_{10}(Cumlative cases) (I)') 

 
subplot 244
cla
plot(0:dinFuture,mean(ratio2e),'k',0:dinFuture,mean(ratio2a),'r',0:dinFuture,mean(ratio2p),'g')
hold on
plot(0:dinFuture,1.96*std(ratio2e)/sqrt(size(ratio2e,1))+mean(ratio2e),...
    0:dinFuture,-1.96*std(ratio2e)/sqrt(size(ratio2e,1))+mean(ratio2e),'Color',[0.8 0.8 0.8])
plot(0:dinFuture,1.96*std(ratio2a)/sqrt(size(ratio2e,1))+mean(ratio2a),...
    0:dinFuture,-1.96*std(ratio2a)/sqrt(size(ratio2e,1))+mean(ratio2a),'Color',[1 0.8 0.8])
plot(0:dinFuture,1.96*std(ratio2p)/sqrt(size(ratio2e,1))+mean(ratio2p),...
    0:dinFuture,-1.96*std(ratio2p)/sqrt(size(ratio2e,1))+mean(ratio2p),'Color',[0.2 1 0.2])
set(gca,'Clipping','on')
box off
ylim([-20 20])
xlabel('Days')
ylabel('Mean percentage error') 


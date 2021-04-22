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

%% airplane passengers World

opt=detectImportOptions('PassengersAirplane.xls','NumHeaderLines',0,...
    'ReadVariableNames',true,'ReadRowNames',true);
airPassengers=readtable('PassengersAirplane.xls',opt);


%fix a few names to match tables

for a=1:length(worldT.Region)
    boolS=strcmp(airPassengers.CountryName,worldT.Region{a});
    if ~isempty(airPassengers.x2018(logical(boolS)))
        worldT.AirPass(a)=airPassengers.x2018(logical(boolS));
    end
end
%complete from other sourcer
%alphaT.AirPass(40)=54033000;%NOrway https://www.statista.com/statistics/716952/number-of-passengers-at-airports-in-norway/
%alphaT.AirPass(48)=40160000;%Sweden https://www.statista.com/statistics/797084/monthly-number-of-passengers-at-airports-in-sweden/

worldTpl=worldT(logical(strcmpi(worldT.BestFit,'PowerLaw')),:);
airTr2plot=worldTpl(logical(~isnan(worldTpl.AirPass)),:);
airTr2plot=airTr2plot(logical((airTr2plot.AirPass)>0),:);

figure(8)
clf
subplot 321
cla
myscatter(log10(airTr2plot.AirPass*1000),airTr2plot.alpha,airTr2plot.Region)
xlim([6 12])
ylim([0 5])
title('Covid propagation vs Air passenger travel')
xlabel('Log_{10}(Air travel passenger)')
ylabel('Covid propagation (\alpha)')



%% us airports
%https://cms7.bts.dot.gov/airport-rankings-2019

opt=detectImportOptions('Airport Rankings 2019top20UStotal.xlsx','NumHeaderLines',2,...
    'ReadVariableNames',true,'ReadRowNames',true);
airUS=readtable('Airport Rankings 2019top20UStotal.xlsx',opt);

for a=1:length(alphaUS.Region)
    boolS=strcmp(airUS.state,alphaUS.Region{a});
    if ~isempty(airUS.totalState(logical(boolS)))
        dummy1=airUS.totalState(logical(boolS));
        dummy2=dummy1(logical(~isnan(dummy1)));
        if ~isempty(dummy2)
         alphaUS.AirPass(a)=sum(dummy2);
        end
    end
end

USpl=alphaUS(logical(strcmpi(alphaUS.BestFit,'PowerLaw')),:);
subplot(3,2,3)
cla
myscatter(log10(USpl.AirPass*1000),USpl.alpha,USpl.Region)
xlim([2 5])
ylim([0 5])

title('Covid propagation vs air passengers')
xlabel('Air passengers')
ylabel('Covid propagation (\alpha)')


%% US cities
figure(10)
airCountyList=table(countyL,airUS.state(1:30),airUS.Airport(1:30),airUS.x2019EnplanedPassengers(1:30));
airCountyList.Properties.VariableNames{2}='State';
airCountyList.Properties.VariableNames{3}='Airport';
airCountyList.Properties.VariableNames{4}='AirPass';
airCountyList=addvars(airCountyList,NaN*(1:length(airCountyList.State))');
airCountyList.Properties.VariableNames(end)={'AlphaCounty'};

for a=1:length(countyAnalysis)
    thisCounty=countyAnalysis(a);
    casesTotal=thisCounty.Data;
    caseTh0=100;%10
    d2f=5;%10
    range2f=20;%20
    [caseTh,dRbool]=checkdata(casesTotal,caseTh0,d2f,range2f,21,2);
    boolCases=(casesTotal>=caseTh);
    firstD=find(diff(boolCases))+1;
    if isempty(firstD)
        firstD=1;
    end
    totalt0=casesTotal(logical(boolCases));
    countyAnalysis(a).FitsTotal=fitData(totalt0,d2f,range2f,thisCounty.Region,caseTh,thisCounty.Dates{firstD});
    %plotFits(countyAnalysis(a).FitsTotal,'up');
end



for a=1:length(countyAnalysis)
    airCountyList.AlphaCounty(a)=countyAnalysis(a).FitsTotal.LogLog.Fit.a;
    airCountyList.Tau(a)=1./countyAnalysis(a).FitsTotal.Exp.Fit.a;
    airCountyList.BestFit{a}=countyAnalysis(a).FitsTotal.BestFit;
    airCountyList.FirstDate(a)=countyAnalysis(a).Dates(1);
end
countyPL2=airCountyList(logical(strcmpi(airCountyList.BestFit,'PowerLaw')),:);
boolX=strcmpi(countyPL2.State,'New York')+strcmpi(countyPL2.State,'New Jersey');
allNYNY=countyPL2(logical(boolX),:);
%boolVA=strcmpi(countyPL2.State,'Virginia')
%allVA=countyPL2(logical(boolVA),:);

countyPL=countyPL2(~logical(boolX),:);
countyPL=[countyPL; allNYNY(1,:)];
countyPL.AirPass(end)=sum(allNYNY.AirPass)
countyPL.AlphaCounty(end)=mean(allNYNY.AlphaCounty)

figure(8)
subplot(3,2,5)
cla
[r,p,fitWair]=myscatter(log10(countyPL.AirPass*1e6),countyPL.AlphaCounty,countyPL.Airport)
xlim([6.9 7.9])
ylim([0 5])

%% US miles traveled by state
%https://www.bts.gov/statistical-products/surveys/vehicle-miles-traveled-and-vehicle-trips-state
figure(5)
clf
opt=detectImportOptions('MilesTraveledState.xlsx','NumHeaderLines',5,...
    'ReadVariableNames',true,'ReadRowNames',true);
mtvUS=readtable('MilesTraveledState.xlsx',opt);
mtvUS(end,:)=[];
mtvUS(9,:)=[]; %get rid of DC

c=1; clear mtvVu mtvVs mtvVr mtvR
for a=1:length(alphaUS.Region)
        r=alphaUS.Region(a);
        [findSt]=find(strcmp(mtvUS.Row,r));
        alphaUS.UrbanMiles(a)=mtvUS.UrbanMiles(findSt);
        alphaUS.SuburbanMiles(a)=mtvUS.SuburbanMiles(findSt);
        alphaUS.RuralMiles(a)=mtvUS.RuralMiles(findSt);
end

alphaUSpl=alphaUS(logical(strcmpi(alphaUS.BestFit,'PowerLaw')),:);


figure(8)
subplot 322
cla
[r,p,fitWair]=myscatter(alphaUSpl.UrbanMiles,alphaUSpl.alpha,alphaUSpl.Region)
ylim([0 5])

subplot 324
cla
[r,p,fitWair]=myscatter(alphaUSpl.SuburbanMiles,alphaUSpl.alpha,alphaUSpl.Region)
ylim([0 5])

subplot 326
cla
[r,p,fitWair]=myscatter(alphaUSpl.RuralMiles,alphaUSpl.alpha,alphaUSpl.Region)
ylim([0 5])

%title('Covid propagation vs Miles traveled')
xlabel('Average Vehicle Miles Traveled')
ylabel('Covid propagation (\alpha)')



[r,p]=corrcoef(log10(alphaUSpl.AirPass),alphaUSpl.UrbanMiles)
[r,p]=corrcoef(log10(alphaUSpl.AirPass),alphaUSpl.SuburbanMiles)
[r,p]=corrcoef(log10(alphaUSpl.AirPass),alphaUSpl.RuralMiles)


figh=figure(8);
set(figh,'WindowStyle','normal')
set(figh, 'PaperUnits', 'inches','Renderer','painters');
set(figh,'Units','inches','Position',[1 1 7 10])
%set(figh, 'PaperSize', [11 8.5]);
exportgraphics(figh,'alphaVSairmiles.eps')
set(8,'WindowStyle','docked')


%% Compare extract states with AirPassenger data, alpha, and miles
airVmileUS=alphaUS(logical(~isnan(alphaUS.AirPass)),:);
airVmileUS=airVmileUS(logical(strcmpi(airVmileUS.BestFit,'PowerLaw')),:);

%compare air miles to rural car miles

%no correlation between rual miles and air miles
[r,p]=corrcoef(log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles)
[r,p]=corrcoef(log10(airVmileUS.AirPass*1e6),airVmileUS.UrbanMiles)


%build linear fit models and explain the varience
%airpass 
lA=fitlm([log10(airVmileUS.AirPass*1e6)],...
    airVmileUS.alpha,...
    'VarNames',{'Air','Alpha'});
%explained variance
1-var(lA.Residuals.Raw)./var(airVmileUS.alpha)

%airpass + ruralmiles
lAR=fitlm([log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles],...
    airVmileUS.alpha,...
    'VarNames',{'Air','RuralMiles','Alpha'});
%explained variance
1-var(lAR.Residuals.Raw)./var(airVmileUS.alpha)


%airpas+rural+urban
lARU=fitlm([log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.UrbanMiles],...
    airVmileUS.alpha,...
    'VarNames',{'Air','RuralMiles','Urban','Alpha'});
%explained variance
1-var(lARU.Residuals.Raw)./var(airVmileUS.alpha)

%airpass + rural  + suburban
lARS=fitlm([log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.SuburbanMiles],...
    airVmileUS.alpha,...
    'VarNames',{'Air','RuralMiles','Suburban','Alpha'});
%explained variance
1-var(lARS.Residuals.Raw)./var(airVmileUS.alpha)

%airpass + rural +urban + suburban
lmall=fitlm([log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.UrbanMiles,airVmileUS.SuburbanMiles],...
    airVmileUS.alpha,...
    'VarNames',{'Air','RuralMiles','Urban','Suburban','Alpha'});
%explained variance
1-var(lmall.Residuals.Raw)./var(airVmileUS.alpha)

figure(9)
clf
subplot(2,2,1)
plot3(log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.alpha,'ko')
grid on
hold on
%plot3(log10(airVmileUS.AirPass*1e6),40*ones(size(airVmileUS.RuralMiles)),airVmileUS.alpha,'o')
%plot3(5*ones(size(log10(airVmileUS.AirPass*1e6))),(airVmileUS.RuralMiles),airVmileUS.alpha,'o')
[airMesh,milesMesh]=meshgrid(5:0.5:8,43:62);
coeff=lAR.Coefficients.Estimate;
yfit=coeff(1)+coeff(2)*airMesh+coeff(3)*milesMesh;
mesh(airMesh,milesMesh,yfit,repmat(zeros(size(yfit)),1,1,3))
alpha(0.5)
hold on
xlabel('Log_{10} (Air passengers)')
ylabel('Rural travel miles')
zlabel('Covid propagation (\alpha)')
plotCornerNames3D(log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.alpha,airVmileUS.Region)
view([-40 30])

subplot(2,2,3)
plot3(log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.alpha,'ko')
grid on
hold on
mesh(airMesh,milesMesh,yfit,repmat(zeros(size(yfit)),1,1,3))
alpha(0.5)
xlabel('Log_{10} (Air passengers)')
ylabel('Rural travel miles')
zlabel('Covid propagation (\alpha)')
plotCornerNames3D(log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,airVmileUS.alpha,airVmileUS.Region)
view([60 15])


subplot(2,2,2)
plot(log10(airVmileUS.AirPass*1e6),airVmileUS.RuralMiles,'ok')
box off
xlabel('Log_{10} (Air passengers)')
ylabel('Rural travel miles')


figh=figure(9);
set(figh,'WindowStyle','normal')
set(figh, 'PaperUnits', 'inches','Renderer','painters');
set(figh,'Units','inches','Position',[1 1 7 5])
exportgraphics(figh,'linearmodel.eps')
set(figh,'WindowStyle','docked')


%% Export Tables!!!!

filename = 'Worldanalyis.xlsx';
writetable(worldT,filename,'Sheet',1,'Range','D1')
filename = 'USanalysis.xlsx';
writetable(alphaUS,filename,'Sheet',1,'Range','D1')


%% supplementary material
%% Supplementary Figure Compare to areas that were better fit by Exp
%compare with Exponential countries,
worldTex=worldT(logical(strcmpi(worldT.BestFit,'Exp')),:);
worldTex2=worldTex(logical(~isnan(worldTex.AirPass)),:);
worldTex2=worldTex2(logical((worldTex2.AirPass)>0),:);

figure(11)
clf

subplot 311
cla
myscatter(log10(worldTex2.AirPass*1000),worldTex2.tau,worldTex2.Region)

USexp=alphaUS(logical(strcmpi(alphaUS.BestFit,'Exp')),:);
USnone=alphaUS(logical(strcmpi(alphaUS.BestFit,'None')),:);

subplot(3,1,2)
cla
myscatter(log10(USexp.AirPass*1e6),USexp.tau,USexp.Region)

subplot 313
cla
countyexp=airCountyList(logical(strcmpi(airCountyList.BestFit,'Exp')),:);
myscatter(log10(countyexp.AirPass*1e6),countyexp.Tau,countyexp.Airport)

figh=figure(11);
set(figh,'WindowStyle','normal')
set(figh,'Units','inches','PaperUnits','inches');
set(figh,'PaperType','usletter')
%set(figh,'PaperSize',[10 2]);
set(figh,'resize','on')
%set(figh,'PaperPositionMode','manual')
set(figh,'Position',[1 1 4 10])
set(figh.Children,'fontname','arial')
exportgraphics(figh,'milsVtau.eps')
set(figh,'WindowStyle','docked')


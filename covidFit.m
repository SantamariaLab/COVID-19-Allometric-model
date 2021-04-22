function [dR,comment]=covidFit(cT,r2a,caseTh0,d2f,range2f)
c=1;
plotBool=0;

if strcmpi(r2a,'ALL')
    stateAll0=cT;
else
  rc=strcmp(cT.Country_Region,{r2a});%PRovince_State
  stateAll0=cT(logical(rc),:);
end

%choose dynamics that shows fast increase in cases
speedThT=21;
derivTh=2.0;%cases double
cases0=table2array(stateAll0(:,5:end))';%cT(r2a,5:end))';
casesTotal=sum(cases0,2);

[caseTh,dRbool,comment]=checkdata(casesTotal,caseTh0,d2f,range2f,speedThT,derivTh);
if ~dRbool
    dR=[];
    return
end

boolCases=(casesTotal>=caseTh);
firstD=find(diff(boolCases))+1;
if isempty(firstD)
    firstD=1;
end

totalt0=casesTotal(logical(boolCases));
allDates=stateAll0.Properties.VariableNames(5:end);
dR.FitsTotal=fitData(totalt0,d2f,range2f,stateAll0.Country_Region{1},caseTh,allDates{firstD});
dR.Region=stateAll0.Country_Region{1};%  T(r2a,2);
dR.caseTh=caseTh;
dR.daysafterThFit=[d2f range2f];
dR.Data=casesTotal;
dR.Dates=allDates;

plotFits(dR.FitsTotal,'up');

c=1;
if size(cases0,2)>1
    for a=2:size(cases0,2)
        thisCases=cases0(:,a);
        %use a low threshold
        [caseTh,dRbool]=checkdata(thisCases,20,d2f,range2f,speedThT,derivTh);
        if dRbool
            boolCases=(thisCases>=caseTh);
            firstD=find(diff(boolCases))+1;
            if isempty(firstD)
                firstD=1;
            end
            
            totalt0=casesTotal(logical(boolCases));
            
            dummyR(c)=fitData(totalt0,d2f,range2f,stateAll0.Province_State{a},caseTh,allDates{firstD});
            plotFits(dummyR(c),'down');
            c=c+1;
        end
    end
else
    dummyR=[];
end
dR.FitsRegions=dummyR;


end


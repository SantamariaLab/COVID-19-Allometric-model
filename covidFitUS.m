function dR=covidFitUS(cT,r2a,caseTh0,d2f,range2f)


if strcmp(upper(r2a),'ALL')
    stateAll0=cT;
else
  rc=strcmp(cT.state,{r2a});%PRovince_State
  stateAll0=cT(logical(rc),:);
end

%choose dynamics that shows fast increase in cases
speedThT=21;
derivTh=2.0;%cases double
%cases0=table2array(stateAll0(:,5:end))';%cT(r2a,5:end))';
casesTotal=stateAll0.cases;%sum(cases0,2);

[caseTh,dRbool]=checkdata(casesTotal,caseTh0,d2f,range2f,speedThT,derivTh);
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
allDates=stateAll0.date;
dR.FitsTotal=fitData(totalt0,d2f,range2f,stateAll0.state{1},caseTh,allDates(firstD));
dR.Region=stateAll0.state{1};%  T(r2a,2);
%dR.caseTh=caseTh;
%dR.daysafterThFit=[d2f range2f];
dR.Data=casesTotal;
dR.Dates=allDates;

plotFits(dR.FitsTotal,'up');
%dR=reprocessReg(dR);






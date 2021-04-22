function dR=findDate(cT,thisR)
c=1;
plotBool=0;
r2a=thisR.Region;
caseTh0=thisR.FitsTotal.caseTh;
range2f=thisR.FitsTotal.Days2Fit;


if strcmpi(r2a,'ALL')
    stateAll0=cT;
else
  rc=strcmp(cT.Country_Region,{r2a});%PRovince_State
  stateAll0=cT(logical(rc),:);
end

%choose dynamics that shows fast increase in cases
speedThT=7;
derivTh=2.0;%cases double
cases0=table2array(stateAll0(:,5:end))';%cT(r2a,5:end))';
casesTotal=sum(cases0,2);
datesAll=stateAll0.Properties.VariableNames(5:end);

% %[caseTh,dRbool]=checkdata(casesTotal,caseTh0,range2f,speedThT,derivTh);
% if ~dRbool
%     dR=[];
%     return
% end
dR.Region=r2a;

totalt0=casesTotal(logical(casesTotal>caseTh0));
dates0=datesAll(logical(casesTotal>caseTh0));


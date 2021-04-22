function dR=covidFitUScounties(cT,r2a,state,caseTh0,d2f,range2f)
c=1;

f=fittype('a*x+b');
g=fitoptions(f);

if strcmp(upper(r2a),'ALL')
    stateAll0=cT;
else
 if iscell(r2a)
     for a=2:length(r2a)
         rc=strcmp(cT.county,{r2a{a}});
         rs=strcmp(cT.state,{state});
         dummy=cT(logical(rc.*rs),:);
         day1(a,:)=datetime(dummy.date{1}(1:11));
     end
     [minday,minpos]=min(day1);
     rc=strcmp(cT.county,{r2a{minpos}});
     rs=strcmp(cT.state,{state});
     dummy=cT(logical(rc.*rs),:);
     for a=2:length(r2a)
         if a~=minpos
             rc=strcmp(cT.county,{r2a{a}});
             rs=strcmp(cT.state,{state});
             thisD=cT(logical(rc.*rs),:);
             for b=1:200 %check the first 200 days
              w(b)=strcmp(dummy.date{b}(1:11),thisD.date{1}(1:11));
             end
             %cummulative sum
             [deteentry,dateentrypoint]=find(w);
             dummy.cases(dateentrypoint:end)=dummy.cases(dateentrypoint:end)+thisD.cases;
         end
     end
     dummy.county=repmat(r2a(1),length(dummy.county),1);
     stateAll0=dummy;
 else
  rc=strcmp(cT.county,{r2a});%PRovince_State
  rs=strcmp(cT.state,{state});
  stateAll0=cT(logical(rc.*rs),:);
 end
end

%choose dynamics that shows fast increase in cases
speedThT=14;
derivTh=2.0;%cases double
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

dR.FitsTotal=fitData(totalt0,d2f,range2f,stateAll0.county{1},caseTh,stateAll0.date{firstD});
dR.Region=stateAll0.county{1};%  T(r2a,2);
%dR.caseTh=caseTh;
%dR.daysafterThFit=[d2f range2f];
dR.Data=casesTotal;
dR.Dates=stateAll0.date;

plotFits(dR.FitsTotal,'up');
%dR=reprocessReg(dR);


% stateAll=stateAll0(logical(stateAll0.cases>caseTh),:);
% 
% 
% dR(c).Region=stateAll.state(1);%  T(r2a,2);
% dR(c).SubRegion=stateAll.county(1);% cT(r2a,1);
% dR(c).Table=stateAll; %all the data.
% dR(c).caseTh=caseTh;
% dR(c).daysafterThFit=[d2f range2f];
% 
% thisT2f=d2f+[0:range2f];
% t=1:length(stateAll.cases);
% clf      
% subplot 231
% plot(log10(t),log10(stateAll.cases))
% 
% 
% [f0,gof0]=fit(log10(thisT2f'),log10(stateAll.cases(thisT2f')),f,g);
% dR(c).FitTotal=f0;
% dR(c).FitTotalGOF=gof0;
% 
% hold on 
% plot(log10(thisT2f'),f0(log10(thisT2f')))
% box off
% title(dR(c).SubRegion{1});%.Country_Region{1})
% xlabel(['Log_{10} (Days after ' num2str(caseTh) ' cases)']);
% ylabel('Log_{10} (cases)')
% 
% 
% subplot 232
% [f2,gof2]=fit(thisT2f',log10(stateAll.cases(thisT2f')),f,g);
% dR(c).ExpFitTotal=f2;
% dR(c).ExpFitTotalGOF=gof2;
% plot(t,log10(stateAll.cases),'b',thisT2f',log10(stateAll.cases(thisT2f')),'r',thisT2f',f2(thisT2f'),'g')
% title('Exp fit')
% xlabel(['Days after ' num2str(caseTh) ' cases']);
% ylabel('Log_{10} (cases)')
% box off
% 


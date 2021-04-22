function out=reprocessReg(in)
out=in;
outofhere=0;

region=in.FitsTotal.Region;
caseTh0=in.FitsTotal.caseTh;
StartFit0=in.FitsTotal.StartFit;
Days2Fit0=in.FitsTotal.Days2Fit;
alldata=in.Data;
allDates=in.Dates;
%dummyR=fitData(alldata(:,2),StartFit0,Days2Fit0,region,caseTh0);
plotFits(in.FitsTotal,'up');
%dummy=covidFit(cT,in.FitsTotal.Region,caseTh0,StartFit0,Days2Fit0);

yn1=input('Do you want to change parameters? y/n ','s');


if strcmpi(yn1,'Y')
    while ~outofhere
        casein=input(['Caseth? ', num2str(caseTh0),' ']);
        startin=input(['startfit?', num2str(StartFit0),' ']);
        daysin=input(['days to fit?', num2str(Days2Fit0),' ']);
        if ~isempty(casein)
            caseTh0=casein;
        end
        if ~isempty(startin)
            StartFit0=startin;
        end
        if ~isempty(daysin)
            Days2Fit0=daysin;
        end
        
        boolCases=(alldata>=caseTh0);
        firstD=find(diff(boolCases))+1;
        if isempty(firstD)
            firstD=1;
        end
        data2fit=alldata(logical(boolCases));
        
        dummyR=fitData(data2fit,StartFit0,Days2Fit0,region,caseTh0,allDates{firstD});
        plotFits(dummyR,'up');
        outBool=input('Finish and move to next? y/n ','s');
        if strcmpi(outBool,'Y')           
            out.FitsTotal=dummyR;
            return
        end
    end
else
    out=in;
end


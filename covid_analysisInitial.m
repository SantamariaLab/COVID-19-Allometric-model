

clear 
homedir = 'C:\Users\jfu936\OneDrive - University of Texas at San Antonio\Manuscripts\2020\COVID19\analysis\Covid19';
cd(homedir)
opt=detectImportOptions('CovidGITHUBREpLatest.xlsx','NumHeaderLines',0,'ReadVariableNames',true);
cT=readtable('CovidGITHUBREpLatest.xlsx',opt);
%% do the analysis for all territories
clear allRegions
range2f=30;
dr=5;
caseTh=100;
c=1;c2=1;c3=1;
ausBool=1;
canBool=1;
chiBool=1;
clear allRegions notAnalyzed 
for a=2:length(cT.Country_Region)
    commentOut='';
    disp(cT.Country_Region{a})
    if strcmp(cT.Country_Region{a},'Australia')
        if ausBool
            dummyR=covidFit(cT,cT.Country_Region{a},caseTh,5,15);
            ausBool=0;
        else
            dummyR=[];
        end
    elseif strcmp(cT.Country_Region{a},'Canada')
        if canBool
            dummyR=covidFit(cT,cT.Country_Region{a},caseTh,dr,range2f);
            canBool=0;
        else
            dummyR=[];
        end
    elseif strcmp(cT.Country_Region{a},'China')
        if chiBool
            dummyR=covidFit(cT,cT.Country_Region{a},caseTh,3,10);
            chiBool=0;
        else
            dummyR=[];
        end
    else
        [dummyR,commentOut]=covidFit(cT,cT.Country_Region{a},caseTh,dr,range2f);
    end
    if ~isempty(dummyR)
        display(cT.Country_Region{a})
        allRegions(c)=dummyR;
        %input('r')
        c=c+1;
    else 
        if ~(strcmpi(cT.Country_Region{a},'Australia') + strcmpi(cT.Country_Region{a},'Canada') + strcmpi(cT.Country_Region{a},'China') )
            [dummyR2,comment2]=covidFit(cT,cT.Country_Region{a},1,1,40);
            if ~isempty(dummyR2)
                notAnalyzed(c2)=dummyR2;
                notAnalyzedComment{c2}=commentOut;
                disp(['Not analyzed ' cT.Country_Region{a}])
                %input('r')
                c2=c2+1;
            else
                disp(['never took off ' cT.Country_Region{a}])
                notConsidered{c3}=cT.Country_Region{a};
                notConsideredComment{c3}=comment2;
                c3=c3+1;
               % input('r')
            end
            %input('r')
        end
    end
    fprintf('\n\n')
end

allR=allRegions;
% %% re-analize to better fit the data. In case it is needed.
% for a=1:length(allRegions)
%     allR(a)=reprocessReg(allRegions(a));
% end
% %% Do sub regions Australia, Canada, China. In case it is needed
% allR(7)=reprocessSubReg(allR(7));
% allR(20)=reprocessSubReg(allR(20));
% allR(24)=reprocessSubReg(allR(24));
%%
%save InitialAnalysis2.mat allR notAnalyzed notAnalyzedComment notConsidered notConsideredComment
clear cT allRegions a ausBool c c2 c3 canBool caseTh chiBool comment2 commentOut dr dummyR dummyR2 opt range2f
save worldAnalysis

%% Done with analysis of World data


%%
clear
usT=readtable('NYT_us_states_latest.xlsx');
states={'Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','Florida',...
    'Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine',...
    'Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana',...
    'Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina',...
    'North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina',...
    'South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia',...
    'Wisconsin','Wyoming'};

clear usC
usCnotAnalyzed=[];
c=1;c2=1;
for a=1:length(states)
    dummy=covidFitUS(usT,states{a},10,5,20);
    if ~isempty(dummy)
        usC(c)=dummy;
        c=c+1;
    else
        dummyR2=covidFitUS(usT,states{a},1,1,20);
        usCnotAnalyzed(c2)=dummyR2;
        c2=c2+1;
    end
end
%% Manually check all the fits, if needed
% for a=1:length(usC)
%     usC(a)=reprocessReg(usC(a));
% end

%save  InitialAnalysis2.mat allR notAnalyzed notAnalyzedComment notConsidered notConsideredComment InitialAnalysis2 usC usCnotAnalyzed states 
clear usT a c c2 dummy 
save USstates


%% Get the data for all US counties
clear
opt=detectImportOptions('NYTimesAllCounties.xlsx','NumHeaderLines',0,...
    'ReadVariableNames',true,'ReadRowNames',true);
allcountiesUS=readtable('NYTimesAllCounties.xlsx',opt);
opt=detectImportOptions('Airport Rankings 2019top20UStotal.xlsx','NumHeaderLines',2,...
    'ReadVariableNames',true,'ReadRowNames',true);
airUS=readtable('Airport Rankings 2019top20UStotal.xlsx',opt);

%% analyze the  metropolitan areas that correspond the the most used airports
countyL={{'ATLANTA','Fulton','DeKalb','Cobb','Gwinnett'};...
    {'LA','Los Angeles','San Bernardino','Ventura'};...
    {'CHICAGO','Cook','DeKalb','DuPage'};...
    {'DALLAS','Collin', 'Dallas', 'Denton', 'Ellis', 'Hood', 'Hunt', 'Johnson', 'Kaufman', 'Parker', 'Rockwall', 'Tarrant','Wise'};...
    {'DENVER','Denver','Arapahoe','Jefferson','Adams','Douglas'};...
    {'NYC','New York City','Suffolk','Nassau','Westchester'};...
    {'SAN FRANCISCO','Alameda','Contra Costa','San Francisco','San Mateo','Marin'};...
    {'SEATTLE','King','Snohomish','Pierce','Kitsap','Thurston','Skagit'};...
    {'Orlando','Lake','Orange','Osceola','Seminole'};...
    {'LAS VEGAS','Clark','Nye'};
    {'CHARLOTTE','Mecklenburg','Union','Gaston','Cabarrus','Iredell','Rowan'};...
    {'NEW JERSEY','Essex','Union','Morris','Sussex'};...
    {'PHOENIX','Maricopa','Pinal','Gila'};...
    {'HOUSTON','Austin','Brazoria','Chambers','Fort Bend','Galveston','Harris','Liberty','Montgomery','Waller'};...
    {'MIAMI','Miami-Dade','Broward','Palm Beach'};...
    {'BOSTON','Norfolk','Plymouth','Suffolk'};...
    {'TWIN CITIES','Hennepin','Ramsey','Anoka','Washington','Scott','Wright','Carver','Sherburne'};...
    {'DETROIT','Wayne','Oakland','Macomb','Livingston','St. Clair'};...
    'Broward';...
    {'PHILADELPHIA','Delaware','Montgomery','Philadelphia'};...
    'New York City';...
    {'BALTIMORE','Baltimore','Carroll','Harford','Howard'};...
    'Salt Lake';'San Diego';...
    {'DULLES','Fairfax','Loudoun','Prince William'};...
    'Fairfax';...
    {'TAMPA','Hillsborough','Pinellas','Hernando','Pasco'};...
    'Cook';...
    'Honolulu';...
    {'PORTLAND','Clackamas','Multnomah','Washington','Yamhill'}};
airCountyList=table(countyL,airUS.state(1:30),airUS.Airport(1:30),airUS.x2019EnplanedPassengers(1:30));
airCountyList.Properties.VariableNames{2}='State';
airCountyList.Properties.VariableNames{3}='Airport';
airCountyList.Properties.VariableNames{4}='AirPass';
airCountyList=addvars(airCountyList,NaN*(1:length(airCountyList.State))');
airCountyList.Properties.VariableNames(end)={'AlphaCounty'};

%%
clear countyAnalysis;
c=1;
for a=1:length(airCountyList.State)
    thisCounty=airCountyList.countyL{a};
    thisState=airCountyList.State{a};
    dummyR=covidFitUScounties(allcountiesUS,thisCounty,thisState,10,10,20);
    if ~isempty(dummyR)
        countyAnalysis(c)=dummyR;
        c=c+1;
    end
end

% %%
% for a=1:length(countyAnalysis)
%     countyAnalysis(a)=reprocessReg(countyAnalysis(a));
% end
%%
%save CovidAnalysis.mat allR notAnalyzed notAnalyzedComment notConsidered notConsideredComment usC usCnotAnalyzed states countyL airCountyList countyAnalysis airUS 
clear a allcountiesUS c dummyR opt thisCounty thisState 
save UScities



function [r,p,fitWair]=myscatter(x,y,regions)
scatter(x,y,'MarkerEdgeColor',[0 0 0])
hold on
fitWair=fit(x,y,'a*x+b');
xmin=floor(min(x));
xmax=ceil(max(x));
ymin=floor(min(y));
ymax=ceil(max(y));

plotCornerNames(x,y,regions)
h=gca;
set(h,'Clipping','on')
xlim([xmin xmax])
ylim([ymin ymax])
[r,p]=corrcoef(x,y)
if p(2)<0.05
    plot([xmin xmax],fitWair([xmin xmax]),'Color',[0.2 0.2 0.2]);
end

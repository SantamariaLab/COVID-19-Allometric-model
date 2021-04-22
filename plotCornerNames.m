function plotCornerNames3d(x,y,r)
[dv,dp]=max(y);
text(x(dp),y(dp),r{dp})
[dv,dp]=max(x);
text(x(dp),y(dp),r{dp})
[dv,dp]=min(y);
text(x(dp),y(dp),r{dp})
[dv,dp]=min(x);
text(x(dp),y(dp),r{dp})

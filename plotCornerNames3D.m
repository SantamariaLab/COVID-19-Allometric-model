function plotCornerNames3D(x,y,z,r)
[dv,dp]=max(y);
text(x(dp),y(dp),z(dp),r{dp})
[dv,dp]=max(x);
text(x(dp),y(dp),z(dp),r{dp})
[dv,dp]=min(y);
text(x(dp),y(dp),z(dp),r{dp})
[dv,dp]=min(x);
text(x(dp),y(dp),z(dp),r{dp})

[dv,dp]=max(z);
text(x(dp),y(dp),z(dp),r{dp})
[dv,dp]=min(z);
text(x(dp),y(dp),z(dp),r{dp})


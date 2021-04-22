function out=reprocessSubReg(in)
out=in;
outofhere=0;

for a=1:length(in.FitsRegions)
    dummy=in;
    dummy.FitsTotal=dummy.FitsRegions(a);
    dummyout=reprocessReg(dummy);
    out.FitsRegions(a)=dummyout.FitsTotal;
end



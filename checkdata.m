function [caseTh,dRbool,outtext]=checkdata(casesTotal,caseTh,d2f,range2f,speedThT,derivTh)
dRbool=1;
outtext='';
if nnz(casesTotal>caseTh)>(range2f+d2f)
    dummy1=casesTotal(logical(casesTotal>caseTh),1);
    deriv=diff(dummy1(1:speedThT:end))./dummy1(1:speedThT:end-speedThT);
    dummy2=find((deriv>derivTh));
    if ~isempty(dummy2) %if the speed of increase is larger than caseTh at any point
        caseTh=dummy1(dummy2(1));%the new caseTh
        if nnz(casesTotal>caseTh)<(range2f+d2f) %see if you do not have enough points
            dRbool=0;
            outtext='R2 reached but not enough points to fit';
            return
        end
    else
        dRbool=0;
        outtext='R2 not reached';
        return
    end
else
    dRbool=0;
    outtext='Initial threshold reached but not enoug points to fit';
    return
end

end

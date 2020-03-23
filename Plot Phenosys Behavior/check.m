function [match_bul] = check(x,lo,hi)
%returns bulean value if x is within range lo <= x <= hi
    match_bul = (x>=lo) & (x<=hi);
end
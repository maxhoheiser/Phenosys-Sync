function [match_bul_2]=test_fit(comp, base,diff)
% find time overlap returns overlap
hi = diff;

if comp < base
    match_bul_2 = ((base-comp)<=hi);
elseif comp >= base
    match_bul_2 = ((comp-base)<=hi);
end
end